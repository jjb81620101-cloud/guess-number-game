---
name: research-pipeline
description: 標準研究流程 — 從搜尋到結構化報告
version: 1.0.0
author: lobster-core
tags: [research, pipeline, workflow]
triggers:
  - 研究
  - 調查
  - 搜尋分析
  - 研究報告
created: 2026-04-08
updated: 2026-04-08
---

# 研究流程（Research Pipeline）

## 概述
標準化的研究工作流：從關鍵字搜尋 → 資料收集 → 整理分析 → 結構化輸出。

## 觸發條件
- 用戶要求「研究 XXX」
- 用戶要求「調查 XXX」
- 用戶要求「分析 XXX 的市場/趨勢/現況」
- 用戶要求「撰寫 XXX 研究報告」

## 工作流程

### Step 1: 理解目標（ANALYZING_GOAL）

**任務**：確認研究目標和範圍

**問題清單**：
- 研究的主題是什麼？
- 需要多深入？（淺層了解 / 深度分析）
- 需要哪些面向？（技術、市場、競爭、趨勢）
- 輸出形式？（口頭摘要 / 文字報告 / 圖表）

**輸出**：
```yaml
research_objective:
  topic: "主題"
  depth: "淺|中|深"
  aspects: ["面向1", "面向2"]
  output_format: "摘要|報告|圖表"
```

---

### Step 2: 資訊收集（COLLECTING）

**任務**：多來源搜尋與資料收集

**工具使用順序**：
1. `tavily_search` — 快速搜尋（初步了解）
2. `tavily_research` — 深度研究（多源綜合）
3. `web_fetch` — 補充特定 URL 內容

**搜尋策略**：
- 主題關鍵字
- 子主題關鍵字
- 最新趨勢關鍵字（+ 最新、最新消息）
- 競爭分析（+ 競爭對手、比較）

**品質檢查**：
- [ ] 至少 3 個獨立來源
- [ ] 包含最新資訊（時間戳）
- [ ] 來源可信度評估

---

### Step 3: 整理分析（ANALYZING）

**任務**：結構化整理收集到的資訊

**分析框架**：
```
1. 現況描述（事實）
2. 關鍵趨勢（分析）
3. 驅動因素（因果）
4. 風險與機會（評估）
5. 建議與下一步（行動）
```

**事實 vs 推論 分離**：
- ✅ `[GROUNDED_FACT]` — 可驗證的事實
- ⚠️ `[SINGLE_SRC]` — 單一來源，需驗證
- 🔍 `[ASSUMPTION]` — 合理推論，標註不確定性

---

### Step 4: 產出輸出（DELIVERING）

**根據要求的格式輸出**：

| 格式 | 說明 |
|------|------|
| 口頭摘要 | 300 字內，3-5 個重點 |
| 文字報告 | 1000-2000 字，結構化章節 |
| 圖表 | 視覺化呈現，附說明 |

**標註來源**：
每個關鍵主張必須附帶：
- 來源名稱或 URL
- 時間戳
- `[VERIFIED_SRC]` 或 `[SINGLE_SRC]`

---

## 狀態追蹤

```yaml
task:
  id: research-{timestamp}
  status: collecting|analyzing|delivering|done
  topic: "{研究主題}"
  sources_count: {數量}
  output_format: "{格式}"
  created_at: {時間}
  completed_at: {時間}
```

## 錯誤處理

| 情況 | 處理 |
|------|------|
| 搜尋無結果 | 擴大關鍵字範圍，或回報「找不到相關資訊」 |
| 來源不足 | 至少找到 3 個獨立來源再繼續 |
| 配額用盡 | 暫停流程，通知用戶 |
| 主題太寬 | 先澄清範圍，再執行 |

---

_版本日誌：2026-04-08 建立標準化研究流程_
