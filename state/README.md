# state/ — 狀態追蹤系統

_用途：結構化追蹤任務進度、審計日誌、Session 歷史_

---

## 目錄結構

```
state/
├── README.md              # 本文件
├── audit.log              # 審計日誌（JSON Lines 格式）
├── audit-log.py           # 審計日誌工具
├── tasks/                 # 任務追蹤
│   ├── task-template.md   # 任務模板
│   ├── task-tracker.sh   # 任務追蹤腳本
│   └── task-YYYY-MM-DD-NNN.md  # 每日任務檔案
└── sessions/              # Session 歷史（可選）
```

---

## 任務追蹤

### 建立新任務

```bash
./state/tasks/task-tracker.sh new "任務標題"
```

### 更新狀態

```bash
./state/tasks/task-tracker.sh status task-2026-04-08-001 executing
```

### 列出今日任務

```bash
./state/tasks/task-tracker.sh list
```

### 顯示任務詳情

```bash
./state/tasks/task-tracker.sh show task-2026-04-08-001
```

---

## 審計日誌

### 記錄動作

```bash
python3 state/audit-log.py log task_created task_id=task-001 title="測試"
python3 state/audit-log.py log email_sent to=user@example.com subject="Test"
```

### 讀取日誌

```bash
python3 state/audit-log.py read 50
```

---

## 審計日誌格式

```json
{"timestamp": "2026-04-08T10:30:00Z", "action": "task_created", "task_id": "task-001", "title": "測試"}
{"timestamp": "2026-04-08T10:31:00Z", "action": "subtask_assigned", "task_id": "task-001", "subtask_id": "task-001-01", "agent": "researcher"}
{"timestamp": "2026-04-08T10:35:00Z", "action": "email_sent", "to": "user@example.com", "subject": "Test"}
```

---

## 追蹤的動作類型

| Action | 說明 |
|--------|------|
| `task_created` | 建立新任務 |
| `task_status_changed` | 任務狀態變更 |
| `subtask_assigned` | 子任務分配 |
| `subtask_completed` | 子任務完成 |
| `email_sent` | 郵件發送 |
| `email_received` | 郵件接收 |
| `file_created` | 檔案建立 |
| `file_modified` | 檔案修改 |
| `cron_created` | Cron 任務建立 |
| `cron_deleted` | Cron 任務刪除 |
| `agent_spawned` | 子代理啟動 |
| `agent_completed` | 子代理完成 |
| `error_occurred` | 錯誤發生 |

---

_每次重大狀態變更都應記錄到審計日誌。_
