---
name: using-mezzanine-ui-react
description: React / Next.js Mezzanine-UI skill — create, edit, or style JSX components with @mezzanine-ui/react (1.4.1). Covers Button, TextField, Select, Table, Modal, Form, DatePicker, Tabs, Navigation, Typography, Icon, Drawer, Upload, Toggle, design tokens, theming, and CalendarConfigProvider. Also defines the page layout padding contract (PageHeader / PageFooter / Section ship their own padding — page containers must not add horizontal padding). Use when working on *.tsx, *.scss files with @mezzanine-ui/react imports, building React forms, laying out a page skeleton, or configuring Mezzanine styles in a React codebase. Trigger — React, Next.js, tsx, JSX, mezzanine-ui/react, add mezzanine component, build form, create page UI, page layout, container padding, 版面對不齊, 雙層 padding, design tokens, mzn. For Angular projects use the sibling using-mezzanine-ui-ng skill instead.
---

# Mezzanine-UI Design System

**Core principle: All frontend development MUST prefer the Mezzanine-UI design system.**

> Baseline: `@mezzanine-ui/react` `1.4.1` · `@mezzanine-ui/core` `1.1.0` · `@mezzanine-ui/system` / `@mezzanine-ui/icons` `1.0.2`. Last verified: 2026-07-01.
>
> Check latest version: `npm view @mezzanine-ui/react versions` or see [GitHub Releases](https://github.com/Mezzanine-UI/mezzanine/releases).

## Resource Overview

| Type               | Resource                                                         | Purpose                |
| ------------------ | ---------------------------------------------------------------- | ---------------------- |
| **Figma Components** | [Component File](https://www.figma.com/design/gjGdP49GQZzOeQf0bNOFlt) | Referenceable design components |
| **Figma Docs**     | [Documentation](https://www.figma.com/design/VgnrTeu6oOSE0giftMw1Oy) | Design specs & guidelines |
| **Frontend Package** | [GitHub](https://github.com/Mezzanine-UI/mezzanine)           | React component source |
| **Doc Site**       | [Storybook (React)](https://storybook.mezzanine-ui.org/react/)  | Component examples & API |

---

## Quick Start

### Installation

```bash
yarn add @mezzanine-ui/core @mezzanine-ui/react @mezzanine-ui/system @mezzanine-ui/icons
```

### Style Setup

Create `main.scss`:

```scss
@use '~@mezzanine-ui/system' as mzn-system;
@use '~@mezzanine-ui/core' as mzn-core;

// Set design system variables
:root {
  @include mzn-system.palette-variables(light);
  @include mzn-system.common-variables(default);
}

// Dark mode
[data-theme='dark'] {
  @include mzn-system.palette-variables(dark);
}

// Compact mode
[data-density='compact'] {
  @include mzn-system.common-variables(compact);
}

// Load component styles
@include mzn-core.styles();
```

### Basic Usage

```tsx
import './main.scss';
import { Button, Typography } from '@mezzanine-ui/react';
import { PlusIcon } from '@mezzanine-ui/icons';

function App() {
  return (
    <div>
      <Typography variant="h1">Welcome to Mezzanine UI</Typography>
      <Button variant="base-primary" size="main">
        <PlusIcon />
        Click Me
      </Button>
    </div>
  );
}
```

### CalendarConfigProvider Setup (日期/時間元件必要)

使用任何日期或時間相關元件（DatePicker, DateRangePicker, DateTimePicker, DateTimeRangePicker, MultipleDatePicker, TimePicker, TimeRangePicker, Calendar, TimePanel）之前，**必須**在應用程式根層級包裹 `CalendarConfigProvider`，否則會拋出 runtime error: `Cannot find values in your context`.

```tsx
// layout.tsx 或 App.tsx
import { CalendarConfigProvider } from '@mezzanine-ui/react';
import { CalendarMethodsMoment } from '@mezzanine-ui/core/calendar';

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <CalendarConfigProvider methods={CalendarMethodsMoment}>
      {children}
    </CalendarConfigProvider>
  );
}
```

> 也可使用 `CalendarConfigProviderMoment` 或 `CalendarConfigProviderDayjs` 便捷封裝（從 `@mezzanine-ui/react/Calendar` 匯入）。

---

## Page Layout Skeleton (必讀 — 版面 padding 契約)

**建立任何頁面之前先讀這段。** Mezzanine 的頁面級元件**自己內建 padding**，而這些 padding 只寫在 `@mezzanine-ui/core` 的 SCSS 裡，**從 React props / TypeScript 型別完全看不出來**。若照一般開發慣例「先給 page container 一圈 padding 再放元件」，`PageHeader` 會出現**兩層水平 padding**（外層 + 內建），標題與下方內容左緣錯開。

### A. 滿版帶狀元件 — 自帶 gutter，必須是 page container 的直接子代

以下元件**沒有卡片底色**，它們的水平 padding 就是版面 gutter 本身。放進任何有 `padding-inline` 的 wrapper 都會多縮一次；`Tab` / `PageFooter` 的橫線也會斷在兩側。（數值皆核對自 `@mezzanine-ui/core` 原始 SCSS。）

| 元件         | 生效條件                                | host padding                                                             | default       | compact       | 備註                                              |
| ------------ | --------------------------------------- | ------------------------------------------------------------------------ | ------------- | ------------- | ------------------------------------------------- |
| `PageHeader` | 無條件                                  | `vertical-spacious horizontal-spacious 0`                                | `16 / 16 / 0` | `12 / 14 / 0` | **bottom 為 0**，區塊間距靠 container `row-gap`   |
| `PageFooter` | 無條件                                  | `vertical-base horizontal-spacious`                                      | `8 / 16`      | `4 / 14`      | 另有 `border-top` 與底色，必須整條貼齊版面        |
| `FilterArea` | `size="main"`（**預設值**）             | `padding-inline: horizontal-spacious` + `padding-top: vertical-spacious` | `16 / top 16` | `14 / top 12` | 與 PageHeader 同構，同樣沒有 bottom padding       |
| `Tab`        | `size="main"`（**預設值**）+ horizontal | `vertical-spacious horizontal-spacious 0`                                | `16 / 16 / 0` | `12 / 14 / 0` | 底線 `::before` 為 `inset: 0`，需滿版才不會被截斷 |
| `Tab`        | `size="main"` + vertical                | `0 0 0 horizontal-spacious`                                              | `left 16`     | `left 14`     | 只有左側                                          |

> **`size="main"` vs `size="sub"` 是判斷關鍵**：`main` = 直接放在頁面骨架、自帶 gutter；`sub` = 放在 `Section` 內、**沒有**外距（由 Section 的 padding 負責）。`Section` 會自動把傳入 `contentHeader` / `filterArea` 改寫成 `size="sub"`，並用 `> .mzn-tab--horizontal.mzn-tab--main { padding: 0 }` 把 main size 的 Tab padding 歸零。**`FilterArea` 與 `Tab` 的預設值都是 `main`** — 放進 body wrapper 卻忘了改 `size="sub"`，就會出現 16 + 16 = 32px 的雙層內縮。

### B. 卡片／內容元件 — 放進 body wrapper，由 wrapper 提供 gutter

| 元件                     | host padding                            | default   | compact   | 備註                                                       |
| ------------------------ | --------------------------------------- | --------- | --------- | ---------------------------------------------------------- |
| `Section`                | `vertical-spacious horizontal-spacious` | `16 / 16` | `12 / 14` | 有底色圓角但**無 margin**，外側 gutter 仍要靠 wrapper 提供 |
| `Table`                  | 無（padding 在 `th` / `td` 儲存格上）   | —         | —         | host `<table>` 本身沒有 padding                            |
| `Layout` / `Layout.Main` | 無                                      | —         | —         | app shell，完全不提供 padding                              |
| `ContentHeader`          | 無（只有 `gap: calm`）                  | —         | —         | 內距全由外層 `PageHeader` / `Section` 提供                 |

### C. 其他自帶 padding 的元件（與版面 gutter 無關，但同樣不要再包一層）

`Pagination` `8/12`、`AlertBanner` `block 12 / inline 24`、`NotificationCenter` `16/16`、`Upload` dropzone `24/24`、`Message` `12/16`、`Tooltip` `4/8`、`TimePanel`、`Card`、`Cascader`、`SelectionCard`、`Calendar` 各自有 host padding。這些是元件自身的內距，不需要也不應該再外加 padding，但它們不負責頁面 gutter。

### 四條規則

1. **頁面最外層 container 不可有水平 padding**（`padding` / `padding-inline` / `padding-left|right` 一律不要）— 讓 A 組元件自己貼齊版面邊緣。
2. **A 組元件直接掛在最外層 column**，不要塞進有 padding 的 wrapper 內。若非得放在 body wrapper 內（例如 filter 屬於某個 Section 的一部分），改用 `size="sub"`。
3. **B 組內容一律另包一層 main content wrapper**，套上與 PageHeader 相同的水平 padding：`padding-inline: var(--mzn-spacing-padding-horizontal-spacious)`。這樣表格 / 卡片 / 表單的左緣才會對齊 PageHeader 的標題文字。
4. **垂直間距用 container 的 `row-gap`**（建議 `var(--mzn-spacing-gap-calm)`，12px / compact 10px），不要對 `PageHeader` 補 `margin-bottom` — 它的 bottom padding 就是刻意留 0 給 container 分配。

```
+-------------------------------------------+   <- page container: 無水平 padding
| PageHeader  (padding: 16 16 0)            |
|       Breadcrumb / Title                  |   <- 標題文字內縮 16px
+-------------------------------------------+
| Tab size="main"  (padding: 16 16 0)       |   <- A 組：貼邊，底線才會滿版
+-------------------------------------------+
        row-gap: var(--mzn-spacing-gap-calm)
+-------------------------------------------+
| body wrapper (padding-inline: 16)         |
|     +-------------------------------+     |
|     | Section / Table / Form        |     |
|     +-------------------------------+     |   <- 卡片左緣同樣內縮 16px
+-------------------------------------------+
| PageFooter  (padding: 8 16)               |   <- border-top 需滿版
+-------------------------------------------+
```

### Canonical page skeleton（每個頁面都照這個結構寫）

Mezzanine **沒有**提供負責頁面 gutter 的容器元件 — `Layout` / `Layout.Main` 是 app shell（Navigation + 面板），內部只有 flex / min-width / overflow，**零 padding、也沒有任何 padding 相關 prop**。所以 gutter 一定要由頁面自己處理，結構固定為三層：

```tsx
// ContentHeader 已於 1.4.1 從主入口移除，但 PageHeader 仍要求它作為必要子元件 → sub-path 匯入
import { PageHeader, PageFooter, Breadcrumb, Button, Table } from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';
import styles from './page.module.scss';

export default function ProductListPage(): JSX.Element {
  return (
    // 第 1 層：page container — 無水平 padding，只負責垂直排列與 row-gap
    <div className={styles.page}>
      {/* 第 2 層 a：PageHeader 直接掛在 page container 底下，貼齊版面 */}
      <PageHeader>
        <Breadcrumb items={[{ name: 'Home', href: '/' }, { name: 'Products' }]} />
        <ContentHeader title="Product Management" description="管理所有商品">
          <Button>Add Product</Button>
        </ContentHeader>
      </PageHeader>

      {/* 第 2 層 b：主要內容包一層 body wrapper，這裡才套水平 padding */}
      <main className={styles.body}>
        <Table columns={columns} dataSource={data} />
      </main>

      {/* 第 2 層 c：PageFooter 與 PageHeader 同層，border-top 才會滿版 */}
      <PageFooter actions={{ primaryButton: { children: 'Save' } }} />
    </div>
  );
}
```

```scss
// page.module.scss
.page {
  display: flex;
  flex-direction: column;
  // ❌ 這裡永遠不加 padding-inline / padding-left / padding-right
  row-gap: var(--mzn-spacing-gap-calm);
  width: 100%;
  min-height: 100%;
}

.body {
  // ✅ 頁面裡唯一負責水平 gutter 的地方，值必須與 PageHeader 的水平 padding 相同
  padding-inline: var(--mzn-spacing-padding-horizontal-spacious);
  padding-block-end: var(--mzn-spacing-padding-vertical-spacious);
  display: flex;
  flex-direction: column;
  row-gap: var(--mzn-spacing-gap-calm);
  flex: 1;
  min-height: 0;
}
```

逐層說明：

- **`.page`（第 1 層）** — 只做「由上而下排列 + 區塊間距」。它**不能**有任何水平 padding，因為 `PageHeader` / `PageFooter` 自己已經有了；在這裡加就是雙層內縮的來源。`row-gap` 取代 `margin`，因為 `PageHeader` 的 `padding-bottom` 是 `0`，間距刻意留給 container 分配。
- **`PageHeader` / `PageFooter`（第 2 層，直接子代）** — 必須是 `.page` 的直接子代。只要被任何有 `padding-inline` 的 wrapper 包住，header 會多縮一次、footer 的 `border-top` 與底色也會斷在兩側。
- **`.body`（第 2 層）** — 唯一補 gutter 的地方，`padding-inline` 一律用 `--mzn-spacing-padding-horizontal-spacious`，與 `PageHeader` 同值，這樣表格 / 卡片 / 表單左緣才會對齊標題文字。`padding-block-end` 給頁尾內容留呼吸空間。內容之間的間距同樣用 `row-gap`，不要在子元素上加 `margin`。
- **內容是 `Section` 時** — 要分清楚兩層 padding：**外側 gutter 仍由 `.body` 的 `padding-inline` 提供**（`Section` 是 `.body` 的子元素，少了它卡片會貼齊版面邊緣、也不會與 PageHeader 標題左緣對齊）；**內側 16px 則是 `Section` 自帶的**，所以不要再對 `Section` 本身或它的直接子元素補 padding。結果是：卡片左緣 = 標題文字左緣 = 16px，卡片內容再往內 16px。

搭配 `Layout` 時，整個骨架原封不動放進 `Layout.Main`（它不提供 padding，也不需要）：

```tsx
<Layout>
  <Navigation>...</Navigation>
  <Layout.Main>
    <div className={styles.page}>{/* 同上結構 */}</div>
  </Layout.Main>
</Layout>
```

> 若專案頁面數量多、想避免每頁重抄這段 SCSS，可以把 `.page` / `.body` 抽成共用的 SCSS mixin（例如 `styles/_page-layout.scss` 提供 `@mixin page-root` / `@mixin page-body`），JSX 結構仍照上面明確寫出來。**不要**把 `PageHeader` 包進自訂容器元件再用 props 傳進去 — 那會讓頁面結構變得不透明。

### 自查清單（寫完頁面前逐項確認）

- [ ] page container 沒有任何水平 padding？
- [ ] `PageHeader` / `PageFooter` 是 page container 的**直接子代**，沒被 padded wrapper 包住？
- [ ] 主要內容有獨立 wrapper 且 `padding-inline` 使用 `--mzn-spacing-padding-horizontal-spacious`（不是寫死 16px、也不是 24px）？
- [ ] 區塊間距靠 `row-gap`，沒有對 `PageHeader` 加 `margin-bottom`？
- [ ] 內容是 `Section` 時，它有放在套了 `padding-inline` 的 `.body` 裡（不是直接掛在 `.page` 下貼邊），且**沒有**再幫 `Section` 自己補 padding？
- [ ] 有用到 `FilterArea` / `Tab` 嗎？放在 `.page` 直接層就維持預設 `size="main"`（自帶 gutter）；放進 `.body` 或 `Section` 內就必須改 `size="sub"`，否則是 16 + 16 的雙層內縮？

詳細範例與反例見 [references/PATTERNS.md → Page Body Alignment with PageHeader](references/PATTERNS.md#page-body-alignment-with-pageheader-重要--容易忽略)。

---

## What's New in v1.4.1

> 涵蓋 1.2.0 – 1.4.1（5 個 release）累積變更。詳見各元件文件與 [GitHub Releases](https://github.com/Mezzanine-UI/mezzanine/releases)。

### 元件正式移除 (Breaking — Removed)

> 以下元件已**正式**從 `@mezzanine-ui/react` 公開 API 移除（1.1.0 起已標記為即將棄用，1.4.1 完成移除）。升級前請完成遷移：

| 元件            | 遷移指引                                                                    |
| --------------- | --------------------------------------------------------------------------- |
| `ClearActions`  | 無直接替代品，改以組合模式自行實作關閉按鈕                                  |
| `ContentHeader` | 改以 `PageHeader` + `Section` + 自訂元素組合取代（`Section` / `PageHeader` 內部仍需透過 sub-path 匯入 `ContentHeader`）|
| `Scrollbar`     | 改用原生滾動或 CSS 自訂捲軸樣式                                             |
| `Switch`        | 已由 `Toggle` 正式取代，所有用法請直接改用 `<Toggle>`                       |

### 新增功能 (Improvements)

- **`Select`**（1.4.0）— 新增 opt-in `flip?: boolean` prop（預設 `false`），轉發給底層 `Dropdown`。啟用後選單在視窗底部空間不足時會往上翻轉，同時保持寬度與錨點水平對齊。
- **`Dropdown`**（1.4.0）— `flip` 啟用時僅沿主軸（`bottom-start` ↔ `top-start`）翻轉，不做 shift/cross-axis 位移，`sameWidth` 選單維持水平對齊；進場動畫方向現在會跟隨 floating-ui 實際翻轉後的方向，不再固定用翻轉前的方向播放。
- **`Popper`**（1.4.0）— 新增 `onPlacementChange` callback，於 floating-ui 解析出的 placement（含 middleware 翻轉後結果）變動時觸發，方便消費端根據翻轉後方向調整進場動畫。
- **`Pagination`**（1.2.0）— 分頁大小下拉選單現在會設定 `flip`，避免在表格貼近視窗底部時選單被裁切。
- **`CalendarConfigProviderTemporal`**（1.2.0）— 新增 `@mezzanine-ui/react/temporal` 的 JS 原生 `Temporal` 日期轉接器，免第三方日期函式庫依賴（需 Chrome 144+ / Firefox 139+ / Edge 144+ 或註冊 `@js-temporal/polyfill`）。
- **`Dropdown`**（1.2.0）— 新增 opt-in `flip?: boolean` prop（預設 `false`），啟用 floating-ui `flip` middleware，視窗溢出時自動翻轉方向。

### 錯誤修正 (Bug Fixes)

- **`Select`**（1.4.1）— 修正 `error` prop 被靜默忽略的問題。`SelectTrigger` 過去轉發 `error={type === 'error'}`，但 `type` 是 `DropdownType`（永遠不會是 `'error'`），導致 error 樣式從未套用；現在改為直接採用真正的 `error` prop。
- **`Navigation`**（1.4.1）— 修正只有 `Badge` 作為唯一子項的 `NavigationOption` 被誤判為可展開群組的問題（改依實際子選項數量 `items.length` 判斷，不再誤用原始 `children`）。
- **`Dropdown` / `Select` / `AutoComplete`**（1.3.1）— 修正 React 18 開發模式下每次 render 觸發器都會出現的 `ref is not a prop` console 警告，純噪音修正，無行為變更。
- **`Table`**（1.3.0）— 欄寬調整（resize）改為優先向最右側欄位借用空間，中間欄位在拖曳時維持穩定；僅當最右欄達 `minWidth` 才退回向相鄰欄借用。既有 `columns` / `minWidth` / `maxWidth` 設定不受影響。
- **`Calendar` / `DatePicker` / `DateRangePicker` / `MultipleDatePicker`**（1.2.0）— 修正 Day.js / Moment adapter 對非 ISO 星期一起始 locale（`en-AU`、`zh-CN` 等）的週數計算錯誤（CLDR `minimalDays` 判斷），以及缺少 `.locale()` 呼叫導致的週邊界錯誤。顯示週數的 UI 建議重新驗證。

**相依套件要求**：`@mezzanine-ui/core` ≥ 1.1.0、`@mezzanine-ui/system` ≥ 1.0.2、`@mezzanine-ui/icons` ≥ 1.0.2

---

<details>
<summary>Previous: What's New in 1.1.0</summary>

## What's New in 1.1.0

### 新增功能 (Improvements)

- **`Input` 的 `SelectButton` 子元件**（用於 `Input` 的 `select` variant，見 `packages/react/src/Input/SelectButton/`）新增 `closeOnSelect` prop（預設值 `true`）：選取選項後自動關閉下拉選單，符合單選 UX 預期。若需保持舊行為（選後不關閉），可在呼叫端傳入 `closeOnSelect={false}`。詳見 [Input.md](./references/components/Input.md#select-input)。

### 錯誤修正 (Bug Fixes)

- **`Table`** — 修正 SSR hydration mismatch 問題。列高原本在 `useMemo` 中透過 `getComputedStyle` 讀取，伺服器端回傳 `0`、客戶端回傳實際 pixel，導致 React 18/19 strict mode 下發出 hydration 警告甚至拋錯。現改為在 `useIsomorphicLayoutEffect` 中延遲讀取，首次 render 結果在 SSR 與 CSR 之間完全一致。Next.js / Remix 使用者建議升級。
- **Picker 家族鍵盤導覽** (`DatePicker`、`DateRangePicker`、`TimePicker`、`DateTimePicker`、`DateTimeRangePicker`、`TimeRangePicker`、`MultipleDatePicker`) — 修復 1.0.4 portal 遷移後 Tab / Shift+Tab 無法在觸發輸入框與日曆/時間面板之間循環的問題。Popper 現在建立明確的邏輯焦點迴圈，並在 `Modal` focus trap 內亦可正常運作。

### 元件計畫棄用 (Deprecation Notice)

> 以下元件於 1.1.0 標記為即將棄用，並已於 **1.4.1 正式從公開 API 移除**（見上方「What's New in v1.4.1」）：`ClearActions`、`ContentHeader`、`Scrollbar`、`Switch`。

</details>

---

<details>
<summary>Previous: What's New in 1.0.4 / Patch Releases (1.0.1 – 1.0.3)</summary>

## Patch Releases (1.0.1 – 1.0.3)

> **No public API changes** in this range — existing usage does not need to be modified. Upgrade is a straightforward `yarn upgrade @mezzanine-ui/*`.

### `@mezzanine-ui/react` 1.0.4 (2026-04-22)

- **Fix** — Picker 家族（DatePicker、DateRangePicker、TimePicker、DateTimePicker、DateTimeRangePicker、TimeRangePicker、MultipleDatePicker）在 Modal 或視窗底部附近渲染時，下拉 popup 不再被裁切。`InputTriggerPopper` 預設改為 portal 模式（`z-index: 1005` 高於 `Modal: 1004`）。同時啟用 Floating UI 的 `flip` middleware，面板會在空間不足時自動翻轉方向。

### `@mezzanine-ui/react` 1.0.3 (2026-04-21)

- **Chore** — bump `@mezzanine-ui/core` dependency to `1.0.3`.

### `@mezzanine-ui/react` 1.0.2 (2026-04-17)

- **Fix** — `Badge`: correct `utils` import path to use a relative path. Internal only; no surface change.

### `@mezzanine-ui/react` 1.0.1 (2026-04-14)

- **Fix** — `Notifier`: lazy-init `createRoot` to fix React 19 event delegation. Required if the host app is on React 19 — previously `Notifier` toast handlers could silently fail to fire. No API change.

### `@mezzanine-ui/core` 1.0.3 (2026-04-21)

- **Feat** — `core/calendar`: separate ISO and locale week-year format tokens. Internal formatting utility; does **not** change Calendar / DatePicker React props. Only relevant if you consume `@mezzanine-ui/core/calendar` week-year format helpers directly.

### `@mezzanine-ui/icons` 1.0.2 · `@mezzanine-ui/system` 1.0.2 (2026-04-17)

- Monorepo-sync version bump only. No code change.

</details>

---

## What's New in 1.0.0

1.0.0 是 Mezzanine-UI 的**第一個正式穩定版本**。主要變更如下：

### 元件移除（Breaking Changes）

4 個元件從公開 API 中移除，不再從 `@mezzanine-ui/react` 主入口匯出：

- **ClearActions** — 無直接替代品，改用組合模式自行實作關閉按鈕
- **ContentHeader** — 無直接替代品，改以 `PageHeader` + `Section` + utility components 組合取代
- **Scrollbar** — 無直接替代品，改用原生滾動或 CSS 自訂捲軸樣式
- **Switch** — 已正式由 `Toggle` 取代，所有 Switch 用法請直接改用 Toggle

> 若專案中有使用上述元件，請在升級前完成遷移。詳見各元件 `.md` 的遷移說明。

### API 重構

- **Drawer** — 移除內建底部操作按鈕與篩選區域，改採明確的組合模式：`DrawerHeader` / `DrawerBody` / `DrawerFooter`
- **Dropdown** — API 簡化，移除直接傳入 `options` / `onSelect` 的模式，改為 slot-based 組合
- **Calendar** — 移除直接的 `mode` / `value` / `onChange` props，改為 `calendarDaysProps` / `calendarMonthsProps` 結構

### 功能增強

- **Toggle** — 正式取代 Switch，提供更簡潔一致的 API
- **Upload** — 移除內建錯誤與刪除 handler，新增 `dropzoneHints` prop 供自訂提示
- **Typography** — 新增 `align`、`color`、`display`、`ellipsis`、`noWrap`、`variant` props，排版控制更完整
- **Popper** — 新增 `arrow`、`className`、`enabled`、`padding` props，定位控制更靈活

---

## Breaking Changes in 1.0.0

- **4 個元件移除**：ClearActions、ContentHeader、Scrollbar、Switch
  - ClearActions: 無直接替代品，改用組合模式
  - ContentHeader: 無直接替代品，改用 PageHeader + Section + utility components
  - Scrollbar: 無直接替代品，改用原生滾動或 CSS 樣式
  - Switch: 已由 Toggle 取代，直接改用 Toggle
- **Toggle** 取代 Switch — 全新元件，提供更簡潔的 API
- **Drawer** 簡化 — 移除內建底部操作按鈕與篩選區域，改採組合模式（DrawerHeader / DrawerBody / DrawerFooter）
- **Dropdown** 重構 — 簡化 API，移除直接傳入 options / onSelect 的模式
- **Calendar** 重構 — 移除直接的 mode / value / onChange，改為 calendarDaysProps / calendarMonthsProps
- **Upload** 簡化 — 移除內建錯誤與刪除 handler，新增 dropzoneHints
- **Typography** 增強 — 新增 align、color、display、ellipsis、noWrap、variant props
- **Popper** 增強 — 新增 arrow、className、enabled、padding props

---

## Storybook — 權威互動參考

所有元件皆可在 [React Storybook](https://storybook.mezzanine-ui.org/react/) 中查看互動範例。當文件描述與實際行為不一致時，以 Storybook 的互動範例為準。

> 站台根目錄 `storybook.mezzanine-ui.org` 是 landing page，**`?path=` 參數會被忽略**；React 的 Storybook 在 `/react/`、Angular 在 `/angular/`。

每個元件的參考文件都包含直接的 Storybook 連結，格式為：
`https://storybook.mezzanine-ui.org/react/?path=/docs/{kebab-storybook-title}--docs`

> `{kebab-storybook-title}` 來自 Storybook 內的 title（例如 `Data Display/Section` → `data-display-section`），**不一定等於本文件的分類**（例如 Drawer 在 Storybook 屬 Feedback、Layout 屬 Foundation）。要新增連結時，以 `https://storybook.mezzanine-ui.org/react/index.json` 的 `entries` key 為準；沒有 `--docs` 的元件改用 `?path=/story/{id}`。

> **Best Practice**: 在實作前先查看 Storybook 的 Controls panel，了解各 prop 的實際效果和預設值。

---

## Package Architecture

| Package                 | Description                          |
| ----------------------- | ------------------------------------ |
| `@mezzanine-ui/system`  | Design tokens (colors, spacing, fonts, etc.) |
| `@mezzanine-ui/core`    | CSS styles and class definitions     |
| `@mezzanine-ui/react`   | React components                     |
| `@mezzanine-ui/icons`   | Icon library                         |

---

## Children Validation Pitfalls (重要 — 容易踩雷)

部分容器元件會在 **runtime** 用 `Children.map` / `isValidElement` / `child.type === X` 對 `children` 做型別檢查，**只渲染白名單內的子元件**。傳入其他 JSX（自訂元件、`<div>` 包裝、Fragment 內亂塞、錯誤的 Button variant 等）時，雖然 React 樹中還在，**畫面會直接消失**，且部分元件靜默無提示。

> 任何時候 ContentHeader / PageHeader / Tab / Layout / Navigation / Accordion 等容器「JSX 寫了但畫面不顯示」，**第一個檢查點就是 children 是否在白名單內**。`<></>` Fragment 不會被解開、`<div>` 不會被穿透。

### 過濾規則一覽

| 元件 | 接受的 children | 被丟棄的 children | 失敗模式 |
| --- | --- | --- | --- |
| `ContentHeader` | `<a>` / 帶 `href` 元素（返回鈕）、`Input variant="search"`、`Select`、`Toggle`、`Checkbox`、`Button`（**限 `base-primary` / `base-secondary` / `destructive-secondary` / undefined**）、icon-only `Button` 包進 `Dropdown` | 一般 `<div>`、`Typography`、自訂 wrapper、其他 variant 的 `Button`、無 icon 的 `Button` 包進 `Dropdown`、`SegmentedControl` | console.warn + 不渲染 |
| `PageHeader` | 至多一個 `Breadcrumb` + 必要一個 `ContentHeader`（強制 `size="main"`） | 任何其他元件、重複的 `Breadcrumb` / `ContentHeader` | console.warn + 不渲染 |
| `Section` (props) | `contentHeader` 必為 `<ContentHeader>`、`filterArea` 必為 `<FilterArea>`、`tab` 必為 `<Tab>` | 其他元件型別 | console.warn + 不渲染 |
| `Tab` | 只接受 `<TabItem>` | 任何其他元件、`<div>` 包裝、Fragment 中夾雜的非 TabItem | **靜默丟棄（無 warning）** |
| `Layout` | 只接受 `<Layout.Main>`、`<Layout.LeftPanel>`、`<Layout.RightPanel>`、`<Navigation>` | 自訂 `<div>` wrapper、其他元件 | **靜默丟棄（無 warning）** |
| `Navigation` | `NavigationHeader`、`NavigationFooter`、`NavigationOptionCategory`、`NavigationOption` | 原生 `<a>` / `<li>`、自訂導覽元件 | console.warn + 不渲染 |
| `NavigationOption` | 子層只接受 `NavigationOption`（巢狀）或 `Badge` | 其他元件 | 不渲染 |
| `NavigationOptionCategory` | 只接受 `NavigationOption` | 其他元件 | 不渲染 |
| `Accordion` | 一個 `AccordionTitle` + 一個 `AccordionContent`（其餘原始節點會自動包成 `AccordionContent`） | 重複的 `AccordionTitle` / `AccordionContent` | console.warn + 丟棄重複者 |
| `AccordionActions` | 只接受 `Button` / `Dropdown` | 其他元件 | 不渲染 |

### Tab 與 Layout 的靜默失敗（高風險）

`Tab` 與 `Layout` **不會在 console 顯示警告**。常見錯誤：

```tsx
// ❌ 包一層 div — 整個 TabItem 都不會渲染（無 warning）
<Tab>
  <div className={styles.wrapper}>
    <TabItem key="a">A</TabItem>
    <TabItem key="b">B</TabItem>
  </div>
</Tab>

// ❌ 條件渲染包了 Fragment 又混入文字 — 字串會被 drop
<Tab>
  <>
    <TabItem key="a">A</TabItem>
    {showB && '部分使用者可見'}  {/* 靜默掉 */}
  </>
</Tab>

// ✅ 直接放 TabItem，使用陣列 / 條件渲染
<Tab>
  <TabItem key="a">A</TabItem>
  {showB && <TabItem key="b">B</TabItem>}
</Tab>
```

```tsx
// ❌ Layout 自訂 wrapper — 內容不顯示
<Layout>
  <div className={styles.shell}>
    <Layout.LeftPanel>...</Layout.LeftPanel>
    <Layout.Main>...</Layout.Main>
  </div>
</Layout>

// ✅ Slot 必須是 Layout 直接子代
<Layout>
  <Layout.LeftPanel>...</Layout.LeftPanel>
  <Layout.Main>...</Layout.Main>
</Layout>
```

### ContentHeader Button variant 限制

`ContentHeader` 在 `getActions` 階段只保留三種 variant，其餘 variant **不渲染**：

```tsx
// ❌ variant="text" 不在白名單，按鈕不出現
<ContentHeader title="X">
  <Button variant="text">Cancel</Button>
  <Button>Save</Button>
</ContentHeader>

// ✅
<ContentHeader title="X">
  <Button variant="base-secondary">Cancel</Button>
  <Button>Save</Button>
</ContentHeader>
```

排序後固定為：`destructive-secondary` → `base-secondary` → `base-primary` / undefined。

### 不會過濾 children 的元件（permissive）

下列元件 **不在 runtime 檢查 children 型別**，TypeScript 型別只是 hint，實際塞任何 JSX 都會渲染（但仍須遵守 prop 對的物件 shape）：

`Stepper`、`Breadcrumb`、`ButtonGroup`、`FormField`、`FormGroup`、`SectionGroup`、`PageFooter`、`Drawer`、`Modal`、`Description`、`DescriptionContent`、`Dropdown`、`Table`、`FilterArea` / `FilterLine` / `Filter`。

> 即使這些元件不會 runtime 過濾，仍**強烈建議**遵守 TypeScript 型別。`Description` 的「supported children types」（DescriptionContent / Badge / Button / Progress / TagGroup）是設計建議，視覺與排版只在這些元件下被測試過。

### 排查流程

1. JSX 結構正確但畫面缺塊 → 檢查上方表格內元件的 children 是否合法
2. `Tab` / `Layout` 整塊消失而 console 無錯 → 是靜默過濾，移除中間 wrapper
3. `ContentHeader` 按鈕沒出現但別處出現 → 確認 `variant` 在白名單
4. `PageHeader` / `Navigation` console 出現 `Invalid ... type` warning → 該位置應替換為合法元件

詳細個別 API 與例外請見 [references/components/](references/components/) 內各元件文件中「Accepted children types」/「Children Validation」章節。

---

## Component Categories

> Categories below are based on `packages/react/src/index.ts` exports. See individual component reference files for detailed API.

### General

Foundational visual elements that serve as building blocks for other components.

| Component     | Description    | Reference                                            |
| ------------- | -------------- | ---------------------------------------------------- |
| `Button`      | Button         | [Button.md](references/components/Button.md)         |
| `ButtonGroup` | Button group   | [Button.md](references/components/Button.md)         |
| `Cropper`     | Crop tool      | [Cropper.md](references/components/Cropper.md)       |
| `Icon`        | Icon           | [Icon.md](references/components/Icon.md)             |
| `Separator`   | Divider line   | [Separator.md](references/components/Separator.md)   |
| `Typography`  | Typography     | [Typography.md](references/components/Typography.md) |

### Navigation

Components for navigating between and within pages.

| Component    | Description     | Reference                                            |
| ------------ | --------------- | ---------------------------------------------------- |
| `Breadcrumb` | Breadcrumb      | [Breadcrumb.md](references/components/Breadcrumb.md) |
| `Drawer`     | Drawer          | [Drawer.md](references/components/Drawer.md)         |
| `Navigation` | Side navigation | [Navigation.md](references/components/Navigation.md) |
| `PageFooter` | Page footer     | [PageFooter.md](references/components/PageFooter.md) |
| `PageHeader` | Page header     | [PageHeader.md](references/components/PageHeader.md) |
| `Stepper`    | Step indicator  | [Stepper.md](references/components/Stepper.md)       |
| `Tab`        | Tab             | [Tab.md](references/components/Tab.md)               |

### Data Display

Data presentation and visualization components.

| Component           | Description       | Reference                                                      |
| ------------------- | ----------------- | -------------------------------------------------------------- |
| `Accordion`         | Accordion         | [Accordion.md](references/components/Accordion.md)             |
| `Badge`             | Badge             | [Badge.md](references/components/Badge.md)                     |
| `Card`              | Card              | [Card.md](references/components/Card.md)                       |
| `Description`       | Description list  | [Description.md](references/components/Description.md)         |
| `Empty`             | Empty state       | [Empty.md](references/components/Empty.md)                     |
| `OverflowTooltip`   | Overflow tooltip  | [OverflowTooltip.md](references/components/OverflowTooltip.md) |
| `OverflowCounterTag`| Overflow counter  | [OverflowTooltip.md](references/components/OverflowTooltip.md) |
| `Pagination`        | Pagination        | [Pagination.md](references/components/Pagination.md)           |
| `Section`           | Section           | [Section.md](references/components/Section.md)                 |
| `SectionGroup`      | Section group     | [Section.md](references/components/Section.md)                 |
| `Table`             | Table             | [Table.md](references/components/Table.md)                     |
| `Tag`               | Tag               | [Tag.md](references/components/Tag.md)                         |
| `Tooltip`           | Tooltip           | [Tooltip.md](references/components/Tooltip.md)                 |

### Data Entry

Form and user input components.

| Component             | Description          | Reference                                                              |
| --------------------- | -------------------- | ---------------------------------------------------------------------- |
| `AutoComplete`        | Autocomplete         | [AutoComplete.md](references/components/AutoComplete.md)               |
| `Cascader`            | Cascader             | [Cascader.md](references/components/Cascader.md)                       |
| `Checkbox`            | Checkbox             | [Checkbox.md](references/components/Checkbox.md)                       |
| `DatePicker`          | Date picker          | [DatePicker.md](references/components/DatePicker.md)                   |
| `DateRangePicker`     | Date range picker    | [DateRangePicker.md](references/components/DateRangePicker.md)         |
| `DateTimePicker`      | Date time picker     | [DateTimePicker.md](references/components/DateTimePicker.md)           |
| `DateTimeRangePicker` | Date time range      | [DateTimeRangePicker.md](references/components/DateTimeRangePicker.md) |
| `FilterArea`          | Filter area          | [FilterArea.md](references/components/FilterArea.md)                   |
| `Form`                | Form                 | [Form.md](references/components/Form.md)                               |
| `FormGroup` *(sub-path only)* | Form field group | [Form.md](references/components/Form.md)                           |
| `Input`               | Input                | [Input.md](references/components/Input.md)                             |
| `MultipleDatePicker`  | Multiple date picker | [MultipleDatePicker.md](references/components/MultipleDatePicker.md)   |
| `Picker`              | Picker base          | [Picker.md](references/components/Picker.md)                           |
| `Radio`               | Radio button         | [Radio.md](references/components/Radio.md)                             |
| `Select`              | Select dropdown      | [Select.md](references/components/Select.md)                           |
| `SelectionCard`       | Selection card       | [SelectionCard.md](references/components/SelectionCard.md)             |
| `Slider`              | Slider               | [Slider.md](references/components/Slider.md)                           |
| `Switch` *(已移除 v1.4.1)* | Switch toggle — 已由 Toggle 取代 | [Switch.md](references/components/Switch.md)               |
| `Textarea`            | Textarea             | [Textarea.md](references/components/Textarea.md)                       |
| `TextField`           | Text field           | [TextField.md](references/components/TextField.md)                     |
| `TimePicker`          | Time picker          | [TimePicker.md](references/components/TimePicker.md)                   |
| `TimeRangePicker`     | Time range picker    | [TimeRangePicker.md](references/components/TimeRangePicker.md)         |
| `Toggle`              | Toggle (取代 Switch) | [Toggle.md](references/components/Toggle.md)                           |
| `Upload`              | Upload               | [Upload.md](references/components/Upload.md)                           |

### Feedback

User action feedback and system status display.

| Component            | Description          | Reference                                                            |
| -------------------- | -------------------- | -------------------------------------------------------------------- |
| `InlineMessage`      | Inline message       | [InlineMessage.md](references/components/InlineMessage.md)           |
| `Message`            | Message toast        | [Message.md](references/components/Message.md)                       |
| `Modal`              | Modal dialog         | [Modal.md](references/components/Modal.md)                           |
| `NotificationCenter` | Notification center  | [NotificationCenter.md](references/components/NotificationCenter.md) |
| `Progress`           | Progress bar         | [Progress.md](references/components/Progress.md)                     |
| `ResultState`        | Result state         | [ResultState.md](references/components/ResultState.md)               |
| `Skeleton`           | Skeleton loader      | [Skeleton.md](references/components/Skeleton.md)                     |
| `Spin`               | Loading spinner      | [Spin.md](references/components/Spin.md)                             |

### Layout

Full-page layout components.

| Component | Description                | Reference                                          |
| --------- | -------------------------- | -------------------------------------------------- |
| `Layout`  | Full-page layout + sidebar | [Layout.md](references/components/Layout.md)       |

### Others

Auxiliary components.

| Component        | Description       | Reference                                                    |
| ---------------- | ----------------- | ------------------------------------------------------------ |
| `AlertBanner`    | Alert banner      | [AlertBanner.md](references/components/AlertBanner.md)       |
| `Anchor`         | Anchor navigation | [Anchor.md](references/components/Anchor.md)                 |
| `Backdrop`       | Backdrop overlay  | [Backdrop.md](references/components/Backdrop.md)             |
| `FloatingButton` | Floating button   | [FloatingButton.md](references/components/FloatingButton.md) |

### Utility

Utility components and transition animations.

| Component    | Description          | Reference                                            |
| ------------ | -------------------- | ---------------------------------------------------- |
| `Calendar`   | Calendar             | [Calendar.md](references/components/Calendar.md)     |
| `Collapse`   | Collapse animation   | [Transition.md](references/components/Transition.md) |
| `Fade`       | Fade animation       | [Transition.md](references/components/Transition.md) |
| `Notifier`   | Notifier             | [Notifier.md](references/components/Notifier.md)     |
| `Popper`     | Popper positioning   | [Popper.md](references/components/Popper.md)         |
| `Portal`     | Portal               | [Portal.md](references/components/Portal.md)         |
| `Rotate`     | Rotate animation     | [Transition.md](references/components/Transition.md) |
| `Scale`      | Scale animation      | [Transition.md](references/components/Transition.md) |
| `Slide`      | Slide animation      | [Transition.md](references/components/Transition.md) |
| `TimePanel`  | Time panel           | [TimePanel.md](references/components/TimePanel.md)   |
| `Transition` | Transition base      | [Transition.md](references/components/Transition.md) |
| `Translate`  | Translate animation  | [Transition.md](references/components/Transition.md) |

### Internal

Internal components, not typically used directly but available for advanced customization.

| Component                         | Description                          | Export                | Reference                                                    |
| --------------------------------- | ------------------------------------ | --------------------- | ------------------------------------------------------------ |
| `ClearActions` *(已移除 v1.4.1)* | Clear/close button                   | sub-path only         | [ClearActions.md](references/components/ClearActions.md)     |
| `ContentHeader` *(已移除 v1.4.1)*| Content section header               | sub-path only         | [ContentHeader.md](references/components/ContentHeader.md)   |
| `Dropdown`                        | Dropdown container (API 已重構)      | `@mezzanine-ui/react` | [Dropdown.md](references/components/Dropdown.md)             |
| `Scrollbar` *(已移除 v1.4.1)*    | Custom scrollbar                     | sub-path only         | [Scrollbar.md](references/components/Scrollbar.md)           |

---

## Design Token System

Mezzanine-UI uses a **Primitives + Semantic** two-layer architecture.

See [references/DESIGN_TOKENS.md](references/DESIGN_TOKENS.md) for detailed design tokens.

### Quick Reference

**Color usage**:
```scss
color: var(--mzn-color-text-brand);
background-color: var(--mzn-color-background-base);
border-color: var(--mzn-color-border-neutral);
```

**Spacing usage**:
```scss
padding: var(--mzn-spacing-padding-horizontal-base);
gap: var(--mzn-spacing-gap-base);
```

---

## Icon Usage

Icons are organized in `@mezzanine-ui/icons`.

See [references/ICONS.md](references/ICONS.md) for the complete icon list.

### Quick Example

```tsx
import { Icon } from '@mezzanine-ui/react';
import { PlusIcon, SearchIcon } from '@mezzanine-ui/icons';

<Icon icon={PlusIcon} />
<Icon icon={SearchIcon} size={24} />
```

---

## Theme Switching

### Light/Dark Mode

```tsx
// Switch theme
document.documentElement.setAttribute('data-theme', 'dark');
```

### Default/Compact Density

```tsx
// Switch density
document.documentElement.setAttribute('data-density', 'compact');
```

---

## Related Documentation

| Document                                    | Description                    |
| ------------------------------------------- | ------------------------------ |
| [references/DESIGN_TOKENS.md](references/DESIGN_TOKENS.md)   | Detailed design token definitions |
| [references/ICONS.md](references/ICONS.md)                   | Complete icon list             |
| [references/PATTERNS.md](references/PATTERNS.md)             | Common usage pattern examples  |
| [references/FIGMA_MAPPING.md](references/FIGMA_MAPPING.md)   | Figma node mapping table       |
| [references/components/](references/components/)             | Detailed API docs per component |

---

## Maintenance

### Version Sync Command

When Mezzanine-UI releases a new version, use the `/sync-mezzanine-ui` command to refresh all skill content:

```
/sync-mezzanine-ui 1.4.1
```

This orchestrates a team of agents to:
1. Fetch TypeScript interfaces from the GitHub source code
2. Update component `.md` files to match real props/types
3. Refresh cache JSON files
4. Update this SKILL.md with the new version info

See also: `scripts/upgrade-version.sh` (analysis script), `scripts/figma-sync.sh` (Figma metadata sync)
