---
name: report-pipeline
description: 報告生成流程 — 從數據到精美 PDF
version: 1.0.0
author: lobster-core
tags: [report, pipeline, pdf, workflow]
triggers:
  - 生成報告
  - 製作報告
  - 輸出 PDF
  - 報告
created: 2026-04-08
updated: 2026-04-08
---

# 報告生成流程（Report Pipeline）

## 概述
標準化報告產出流程：資料收集 → 結構化整理 → 美化排版 → PDF 交付。

## 觸發條件
- 用戶要求「生成報告」
- 用戶要求「製作 PDF」
- 用戶要求「輸出報告」
- 任務涉及「ESG」、「分析報告」、「研究報告」

## 工作流程

### Step 1: 確認報告需求（ANALYZING_GOAL）

**必要資訊**：
```yaml
report_requirements:
  type: "ESG分析|市場報告|研究報告|自訂"
  title: "報告標題"
  sections: ["區塊1", "區塊2", ...]
  data_sources: ["數據源1", "數據源2"]
  audience: "目標讀者"
  language: "繁體中文|英文"
  format: "PDF|HTML|DOCX"
```

**確認清單**：
- [ ] 報告類型
- [ ] 必要的章節/區塊
- [ ] 數據來源
- [ ] 格式要求

---

### Step 2: 資料收集（COLLECTING）

**工具使用**：
- `research-pipeline` — 先完成研究流程
- `tavily_search` — 补充搜索
- `get_sheet_values` — 讀取 Google Sheets 數據

**檢查清單**：
- [ ] 主要數據齊備
- [ ] 相關法規/趨勢更新
- [ ] 圖表素材準備

---

### Step 3: 內容撰寫（DRAFTING）

**標準結構**：
```
# 報告標題

## 執行摘要（Executive Summary）
2-3 段概述核心發現

## 主體章節 1
### 1.1 小節
### 1.2 小節

## 主體章節 2
...

## 法規/趨勢 （如適用）

## 結論與建議

## 附錄（如有）
```

**撰寫原則**：
- 每 300 字一個 H3 子標題
- 句子不超過 40 個繁體中文字
- 禁止「我認為」、「或許」、「可能」
- 數據事實標註來源

---

### Step 4: 視覺美化（FORMATTING）

**排版標準**：
- 標題：H1（報告標題）、H2（章節）、H3（小節）
- 要點： bullet list（Discord/WhatsApp）或表格
- 數據：圖表 > 數字 > 文字

**視覺元素**：
- 表格：對齊、網格線
- 圖示：適當使用 emoji 增加可讀性
- 分塊：A/B/C/D 區塊清晰區分

---

### Step 5: PDF 生成（GENERATING）

**工具**：
- `pdf_generator` skill — HTML/Markdown 轉 PDF

**品質標準**：
- 檔案大小合理（壓縮圖片）
- 字體嵌入
- 跨頁標題重複

---

### Step 6: 交付與追蹤（DONE）

**交付確認**：
```yaml
report_delivery:
  file: "{檔案路徑}"
  size_bytes: {大小}
  generated_at: {時間}
  quality_check: passed|failed
  notification_sent: true|false
```

---

## 錯誤處理

| 情況 | 處理 |
|------|------|
| 數據缺失 | 先告知用戶，爭取補充 |
| PDF 生成失敗 | 回退 Markdown 版本 |
| 格式不符預期 | 提供修改版本 |

---

## 範例：ESG 報告結構

```yaml
esg_report:
  sections:
    - 執行摘要
    - 法規合規（CSRD/SEC/CBAM）
    - 技術架構（IIoT）
    - 數據分析
    - 減碳策略
    - 結論與建議
  visuals:
    - 法規時程圖
    - 技術架構圖
    - 數據趨勢圖
```

---

_版本日誌：2026-04-08 建立標準化報告生成流程_
