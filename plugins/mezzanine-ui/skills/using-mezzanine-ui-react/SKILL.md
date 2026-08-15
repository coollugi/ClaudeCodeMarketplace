---
name: using-mezzanine-ui-react
description: React / Next.js Mezzanine-UI skill — create, edit, or style JSX components with @mezzanine-ui/react (1.4.1). Covers Button, TextField, Select, Table, Modal, Form, DatePicker, Tabs, Navigation, Typography, Icon, Drawer, Upload, Toggle, design tokens, theming, and CalendarConfigProvider. Defines the component-selection contract (a UI-concept-to-component reverse index — status chips are Badge not Tag, segmented controls are RadioGroup type="segment" not Buttons — plus the rule that needing a className override of background/color/border means the wrong component was chosen) and the page layout padding contract (PageHeader / PageFooter / Section ship their own padding — page containers must not add horizontal padding). Use when working on *.tsx, *.scss files with @mezzanine-ui/react imports, building React forms, laying out a page skeleton, picking which component to use, or configuring Mezzanine styles in a React codebase. Trigger — React, Next.js, tsx, JSX, mezzanine-ui/react, add mezzanine component, build form, create page UI, page layout, container padding, 版面對不齊, 雙層 padding, design tokens, mzn, 該用哪個元件, 選元件, tag vs badge, chip, status chip, 狀態標籤, 狀態晶片, segmented control, 分段切換, 排序切換, 覆寫元件樣式. For Angular projects use the sibling using-mezzanine-ui-ng skill instead.
---

# Mezzanine-UI Design System

**Core principle: All frontend development MUST prefer the Mezzanine-UI design system.**

> Baseline: `@mezzanine-ui/react` `1.4.1` · `@mezzanine-ui/core` `1.1.0` · `@mezzanine-ui/system` / `@mezzanine-ui/icons` `1.0.2`（三個相依皆為**精確釘版**，非 `>=`）。
> 元件文件的 `Verified` 標記：64 份為 `1.4.1`（2026-07-01），`AutoComplete.md` 已核到 `1.4.2`。版本歷史於 2026-08-14 逐版重新核對；
> 名稱／型別／預設值對原始碼的比對狀態見 [RECONCILIATION.md](../../RECONCILIATION.md)（尚有未分類的殘差）。
>
> **已有更新版本**：`@mezzanine-ui/react@1.4.2` 已發布（含 `AutoComplete` 的 `caseSensitive` 新 prop 與預設比對行為變更），本 skill 尚未涵蓋 —— 見〈更新版本存在〉。
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

## 元件選用（必讀 — 先用「UI 概念」反查元件名）

**放任何元件進畫面之前先讀這段。** Mezzanine 的元件名反映**實作結構**，不是使用者概念 —— 分段控制項的實作是 `RadioGroup type="segment"`，被歸類在 Data Entry；狀態標籤的實作是 `Badge`，不是 `Tag`。若照其他設計系統（MUI / Ant Design / Bootstrap）的先驗去猜元件名，會系統性地選錯，而且**錯法看起來很合理**：找不到 `color` prop 時，最自然的推論是「這個元件比較陽春，顏色要自己補」，而不是「顏色不在它的職責範圍內 → 我選錯元件了」。

### 三條鐵則

1. **先查下面的反查表**，用「我要做的 UI 長什麼樣」去找元件名，不要用「這東西在別的設計系統叫什麼」去猜。
2. **表上沒有 → 全文搜尋 `references/components/` 的 `Aliases` 行**（各元件文件在摘要句下方列出了其他設計系統與 Figma 的慣用名）。還是找不到才考慮用既有元件組合，**永遠不要自建元件取代**。
3. **Tripwire（最重要）：如果你需要覆寫元件的 `background` / `color` / `border` 才能做出設計稿 —— 停下來，這幾乎一定代表選錯元件。**
   回頭查表，不要在專案裡長出一套與設計系統平行的私有色階。
   （純排版位移的 `margin` / `width` / `flex` / `grid-area` 不算，那是版面職責。）

   > **這條規則涵蓋「重新指定 CSS 變數」，不只是直接寫 `background:`。**
   > 在某個 class 裡把元件內部用到的語意 token 指到別的 token —— 例如
   > `.statusApproved { --mzn-color-background-brand-faint: var(--mzn-color-background-success-faint); }`
   > —— **同樣是覆寫元件外觀**，而且更危險：它看起來像「只用了 design tokens」，實際上是在偽造元件的語意。
   >
   > 分清楚兩件事：
   > - ✅ **用 design tokens** = 在**你自己的版面元素**上使用 `var(--mzn-spacing-*)`、`var(--mzn-color-*)`（例如 page body 的 `padding-inline`）
   > - ❌ **重新定義 design tokens** = 在元件節點或其祖先上把 `--mzn-color-*` 指到別的值，藉此改變元件外觀
   >
   > 元件的語意色只能透過**元件自己的 prop**（`variant` / `severity` / `type`）選擇。
   > 一個元件沒有提供選語意色的 prop，就代表**它不負責表達語意** —— 那是選錯元件，不是缺功能。

