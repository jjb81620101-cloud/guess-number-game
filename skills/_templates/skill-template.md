---
name: skill-template
description: Skill 標準化範本（YAML Frontmatter 格式）
version: 1.0.0
author: lobster-core
tags: [template, standard]
triggers:
  - 觸發關鍵字 1
  - 觸發關鍵字 2
created: 2026-04-08
updated: 2026-04-08
---

# Skill 名稱

## 概述
一句話說明這個 Skill 做什麼。

## 觸發條件
- 當用戶要求「...」時
- 當任務涉及「...」時
- **注意**：不符合條件時不要觸發

## 工作流程

### Step 1: 步驟名稱
詳細說明這個步驟要做什麼。

**輸入**：什麼資料/參數
**輸出**：預期結果

### Step 2: 步驟名稱
...

## 工具使用

| 工具 | 用途 | 風險等級 |
|------|------|---------|
| web_search | 搜尋資訊 | low |
| read | 讀取檔案 | low |
| write | 寫入結果 | medium |

## 輸出格式

```yaml
result:
  status: success|error
  summary: 一句話摘要
  details:
    - 項目 1
    - 項目 2
```

## 範例

**輸入**：
用戶說「幫我研究區塊鏈在供應鏈的應用」

**執行**：
1. web_search 搜尋相關資訊
2. 整理成結構化報告
3. 輸出摘要

**輸出**：
```yaml
result:
  status: success
  summary: 區塊鏈在供應鏈的三大應用場景
  details:
    - 可追溯性
    - 智慧合約
    - 貿易金融
```

## 錯誤處理

| 錯誤情況 | 處理方式 |
|---------|---------|
| 網路錯誤 | 重試 3 次，失敗則回報 |
| 無資料 | 回報「搜尋結果為空」 |
| 配額用盡 | 暫停並通知用戶 |

## 依賴的其他 Skills

- `research-pipeline.md`（如有需要）
- `output-formatting.md`（如有需要）

---

_使用此範本建立新 Skill，保持 YAML frontmatter 一致性。_
