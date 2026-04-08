# Control Center 整合指南

_對接 OpenClaw Control Center 與 Harness Engineering 架構_

---

## 🎯 整合目標

將 OpenClaw Control Center 的可視化能力，與 Harness Engineering 架構的結構化代理系統結合。

---

## 📊 Control Center 功能

### 已啟用功能

| 功能 | 說明 | 對接 Harness |
|------|------|--------------|
| `Overview` | 健康狀態、待處理事項 | ✅ 對接任務追蹤 |
| `Usage` | Token 用量、配額監控 | ✅ 工具風險管理 |
| `Staff` | 活躍代理、工作狀態 | ✅ 代理團隊狀態 |
| `Collaboration` | 多代理協作討論 | ✅ 協調協議 |
| `Tasks` | 任務板審批執行鏈 | ✅ 任務追蹤系統 |
| `Memory` | 記憶狀態 | ✅ 語義記憶 |
| `Settings` | 連線狀態、安全摘要 | ✅ 權限系統 |

---

## 🚀 啟動 Control Center

```bash
# 方法 1: 直接啟動 UI 模式
cd ~/.openclaw/workspace/.agents/openclaw-control-center
./start.sh ui

# 方法 2: 後台運行
nohup ./start.sh ui > runtime/logs/control-center.log 2>&1 &

# 方法 3: Docker 運行
docker-compose -f docker-compose.example.yml up
```

---

## 🌐 存取網址

- **Control Center UI**: http://127.0.0.1:4310/
- **Gateway**: ws://127.0.0.1:18789

---

## 🔗 對接矩陣

### Control Center ↔ Harness 架構對應

| Control Center 頁面 | Harness 元件 | 檔案位置 |
|-------------------|-------------|---------|
| Overview | 任務追蹤 | `state/tasks/` |
| Usage | 工具註冊表 | `tools/registry.yaml` |
| Staff | 代理規格 | `agents/*/SPEC.md` |
| Collaboration | 協調協議 | `agents/_protocols/` |
| Tasks | Pipeline | `workflows/*.md` |
| Memory | 語義記憶 | `memory/semantic/` |
| Settings | 權限系統 | `permissions.yaml` |

---

## 📝 工作流程整合

### 1. 任務建立 → Control Center 可見

```
[用戶下達任務]
    ↓
[lobster 主控代理接收]
    ↓
[建立 state/tasks/task-YYYY-MM-DD-NNN.md]
    ↓
[Control Center Tasks 頁面自動顯示]
```

### 2. 代理分工 → Staff 頁面追蹤

```
[lobster 分配子任務]
    ↓
[researcher/writer/analyst/outreach 執行]
    ↓
[Control Center Staff 頁面顯示活躍代理]
```

### 3. 複雜任務 → Collaboration 協作

```
[討論階段] → [執行順序] → [交接] → [審查]
    ↓
[Control Center Collaboration 完整追蹤]
```

---

## 🔧 配置

### 環境變數

```bash
# 編輯 .env
GATEWAY_URL=ws://127.0.0.1:18789
UI_TIMEZONE=Asia/Bangkok
UI_PORT=4310

# 安全設定（預設為唯讀）
READONLY_MODE=true
APPROVAL_ACTIONS_ENABLED=false
LOCAL_TOKEN_AUTH_REQUIRED=true
```

### 與 Harness 共享設定

Control Center 的路徑設定可與 Harness 架構對齊：

```bash
OPENCLAW_HOME=~/.openclaw
OPENCLAW_WORKSPACE_ROOT=~/.openclaw/workspace
```

---

## 📊 狀態檔案

Control Center 產生的狀態檔案：

```
runtime/
├── digests/
│   └── YYYY-MM-DD.json     # 每日摘要
├── timeline.log            # 時間線日誌
├── task-heartbeat.log     # 任務心跳日誌
└── ui-preferences.json    # UI 偏好設定
```

---

## 🔍 故障排除

### UI 無法訪問

```bash
# 檢查端口是否被佔用
netstat -tlnp | grep 4310

# 檢查日誌
tail -f runtime/logs/control-center.log
```

### Gateway 連線失敗

```bash
# 檢查 Gateway 狀態
ps aux | grep openclaw-gateway

# 檢查端口
cat /proc/net/tcp | grep 18789
```

### 資料未顯示

1. 確認 `OPENCLAW_HOME` 指向正確的 `.openclaw` 目錄
2. 檢查 `runtime/digests/` 目錄是否有每日摘要
3. 執行 `./status.sh` 查看詳細狀態

---

## 🚀 與 Cron 整合

將 Control Center 狀態檢查加入每日 Cron：

```bash
# 每日 9:00 檢查狀態
0 9 * * * cd ~/.openclaw/workspace/.agents/openclaw-control-center && ./status.sh >> ~/.openclaw/workspace/memory/YYYY-MM-DD.md
```

---

_整合日期：2026-04-08_
