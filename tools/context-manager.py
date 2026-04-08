#!/usr/bin/env python3
# tools/context-manager.py
# 上下文管理器 — 自動追蹤與優化 Token 使用
# 用法: python3 context-manager.py [command]

import json
import os
import sys
from datetime import datetime, timedelta

STATE_DIR = os.path.expanduser("~/.openclaw/workspace/state")
os.makedirs(STATE_DIR, exist_ok=True)

CONTEXT_STATE_FILE = os.path.join(STATE_DIR, "context-state.json")

# 預設設定
DEFAULT_THRESHOLDS = {
    "threshold": 150000,
    "target": 100000,
    "preserve_recent": 20,
    "compress_system_prompt": False
}

def load_state():
    """載入上下文狀態"""
    if os.path.exists(CONTEXT_STATE_FILE):
        with open(CONTEXT_STATE_FILE, "r") as f:
            return json.load(f)
    return {
        "current_tokens": 0,
        "last_updated": datetime.utcnow().isoformat() + "Z",
        "compaction_count": 0,
        "last_compaction": None,
        "history": []
    }

def save_state(state):
    """儲存上下文狀態"""
    state["last_updated"] = datetime.utcnow().isoformat() + "Z"
    with open(CONTEXT_STATE_FILE, "w") as f:
        json.dump(state, f, indent=2)

def update_tokens(estimated_tokens):
    """更新當前 token 估算"""
    state = load_state()
    old_tokens = state["current_tokens"]
    state["current_tokens"] = estimated_tokens
    
    # 記錄歷史
    state["history"].append({
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "old_tokens": old_tokens,
        "new_tokens": estimated_tokens,
        "delta": estimated_tokens - old_tokens
    })
    
    # 只保留最近 100 筆記錄
    if len(state["history"]) > 100:
        state["history"] = state["history"][-100:]
    
    save_state(state)
    
    # 檢查是否需要壓縮
    threshold = DEFAULT_THRESHOLDS["threshold"]
    if estimated_tokens >= threshold:
        return {
            "needs_compaction": True,
            "current_tokens": estimated_tokens,
            "threshold": threshold,
            "recommendation": f"建議執行壓縮（當前 {estimated_tokens} >= 閾值 {threshold}）"
        }
    
    return {
        "needs_compaction": False,
        "current_tokens": estimated_tokens,
        "threshold": threshold,
        "status": "normal"
    }

def get_status():
    """取得當前狀態"""
    state = load_state()
    current = state["current_tokens"]
    threshold = DEFAULT_THRESHOLDS["threshold"]
    usage_pct = (current / threshold) * 100 if threshold > 0 else 0
    
    status = "✅ 正常" if usage_pct < 80 else "⚠️ 警告" if usage_pct < 100 else "🔴 需壓縮"
    
    return {
        "current_tokens": current,
        "threshold": threshold,
        "usage_percentage": round(usage_pct, 1),
        "status": status,
        "compaction_count": state["compaction_count"],
        "last_compaction": state["last_compaction"],
        "recommendation": get_recommendation(usage_pct)
    }

def get_recommendation(usage_pct):
    """根據使用率給出建議"""
    if usage_pct >= 100:
        return "立即執行上下文壓縮"
    elif usage_pct >= 95:
        return "即將達到閾值，建議儘快壓縮"
    elif usage_pct >= 80:
        return "使用率偏高，監控中"
    else:
        return "使用率正常，無需操作"

def manual_compact(target_tokens=None):
    """手動觸發壓縮"""
    state = load_state()
    
    target = target_tokens or DEFAULT_THRESHOLDS["target"]
    old_tokens = state["current_tokens"]
    new_tokens = min(old_tokens, target)
    
    state["current_tokens"] = new_tokens
    state["compaction_count"] += 1
    state["last_compaction"] = datetime.utcnow().isoformat() + "Z"
    
    save_state(state)
    
    return {
        "success": True,
        "old_tokens": old_tokens,
        "new_tokens": new_tokens,
        "saved_tokens": old_tokens - new_tokens,
        "compaction_count": state["compaction_count"]
    }

def main():
    if len(sys.argv) < 2:
        print("用法:")
        print("  python3 context-manager.py status              # 查看狀態")
        print("  python3 context-manager.py update <tokens>    # 更新 token 估算")
        print("  python3 context-manager.py compact [target]   # 手動壓縮")
        print("  python3 context-manager.py reset              # 重置狀態")
        print("")
        print("閾值設定:")
        for k, v in DEFAULT_THRESHOLDS.items():
            print(f"  {k}: {v}")
        sys.exit(1)
    
    cmd = sys.argv[1]
    
    if cmd == "status":
        status = get_status()
        print("📊 上下文狀態")
        print("=" * 40)
        print(f"  當前 Tokens: {status['current_tokens']:,}")
        print(f"  閾值: {status['threshold']:,}")
        print(f"  使用率: {status['usage_percentage']}%")
        print(f"  狀態: {status['status']}")
        print(f"  壓縮次數: {status['compaction_count']}")
        if status['last_compaction']:
            print(f"  上次壓縮: {status['last_compaction']}")
        print(f"  建議: {status['recommendation']}")
    
    elif cmd == "update":
        if len(sys.argv) < 3:
            print("錯誤: 需要指定 token 數量")
            sys.exit(1)
        tokens = int(sys.argv[2])
        result = update_tokens(tokens)
        print(f"✅ 已更新: {tokens:,} tokens")
        if result["needs_compaction"]:
            print(f"⚠️ {result['recommendation']}")
    
    elif cmd == "compact":
        target = int(sys.argv[2]) if len(sys.argv) > 2 else None
        result = manual_compact(target)
        print(f"✅ 壓縮完成")
        print(f"  節省: {result['saved_tokens']:,} tokens")
        print(f"  當前: {result['new_tokens']:,} tokens")
        print(f"  累計壓縮次數: {result['compaction_count']}")
    
    elif cmd == "reset":
        state = load_state()
        state["current_tokens"] = 0
        save_state(state)
        print("✅ 已重置")
    
    else:
        print(f"未知命令: {cmd}")
        sys.exit(1)

if __name__ == "__main__":
    main()
