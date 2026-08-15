# 元件選用指引（UI 概念 → directive）

> 對照版本：`@mezzanine-ui/ng` `1.0.0-rc.4` · `@mezzanine-ui/core` `1.0.4`。Last verified: 2026-08-14。
>
> 這份文件回答的問題是：**「我知道我要做的 UI 長什麼樣，但不知道它在 Mezzanine 叫什麼。」**
> 速查表在 [SKILL.md → 元件選用](../SKILL.md#元件選用必讀--先用ui-概念反查-directive-名)，這裡是完整版與理由。

---

## 為什麼會選錯：三個機制

選錯元件不是「不夠細心」，是三個可預期的推論陷阱。認得出機制，才擋得住下一次。

### 1. 先驗誤導 — 帶著別的設計系統的記憶來讀

同一個 UI 概念在各家設計系統叫法不同，而且**互相衝突**：

| UI 概念          | Angular Material | MUI                 | Ant Design  | Mezzanine (ng)                 |
| ---------------- | ---------------- | ------------------- | ----------- | ------------------------------ |
| 有顏色的狀態晶片 | `mat-chip`       | `Chip`              | `Tag`       | `MznBadge variant="dot-*"`     |
| 分類標籤         | `mat-chip`       | `Chip`              | `Tag`       | `MznTag`                       |
| icon 角落紅點    | `matBadge`       | `Badge`             | `Badge`     | `MznBadge variant="dot-*"` + 投影內容 |
| 分段控制項       | `mat-button-toggle-group` | `ToggleButtonGroup` | `Segmented` | `MznRadio type="segment"`  |
| 開關             | `mat-slide-toggle` | `Switch`          | `Switch`    | `MznToggle`                    |

帶著「Badge = icon 上的小紅點」「Tag = 有顏色的 Chip」這種先驗來讀 Mezzanine 文件時，摘要句若沒有**主動推翻**先驗，讀者就會照先驗行動。

### 2. 可發現性斷裂 — 概念名稱與元件名稱斷開

Mezzanine 的元件名反映**實作結構**，不是使用者概念：

- 分段控制項的實作是 `MznRadio` 的一個 `type` → 歸類在 **Data Entry**。
  但「排序切換」不是表單輸入，沒有人會用這個念頭走到 `Radio.md`。
- 設計稿上的元件名是 **`Segmented Control`**，程式碼裡叫 `Radio`。
  兩個名字若沒有在文件裡接起來，只靠人肉記憶會反覆重犯。

### 3. 只描述能力、不描述邊界

文件說了元件「能做什麼」，沒說它「不能做什麼」。缺少否定句時，這條推論鏈完全合理：

```
我要做狀態晶片
  → 這件事在別家叫 Chip / Tag
  → 打開 Tag.md，inputs 裡沒有 color / severity
  → 「這個 Tag 比較陽春，顏色要自己補」          ← 錯在這一步
  → 在 component.scss 寫 5 條規則覆寫底色
```

正確的推論是：**「顏色不在 Tag 的職責範圍內 → 狀態不該用 Tag → 應該有別的元件。」**

> **最有效的攔截不是補更多範例，而是在容易被先驗誤導的元件上寫一句明確的否定句：「X 不做 Y，要 Y 請用 Z。」**
> 否定句會攔截錯誤推論，範例不會 —— 因為讀者在看到範例之前就已經離開那份文件了。
> 這也是為什麼各元件文件的 `Aliases` / `Not for` 兩行放在**摘要句正下方**：否定句必須出現在讀者被勸退**之前**。

---

## 判斷句速查

遇到下列情境，先問自己右邊那句話：

| 情境                      | 判斷句                                               | 結果                                                                    |
| ------------------------- | ---------------------------------------------------- | ----------------------------------------------------------------------- |
| 要放一個小標籤            | 「它在說『它是什麼』，還是『它現在怎麼樣』？」       | 是什麼 → `MznTag`；現在怎麼樣 → `MznBadge variant="dot-*"`               |
| 要做一組互斥切換          | 「這組選項是不是同一時間只能選一個？」               | 是 → `MznRadio type="segment"`；不是 → `MznCheckbox` / `MznTag active`   |
| 要放一段提示文字          | 「它是講整個系統／整頁的事，還是講這個區塊的事？」   | 整頁 → `MznAlertBanner`；這個區塊 → `MznInlineMessage`                   |
| 要顯示「沒東西」          | 「是還沒有資料，還是剛做完一件事？」                 | 沒資料 → `MznEmpty`；做完一件事 → `MznResultState`                       |
| 要做載入中                | 「知不知道進度百分比？看不看得出版面骨架？」         | 有百分比 → `MznProgress`；有骨架 → `MznSkeleton`；都沒有 → `MznSpin`     |
| 要做下拉                  | 「選完之後是留下一個『值』，還是觸發一個『動作』？」 | 值 → `MznSelect`；動作 → `MznDropdown`                                   |
| **要覆寫元件外觀**        | **「我是不是在改 background / color / border？」**   | **是 → 停下來，你選錯元件了**（`::ng-deep` 出現在這類規則上同樣是訊號） |

---

## 完整對照表

### 標籤與狀態

| 你要做的 UI                                | directive                                     | 不要用                                     |
| ------------------------------------------ | --------------------------------------------- | ------------------------------------------ |
| 狀態晶片（已核准 / 失敗 / 停用 / 送審中）  | `MznBadge variant="dot-*"` + `text`           | `MznTag` + class 覆寫底色                  |
| 表格狀態欄                                 | `MznBadge variant="dot-*"` + `text`           | `MznBadge variant="text-*"`（見下）        |
| 分類標籤、可篩選的屬性                     | `MznTag`                                      | 自刻 `span` + border                       |
| 白底灰框的描邊標籤                         | `MznTag readOnly`                             | 自刻 border                                |
| 未讀數字氣泡                               | `MznBadge variant="count-*"` + `count`        | `MznTag` 的 counter 型（那是分類計數）     |
| icon 角落的小紅點                          | `MznBadge variant="dot-*"` + 投影 icon        | 自刻絕對定位圓點                           |

### 選取與切換

| 你要做的 UI                                        | directive                                              | 不要用                                |
| -------------------------------------------------- | ------------------------------------------------------ | ------------------------------------- |
| 分段控制項 / Segmented Control / 檢視切換 / 排序切換 | `MznRadioGroup type="segment"` + `MznRadio type="segment"` | 多顆 `mznButton` 用 variant 差異模擬 |
| 開關                                               | `MznToggle`                                            | 自刻 checkbox + CSS                   |
| 多選                                               | `MznCheckbox` / `MznCheckboxGroup`                     | 多顆 `MznToggle`                      |
| 卡片式的單選 / 多選                                | `MznSelectionCard`                                     | `MznBaseCard` + 自刻選中框            |
| 選「值」的下拉                                     | `MznSelect`                                            | `MznDropdown`                         |
| 選「動作」的下拉選單                               | `MznDropdown` + `MznDropdownItem` / `MznDropdownAction` | `MznSelect`                           |
| 有階層的下拉                                       | `MznCascader`                                          | 巢狀 `MznSelect`                      |
| 邊打字邊過濾的下拉                                 | `MznAutocomplete`                                      | `MznSelect` + 自製搜尋                |

### 訊息與回饋

| 你要做的 UI                    | directive                                            | 不要用                                  |
| ------------------------------ | ---------------------------------------------------- | --------------------------------------- |
| 頁面級 / 系統級警示橫幅        | `MznAlertBanner`                                     | `MznInlineMessage` 撐滿寬度             |
| 區塊內的說明 / 警語 / 表單提示 | `MznInlineMessage` / `MznInlineMessageGroup`         | `MznAlertBanner`（它會浮到頁面頂端）    |
| 操作完成的浮動提示 / Toast     | `MznMessage`（imperative API）                       | 自刻 toast                              |
| 站內通知列表 / 通知中心        | `MznNotificationCenter`                              | 用 `MznMessage` 堆疊                    |
| 自建一套通知系統               | `MznNotifier`                                        | 直接改 `MznMessage`                     |
| 需要使用者回應的對話框         | `MznModal`                                           | `MznDrawer`                             |
| 側邊滑出的詳情 / 表單          | `MznDrawer`                                          | `MznModal` 靠 CSS 移到側邊              |

> **`MznAlertBanner` 為什麼不能當區塊內說明**：它透過 Portal 的 `alert` 層渲染（`packages/core/src/portal/_portal-styles.scss` — `position: sticky; top: 0`），**不會待在你放它的地方**，而是浮到頁面頂端，蓋住 `mznPageHeader`。區塊內的說明一律用 `MznInlineMessage`。

### 版面與內容

| 你要做的 UI                       | directive                                              | 不要用                              |
| --------------------------------- | ------------------------------------------------------ | ----------------------------------- |
| 卡片式頁面區塊 / Panel / Fieldset | `MznSection`（自帶 16px 內距與底色）                   | 自刻 `div` + box-shadow             |
| 圖文卡片 / 商品卡                 | `MznBaseCard` / `MznQuickActionCard` / `MznCardGroup`  | `MznSection`                        |
| 標題-內容成對的詳情資訊           | `MznDescription` + `MznDescriptionTitle` / `MznDescriptionContent` | 兩欄 `MznTable`         |
| 頁籤                              | `MznTabs` + `MznTabItem`                               | 自刻按鈕列                          |
| 篩選列                            | `MznFilterArea` + `MznFilterLine` + `MznFilter`        | 自排 `mznTextField` + `mznButton`   |
| 多步驟流程指示                    | `MznStepper`                                           | 自刻圓圈 + 連線                     |
| 滑過顯示說明                      | `MznTooltip`                                           | 原生 `title` 屬性                   |
| 文字溢出才顯示完整內容            | `MznOverflowTooltip`                                   | `MznTooltip` + 自行量測寬度         |

> 內容投影（content projection）有靜默過濾的陷阱，詳見 [SKILL.md → Content Projection Pitfalls](../SKILL.md#content-projection-pitfalls-重要--寫了但畫面不顯示)。

### 狀態畫面

| 你要做的 UI                     | directive        | 不要用             |
| ------------------------------- | ---------------- | ------------------ |
| 沒有資料的空畫面                | `MznEmpty`       | `MznResultState`   |
| 操作結果頁（成功 / 失敗 / 404） | `MznResultState` | `MznEmpty`         |
| 載入骨架（看得出版面結構）      | `MznSkeleton`    | `MznSpin` 蓋整頁   |
| 轉圈 loading（不知道進度）      | `MznSpin`        | `MznProgress`      |
| 有百分比的進度                  | `MznProgress`    | `MznSpin`          |

---

## Figma 名稱 ≠ 程式碼名稱

設計師講的名字與程式碼名字對不上的地方。**這是可發現性斷裂最直接的來源**，看設計稿時對照這張表。

| Figma 元件名                                  | 程式碼                                                      | 備註                                  |
| --------------------------------------------- | ----------------------------------------------------------- | ------------------------------------- |
| `Segmented Control` / `Segmented Control Set` | `MznRadioGroup type="segment"` + `MznRadio type="segment"`  | 完全不同的名字，最容易漏              |
| `Badge / Dot With Text`                       | `<div mznBadge variant="dot-*" text="…"></div>`             | 表格狀態欄的正解（selector 限定 `div`） |
| `Tag / Static`（描邊樣式）                    | `<span mznTag readOnly></span>`                             | 描邊不是另一個元件，是 `readOnly` input |

完整 Figma 對照見 [FIGMA_MAPPING.md](FIGMA_MAPPING.md)。

---

## 已驗證的元件邊界事實

以下都核對自 `@mezzanine-ui` 原始碼（樣式由 `@mezzanine-ui/core` 提供，React 與 Angular 共用），是「為什麼不能這樣做」的依據。

### `MznTag` 沒有語意顏色

`packages/core/src/tag/_tag-styles.scss` — `Tag` 只有**單一配色**（`background/brand-faint` 底 + `text/brand-solid` 字），沒有 `color` / `severity` / `status` input，也沒有對應的 CSS variable。

這是刻意的：**`Tag` 表達「這是什麼」（分類），不表達「它現在怎麼樣」（狀態）。**

`readOnly` 是唯一的外觀變化 —— `background-color: unset` + `border: 1px solid border/neutral-light`，也就是「白底 + 灰框」的描邊型。需要描邊外觀時用它，不要自己刻 border。

### `MznBadge` 的 `dot-*` / `text-*` **沒有背景色**

`packages/core/src/badge/_badge-styles.scss`：

| variant   | 實際樣式                                                               | 有膠囊底嗎                                   |
| --------- | ---------------------------------------------------------------------- | -------------------------------------------- |
| `dot-*`   | `color` + `column-gap` + 一顆 `::before` 圓點                          | ❌ 無 background / radius / padding           |
| `text-*`  | `color` + `column-gap`                                                 | ❌ 只有文字顏色                               |
| `count-*` | `color` + `background-color` + `border-radius` + `padding-inline` | ✅ 但它的 input 是 `count: number`，塞不了文字 |

> `count-*` 的圓角**不是一致的**：`count-alert` / `count-inactive` / `count-inverse` / `count-brand` 是 `radius.variable(full)`（膠囊），但 **`count-info` 是 `radius.variable(tiny)`**（近乎方角）。核對自 `packages/core/src/badge/_badge-styles.scss` 的 `$count-type-config`。

**結論：設計稿上的「膠囊狀態晶片」（有底色的圓角方塊 + 狀態文字）在 Mezzanine 裡零覆寫做不出來。** 遇到這種稿子的正解是改用 `dot-*` + `text`，或回頭與設計確認 —— **不是**自己補 background。

### 表格狀態欄用 `dot-*`，不要用 `text-*`

實測（放大對照）：表格狀態欄用 `text-success` 時，「啟用」與同一列操作欄的 `base-text-link`「編輯」**幾乎無法分辨** —— 同色系、同字重、同字級，狀態看起來像可點的連結。

`dot-*` 多的那顆 6px 圓點提供了「這是狀態指示器」的**形狀記號**，一眼分開，不靠顏色。

補充一個色階事實（`packages/system/src/palette/typings.ts`）：`TextTone` 有 `error-strong` / `warning-strong` / `info-strong`，**但沒有 `success-strong`**（只有 `IconTone` 有）。所以純文字綠固定卡在 `text/success` = green-500 `#139F62`，對白底對比 **3.41:1**，低於 WCAG AA 的 4.5:1，**在型別範圍內換不掉**。這是另一個該用 `dot-*` 的理由。

### `@mezzanine-ui/ng` 沒有 `MznSwitch`

開關一律用 `MznToggle`（React 的 `Switch` 已於 `@mezzanine-ui/react` 1.4.1 移除，ng 從未提供）。

---

## 兩個真實案例

來源：某 React 專案 P2 開發。機制與 Angular 完全相同，兩次誤用的資訊**都已經在文件裡**，但都沒被讀到。

### 案例一：狀態標籤用了 `Tag`

大量「狀態」需要呈現（啟用 / 停用、草稿 / 送審中 / 已核准 / 退回補正、成功 / 失敗）。實作用了 `Tag`，並自建四個 class 覆寫底色：

```scss
/* ❌ 這就是「長出一套與設計系統平行的私有色階」 */
.app-status--positive { background: …; color: …; }
.app-status--negative { … }
.app-status--caution  { … }
.app-status--neutral  { … }
```

這違反了「樣式只能透過 design token 調整，不可覆寫改造元件外觀」，**而寫的當下沒有意識到違反了** —— 因為它以為 `Tag` 就是狀態元件，只是剛好沒提供顏色 input。

正解，五階語意色、零覆寫：

```html
<!-- MznBadge 的 selector 限定 div[mznBadge]，host element 必須是 <div> -->
<div mznBadge variant="dot-success"  text="已核准"></div>
<div mznBadge variant="dot-error"    text="退回補正"></div>
<div mznBadge variant="dot-warning"  text="送審中"></div>
<div mznBadge variant="dot-info"     text="待覆核"></div>
<div mznBadge variant="dot-inactive" text="草稿"></div>
```

**為什麼會漏掉 `Badge`**：它在其他設計系統的唯一形態是「icon 角落的小圓點／數字氣泡」，摘要句若只提 dot 與 count，就會附和這個先驗，讓讀者跳過 `text` 與 dot-with-text —— 而那兩個才是狀態標籤。摘要句決定了讀者要不要往下讀。

### 案例二：分段控制項用了兩顆 `Button`

排序切換（「時效由近到遠」／「金額由大到小」）用兩顆 `Button` 的 variant 差異模擬選中狀態。正解：

```html
<div mznRadioGroup
  type="segment"
  size="sub"
  [(ngModel)]="sort"
  name="sort"
  [options]="[
    { id: 'sla', name: '時效由近到遠' },
    { id: 'amount', name: '金額由大到小' }
  ]">
</div>
```

**為什麼會漏掉**：全文搜尋 `Segmented` / `SegmentedControl` 只在 Figma cache 命中（Figma 元件名確實叫 `Segmented Control`），**`.md` 正文沒有出現過這個詞** → 結論「Mezzanine 沒有這個元件」→ 自己用 `Button` 刻。真正的實作在 `Radio.md`，歸類在 Data Entry，而「排序切換」這個念頭不會走到表單元件底下。

這是純粹的**可發現性問題**，不是文件正確性問題。已於本版在 `Radio.md` 補上別名列與非表單範例。

---

## 給文件維護者

新增或更新元件文件時，兩個欄位是**必填**，放在摘要句正下方、`## Import` 之前：

```markdown
> **Aliases** — mat-chip (Angular Material) · Chip (MUI) · Tag (Ant Design) · 標籤 · 分類標籤
> **Not for** — 狀態呈現（用 [`MznBadge variant="dot-*"`](Badge.md)）
```

- `Aliases` 收**其他設計系統的慣用名、Figma 元件名、中文口語名**。目的是讓全文搜尋命中 —— agent 與新進工程師都是從 UI 概念出發去找元件的。
- `Not for` 寫**否定句**：「X 不做 Y，要 Y 請用 Z」。沒有明確邊界時寫 `—`，保留欄位以維持模板一致。
- 這兩行與各元件文件裡「沒有語意顏色」「沒有膠囊底色」這類邊界章節是 **hand-curated**，`/sync-mezzanine-ui` 不得刪除或重寫；只有當 source 真的新增了對應能力（例如 `MznTag` 出現 `color` input）才回報給呼叫端，由人決定改寫。
