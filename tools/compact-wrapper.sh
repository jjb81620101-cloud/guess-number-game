#!/bin/bash
# tools/compact-wrapper.sh
# OpenClaw Cron 呼叫的包裝腳本
# 由 OpenClaw 內建 cron scheduler 定期執行

cd /home/node/.openclaw/workspace

# 執行狀態檢查
bash tools/auto-compact.sh status

# 記錄執行時間
echo "[$(date)] OpenClaw Cron: auto-compact check" >> state/compaction.log
