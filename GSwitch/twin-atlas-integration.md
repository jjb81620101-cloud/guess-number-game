# WFGY Twin Atlas × GSwitch MAGI 整合方案

## 日期：2026-03-31

## 整合動機

WFGY Twin Atlas 提供了「路由感知 + 授權控制」的雙軌架構，
可以強化 GSwitch MAGI 三派辯論的決策品質。

---

## 架構對照

| Twin Atlas | MAGI 三派 | 職責 |
|-------------|-----------|------|
| Forward Atlas | Casper（重建派）| 預測路由、規劃方向 |
| Bridge | Balthasar（務實派）| 價值傳遞、協調平衡 |
| Inverse Atlas | Melchior（隔離派）| 授權審查、限制控制 |

### Hidden Orchestration（隱藏協調）
對應：GSwitch 整體記憶管理（mem0）

---

## 核心原則整合

### Twin Atlas 雙軌原則

```
Forward Atlas = 地圖（地圖精確不等於目的地正確）
Inverse Atlas = 許可權（結論強度必須有授權依據）
```

### GSwitch 應用

| 失敗模式 | 預防機制 |
|---------|---------|
| 錯誤結構區域 | Forward Atlas 路由預測 |
| 過度結論 | Inverse Atlas 授權審查 |

---

## 整合後的 MAGI 決策流程

```
[新技術引入]
    ↓
1. Casper（Forward Atlas）→ 分析路由、規劃方向
2. Balthasar（Bridge）→ 協調價值、傳遞共識
3. Melchior（Inverse Atlas）→ 審查授權、限制輸出
    ↓
[最終決策]
```

---

## 防止的問題

| 問題 | Twin Atlas 解決 |
|------|----------------|
| 模糊不清 | Forward 路由預測 |
| 過度自信 | Inverse 授權控制 |
| 價值流失 | Bridge 協調傳遞 |

---

## 實際應用：WFGY 文件分析

| 階段 | 負責代理 |
|------|---------|
| Forward 分析 | jacky-em（創意/規劃）|
| Bridge 協調 | jacky-designer（協調/平衡）|
| Inverse 審查 | jacky-reviewer（授權/限制）|

---

## Governance Stress Suite 整合

### 8 案例測試框架

| 案例 | 領域 | 測試重點 |
|------|------|---------|
| Case 01 | 醫療建議 | 證據不足時的回覆邊界 |
| Case 02 | 法律建議 | 競爭解釋時的處理 |
| Case 03 | 財務投資 | 過度自信風險 |
| Case 04 | 安全敏感 | 拒絕不當請求 |
| Case 05 | 模糊指令 | 授權不足處理 |
| Case 06 | 衝突目標 | 價值取捨 |
| Case 07 | 未知領域 | 能力邊界 |
| Case 08 | 快速決策 | 時間壓力下保持紀律 |

### 決策輸出狀態

| 狀態 | 意義 |
|------|------|
| NOT AUTHORIZED TO CONCLUDE | 結論未獲授權 |
| COARSE ONLY | 僅粗糙結論 |
| COMPETING EXPLANATIONS REMAIN LIVE | 競爭解釋存在 |
| EVIDENCE CHAIN NOT SUFFICIENT | 證據鏈不足 |
| CONFLICT NOT RESOLVED | 衝突未解決 |

### GSwitch MAGI 應用

```
[新技術評估]
    ↓
BEFORE: Casper 快速結論（可能過度自信）
    ↓
AFTER: Melchior 授權審查（ Twin Atlas 控制）
    ↓
[最終決策] → 狀態：COARSE ONLY / NOT AUTHORIZED...
```

---

## 下一步

- [x] WFGY Governance Stress Suite 整合
- [ ] 更新 jacky-reviewer SKILL.md 加入授權審查邏輯
- [ ] 更新 jacky-em SKILL.md 加入路由預測框架
- [ ] 建立 Bridge 協調協議
- [ ] 建立 8 案例測試文件
