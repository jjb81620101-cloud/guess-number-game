---
name: taskr
version: 1.0.0
description: "Persistent Task Planning & Execution for AI Agents — 任務規劃與執行系統"
role: task-management
---

# Taskr — 任務管理技能

Taskr 提供持久化、結結構化的任務管理，存在於對話 session 之外。

## 六大核心功能

| 功能 | 說明 |
|------|------|
| 階層式規劃 | 將工作拆分為巢狀任務層級 |
| 持久化上下文 | 任務在對話重置後仍可繼續 |
| 跨代理連續性 | 任何代理可隨時接管任務 |
| 審計追蹤 | 筆記直接附加在任務上 |
| 回溯同步 | 可補錄 Taskr 啟用前的工作 |
| 共享狀態 | open/wip/done/skipped 即時同步 |

---

## 核心流程

```
Plan → Create → Create CONTEXT → Review → Execute → Document → Repeat
```

| 步驟 | 說明 |
|------|------|
| Plan | 思考完整範圍，拆分成階段和子任務 |
| Create | create_task 建立整個任務層級 |
| CONTEXT | 附加背景、目標、用戶偏好 |
| Review | 向用戶展示計劃並獲得批准 |
| Execute | get_task → 工作 → update_task |
| Document | 過程筆記 |

---

## 何時使用 Taskr

**使用：**
- 工作有 3+ 步驟
- 工作跨越多個 session
- 用戶想要遠程監控或批准進度
- 從之前的 session 恢復工作

**跳過：**
- 單次快速操作

---

## 任務操作 API

### 建立任務
```
create_task(task_list_id, task_list_title, tasks, rule_context)
```

### 獲取任務
```
get_task(task_list_id, include_context, bypass_task_id)
```

### 更新任務
```
update_task(taskId, status, ruleContext)
update_task(tasks=[...], ruleContext)
```

### 任務狀態
| 狀態 | 意義 |
|------|------|
| open | 待處理 |
| wip | 工作中 |
| done | 已完成 |
| skipped | 跳過（需附上 FINDING 筆記）|

---

## 任務階層設計

| 位置 | 說明 |
|------|------|
| "1", "2", "3" | 頂層階段 |
| "1.1", "1.2" | 子任務 |
| "1.1.1" | 更深層（最多10層）|

---

## 筆記類型

| 類型 | 何時使用 |
|------|---------|
| CONTEXT | 背景、目標、用戶偏好 |
| FINDING | 發現、問題、阻塞 |
| PROGRESS | 階段完成（僅限頂層任務）|
| FILE_LIST | 創建/修改/刪除的檔案 |
| OTHER | 其他 |

---

## 回溯同步

```
task_sync() # 輕量級摘要
task_sync(task_list_id) # 詳細列表
task_sync(items) # 創建已完成標記的任務
```

---

## GSwitch 整合應用

### 與 jacky-em 整合
- 接收需求 → 建立任務階層
- create_task 建立完整計劃

### 與 jacky-release 整合
- get_task 獲取下一個任務
- update_task 更新狀態

### 與 jacky-qa 整合
- 驗證通過 → update_task status=done

---

## 標準工作語

> "我會先在 Taskr 中規劃這個任務——您可以審查任務分解後再開始。"

---

## 限制原則

- 一次只處理一個任務
- 完成後再移動到下一個
- 跳過的任務必須附上 FINDING 筆記說明原因
