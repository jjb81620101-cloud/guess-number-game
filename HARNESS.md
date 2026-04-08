# HARNESS.md — OpenClaw 駕馭工程架構

_基於 Harness Engineering 原則重構 OpenClaw 工作空間_
_建立日期：2026-04-08_

---

## 🎯 核心理念

```
Harness = Tools + Knowledge + Observation + Action + Permissions
```

**目標：讓 AI 代理像一個有結構的團隊，而非一群各幹各的游擊隊。**

---

## 📐 三層記憶架構

### Layer 1: Working Memory（工作記憶）
- 用途：當前任務的即時上下文
- 位置：`memory/YYYY-MM-DD.md`（當日 session 記錄）
- 特性：純文字、隨對話累積、每日歸檔

### Layer 2: Semantic Memory（語義記憶）
- 用途：跨 session 的結構化知識
- 位置：`memory/semantic/`（index + 專題記憶）
- 特性：自動 index、標籤分類、可搜尋

### Layer 3: Procedural Memory（程序記憶）
- 用途：如何做事的流程（Skills、Workflows、SOPs）
- 位置：`skills/`、`lobster-core/SOP.md`
- 特性：YAML frontmatter 標準化、版本追蹤

---

## 👥 代理團隊結構

### 核心角色

| 代理 | 代號 | 職責 |
|------|------|------|
| **主控代理** | `lobster` | 接收指令、分解任務、協調資源、交付結果 |
| **研究代理** | `researcher` | 網頁爬取、資料收集、事實查核 |
| **內容代理** | `writer` | 文案生成、SEO 優化、社群內容 |
| **分析代理** | `analyst` | 數據處理、報告產出、視覺化 |
| **外聯代理** | `outreach` | 陌生開發、郵件 outreach、潛客追蹤 |

### 代理通訊規範

```
主控代理(lobster) ──任務拆解──→ 研究代理(researcher)
                              ──任務拆解──→ 內容代理(writer)
                              ──任務拆解──→ 分析代理(analyst)
                              ──任務拆解──→ 外聯代理(outreach)

子代理 ──執行結果──→ 主控代理 ──彙整交付──→ 用戶
```

---

## 🔧 工具註冊表（Tool Registry）

### 標準化格式

每個 Skill 的工具需要結構化定義：

```yaml
# tools/
web_search:
  description: 網頁搜尋
  category: research
  risk_level: low
  auth_required: false
  
gmail_send:
  description: 發送郵件
  category: communication
  risk_level: high
  auth_required: true
  requires_confirmation: true

file_write:
  description: 寫入檔案
  category: file_io
  risk_level: medium
  requires_confirmation: true
  path_rules:
    - pattern: "/workspace/**"
      allow: true
    - pattern: "/system/**"
      allow: false
```

### 風險分級

| 等級 | 定義 | 預設行為 |
|------|------|---------|
| `low` | 無風險（搜尋、讀取） | 自動執行 |
| `medium` | 有限風險（寫入、修改） | 確認後執行 |
| `high` | 高風險（刪除、對外發送） | 明確授權 |

---

## 🛡️ 權限系統（從 OpenHarness 借鑒）

### 權限模式

```yaml
# permissions.yaml
modes:
  default:  # 標準模式
    write_confirmation: true
    exec_confirmation: true
    delete_confirmation: true
    
  plan:  # 僅規劃模式
    write_confirmation: false
    exec_confirmation: false
    delete_confirmation: false
    allow_writes: false
    
  full_auto:  # 全自動模式（已驗證流程）
    write_confirmation: false
    exec_confirmation: false
    delete_confirmation: false
    allow_writes: true
```

### 路徑規則

```yaml
path_rules:
  - pattern: "~/.openclaw/workspace/**"
    description: 工作區檔案
    risk_level: medium
    
  - pattern: "~/.openclaw/config/**"
    description: 設定檔（禁止修改）
    risk_level: critical
    allow: false
```

---

## 📋 任務工作流（Task Pipeline）

### 標準流程

