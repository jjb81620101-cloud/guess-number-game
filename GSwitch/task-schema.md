# GSwitch Task Schema

## 任務結構定義

```json
{
  "task_id": "TASK-001",
  "title": "任務標題",
  "description": "任務描述",
  "status": "pending|in_progress|completed|blocked",
  "priority": "P0|P1|P2|P3",
  "assigned_agent": "jacky-em|jacky-designer|jacky-reviewer|jacky-qa|jacky-security|jacky-release",
  "created_at": "2026-04-01T00:00:00Z",
  "updated_at": "2026-04-01T00:00:00Z",
  "dependencies": ["TASK-XXX"],
  "tags": ["#tag1", "#tag2"],
  "context": {
    "goal": "最終目標",
    "constraints": ["限制條件"],
    "expected_output": "預期產出"
  },
  "subtasks": [
    {
      "id": "SUB-001",
      "title": "子任務標題",
      "status": "pending|completed"
    }
  ],
  "artifacts": [
    {
      "type": "file|html|pdf|code",
      "path": "路徑",
      "description": "說明"
    }
  ]
}
```

---

## 任務狀態機

```
[CREATED] → [PENDING] → [IN_PROGRESS] → [COMPLETED]
                  ↓              ↓
              [BLOCKED]     [NEEDS_REVIEW]
                              ↓
                          [REVIEW_PASS] → [COMPLETED]
                          [REVIEW_FAIL] → [IN_PROGRESS]
```

---

## 優先順序定義

| 等級 | 標識 | 說明 | 回應時間 |
|------|------|------|---------|
| P0 | 緊急 | 立即處理 | < 1小時 |
| P1 | 高 | 當天完成 | < 4小時 |
| P2 | 中 | 本週完成 | < 2天 |
| P3 | 低 | 可延後 | < 1週 |

---

## 創建任務格式

```
### TASK-[ID]: [標題]

**狀態：** 🟡 pending
**優先：** 🔴 P0 / 🟠 P1 / 🟡 P2 / ⚪ P3
**負責代理：** @agent

**目標：**
-

**約束條件：**
-

**預期產出：**
-

**依賴任務：**
-

**子任務：**
- [ ] 子任務1
- [ ] 子任務2

---
```

---

## 任務完成報告格式

```
### ✅ TASK-[ID] 完成報告

**實際產出：**
-

**花費時間：**
-

**遇到的問題：**
-

**解決方案：**
-

**經驗教訓：**
-
```
