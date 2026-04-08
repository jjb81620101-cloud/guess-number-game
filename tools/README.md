# tools/ — 工具腳本目錄

_用途：維護系統工具腳本，包括上下文管理和自動化_

---

## 目錄內容

| 檔案 | 說明 |
|------|------|
| `registry.yaml` | 工具註冊表（風險分級、配額管理）|
| `context-manager.py` | 上下文管理器（Token 追蹤）|
| `auto-compact.sh` | 自動壓縮腳本 |
| `agent-session-init.sh` | 代理會話初始化 |
| `compact-wrapper.sh` | Cron 包裝腳本 |

---

## 上下文管理系統

### 工作原理

```
┌─────────────────────────────────────────┐
│  OpenClaw Cron (每 30 分鐘)             │
│  ↓                                      │
│  auto-compact.sh check                  │
│  ↓                                      │
│  context-manager.py status               │
│  ↓                                      │
│  Token 使用率                            │
│  ├─ < 80% → 正常 ✅                      │
│  ├─ 80-95% → 警告 ⚠️                    │
│  └─ >= 95% → 自動壓縮 🔄                │
└─────────────────────────────────────────┘
```

### 設定值

| 參數 | 預設值 | 說明 |
|------|--------|------|
| `threshold` | 150,000 | 開始壓縮的 token 數 |
| `target` | 100,000 | 壓縮後目標 token 數 |
| `preserve_recent` | 20 | 保留最近 N 條對話 |

### 命令

```bash
# 查看狀態
python3 tools/context-manager.py status
python3 tools/auto-compact.sh status

# 手動觸發
python3 tools/compact-wrapper.sh
bash tools/auto-compact.sh compact

# Cron job（每 30 分鐘自動執行）
bash tools/auto-compact.sh install
```

### 應用到所有代理

每個代理啟動時會自動呼叫 `agent-session-init.sh`：

```bash
# 在代理執行任務前
bash tools/agent-session-init.sh

# 或在任務開始時
python3 tools/context-manager.py status
```

---

## 自動壓縮 Cron Job

已設定 OpenClaw cron job（每 30 分鐘）：
- Job ID: `cc0eb8eb-f58e-4e8b-a9cf-26acb15a55d6`
- 執行：`tools/compact-wrapper.sh`
- 狀態檢查後自動觸發壓縮（如需要）

---

_更新時間：2026-04-08_