```
[接收指令] → [意圖澄清] → [任務分解] → [代理分配] → [執行監控] → [結果彙整] → [交付]
```

### 狀態機

```
[IDLE] → [ANALYZING_GOAL] → [PLANNING] → [EXECUTING] → [DONE]
                           ↓              ↓
                     [AWAITING_CONFIRM] [RETRY] → [ABORT]
```

### 任務追蹤格式

```yaml
task:
  id: task-2026-04-08-001
  title: ESG 報告生成
  status: executing
  decomposition:
    - step: 資料收集
      assigned_to: researcher
      status: done
    - step: 數據分析
      assigned_to: analyst
      status: executing
    - step: PDF 產出
      assigned_to: writer
      status: pending
  created_at: 2026-04-08T10:00:00Z
  updated_at: 2026-04-08T10:30:00Z
```

---

## 🗂️ 目錄結構（重構後）

```
~/.openclaw/workspace/
├── HARNESS.md                    # 本文件（架構藍圖）
├── memory/
│   ├── YYYY-MM-DD.md            # 每日工作記錄
│   └── semantic/                # 語義記憶（跨 session）
│       ├── index.md            # 記憶索引
│       ├── projects/           # 專案記憶
│       ├── contacts/           # 人脈記憶
│       └── preferences/        # 用戶偏好
├── agents/                      # 代理定義
│   ├── lobster/                # 主控代理
│   ├── researcher/
│   ├── writer/
│   ├── analyst/
│   └── outreach/
├── skills/                      # 技能標準化（YAML frontmatter）
│   ├── _templates/             # Skill 範本
│   ├── web_search/
│   ├── content_generation/
│   ├── data_analysis/
│   └── outreach/
├── workflows/                  # 工作流程定義
│   ├── research-pipeline.md
│   ├── content-pipeline.md
│   ├── report-pipeline.md
│   └── outreach-pipeline.md
├── tools/                      # 工具註冊表
│   ├── registry.yaml          # 工具清單
│   └── risk-matrix.yaml       # 風險矩陣
├── permissions.yaml            # 權限設定
└── state/                      # 狀態追蹤
    ├── tasks/                 # 任務佇列
    └── sessions/              # Session 歷史
```

---

## 🚀 優先實作順序

### Phase 1：核心框架（第 1-2 天）
- [ ] 建立 `tools/registry.yaml`（工具註冊表）
- [ ] 建立 `permissions.yaml`（權限系統）
- [ ] 標準化 `skills/` 的 YAML frontmatter
- [ ] 建立 `memory/semantic/index.md`（記憶索引）

### Phase 2：代理協調（第 3-4 天）
- [ ] 定義 `agents/` 代理規格
- [ ] 實作 `workflows/` 標準流程
- [ ] 建立 `state/tasks/` 任務追蹤

### Phase 3：自動化（第 5-7 天）
- [ ] 建立 cron job 自動記憶蒸餾
- [ ] 實作多代理協調協議
- [ ] 建立監控儀表板（對接 openclaw-control-center）

---

## 📊 成功指標

| 指標 | 當前 | 目標 |
|------|------|------|
| 任務完成率 | 取決於單次對話 | 結構化追蹤 |
| 知識複用率 | 低（靠記憶） | 高（語義索引） |
| 代理協作效率 | 無明確機制 | 明確分工+通訊規範 |
| 錯誤恢復能力 | 卡住需人接手 | 自動重試+降級 |

---

## 🔗 對接現有資源

- **OpenHarness**：`~/.openclaw/workspace/OpenHarness/`（已存在，可借鑽程式碼）
- **GSwitch**：`~/.openclaw/workspace/GSwitch/`（已整合）
- **lobster-core**：`~/.openclaw/workspace/lobster-core/`（代理身份定義）
- **openclaw-control-center**：`~/.openclaw/workspace/.agents/skills/openclaw-control-center/`（監控面板）

---

_本文件為 Harness Engineering 重構藍圖，每次大幅更新後修訂版本號。_
