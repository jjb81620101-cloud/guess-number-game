# MEMORY.md - 長期記憶

_最後更新：2026-03-22_

## 人物
_

## 偏好
- 報告要求精美（偏好 PDF 輸出、視覺化呈現）
- 偏好本地運行工具（noteapp 尚未決定是否安裝）
- 繁體中文為主

## 决策
- gogcli WSL 端跳過（路徑問題）
- google-workspace-mcp OAuth 設定待完成（綁定 Gmail/Calendar/Drive）
- noteapp 研究後未安裝（待確認）

## 事實
- 使用者正在推動 ESG IIoT 報告，EN_E-Power-ESG-IIoT-2026.pdf 已產出 v3 美化版（957KB）
  - 法規區塊（CSRD/SEC/CBAM/中國碳市場）需強化：約束對象 + 違反下場
- MiniMax 模型用量緊張：本週區間只剩 78 次
- gogcli v0.12.0 安裝於 container（Linuxbrew）
- MCP server 需求：@execute/mcp-server-google-workspace v2.3.4

## 待辦（進行中）
- [ ] 完成 google-workspace-mcp OAuth 設定（Gmail/Calendar/Drive 讀寫）
- [ ] noteapp 安裝評估（待使用者確認）
- [ ] 監控 MiniMax 區間用量（只剩 78 次）
- [ ] ESG IIoT 報告法規區塊加強：約束對象 + 違反下場

## Harness Engineering 重構（2026-04-08）

少爺看了 Harness Engineering 影片後，要求直接重構 OpenClaw 工作空間。

### Phase 1 ✅ 完成
- `HARNESS.md` 架構藍圖
- `tools/registry.yaml` 工具註冊表（46+工具）
- `permissions.yaml` 權限系統
- `memory/semantic/` 語義記憶系統
- `workflows/` 標準工作流程（research/report/outreach）
- `agents/lobster/SPEC.md` 主控代理規格
- `state/tasks/` 任務追蹤模板

### Phase 2 ✅ 完成
- 4 個專業代理規格（researcher/writer/analyst/outreach）
- `coordinator-protocol.md` 主控協調協議
- `state/` 任務追蹤系統（task-tracker.sh + audit-log.py）

### Phase 3 ✅ 完成
- [x] 安裝 openclaw-control-center 至 .agents/
- [x] 建立 start.sh 啟動腳本
- [x] 建立 status.sh 狀態檢查腳本
- [x] 建立 INTEGRATION.md 整合指南
- [x] Control Center UI 已運行於 http://127.0.0.1:4310/

## 歷史蒸餾記錄

### 2026-03-21
- ESG IIoT 報告：完成 v3 美化版（957KB），A/B/C/D 四區塊強化，法規說明待加強約束對象與違反下場
- MiniMax 用量：本週 574 剩餘，區間僅剩 78 次（⚠️ 警覺）
- gogcli 安裝完成（v0.12.0，container Linuxbrew）
- google-workspace-mcp 待 OAuth 設定
- noteapp（AI 多代理筆記工具）研究完成，待用戶確認是否安裝
- 研究：NotebookLM + Gemini 英語學習法（來源：101事務所 YouTube）