> 鐵則 3 是本段唯一**可偵測**的訊號：它把「我推論錯了」這種看不見的失誤，轉成寫 SCSS 當下就能自問的條件。真實案例：某專案用 `Tag` + 五個自訂 class 覆寫底色做狀態晶片，違反了「樣式僅可透過 design tokens 調整」的規範**而當下沒有意識到**——因為它以為 Tag 就是狀態元件，只是剛好沒提供顏色 prop。

### UI 概念 → 元件 反查表

| 你要做的 UI（含他家設計系統慣用名）                                        | Mezzanine 元件                                        | 常見誤用                                 |
| -------------------------------------------------------------------------- | ----------------------------------------------------- | ---------------------------------------- |
| 狀態晶片 / status chip / 已核准・失敗・停用                                | `Badge variant="dot-*" text="…"`                      | ❌ `Tag` + `className` 覆寫底色          |
| 分類標籤 / Chip (MUI) / Tag (AntD) / Pill                                  | `Tag`（描邊外觀用 `readOnly`）                        | ❌ 自刻 `span` + border                  |
| 分段控制項 / Segmented Control / 檢視切換 / 排序切換 / Toggle Button Group | `RadioGroup type="segment"` + `Radio type="segment"`  | ❌ 多顆 `Button` 用 variant 差異模擬選中 |
| 開關 / Switch (MUI・AntD)                                                  | `Toggle`                                              | ❌ `Switch`（已不在公開 API）            |
| 未讀數字氣泡 / 角落紅點                                                    | `Badge variant="count-*"` / `dot-*` + children        | ❌ 自刻絕對定位圓點                      |
| 頁面級・系統級警示橫幅                                                     | `AlertBanner`（Portal `alert` 層，`sticky; top: 0`）  | ❌ 拿來當區塊內說明（它不會待在原地）    |
| 區塊內說明 / 警語 / 表單提示                                               | `InlineMessage`（`content` prop）                     | ❌ `AlertBanner`                         |
| Toast / Snackbar / 操作完成浮動提示                                        | `Message`（imperative API）                           | ❌ 自刻 toast                            |
| 站內通知列表 / 通知中心                                                    | `NotificationCenter`                                  | ❌ 用 `Message` 堆疊                     |
| 卡片式頁面區塊 / Panel / Fieldset                                          | `Section`（自帶內距與底色）                           | ❌ 自刻 `div` + box-shadow               |
| 圖文卡片 / 商品卡                                                          | `Card` 家族（v2 已拆子元件）                          | ❌ `Section`                             |
| 標題-內容成對的詳情資訊 / Descriptions (AntD)                              | `Description` + `DescriptionContent`                  | ❌ 兩欄 `Table`                          |
| 空資料畫面 / Empty state                                                   | `Empty`                                               | ❌ `ResultState`                         |
| 操作結果頁（成功 / 失敗 / 404）                                            | `ResultState`                                         | ❌ `Empty`                               |
| 載入骨架 / Skeleton screen                                                 | `Skeleton`                                            | ❌ `Spin` 蓋整頁                         |
| 轉圈 loading（無進度）                                                     | `Spin`                                                | ❌ `Progress`                            |
| 有百分比的進度                                                             | `Progress`                                            | ❌ `Spin`                                |
| 多步驟流程指示 / Steps (AntD)                                              | `Stepper`                                             | ❌ 自刻圓圈 + 連線                       |
| 選「值」的下拉                                                             | `Select`                                              | ❌ `Dropdown`                            |
| 選「動作」的下拉選單 / Menu                                                | `Dropdown`（`options` 陣列 + trigger children）       | ❌ `Select`                              |
| 滑過顯示說明                                                               | `Tooltip`                                             | ❌ 原生 `title` 屬性                     |
| 文字溢出才顯示完整內容                                                     | `OverflowTooltip`                                     | ❌ `Tooltip` + 自行量測寬度              |
| 頁籤 / Tabs                                                                | `Tab` + `TabItem`（只收 `TabItem`，其餘**靜默丟棄**） | ❌ 自刻按鈕列                            |
| 篩選列                                                                     | `FilterArea` + `FilterLine` + `Filter`                | ❌ 自排 `TextField` + `Button`           |

