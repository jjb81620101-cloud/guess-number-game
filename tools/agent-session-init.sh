#!/bin/bash
# tools/agent-session-init.sh
# 代理會話初始化腳本
# 每個代理啟動時自動執行，檢查上下文狀態

set -e

SCRIPT_DIR="$(dirname "$0")"
STATE_DIR="$HOME/.openclaw/workspace/state"
AGENT_NAME="${AGENT_NAME:-lobster}"

echo "🔧 [$AGENT_NAME] 會話初始化..."

# 1. 檢查上下文狀態
python3 "$SCRIPT_DIR/context-manager.py" status

# 2. 檢查是否有待執行的任務
if [ -f "$STATE_DIR/active-task.md" ]; then
    echo ""
    echo "📋 待處理任務:"
    grep -A5 "當前任務" "$STATE_DIR/active-task.md" | head -10
fi

# 3. 檢查審計日誌
echo ""
echo "📊 今日操作摘要:"
if [ -f "$STATE_DIR/audit.log" ]; then
    today=$(date +%Y-%m-%d)
    today_count=$(grep "$today" "$STATE_DIR/audit.log" 2>/dev/null | wc -l || echo "0")
    echo "   今日記錄: $today_count 筆"
fi

# 4. 檢查 cron job 狀態
echo ""
echo "⏰ Cron 任務:"
crontab -l 2>/dev/null | grep -v "^#" | head -5 || echo "   無活躍 cron"

echo ""
echo "✅ [$AGENT_NAME] 初始化完成 - $(date '+%Y-%m-%d %H:%M:%S')"
