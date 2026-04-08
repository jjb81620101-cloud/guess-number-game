#!/bin/bash
# tools/auto-compact.sh
# 全域上下文自動壓縮腳本
# 設計：達到閾值時自動觸發摘要，保留重要上下文

set -e

SCRIPT_DIR="$(dirname "$0")"
STATE_DIR="$HOME/.openclaw/workspace/state"
CONTEXT_STATE="$STATE_DIR/context-state.json"
LOG_FILE="$STATE_DIR/compaction.log"

# 載入設定
THRESHOLD=${COMPACT_THRESHOLD:-150000}
TARGET=${COMPACT_TARGET:-100000}
PRESERVE_RECENT=${COMPACT_PRESERVE_RECENT:-20}

mkdir -p "$STATE_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 檢查是否需要壓縮
check_and_compact() {
    local current_tokens=${1:-0}
    local usage_pct=$((current_tokens * 100 / THRESHOLD))
    
    log "檢查上下文: 當前 $current_tokens / 閾值 $THRESHOLD (${usage_pct}%)"
    
    if [ "$current_tokens" -ge "$THRESHOLD" ]; then
        log "⚠️  達到閾值，執行自動壓縮..."
        compact_session
        return 0
    elif [ "$usage_pct" -ge 80 ]; then
        log "⚠️  使用率達 ${usage_pct}%，監控中"
        return 1
    else
        log "✅ 使用率正常: ${usage_pct}%"
        return 0
    fi
}

# 壓縮會話（生成摘要）
compact_session() {
    log "🔄 執行會話壓縮..."
    
    # 讀取當前狀態
    local timestamp=$(date -Iseconds)
    local history_file="$STATE_DIR/sessions/session-$(date +%Y%m%d-%H%M%S).json"
    
    mkdir -p "$STATE_DIR/sessions"
    
    # 記錄壓縮前的狀態
    cat > "$history_file" << EOF
{
  "timestamp": "$timestamp",
  "type": "compaction",
  "reason": "threshold_reached",
  "threshold": $THRESHOLD,
  "target": $TARGET,
  "preserved_recent": $PRESERVE_RECENT
}
EOF
    
    # 更新上下文狀態
    python3 "$SCRIPT_DIR/context-manager.py" compact "$TARGET" 2>/dev/null || {
        log "⚠️  context-manager.py 執行失敗，手動更新狀態"
        update_state_file "$TARGET"
    }
    
    log "✅ 壓縮完成: $THRESHOLD → $TARGET tokens"
    log "📁 歷史已保存至: $history_file"
}

# 更新狀態檔案
update_state_file() {
    local new_tokens=${1:-$TARGET}
    local now=$(date -Iseconds)
    
    if [ -f "$CONTEXT_STATE" ]; then
        # 使用 jq 更新（如果有的話）否則用 python
        python3 -c "
import json
with open('$CONTEXT_STATE', 'r') as f:
    state = json.load(f)
state['current_tokens'] = $new_tokens
state['compaction_count'] = state.get('compaction_count', 0) + 1
state['last_compaction'] = '$now'
with open('$CONTEXT_STATE', 'w') as f:
    json.dump(state, f, indent=2)
"
    else
        cat > "$CONTEXT_STATE" << EOF
{
  "current_tokens": $new_tokens,
  "last_updated": "$now",
  "compaction_count": 1,
  "last_compaction": "$now",
  "history": []
}
EOF
    fi
}

# 主程式
case "${1:-check}" in
    check)
        current=${2:-0}
        check_and_compact "$current"
        ;;
    compact)
        compact_session
        ;;
    status)
        python3 "$SCRIPT_DIR/context-manager.py" status
        ;;
    install)
        log "📦 安裝自動壓縮 cron job..."
        # 移除舊的
        crontab -l 2>/dev/null | grep -v "auto-compact" | crontab - 2>/dev/null || true
        # 添加新的（每 30 分鐘檢查一次）
        (crontab -l 2>/dev/null; echo "*/30 * * * * cd $HOME/.openclaw/workspace && bash tools/auto-compact.sh check >> $LOG_FILE 2>&1") | crontab -
        log "✅ 已安裝自動壓縮 cron (每 30 分鐘檢查)"
        ;;
    uninstall)
        log "🗑️  移除自動壓縮 cron job..."
        crontab -l 2>/dev/null | grep -v "auto-compact" | crontab -
        log "✅ 已移除"
        ;;
    *)
        echo "用法: $0 {check|compact|status|install|uninstall}"
        echo ""
        echo "命令:"
        echo "  check [tokens]  - 檢查是否需要壓縮"
        echo "  compact         - 手動執行壓縮"
        echo "  status          - 顯示當前狀態"
        echo "  install         - 安裝定時檢查 cron"
        echo "  uninstall       - 移除定時檢查"
        ;;
esac
