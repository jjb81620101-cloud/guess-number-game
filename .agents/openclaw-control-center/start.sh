#!/bin/bash
# openclaw-control-center/start.sh
# 啟動 OpenClaw Control Center
# 用法: ./start.sh [mode]
# mode: ui (default) | monitor | dev

set -e

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR"

MODE=${1:-ui}

echo "🚀 啟動 OpenClaw Control Center..."
echo "   模式: $MODE"
echo "   Gateway: ws://127.0.0.1:18789"
echo ""

# 確保依賴已安裝
if [ ! -d "node_modules" ]; then
  echo "📦 安裝依賴..."
  pnpm install
fi

# 確保 runtime 目錄存在
mkdir -p runtime/digests runtime/logs

case "$MODE" in
  ui)
    echo "🌐 啟動 UI 模式 (http://127.0.0.1:4310/)"
    UI_MODE=true npm run dev
    ;;
  monitor)
    echo "📊 啟動監控模式..."
    npm run dev
    ;;
  dev)
    echo "🔧 啟動開發模式..."
    npm run dev:continuous
    ;;
  *)
    echo "未知模式: $MODE"
    echo "用法: $0 [ui|monitor|dev]"
    exit 1
    ;;
esac
