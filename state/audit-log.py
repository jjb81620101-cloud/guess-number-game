# audit-log.py
# 審計日誌記錄腳本
# 用法: python3 audit-log.py [action] [args]

import json
import sys
import os
from datetime import datetime

AUDIT_LOG = os.path.expanduser("~/.openclaw/workspace/state/audit.log")
os.makedirs(os.path.dirname(AUDIT_LOG), exist_ok=True)

def write_log(action, details):
    """寫入審計日誌"""
    entry = {
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "action": action,
        **details
    }
    with open(AUDIT_LOG, "a", encoding="utf-8") as f:
        f.write(json.dumps(entry, ensure_ascii=False) + "\n")
    return entry

def read_log(limit=50):
    """讀取最近的審計日誌"""
    if not os.path.exists(AUDIT_LOG):
        print("暂无审计日志")
        return
    
    with open(AUDIT_LOG, "r", encoding="utf-8") as f:
        lines = f.readlines()
    
    print(f"📋 審計日誌（最近 {min(limit, len(lines))} 筆記錄）")
    print("=" * 60)
    
    for line in lines[-limit:]:
        entry = json.loads(line)
        dt = entry["timestamp"][:19].replace("T", " ")
        action = entry["action"]
        details = {k: v for k, v in entry.items() if k not in ["timestamp", "action"]}
        print(f"[{dt}] {action}")
        if details:
            for k, v in details.items():
                print(f"  - {k}: {v}")
        print()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("用法:")
        print("  python3 audit-log.py log <action> <key=value>...  # 記錄動作")
        print("  python3 audit-log.py read [limit]                  # 讀取日誌")
        print("")
        print("範例:")
        print('  python3 audit-log.py log task_created task_id=task-001 title="測試"')
        print('  python3 audit-log.py log email_sent to=user@example.com subject="Test"')
        sys.exit(1)
    
    cmd = sys.argv[1]
    
    if cmd == "read":
        limit = int(sys.argv[2]) if len(sys.argv) > 2 else 50
        read_log(limit)
    
    elif cmd == "log":
        if len(sys.argv) < 3:
            print("錯誤: 需要指定 action")
            sys.exit(1)
        
        action = sys.argv[2]
        details = {}
        
        for arg in sys.argv[3:]:
            if "=" in arg:
                key, value = arg.split("=", 1)
                details[key] = value
        
        entry = write_log(action, details)
        print(f"✅ 已記錄: {action}")
        print(f"   ID: {entry['timestamp']}")
    
    else:
        print(f"未知命令: {cmd}")
        sys.exit(1)
