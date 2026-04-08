---
name: coordinator-protocol
description: 主控代理協調協議 — 任務分配、狀態追蹤、結果彙整
version: 1.0.0
author: lobster-core
tags: [protocol, coordination, multi-agent, task-delegation]
created: 2026-04-08
updated: 2026-04-08
---

# 主控代理協調協議

_定義主控代理（lobster）與專業代理之間的協調規範_

---

## 代理團隊

| 代號 | 名稱 | 專長 |
|------|------|------|
| `lobster` | 蝦管（主控） | 任務協調、資源調度、交付把關 |
| `researcher` | 研究代理 | 網頁搜尋、資料收集、事實查核 |
| `writer` | 內容代理 | 文案撰寫、SEO 優化、報告生成 |
| `analyst` | 分析代理 | 數據處理、統計分析、視覺化 |
| `outreach` | 外聯代理 | 陌生開發、潛在客戶管理 |

---

## 任務分配流程

### 步驟 1: 任務解析

```
[接收用戶指令]
    ↓
意圖模糊？ ──YES──→ [意圖clarification]
    ↓ NO
任務複雜度評估
    ↓
├─ 簡單（單步）──→ [直接執行]
    ↓
├─ 中等（2-3步）──→ [順序執行]
    ↓
└─ 複雜（多步/多代理）──→ [啟動協調協議]
```

### 步驟 2: 任務分解

將複雜任務拆解為子任務：

```yaml
task_breakdown:
  main_task_id: "task-{date}-{seq}"
  
  subtasks:
    - id: "{main_task_id}-01"
      name: "子任務名稱"
      assigned_to: researcher|writer|analyst|outreach|lobster
      dependencies: []  # 前置任務ID
      expected_output: "預期產出描述"
      
    - id: "{main_task_id}-02"
      name: "..."
      assigned_to: ...
      dependencies: ["{main_task_id}-01"]  # 等待前置完成
      expected_output: "..."
```

### 步驟 3: 任務分配

使用 `sessions_spawn` 啟動子代理：

```yaml
spawn_instruction:
  action: sessions_spawn
  agent: researcher|writer|analyst|outreach
  
  task: |
    [INPUT]: {原始資料或任務描述}
    [GOAL]: {具體目標}
    [CONSTRAINTS]: {限制條件}
    [OUTPUT_FORMAT]: {期望格式}
    
  # 任務ID用於追蹤
  custom_id: "{subtask_id}"
  
  # Session 標籤
  label: "{main_task_id}-{agent}"
  
  # 隔離session
  mode: isolated
```

### 步驟 4: 進度監控

監控子代理執行狀態：

```yaml
monitoring:
  check_interval: "每5分鐘或收到子代理回覆時"
  
  status_check:
    - sessions_list  # 查看活躍 session
    - sessions_history  # 查看進度（如需要）
    
  escalation:
    - 子代理無響應 > 10 分鐘 → 重新分配或回報
    - 子代理回報錯誤 → 評估是否重試
    - 子代理完成 → 彙整結果，繼續下一步
```

### 步驟 5: 結果彙整

接收子代理結果：

```yaml
result_integration:
  collected_outputs:
    - from: researcher
      output: {研究結果}
      quality: passed|failed
      
    - from: writer
      output: {內容產出}
      quality: passed|failed
      
  integration_steps:
    - 審查所有子任務輸出
    - 確認符合原始目標
    - 處理任何衝突或缺口
    - 組裝最終交付物
    
  delivery:
    format: "根據用戶要求的格式"
    summary: "一句話結果摘要"
    details: "詳細說明（如需要）"
```

---

## 通訊格式

### 主控 → 子代理（任務下達）

```yaml
TASK_ASSIGNMENT:
  task_id: "{subtask_id}"
  parent_task_id: "{main_task_id}"
  
  [INPUT]:
    # 具體任務輸入
  
  [GOAL]:
    # 具體目標
    
  [CONSTRAINTS]:
    # 限制條件
    
  [OUTPUT_FORMAT]:
    # 期望格式
    
  reporting:
    mode: "final|incremental"  # 最終報告或階段報告
    channel: "sessions_send"
```

### 子代理 → 主控（結果回報）

```yaml
TASK_RESULT:
  task_id: "{subtask_id}"
  status: success|partial|failed
  
  summary: "一句話摘要"
  
  output:
    # 實際產出
  
  metadata:
    duration_seconds: {耗時}
    tokens_used: {（如有）}
    
  next_steps:  # 建議
    - "建議1"
```

### 主控 → 用戶（狀態更新）

```yaml
PROGRESS_UPDATE:
  task_id: "{main_task_id}"
  status: executing|waiting_subagent|integrating|done
  
  progress:
    completed_steps: ["步驟1", "步驟2"]
    current_step: "步驟3"
    remaining_steps: ["步驟4"]
    
  waiting_on:
    - agent: researcher
      since: "{時間}"
      
  estimated_completion: "{時間估算}"
```

---

## 狀態追蹤

使用 `state/tasks/{task_id}.md` 追蹤每個複雜任務：

```yaml
task:
  id: "{main_task_id}"
  title: "{任務標題}"
  status: idle|analyzing|planning|executing|integrating|done|abort
  
  created_at: "{時間}"
  updated_at: "{時間}"
  
  subtasks:
    - id: "{subtask_id}-01"
      name: "{名稱}"
      assigned_to: "{agent}"
      status: pending|executing|done|failed
      result: null|{output}
      
    - id: "{subtask_id}-02"
      ...
      
  blockers:
    - type: waiting_subagent|missing_data|ambiguous_goal
      description: "{描述}"
      since: "{時間}"
```

---

## 決策樹

### 當子代理回報失敗

```
[收到失敗報告]
    ↓
評估失敗原因
    ↓
├─ 可重試（網路錯誤、暫時性）──→ [重試最多2次]
    ↓
├─ 需要更多輸入 ──→ [補充輸入，重新分配]
    ↓
└─ 不可重試（能力不足）──→ [主控代理接手或回報用戶]
```

### 當用戶指令模糊

```
[收到模糊指令]
    ↓
生成 3 種假設
    ↓
呈現給用戶選擇
    ↓
等待確認後執行
```

---

## 錯誤處理

| 情況 | 處理 |
|------|------|
| 子代理無響應 | 等 10 分鐘後重新分配或接手 |
| 子代理產出不符 | 要求重做或主控接手 |
| 多個子代理結果衝突 | 主控裁決，優先信任數據來源 |
| 任務複雜度超出預期 | 重新評估，可能需要分解或拒絕 |

---

## 對接

- **主控**：lobster（接收指令、協調、交付）
- **子代理**：researcher / writer / analyst / outreach
- **追蹤**：`state/tasks/{task_id}.md`
- **協議**：`agents/_protocols/coordinator-protocol.md`
