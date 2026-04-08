# 任務追蹤模板

_用途：結構化記錄每個複雜任務的執行狀態_

---

## 任務範例

```yaml
task:
  id: task-2026-04-08-{SEQ}
  title: "ESG 報告生成"
  description: "為 XXX 客戶生成 Q1 ESG 報告"
  status: executing  # idle | analyzing | planning | executing | retry | abort | done
  
  # 基本資訊
  created_at: 2026-04-08T10:00:00+07:00
  created_by: lobster
  updated_at: 2026-04-08T10:30:00+07:00
  
  # 任務分解
  decomposition:
    - step: 1
      name: "資料收集"
      assigned_to: researcher
      status: done
      output: "收集到 12 項數據"
      completed_at: 2026-04-08T10:15:00+07:00
      
    - step: 2
      name: "數據分析"
      assigned_to: analyst
      status: executing
      output: null
      started_at: 2026-04-08T10:15:00+07:00
      
    - step: 3
      name: "PDF 生成"
      assigned_to: lobster
      status: pending
      
  # 風險標記
  risk_flags:
    - "數據來源延遲"
    
  # 依賴
  depends_on: []
  
  # 交付物
  deliverables:
    - type: file
      path: "ESG_IIoT_Report_Q1.pdf"
      status: pending
      
  # 最終結果
  result:
    status: success  # success | partial | failed
    summary: "報告已生成，共 20 頁"
    details:
      - "覆蓋法規合規分析"
      - "包含 IIoT 架構圖"
      - "PDF 大小：957KB"
```

---

## 狀態說明

| 狀態 | 意義 | 可接受的下一步 |
|------|------|--------------|
| `idle` | 任務建立，尚未開始 | `analyzing` |
| `analyzing` | 分析目標和需求 | `planning` 或 `done` |
| `planning` | 規劃執行方案 | `executing` |
| `executing` | 執行中 | `executing`（仍在執行）→ `done` 或 `abort` |
| `retry` | 執行失敗，準備重試 | `executing` 或 `abort` |
| `abort` | 任務取消/失敗 | （終態）|
| `done` | 任務完成 | （終態）|

---

## 填寫指南

### 建立新任務
1. 複製本模板
2. 填入 `id`、`title`、`description`
3. 設定 `status: idle`
4. 規劃 `decomposition`
5. 開始執行

### 更新任務狀態
1. 修改 `status`
2. 更新 `updated_at`
3. 在對應步驟填入 `output` 和 `completed_at`
4. 如有風險，添加 `risk_flags`

### 完成任務
1. 設定最終 `status: done`
2. 填寫 `result`
3. 確認所有 `deliverables` 已產出

---

## 檔案命名

```
state/tasks/
├── task-2026-04-08-001.md
├── task-2026-04-08-002.md
├── task-2026-04-09-001.md
└── ...
```

---

_每次建立新任務時，請完整填寫所有欄位。_
