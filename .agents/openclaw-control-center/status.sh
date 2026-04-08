#!/bin/bash
# openclaw-control-center/status.sh
# 檢查 OpenClaw Control Center 狀態

GATEWAY_URL="ws://127.0.0.1:18789"
CONTROL_CENTER_URL="http://127.0.0.1:4310"

echo "🔍 OpenClaw 系統狀態檢查"
echo "=========================="
echo ""

# 檢查 Gateway
echo "📡 Gateway ($GATEWAY_URL):"
if curl -s --max-time 3 "$GATEWAY_URL" > /dev/null 2>&1; then
  echo "   ✅ Gateway 在線"
else
  echo "   ❌ Gateway 離線"
fi

# 檢查 Control Center
echo ""
echo "🎛️  Control Center ($CONTROL_CENTER_URL):"
if curl -s --max-time 3 "$CONTROL_CENTER_URL" > /dev/null 2>&1; then
  echo "   ✅ Control Center 在線"
else
  echo "   ❌ Control Center 離線"
fi

# 讀取最新摘要
DIGEST_FILE="/home/node/.openclaw/workspace/.agents/openclaw-control-center/runtime/digests/$(date +%Y-%m-%d).json"
if [ -f "$DIGEST_FILE" ]; then
  echo ""
  echo "📋 今日摘要:"
  cat "$DIGEST_FILE" | python3 -c "
import json, sys
d = json.load(sys.stdin)
m = d.get('monitor', {})
print(f\"   Sessions: {m.get('sessions', 'N/A')}\")
print(f\"   Alerts: {len(m.get('alerts', []))}\")
print(f\"   Heartbeat: {m.get('heartbeat', {}).get('ok', 'N/A')}\")
" 2>/dev/null || echo "   (無法解析摘要)"
fi

echo ""