### 兩組最常錯的，記判斷句

- **Tag vs Badge** —— 問自己：**「這個標籤在說『它是什麼』，還是『它現在怎麼樣』？」**
  「是什麼」（分類、屬性、可篩選的標籤）→ `Tag`；「現在怎麼樣」（狀態、結果、進度）→ `Badge variant="dot-*"`。
  `Tag` **沒有**語意顏色，這是刻意的，不是缺漏。詳見 [Tag.md](references/components/Tag.md) 與 [Badge.md](references/components/Badge.md)。
- **Segmented Control** —— 設計師講 `Segmented Control`（Figma 元件名），程式碼叫 `Radio`。互斥的檢視切換、排序切換、篩選切換一律用 `RadioGroup type="segment"`，**不要用多顆 `Button` 的 variant 差異模擬選中狀態**。詳見 [Radio.md](references/components/Radio.md)。

### 自查清單（UI 寫完前逐項確認）

- [ ] 每個區塊都在反查表上找得到對應元件，沒有自建元件取代 Mezzanine 既有元件？
- [ ] **沒有任何 `className` 在覆寫元件的 `background` / `color` / `border`**（鐵則 3）？
- [ ] 狀態類的呈現用的是 `Badge`，不是 `Tag` + 自訂色？
- [ ] 互斥切換用的是 `RadioGroup type="segment"`，不是多顆 `Button`？
- [ ] 區塊內的說明／警語用 `InlineMessage`，沒有誤用會浮到頁面頂端的 `AlertBanner`？
- [ ] 沒有動到元件既有的 UX 行為（只透過 props 與 design tokens 調整）？

完整對照表、Figma 名稱對應與「為什麼會選錯」的機制分析見 [references/COMPONENT_SELECTION.md](references/COMPONENT_SELECTION.md)。

---

## What's New in v1.4.2

- **`AutoComplete`** — 選項比對預設從**大小寫敏感改為不敏感**（先前比對 RegExp 漏了 `i` flag，輸入 `vir` 找不到 `Virginia`）。新增 `caseSensitive?: boolean`（預設 `false`）供退回舊行為；`addable` 模式的重複檢查（`isSameOptionName()`）也一併尊重這個 flag，避免對只差大小寫的既有選項再提供「建立」動作。**這是行為變更，倚賴舊行為的專案升級後需明確傳 `caseSensitive`。**
- **`Dropdown`** — option `mousedown` 時保留 trigger focus，修正 `AutoComplete` 篩選文字在 blur 時被清空。純內部修正，無 API 變更。

> 1.4.2 只動到 `AutoComplete` 家族與 `Dropdown` 內部事件處理，其餘元件文件的 `Verified 1.4.1` 標記仍然成立。

---

## What's New in v1.4.1

