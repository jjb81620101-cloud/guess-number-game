---
name: outreach-pipeline
description: 陌生開發 outreach 流程 — 找客戶 → 研究 → 撰寫 → 發送 → 追蹤
version: 1.0.0
author: lobster-core
tags: [outreach, crm, pipeline, workflow, 潛在客戶]
triggers:
  - 陌生開發
  - 找客戶
  - 開發信
  - outreach
  - 潛在客戶
  - cold email
created: 2026-04-08
updated: 2026-04-08
---

# Outreach 流程（Outreach Pipeline）

## 概述
標準化陌生開發流程：目標設定 → 潛在客戶研究 → 個人化開發信 → 發送追蹤。

## 觸發條件
- 用戶要求「陌生開發」
- 用戶要求「找潛在客戶」
- 用戶要求「發開發信」
- 用戶要求「outreach」

---

## Phase 1: 目標設定（GOAL_SETTING）

### Step 1: 確認目標受眾

```yaml
target_profile:
  industry: "目標產業"
  company_size: "公司規模"
  role: "目標職位"
  geography: "地理範圍"
  pain_points: ["痛點1", "痛點2"]
  value_proposition: "價值主張"
```

### Step 2: 設定 KPI

| 指標 | 目標 |
|------|------|
| 接觸數量 | 每批次 20-50 間 |
| 回覆率 | > 10% |
| 暖回覆率 | > 3% |
| 轉換率 | > 1% |

---

## Phase 2: 潛在客戶研究（RESEARCH）

### Step 1: 名單收集

**工具**：
- LinkedIn 搜尋
- 公司網站
- 產業名錄
- 既有資料庫

**建立名單**：
```yaml
prospect_list:
  - name: "公司名稱"
    website: "url"
    industry: "產業"
    size: "規模"
    key_contact: "聯絡人"
    contact_email: "email"
    source: "來源"
    notes: "備註"
```

### Step 2: 個人化研究

**研究重點**：
- 公司最近動態（新聞、產品、擴張）
- 關鍵決策者的背景
- 與你的產品/服務的潛在連結

**個人化切入點**：
- 最近的文章/言論
- 公司挑戰（從網站/新聞推斷）
- 共同話題或連結

---

## Phase 3: 開發信撰寫（DRAFTING）

### 開發信格式約束

**標題（Subject）**：
- 8 字以內
- 引發私人通訊感
- 避免：「請問」、「合作」、「介紹」

**範例**：
- 「關於 {公司} 的 {痛點}」
- 「{行業} 的 {趨勢} 看過嗎」
- 「有個 {具體數字}% 的提升想法」

---

### 內文結構

```
Paragraph 1（2-3句）:
- 開場鉤子：直接點出價值或痛點
- 禁止廢話（「希望這封信能找到你…」）

Paragraph 2（3-4句）:
- 價值說明：你能提供什麼
- 具體案例或數據
- 避免空泛形容詞

Paragraph 3（2-3句）:
- 明確下一步：示範/通話/文件
- 給對方一個簡單的台階
- 時間敏感時加上期限

結尾：
- 簡短簽名
- 聯繫方式
```

---

### 語氣紅線

- ✅「真人在試圖幫你」
- ❌ 機器人群發感
- ❌ 過度推銷腔
- ❌ 「這個非常好的機會…」
- ❌ 「點擊這裡立即…」
- ❌ 濫用表情符號

---

## Phase 4: 發送（发送）

### 發送前檢查清單

- [ ] 標題有個人化
- [ ] 內文有個人化元素
- [ ] 沒有錯別字
- [ ] 連結測試過
- [ ] 回覆地址正確
- [ ] 追蹤代碼已設定

### 發送工具

- `send_email` — 主要發送工具
- `search_emails` — 追蹤互動

---

## Phase 5: 追蹤（TRACKING）

### 追蹤流程

```
Day 0: 發送第一封信
Day 3-5: 追蹤郵件（如無回覆）
Day 7-10: 第二封追蹤（如無回覆）
Day 14: 最後一次嘗試
Day 30: 移至「待觀察」或「已結束」
```

### 分類標記

| 標籤 | 意義 | 後續動作 |
|------|------|---------|
| `[HOT]` | 高度感興趣，立即回覆 | 24小時內跟進 |
| `[WARM]` | 有回應，需培養 | 1-2天內跟進 |
| `[COLD]` | 無回應，繼續序列 | 按計劃追蹤 |
| `[NURTURE]` | 非目標，長期觀察 | 季度維護 |
| `[DONE]` | 已轉換或放棄 | 移出活躍序列 |

---

## Phase 6: CRM 記錄（LOGGING）

### 記錄格式

```yaml
outreach_record:
  prospect_id: "ID"
  company: "公司名"
  contact: "聯絡人"
  email: "email"
  sent_date: "2026-04-08"
  subject: "標題"
  status: "sent|opened|replied|interested|converted|dropoff"
  response: "回覆內容摘要"
  next_action: "下一步"
  updated_at: "時間"
```

### CRM 工具

- `create_contact` — 建立聯絡人
- `update_sheet_values` — 更新 Google Sheets
- `search_contacts` — 查詢既有客戶

---

## 工具清單

| 工具 | 用途 | 風險 |
|------|------|------|
| `web_search` | 研究潛在客戶 | low |
| `send_email` | 發送開發信 | high（需確認） |
| `search_contacts` | 檢查重複 | low |
| `create_contact` | 建立 CRM 紀錄 | medium |
| `update_sheet_values` | 更新名單 | medium |

---

## 風險控制

- [ ] 單批次不超過 50 封
- [ ] 發送間隔分散（避免一次大量）
- [ ] 追蹤發送頻率避免被標記
- [ ] 敏感內容先給少爺確認

---

_版本日誌：2026-04-08 建立標準化 outreach 流程_