> 涵蓋 1.2.0 – 1.4.1（5 個 release）累積變更。詳見各元件文件與 [GitHub Releases](https://github.com/Mezzanine-UI/mezzanine/releases)。

### 元件移除／未匯出狀況（已依 CHANGELOG 與 git tag 逐版核對）

> **1.4.1 本身沒有移除任何元件。** 1.4.1 只有兩個 bug fix（見下方）。
> 下表是這四個元件**目前**的實際狀態，以及它們真正變動的版本 —— 核對自 `packages/react/CHANGELOG.md` 與各 tag 的 `packages/react/src/index.ts`。

| 元件            | 實際狀態                                                                                       | 變動版本                              | 遷移指引                                             |
| --------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------- | ---------------------------------------------------- |
| `Switch`        | **真的移除**：原始碼目錄 `src/Switch/` 已不存在，由 `Toggle` 取代                              | `1.0.0-canary.3`（canary.2 仍存在）   | 一律改用 `<Toggle>`，公開 API 刻意對齊               |
| `ClearActions`  | **仍存在於原始碼**（`src/ClearActions/`），**從未**從主入口匯出，一直是 sub-path only            | 無 —— 從 0.0.1 至 1.4.2 都不在主入口 | 主入口取不到；需要時走 `@mezzanine-ui/react/ClearActions` |
| `ContentHeader` | **仍存在於原始碼**（`src/ContentHeader/`），**從未**從主入口匯出；`PageHeader` / `Section` 內部仍**必須**用它 | 無 —— 同上                            | 走 sub-path `@mezzanine-ui/react/ContentHeader`      |
| `Scrollbar`     | **仍存在於原始碼**（`src/Scrollbar/`），**從未**從主入口匯出                                    | 無 —— 同上                            | 走 sub-path，或改用原生滾動 / CSS 自訂捲軸樣式        |

> **重要更正**：先前版本的本文件宣稱「這四個元件於 1.1.0 標記棄用、1.4.1 完成移除」，**與原始碼不符**。
> 逐一比對 `0.0.1` → `1.4.2` 全部 tag 的 `src/index.ts` 後確認：
> - `Switch` 從 `0.0.1` 起就在主入口，直到 `1.0.0-canary.3` 被 `Toggle` 取代；
> - 另外三個**從未**出現在主入口，因此不存在「移除」這件事，也沒有任何 `@deprecated` 標記；
> - `1.1.0` – `1.4.2` 之間的 CHANGELOG **沒有任何**元件移除或棄用紀錄。

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
- **`Calendar` / `DatePicker` / `DateRangePicker` / `MultipleDatePicker`**（修正在 **`@mezzanine-ui/core` 1.1.0**，非 react 1.2.0）— 修正 Day.js / Moment adapter 對非 ISO 星期一起始 locale 的週數計算錯誤。三個 commit：`1e736cc` 把 `ISO_WEEK_LOCALES` 對齊 CLDR `weekInfo`（修正 11 個誤分類地區，如 `pt-PT` / `he-IL` / `ar-SA` 實為週日起始，`en-AU` / `ro-RO` / `tr-TR` 等雖週一起始但 `minimalDays=1` 不算 ISO）；`c628e51`（Day.js）與 `b915ff6`（Moment）把 ISO 判定改為「週一起始 **且** `minimalDays=4`」雙條件，並補上遺漏的 `.locale()` 呼叫 —— 先前 `.week()` / `.startOf('week')` 未設 instance locale 會 fallback 到全域預設（通常 `en`，週日起始）。顯示週數的 UI 建議重新驗證。

  > 修正位於 core 的 calendar adapter 層，react / ng 的日期元件透過注入 `calendarMethods` 取用，因此**不需要** react 端另外修改；只要相依的 `@mezzanine-ui/core` 到 1.1.0 即生效。react 1.2.0 與 core 1.1.0 同日（2026-05-07）發布，先前本文件因此把它誤記在 react 1.2.0 名下。

**相依套件版本**：`packages/react/package.json` 對三個套件都是**精確釘版（exact pin，無 `^` / `~` / `>=`）** —— `@mezzanine-ui/core` `1.1.0`、`@mezzanine-ui/system` `1.0.2`、`@mezzanine-ui/icons` `1.0.2`。不要寫成 `>=`，那會誤導成「更高版本也相容」。

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

**只有一個元件真的被移除：`Switch`。**（發生在 `1.0.0-canary.3`，由 `Toggle` 取代。）

- **Switch** — 原始碼目錄已刪除，一律改用 `<Toggle>`；公開 API 刻意對齊（`checked` / `defaultChecked` / `disabled` / `onChange`），另增 `label` / `supportingText` / `size`。

> **更正**：先前本節宣稱「4 個元件從主入口移除」。逐一比對 `0.0.1` → `1.4.2` 全部 tag 的 `src/index.ts` 後確認，
> `ClearActions` / `ContentHeader` / `Scrollbar` **從未**出現在主入口 —— 它們一直都是 sub-path only，
> 原始碼至今仍在（`src/ClearActions/`、`src/ContentHeader/`、`src/Scrollbar/`），也沒有任何 `@deprecated` 標記。
> 所以對這三個元件而言不存在「1.0.0 移除」這件事。完整狀態見上方〈元件移除／未匯出狀況〉表。

### API 變更（已逐項對照 1.4.x 原始碼核實）

| 元件         | 敘述                                                                                          | 核實結果                                                                                                                                  |
| ------------ | --------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `Calendar`   | 改為 `calendarDaysProps` / `calendarMonthsProps` 結構                                          | ✅ 屬實（`Calendar.tsx:75,89`）                                                                                                            |
| `Toggle`     | 取代 `Switch`                                                                                  | ✅ 屬實，但發生在 `1.0.0-canary.3`（見上方移除表）                                                                                         |
| `Upload`     | 新增 `dropzoneHints` prop                                                                      | ✅ 屬實                                                                                                                                    |
| `Typography` | 新增 `align` / `color` / `display` / `ellipsis` / `noWrap` / `variant`                         | ✅ 屬實（`Typography.tsx:41-66`）                                                                                                          |
| `Drawer`     | ~~移除內建底部操作按鈕，改採 `DrawerHeader` / `DrawerBody` / `DrawerFooter` 組合模式~~         | ❌ **不實**。這三個子元件**在整個 monorepo 都不存在**；底部操作按鈕也**沒有**被移除，仍是扁平 props（`bottomPrimaryActionText`、`bottomOnGhostActionClick` … 見 [Drawer.md](references/components/Drawer.md)） |
| `Dropdown`   | ~~移除 `options` / `onSelect`，改為 slot-based 組合~~                                          | ❌ **不實**。`options: DropdownOption[]` 是**必填** prop（`Dropdown.tsx:170`），`onSelect?:` 也仍存在（`:166`）                             |
| `Popper`     | 新增 `arrow` / `className` / `enabled` / `padding` props                                       | ⚠️ **部分不實**。`arrow` 是**物件**（`padding` 是它的欄位），**沒有**頂層的 `enabled` 或 `padding` prop（`Popper.tsx:37-65`）               |

> **注意**：`packages/react/CHANGELOG.md` 的 `1.0.0` release 區塊**只有 Bug Fixes、沒有 Features**。
> 上表這些 API 變更是 `0.x` → `1.0.0` 整段 canary / rc 期間的累積結果，**不是 1.0.0 這個 release 當下發生的**。
> 判斷某個 prop 現在到底存不存在時，**以各元件的 `references/components/*.md` 為準**（那些由 sync workflow 逐版對照 TypeScript 原始碼產生），不要以本節的歷史敘事為準。

---

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
| `ContentHeader` | `<a>` / 帶 `href` 元素（返回鈕）、`Input variant="search"`、`Select`、`Toggle`、`Checkbox`、`Button`（**限 `base-primary` / `base-secondary` / `destructive-secondary` / undefined**）、icon-only `Button` 包進 `Dropdown` | 一般 `<div>`、`Typography`、自訂 wrapper、其他 variant 的 `Button`、無 icon 的 `Button` 包進 `Dropdown`、`SegmentedControl`（見下方註） | console.warn + 不渲染 |

> **註 — `SegmentedControl` 只是 `ContentHeader` 不吃它，不是 Mezzanine 沒有這個元件。**
> `ContentHeaderProps` 的型別 union 含 `SegmentedControlProps` 但內部未實作渲染分支。
> 分段控制項的真正實作是 [`RadioGroup type="segment"`](references/components/Radio.md)，功能完整。
> 別因為搜到「未實作」就改用多顆 `Button` 模擬。
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
| `Switch` *(已移除 @ 1.0.0-canary.3)* | Switch toggle — 已由 Toggle 取代，原始碼已刪除 | [Switch.md](references/components/Switch.md)               |
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
| `ClearActions` *(從未在主入口)*  | Clear/close button                   | sub-path only         | [ClearActions.md](references/components/ClearActions.md)     |
| `ContentHeader` *(從未在主入口)* | Content section header — `PageHeader` / `Section` 內部仍必須用它 | sub-path only | [ContentHeader.md](references/components/ContentHeader.md)   |
| `Dropdown`                        | Dropdown container (API 已重構)      | `@mezzanine-ui/react` | [Dropdown.md](references/components/Dropdown.md)             |
| `Scrollbar` *(從未在主入口)*     | Custom scrollbar                     | sub-path only         | [Scrollbar.md](references/components/Scrollbar.md)           |

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
| [references/COMPONENT_SELECTION.md](references/COMPONENT_SELECTION.md) | UI 概念 → 元件反查、選錯元件的三種機制、元件邊界事實 |
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
/sync-mezzanine-ui react 1.4.2
```

This orchestrates a team of agents to:
1. Fetch TypeScript interfaces from the GitHub source code
2. Update component `.md` files to match real props/types
3. Refresh cache JSON files
4. Update this SKILL.md with the new version info

See also: `scripts/upgrade-version.sh` (analysis script), `scripts/figma-sync.sh` (Figma metadata sync)
