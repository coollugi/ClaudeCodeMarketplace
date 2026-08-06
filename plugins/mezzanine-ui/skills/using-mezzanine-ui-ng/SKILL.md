---
name: using-mezzanine-ui-ng
description: Angular 21+ Mezzanine-UI skill — create, edit, or style standalone Angular components with @mezzanine-ui/ng (1.0.0-rc.4, RC tier) directives. Covers directive-based selectors (mznButton, mznInput, mznSelect, mznTextField, mznFormField, mznModal, mznTable, mznNavigation), ControlValueAccessor + ReactiveFormsModule integration, DI services (ClickAwayService, EscapeKeyService, MZN_CALENDAR_CONFIG), sub-path imports, design tokens. Also defines the page layout padding contract (mznPageHeader / mznPageFooter / mznSection ship their own padding — page containers must not add horizontal padding). Use when working on *.component.ts, *.component.html, *.component.scss files that import from @mezzanine-ui/ng/*, building Angular reactive forms with mznFormField + formControlName, laying out a page skeleton, wiring Mezzanine directives into standalone components, or configuring Angular global SCSS. Trigger — Angular, standalone component, mzn directive, ControlValueAccessor, ReactiveForms, mezzanine-ui/ng, ng form, ng select, ng table, ng modal, page layout, container padding, 版面對不齊, 雙層 padding. For React / Next.js projects use the sibling using-mezzanine-ui-react skill instead.
---

# Mezzanine-UI Angular (`@mezzanine-ui/ng`)

**Core principle: For Angular 21+ standalone projects, prefer `@mezzanine-ui/ng` directives over custom Angular implementations.**

> Baseline: `@mezzanine-ui/ng` `1.0.0-rc.4` · `@mezzanine-ui/core` `1.0.4` · `@mezzanine-ui/system` `1.0.2` · `@mezzanine-ui/icons` `1.0.2`. Last verified: 2026-04-24.
>
> **⚠️ RC tier** — `@mezzanine-ui/ng` is in Release Candidate. API may still shift minor details before `1.0.0` stable. Check `npm view @mezzanine-ui/ng versions` for the latest.

> **For React (Next.js) projects** see the companion skill [`using-mezzanine-ui-react`](../using-mezzanine-ui-react/SKILL.md). Design tokens, icons, and Figma mappings are shared.

## What's New in 1.0.0-rc.4

**純版本對齊（No Angular source changes）**

`@mezzanine-ui/ng@1.0.0-rc.4` is a compatibility bump paired with `@mezzanine-ui/core@1.0.4`. Zero Angular source files changed in this cycle.

- **Pair with `@mezzanine-ui/core@1.0.4`** — the core release fixed React-side picker positioning (globalPortal + flip). Angular was already correct: `MznInputTriggerPopper` ships with `globalPortal=true` and `MznPopper` enables `flip()` by default, so no behaviour change on the Angular side.
- **No prop changes** — 0 component APIs modified.
- **Deprecation: `ThumbnailCards`** — the `thumbnail-cards` package is removed. Use the individual replacement components instead:
  - `MznSingleThumbnailCard` (`@mezzanine-ui/ng/single-thumbnail-card`)
  - `MznFourThumbnailCard` (`@mezzanine-ui/ng/four-thumbnail-card`)
  - `MznSingleThumbnailCardSkeleton` / `MznFourThumbnailCardSkeleton`
  - `MznQuickActionCard` (`@mezzanine-ui/ng/quick-action-card`)

**升級方式 (upgrade)**:

```bash
yarn add @mezzanine-ui/ng@1.0.0-rc.4 @mezzanine-ui/core@1.0.4
```

## Resource Overview

| Type                 | Resource                                                                | Purpose                                |
| -------------------- | ----------------------------------------------------------------------- | -------------------------------------- |
| **Frontend Package** | [GitHub — packages/ng](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng) | Angular component source       |
| **Angular Storybook** | [storybook.mezzanine-ui.org/angular](https://storybook.mezzanine-ui.org/angular/) | Angular component examples（`storybook-ng.mezzanine-ui.org` 已無法解析，勿使用） |
| **Figma Components** | [Component File](https://www.figma.com/design/gjGdP49GQZzOeQf0bNOFlt)   | Shared with React — canonical design   |

---

## Quick Start

### Installation

```bash
yarn add @mezzanine-ui/ng @mezzanine-ui/core @mezzanine-ui/system @mezzanine-ui/icons
```

Angular peer dependencies required:

```
@angular/core >= 21.0.0
@angular/common >= 21.0.0
@angular/cdk >= 21.0.0
@angular/animations >= 21.0.0
@angular/forms >= 21.0.0
```

### Global SCSS Setup

`src/styles.scss` — **identical to React** because `@mezzanine-ui/core` and `/system` are shared:

```scss
@use '@mezzanine-ui/system' as mzn-system;
@use '@mezzanine-ui/core' as mezzanine;

:root {
  @include mzn-system.colors('light');
  @include mzn-system.common-variables(default);
}

[data-theme='dark'] {
  @include mzn-system.colors('dark');
}

[data-density='compact'] {
  @include mzn-system.common-variables(compact);
}

@include mezzanine.styles();
```

> If your Angular project uses the `~` tilde prefix in SCSS, drop it — `@use '@mezzanine-ui/system'` works out-of-the-box with Angular CLI / Nx.

### Bootstrap (standalone app)

Mezzanine does **not** require an `ApplicationConfig` provider. Mezzanine directives are imported per-component via `imports: [...]`.

```ts
// main.ts
import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { App } from './app/app';

bootstrapApplication(App, appConfig).catch(err => console.error(err));
```

```ts
// app.config.ts — nothing Mezzanine-specific required
export const appConfig: ApplicationConfig = {
  providers: [
    provideBrowserGlobalErrorListeners(),
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(appRoutes),
    provideHttpClient(withFetch()),
  ],
};
```

### Basic Usage Example

```ts
// login.page.ts
import { Component } from '@angular/core';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { MznButton } from '@mezzanine-ui/ng/button';
import { MznFormField } from '@mezzanine-ui/ng/form';
import { MznInput } from '@mezzanine-ui/ng/input';
import { MznIcon } from '@mezzanine-ui/ng/icon';
import { FormFieldLayout } from '@mezzanine-ui/core/form';
import { UserIcon } from '@mezzanine-ui/icons';

@Component({
  selector: 'app-login-page',
  imports: [ReactiveFormsModule, MznButton, MznFormField, MznInput, MznIcon],
  templateUrl: './login.page.html',
})
export class LoginPage {
  protected readonly userIcon = UserIcon;
  protected readonly verticalLayout = FormFieldLayout.VERTICAL;

  protected readonly loginForm = this.fb.group({
    account: ['', [Validators.required]],
    password: ['', [Validators.required]],
  });

  constructor(private fb: FormBuilder) {}
}
```

```html
<!-- login.page.html -->
<form [formGroup]="loginForm">
  <div mznFormField name="account" label="帳號" [layout]="verticalLayout">
    <div mznInput variant="base" placeholder="Enter account" [fullWidth]="true" formControlName="account">
      <i mznIcon [icon]="userIcon" [size]="16" slot="prefix"></i>
    </div>
  </div>

  <button mznButton type="submit" variant="base-primary" [disabled]="loginForm.invalid">
    登入
  </button>
</form>
```

### Calendar / Date Provider

Angular date components read config via the `MZN_CALENDAR_CONFIG` DI token. There are two ways to supply it:

**Option A — `ApplicationConfig` provider (recommended for most apps):**

```ts
// app.config.ts
import { provide } from '@angular/core';
import {
  MZN_CALENDAR_CONFIG,
  createCalendarConfig,
  CalendarLocale,
} from '@mezzanine-ui/ng/calendar';
import CalendarMethodsDayjs from '@mezzanine-ui/core/calendarMethodsDayjs';

export const appConfig: ApplicationConfig = {
  providers: [
    // ...
    {
      provide: MZN_CALENDAR_CONFIG,
      useValue: createCalendarConfig(CalendarMethodsDayjs, {
        locale: CalendarLocale.ZH_TW,
      }),
    },
  ],
};
```

**Option B — `MznCalendarConfigProvider` host directive (for per-subtree overrides):**

`MznCalendarConfigProvider` is a **directive** (not a factory function). Apply it to any host element to scope a calendar config to its subtree:

```ts
import { MznCalendarConfigProvider } from '@mezzanine-ui/ng/calendar';
import CalendarMethodsDayjs from '@mezzanine-ui/core/calendarMethodsDayjs';

@Component({
  imports: [MznCalendarConfigProvider, MznDatePicker],
  template: `
    <div mznCalendarConfigProvider [methods]="dayjsMethods" locale="zh-TW">
      <div mznDatePicker [(ngModel)]="date"></div>
    </div>
  `,
})
export class ExamplePage {
  protected readonly dayjsMethods = CalendarMethodsDayjs;
}
```

> Equivalent of React's `<CalendarConfigProvider>`. Date internals use DayJS by default (no extra adapter wiring needed beyond the methods import).

---

## Page Layout Skeleton (必讀 — 版面 padding 契約)

**建立任何頁面之前先讀這段。** Mezzanine 的頁面級 directive **自己內建 padding**，樣式全部來自 `@mezzanine-ui/core` 的 SCSS，**從 template / inputs 型別完全看不出來**（`MznPageHeader` 甚至沒有任何 input）。若照一般開發慣例「先給 page container 一圈 padding 再放元件」，`mznPageHeader` 會出現**兩層水平 padding**，標題與下方內容左緣錯開。

### A. 滿版帶狀元件 — 自帶 gutter，必須是 page container 的直接子代

以下 directive **沒有卡片底色**，它們的水平 padding 就是版面 gutter 本身。放進任何有 `padding-inline` 的 wrapper 都會多縮一次；`mznTabs` / `mznPageFooter` 的橫線也會斷在兩側。（數值皆核對自 `@mezzanine-ui/core` 原始 SCSS，Angular 與 React 共用同一份樣式。）

| Directive         | 生效條件                                | host padding                                                             | default       | compact       | 備註                                              |
| ----------------- | --------------------------------------- | ------------------------------------------------------------------------ | ------------- | ------------- | ------------------------------------------------- |
| `[mznPageHeader]` | 無條件                                  | `vertical-spacious horizontal-spacious 0`                                | `16 / 16 / 0` | `12 / 14 / 0` | **bottom 為 0**，區塊間距靠 container `row-gap`   |
| `[mznPageFooter]` | 無條件                                  | `vertical-base horizontal-spacious`                                      | `8 / 16`      | `4 / 14`      | 另有 `border-top` 與底色，必須整條貼齊版面        |
| `[mznFilterArea]` | `size="main"`（**預設值**）             | `padding-inline: horizontal-spacious` + `padding-top: vertical-spacious` | `16 / top 16` | `14 / top 12` | 與 PageHeader 同構，同樣沒有 bottom padding       |
| `[mznTabs]`       | `size="main"`（**預設值**）+ horizontal | `vertical-spacious horizontal-spacious 0`                                | `16 / 16 / 0` | `12 / 14 / 0` | 底線 `::before` 為 `inset: 0`，需滿版才不會被截斷 |
| `[mznTabs]`       | `size="main"` + vertical                | `0 0 0 horizontal-spacious`                                              | `left 16`     | `left 14`     | 只有左側                                          |

> **`size="main"` vs `size="sub"` 是判斷關鍵**：`main` = 直接放在頁面骨架、自帶 gutter；`sub` = 放在 `mznSection` 內、**沒有**外距（由 Section 的 padding 負責）。`mznSection` 會用 `> .mzn-tab--horizontal.mzn-tab--main { padding: 0 }` 把 main size 的 Tabs padding 歸零。**`mznFilterArea` 與 `mznTabs` 的 `size` input 預設值都是 `'main'`**（`filter-area.component.ts` / `tabs.component.ts`）— 放進 body wrapper 卻忘了改 `size="sub"`，就會出現 16 + 16 = 32px 的雙層內縮。

### B. 卡片／內容元件 — 放進 body wrapper，由 wrapper 提供 gutter

| Directive                         | host padding                            | default   | compact   | 備註                                                       |
| --------------------------------- | --------------------------------------- | --------- | --------- | ---------------------------------------------------------- |
| `[mznSection]`                    | `vertical-spacious horizontal-spacious` | `16 / 16` | `12 / 14` | 有底色圓角但**無 margin**，外側 gutter 仍要靠 wrapper 提供 |
| `[mznTable]`                      | 無（padding 在儲存格上）                | —         | —         | host 本身沒有 padding                                      |
| `[mznLayout]` / `[mznLayoutMain]` | 無                                      | —         | —         | app shell，完全不提供 padding                              |
| `[mznContentHeader]`              | 無（只有 `gap: calm`）                  | —         | —         | 內距全由外層 `mznPageHeader` / `mznSection` 提供           |

### C. 其他自帶 padding 的元件（與版面 gutter 無關，但同樣不要再包一層）

`mznPagination` `8/12`、`mznAlertBanner` `block 12 / inline 24`、`mznNotificationCenter` `16/16`、`mznUpload` dropzone `24/24`、`mznMessage` `12/16`、`mznTooltip` `4/8`、`mznTimePanel`、`mznCard`、`mznCascader`、`mznSelectionCard`、`mznCalendar` 各自有 host padding。這些是元件自身的內距，不需要也不應該再外加 padding，但它們不負責頁面 gutter。

### 四條規則

1. **頁面最外層 container 不可有水平 padding**（`padding` / `padding-inline` / `padding-left|right` 一律不要）— 讓 A 組元件自己貼齊版面邊緣。
2. **A 組元件直接放在最外層 column**，不要塞進有 padding 的 wrapper 內。若非得放在 body wrapper 內（例如 filter 屬於某個 Section 的一部分），改用 `size="sub"`。
3. **B 組內容一律另包一層 body wrapper**，套上與 PageHeader 相同的水平 padding：`padding-inline: var(--mzn-spacing-padding-horizontal-spacious)`。
4. **垂直間距用 container 的 `row-gap`**（建議 `var(--mzn-spacing-gap-calm)`，12px / compact 10px），不要對 `mznPageHeader` 補 `margin-bottom` — 它的 bottom padding 就是刻意留 0 給 container 分配。

```
+-------------------------------------------+   <- page container: 無水平 padding
| mznPageHeader  (padding: 16 16 0)         |
|       Breadcrumb / Title                  |   <- 標題文字內縮 16px
+-------------------------------------------+
| mznTabs size="main" (padding: 16 16 0)    |   <- A 組：貼邊，底線才會滿版
+-------------------------------------------+
        row-gap: var(--mzn-spacing-gap-calm)
+-------------------------------------------+
| body wrapper (padding-inline: 16)         |
|     +-------------------------------+     |
|     | mznSection / mznTable         |     |
|     +-------------------------------+     |   <- 卡片左緣同樣內縮 16px
+-------------------------------------------+
| mznPageFooter  (padding: 8 16)            |   <- border-top 需滿版
+-------------------------------------------+
```

### Canonical page skeleton（每個頁面都照這個結構寫）

Mezzanine **沒有**提供負責頁面 gutter 的容器 — `mznLayout` / `mznLayoutMain` 是 app shell（Navigation + 面板），只有 flex / min-width / overflow，**零 padding、也沒有任何 padding 相關 input**。所以 gutter 一定要由頁面自己處理，結構固定為三層：

```html
<!-- feature.page.html -->
<!-- 第 1 層：page container — 無水平 padding，只負責垂直排列與 row-gap -->
<div class="page">
  <!-- 第 2 層 a：PageHeader 直接掛在 page container 底下，貼齊版面 -->
  <header mznPageHeader>
    <nav mznBreadcrumb [items]="breadcrumb()"></nav>
    <header mznContentHeader title="商品管理" description="管理所有商品">
      <div actions>
        <button mznButton variant="base-primary" (click)="create()">新增</button>
      </div>
    </header>
  </header>

  <!-- 第 2 層 b：主要內容包一層 body wrapper，這裡才套水平 padding -->
  <main class="page__body">
    <div mznSection>
      <header mznContentHeader title="區段標題" size="sub"></header>
      <div mznTable [columns]="columns" [dataSource]="data()"></div>
    </div>
  </main>

  <!-- 第 2 層 c：PageFooter 與 PageHeader 同層，border-top 才會滿版 -->
  <div mznPageFooter type="standard">
    <div actions>
      <button mznButton variant="base-primary" (click)="save()">儲存</button>
    </div>
  </div>
</div>
```

```scss
// feature.page.scss
.page {
  display: flex;
  flex-direction: column;
  // ❌ 這裡永遠不加 padding-inline / padding-left / padding-right
  row-gap: var(--mzn-spacing-gap-calm);
  inline-size: 100%;
  min-block-size: 100%;

  &__body {
    // ✅ 頁面裡唯一負責水平 gutter 的地方，值必須與 PageHeader 的水平 padding 相同
    padding-inline: var(--mzn-spacing-padding-horizontal-spacious);
    padding-block-end: var(--mzn-spacing-padding-vertical-spacious);
    display: flex;
    flex-direction: column;
    row-gap: var(--mzn-spacing-gap-calm);
    flex: 1;
    min-block-size: 0;
  }
}
```

逐層說明：

- **`.page`（第 1 層）** — 只做「由上而下排列 + 區塊間距」。它**不能**有任何水平 padding，因為 `mznPageHeader` / `mznPageFooter` 自己已經有了；在這裡加就是雙層內縮的來源。`row-gap` 取代 `margin`，因為 PageHeader 的 `padding-bottom` 是 `0`，間距刻意留給 container 分配。
- **`mznPageHeader` / `mznPageFooter`（第 2 層，直接子代）** — 必須是 `.page` 的直接子代。只要被任何有 `padding-inline` 的 wrapper 包住，header 會多縮一次、footer 的 `border-top` 與底色也會斷在兩側。
- **`.page__body`（第 2 層）** — 唯一補 gutter 的地方，`padding-inline` 一律用 `--mzn-spacing-padding-horizontal-spacious`，與 PageHeader 同值，這樣表格 / 卡片 / 表單左緣才會對齊標題文字。內容之間的間距同樣用 `row-gap`，不要在子元素上加 `margin`。
- **內容是 `mznSection` 時** — 要分清楚兩層 padding：**外側 gutter 仍由 `.page__body` 的 `padding-inline` 提供**（`mznSection` 是它的子元素，少了它卡片會貼齊版面邊緣、也不會與 PageHeader 標題左緣對齊）；**內側 16px 則是 `mznSection` 自帶的**，所以不要再對它本身或它的直接子元素補 padding。結果是：卡片左緣 = 標題文字左緣 = 16px，卡片內容再往內 16px。

若頁面的 template 根節點就是這層 `.page`，也可以省掉外層 `<div>`、改用 `:host` 承擔第 1 層：

```scss
:host {
  display: flex;
  flex-direction: column;
  row-gap: var(--mzn-spacing-gap-calm);
  min-block-size: 100%;
}
```

> 沒有設成 flex column 的話，`mznPageHeader` 與 body 之間就完全沒有間距（PageHeader 的 `padding-bottom` 是 `0`），兩塊會直接黏在一起。

搭配 Layout 時，整個骨架原封不動放進 `mznLayoutMain`（它不提供 padding，也不需要）：

```html
<div mznLayout>
  <nav mznNavigation>...</nav>
  <main mznLayoutMain>
    <div class="page"><!-- 同上結構 --></div>
  </main>
</div>
```

> 若專案頁面數量多、想避免每頁重抄這段 SCSS，可以抽成共用 mixin（例如 `styles/_page-layout.scss` 提供 `@mixin page-root` / `@mixin page-body`），template 結構仍照上面明確寫出來。**不要**把 `mznPageHeader` 包進自訂容器元件再用 content projection 轉一手 — 那會讓頁面結構變得不透明。

### 自查清單（寫完頁面前逐項確認）

- [ ] page container 沒有任何水平 padding？
- [ ] `mznPageHeader` / `mznPageFooter` 是 page container 的**直接子代**，沒被 padded wrapper 包住？
- [ ] 主要內容有獨立 wrapper 且 `padding-inline` 使用 `--mzn-spacing-padding-horizontal-spacious`（不是寫死 16px、也不是 24px）？
- [ ] 區塊間距靠 `row-gap`，沒有對 `mznPageHeader` 加 `margin-bottom`？
- [ ] 內容是 `mznSection` 時，它有放在套了 `padding-inline` 的 `.page__body` 裡（不是直接掛在 `.page` 下貼邊），且**沒有**再幫它自己補 padding？
- [ ] 有用到 `mznFilterArea` / `mznTabs` 嗎？放在 `.page` 直接層就維持預設 `size="main"`（自帶 gutter）；放進 `.page__body` 或 `mznSection` 內就必須改 `size="sub"`，否則是 16 + 16 的雙層內縮？

詳細範例與反例見 [references/PATTERNS.md → Page Body Alignment with MznPageHeader](references/PATTERNS.md#page-body-alignment-with-mznpageheader-重要--容易忽略)。

---

## Architecture Overview

### Directive-based selectors

Mezzanine-ng components are **standalone directives / components** that attach to semantic HTML:

| Selector | Usage example | Meaning |
| -------- | ------------- | ------- |
| `[mznButton]`     | `<button mznButton variant="base-primary">`        | Attribute directive on native `<button>` / `<a>` |
| `[mznInput]`      | `<div mznInput formControlName="x">`               | Component wrapping a native `<input>` internally |
| `[mznFormField]`  | `<div mznFormField name="account" label="帳號">`  | Wrapper providing label, hint, error slots |
| `[mznIcon]`       | `<i mznIcon [icon]="userIcon" [size]="16">`       | Attribute directive on `<i>` |
| `[mznModal]`      | `<section mznModal>`                               | Component rendering the modal chrome |
| `<mzn-navigation-option>` | Custom element tag                         | A small number of components use tag selectors |

### ControlValueAccessor + ReactiveForms

Form inputs implement `ControlValueAccessor`, so they bind via `formControlName` / `[(ngModel)]` / `[formControl]` like any Angular control:

```html
<div mznInput [formControl]="usernameCtrl"></div>
<div mznSelect [formControl]="statusCtrl"></div>
<div mznCheckbox [formControl]="agreeCtrl"></div>
```

Validation stays in `ReactiveFormsModule` — Mezzanine does **not** wrap `Validators`. Display errors with `[mznInlineMessage]` siblings.

### Signal-based inputs / outputs

Components use Angular's signal API (`input()`, `output()`, `computed()`). This means:

- Most `@Input` properties are `InputSignal<T>` — read via `this.size()` internally
- Two-way binding: `[(collapsed)]="collapsed"` works when the component exposes `collapsed = model<boolean>(false)`
- Effects replace `ngOnChanges` in most cases

### DI Services (replaces React hooks)

Imported from `@mezzanine-ui/ng/services`:

| Service | Purpose | React equivalent |
| ------- | ------- | ---------------- |
| `ClickAwayService`   | Detect outside-click | `useClickAway` hook |
| `EscapeKeyService`   | Stacked Escape handling | `useEscapeKeyDown` |
| `ScrollLockService`  | Lock body scroll (modals) | `useScrollLock` |
| `TopStackService`    | Manage z-index / focus stack | — |
| `WindowWidthService` | Reactive breakpoints | `useWindowSize` |

See [references/SERVICES.md](references/SERVICES.md).

### Utilities

Imported from `@mezzanine-ui/ng/utils`:

| Export | Purpose |
| ------ | ------- |
| `getCSSVariablePixelValue` | Read a `:root` CSS var and resolve to px (handles `rem`/`px`/unitless) |
| `highlightText` / `HighlightSegment` | Split text into segments around a keyword for search-result highlighting |
| `provideValueAccessor` | `NG_VALUE_ACCESSOR` multi-provider shorthand for custom `ControlValueAccessor` components |
| `formatNumberWithCommas` / `parseNumberWithCommas` | Locale-aware comma formatting / parsing for numeric inputs |

See [references/PATTERNS.md → Utilities](references/PATTERNS.md#utilities).

---

## Content Projection Pitfalls (重要 — 寫了但畫面不顯示)

Angular 端與 React 端類似，多個容器元件透過 **named `ng-content` slot** 或 **directive selector 比對**決定哪些子元素會被渲染。如果寫了 host element 但 **selector / 父子關係不正確**，內容會被靜默吃掉。

> 任何時候 `mznTabs` / `mznLayout` / `mznSection` / `mznPageHeader` / `mznNavigation` / `mznAccordion` 等容器「HTML 寫了但畫面沒東西」，先檢查：(1) 子元素 selector 是否正確 (2) 是否多包了一層 `<div>` 把 selector 從父層斷開。

### 常見靜默過濾來源

| 容器 | 接受的子元素 | 失敗模式 |
| --- | --- | --- |
| `[mznTabs]` | `<button mznTabItem>` 直接子代 | 包一層 `<div>` 或不是 `<button>` → 不渲染 |
| `[mznLayout]` | `[mznLayoutMain]` / `[mznLayoutLeftPanel]` / `[mznLayoutRightPanel]` / `[mznNavigation]` 直接子代 | 包 wrapper 後 `ng-content` slot 找不到 → 不渲染 |
| `[mznPageHeader]` | `[mznBreadcrumb]` 與 `[mznContentHeader]`（透過 ng-content） | host 元素若不是 directive 預期的元素則樣式錯亂 |
| `[mznSection]` | named slot：contentHeader / filterArea / tab / 主內容 | slot selector 不對 → 對應區塊空白 |
| `[mznNavigation]` | `[mznNavigationHeader]` / `[mznNavigationFooter]` / `<mzn-navigation-option>` / `<mzn-navigation-option-category>` | 用原生 `<a>` / `<li>` → 不被識別、不渲染 |
| `[mznAccordion]` | `[mznAccordionTitle]` / `[mznAccordionContent]` / `[mznAccordionActions]` | 缺少 directive selector → 內容區或 actions 不出現 |
| `[mznContentHeader]` 內 actions slot | 只接受 `<button mznButton>` 且 variant ∈ `base-primary` / `base-secondary` / `destructive-secondary` | 自訂 `<div>` wrapper / 其他 variant 不渲染 |

### 常見錯誤

```html
<!-- ❌ 包一層 div：mznTabItem 找不到 mznTabs context -->
<div mznTabs>
  <div class="tabs-wrapper">
    <button mznTabItem [key]="'a'">A</button>
    <button mznTabItem [key]="'b'">B</button>
  </div>
</div>

<!-- ✅ 直接放 host element -->
<div mznTabs>
  <button mznTabItem [key]="'a'">A</button>
  <button mznTabItem [key]="'b'">B</button>
</div>
```

```html
<!-- ❌ Layout slot 被外層 div 切斷 -->
<div mznLayout>
  <div class="shell">
    <aside mznLayoutLeftPanel>...</aside>
    <main mznLayoutMain>...</main>
  </div>
</div>

<!-- ✅ slot directive 必須是 mznLayout 直接子代 -->
<div mznLayout>
  <nav mznNavigation>...</nav>
  <aside mznLayoutLeftPanel [open]="leftOpen()">...</aside>
  <main mznLayoutMain>...</main>
</div>
```

```html
<!-- ❌ 直接寫原生 a：Navigation 不認得 -->
<nav mznNavigation>
  <a routerLink="/x">外部連結</a>
</nav>

<!-- ✅ 用 mzn-navigation-option，搭配 router 元件透過 anchorComponent / 自身 routerLink 處理 -->
<nav mznNavigation>
  <mzn-navigation-option title="X" routerLink="/x"></mzn-navigation-option>
</nav>
```

### 排查流程

1. 子元素的 selector 是否與父層期望的 directive 一致？
2. 是否包了 `<div>` 或其他 host element 把 ng-content / DI token context 切斷？
3. 是否在 `standalone: true` 元件裡缺少 `imports` 對應 directive？（會讓 selector 直接無效）
4. host element tag 是否符合 directive 限制（如 `mznTabItem` 必為 `<button>`）？

詳細個別約束請見 [references/components/](references/components/) 內 `Selectors` / `Content Projection Slots` 章節。

---

## Import Convention (Sub-path only)

**Always import from the specific secondary entry point**, not the main `@mezzanine-ui/ng` barrel:

```ts
// ✅ Correct
import { MznButton } from '@mezzanine-ui/ng/button';
import { MznInput, MznInputVariant } from '@mezzanine-ui/ng/input';
import { MZN_CALENDAR_CONFIG, createCalendarConfig } from '@mezzanine-ui/ng/calendar';

// ❌ Wrong — the main barrel only exports VERSION
import { MznButton } from '@mezzanine-ui/ng';
```

Design constants and enums live in `@mezzanine-ui/core`:

```ts
import { FormFieldLayout } from '@mezzanine-ui/core/form';
import { ButtonSize, ButtonVariant } from '@mezzanine-ui/core/button';
```

Icons:

```ts
import { UserIcon, SearchIcon } from '@mezzanine-ui/icons';
```

---

## Component Categories

> Source-of-truth: `/packages/ng/<component>/public-api.ts`. See per-component markdown in [references/components/](references/components/).

### General

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznButton`    | `@mezzanine-ui/ng/button`    | [Button.md](references/components/Button.md) |
| `MznIcon`      | `@mezzanine-ui/ng/icon`      | [Icon.md](references/components/Icon.md) |
| `MznSeparator` | `@mezzanine-ui/ng/separator` | [Separator.md](references/components/Separator.md) |
| `MznTypography`| `@mezzanine-ui/ng/typography`| [Typography.md](references/components/Typography.md) |
| `MznCropper`   | `@mezzanine-ui/ng/cropper`   | [Cropper.md](references/components/Cropper.md) |

### Navigation

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznBreadcrumb` | `@mezzanine-ui/ng/breadcrumb` | [Breadcrumb.md](references/components/Breadcrumb.md) |
| `MznDrawer`     | `@mezzanine-ui/ng/drawer`     | [Drawer.md](references/components/Drawer.md) |
| `MznNavigation`                | `@mezzanine-ui/ng/navigation` | [Navigation.md](references/components/Navigation.md) |
| `MznNavigationOptionCategory`  | `@mezzanine-ui/ng/navigation` | [Navigation.md](references/components/Navigation.md) |
| `MznNavigationUserMenu`        | `@mezzanine-ui/ng/navigation` | [Navigation.md](references/components/Navigation.md) |
| `MznPageFooter` | `@mezzanine-ui/ng/page-footer`| [PageFooter.md](references/components/PageFooter.md) |
| `MznPageHeader` | `@mezzanine-ui/ng/page-header`| [PageHeader.md](references/components/PageHeader.md) |
| `MznStepper`    | `@mezzanine-ui/ng/stepper`    | [Stepper.md](references/components/Stepper.md) |
| `MznTab`        | `@mezzanine-ui/ng/tab`        | [Tab.md](references/components/Tab.md) |

### Data Display

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznAccordion`         | `@mezzanine-ui/ng/accordion`         | [Accordion.md](references/components/Accordion.md) |
| `MznBadge`             | `@mezzanine-ui/ng/badge`             | [Badge.md](references/components/Badge.md) |
| `MznCard`              | `@mezzanine-ui/ng/card`              | [Card.md](references/components/Card.md) |
| `MznDescription`       | `@mezzanine-ui/ng/description`       | [Description.md](references/components/Description.md) |
| `MznEmpty`             | `@mezzanine-ui/ng/empty`             | [Empty.md](references/components/Empty.md) |
| `MznOverflowTooltip`   | `@mezzanine-ui/ng/overflow-tooltip`  | [OverflowTooltip.md](references/components/OverflowTooltip.md) |
| `MznPagination`        | `@mezzanine-ui/ng/pagination`        | [Pagination.md](references/components/Pagination.md) |
| `MznSection`           | `@mezzanine-ui/ng/section`           | [Section.md](references/components/Section.md) |
| `MznTable`             | `@mezzanine-ui/ng/table`             | [Table.md](references/components/Table.md) |
| `MznTag`               | `@mezzanine-ui/ng/tag`               | [Tag.md](references/components/Tag.md) |
| `MznTooltip`           | `@mezzanine-ui/ng/tooltip`           | [Tooltip.md](references/components/Tooltip.md) |

### Data Entry

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznAutocomplete`        | `@mezzanine-ui/ng/autocomplete`            | [Autocomplete.md](references/components/Autocomplete.md) |
| `MznCascader`            | `@mezzanine-ui/ng/cascader`                | [Cascader.md](references/components/Cascader.md) |
| `MznCheckbox`            | `@mezzanine-ui/ng/checkbox`                | [Checkbox.md](references/components/Checkbox.md) |
| `MznDatePicker`          | `@mezzanine-ui/ng/date-picker`             | [DatePicker.md](references/components/DatePicker.md) |
| `MznDateRangePicker`     | `@mezzanine-ui/ng/date-range-picker`       | [DateRangePicker.md](references/components/DateRangePicker.md) |
| `MznDateTimePicker`      | `@mezzanine-ui/ng/date-time-picker`        | [DateTimePicker.md](references/components/DateTimePicker.md) |
| `MznDateTimeRangePicker` | `@mezzanine-ui/ng/date-time-range-picker`  | [DateTimeRangePicker.md](references/components/DateTimeRangePicker.md) |
| `MznFilterArea`          | `@mezzanine-ui/ng/filter-area`             | [FilterArea.md](references/components/FilterArea.md) |
| `MznFormField`           | `@mezzanine-ui/ng/form`                    | [Form.md](references/components/Form.md) |
| `MznInput`               | `@mezzanine-ui/ng/input`                   | [Input.md](references/components/Input.md) |
| `MznMultipleDatePicker`  | `@mezzanine-ui/ng/multiple-date-picker`    | [MultipleDatePicker.md](references/components/MultipleDatePicker.md) |
| `MznPicker`              | `@mezzanine-ui/ng/picker`                  | [Picker.md](references/components/Picker.md) |
| `MznRadio`               | `@mezzanine-ui/ng/radio`                   | [Radio.md](references/components/Radio.md) |
| `MznSelect`              | `@mezzanine-ui/ng/select`                  | [Select.md](references/components/Select.md) |
| `MznSelectionCard`       | `@mezzanine-ui/ng/selection-card`          | [SelectionCard.md](references/components/SelectionCard.md) |
| `MznSlider`              | `@mezzanine-ui/ng/slider`                  | [Slider.md](references/components/Slider.md) |
| `MznTextarea`            | `@mezzanine-ui/ng/textarea`                | [Textarea.md](references/components/Textarea.md) |
| `MznTextField`           | `@mezzanine-ui/ng/text-field`              | [TextField.md](references/components/TextField.md) |
| `MznTimePicker`          | `@mezzanine-ui/ng/time-picker`             | [TimePicker.md](references/components/TimePicker.md) |
| `MznTimeRangePicker`     | `@mezzanine-ui/ng/time-range-picker`       | [TimeRangePicker.md](references/components/TimeRangePicker.md) |
| `MznToggle`              | `@mezzanine-ui/ng/toggle`                  | [Toggle.md](references/components/Toggle.md) |
| `MznUpload`              | `@mezzanine-ui/ng/upload`                  | [Upload.md](references/components/Upload.md) |

### Feedback

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznInlineMessage`      | `@mezzanine-ui/ng/inline-message`      | [InlineMessage.md](references/components/InlineMessage.md) |
| `MznMessage`            | `@mezzanine-ui/ng/message`             | [Message.md](references/components/Message.md) |
| `MznModal`              | `@mezzanine-ui/ng/modal`               | [Modal.md](references/components/Modal.md) |
| `MznNotificationCenter` | `@mezzanine-ui/ng/notification-center` | [NotificationCenter.md](references/components/NotificationCenter.md) |
| `MznProgress`           | `@mezzanine-ui/ng/progress`            | [Progress.md](references/components/Progress.md) |
| `MznResultState`        | `@mezzanine-ui/ng/result-state`        | [ResultState.md](references/components/ResultState.md) |
| `MznSkeleton`           | `@mezzanine-ui/ng/skeleton`            | [Skeleton.md](references/components/Skeleton.md) |
| `MznSpin`               | `@mezzanine-ui/ng/spin`                | [Spin.md](references/components/Spin.md) |

### Layout

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznLayout` | `@mezzanine-ui/ng/layout` | [Layout.md](references/components/Layout.md) |

### Others

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznAlertBanner`    | `@mezzanine-ui/ng/alert-banner`    | [AlertBanner.md](references/components/AlertBanner.md) |
| `MznAnchor`         | `@mezzanine-ui/ng/anchor`          | [Anchor.md](references/components/Anchor.md) |
| `MznBackdrop`       | `@mezzanine-ui/ng/backdrop`        | [Backdrop.md](references/components/Backdrop.md) |
| `MznFloatingButton` | `@mezzanine-ui/ng/floating-button` | [FloatingButton.md](references/components/FloatingButton.md) |

### Angular-only components

Components that exist in `@mezzanine-ui/ng` but **not** `@mezzanine-ui/react`:

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznThumbnail`             | `@mezzanine-ui/ng/thumbnail`                | [Thumbnail.md](references/components/Thumbnail.md) |
| `MznSingleThumbnailCard` *(已廢棄 v1.0.0-rc.4)*   | `@mezzanine-ui/ng/single-thumbnail-card`    | [SingleThumbnailCard.md](references/components/SingleThumbnailCard.md) |
| `MznFourThumbnailCard` *(已廢棄 v1.0.0-rc.4)*     | `@mezzanine-ui/ng/four-thumbnail-card`      | [FourThumbnailCard.md](references/components/FourThumbnailCard.md) |
| `MznThumbnailCardInfo` *(已廢棄 v1.0.0-rc.4)*     | `@mezzanine-ui/ng/thumbnail-card-info`      | [ThumbnailCardInfo.md](references/components/ThumbnailCardInfo.md) |
| `MznMediaPreviewModal`     | `@mezzanine-ui/ng/media-preview-modal`      | [MediaPreviewModal.md](references/components/MediaPreviewModal.md) |

### Utility

| Directive / Component | Import path | Reference |
| --------------------- | ----------- | --------- |
| `MznCalendar`   | `@mezzanine-ui/ng/calendar`   | [Calendar.md](references/components/Calendar.md) |
| `MznNotifier`   | `@mezzanine-ui/ng/notifier`   | [Notifier.md](references/components/Notifier.md) |
| `MznPopper`     | `@mezzanine-ui/ng/popper`     | [Popper.md](references/components/Popper.md) |
| `MznPortal`     | `@mezzanine-ui/ng/portal`     | [Portal.md](references/components/Portal.md) |
| `MznTimePanel`  | `@mezzanine-ui/ng/time-panel` | [TimePanel.md](references/components/TimePanel.md) |
| `MznTransition` | `@mezzanine-ui/ng/transition` | [Transition.md](references/components/Transition.md) |

### Internal / Deprecated

| Directive / Component | Status | Reference |
| --------------------- | ------ | --------- |
| `MznClearActions`  | *(internal)* — used inside Select / Input | [ClearActions.md](references/components/ClearActions.md) |
| `MznContentHeader` | *(internal)* — used inside PageHeader / Section | [ContentHeader.md](references/components/ContentHeader.md) |
| `MznDropdown`      | *(internal slot target)*                   | [Dropdown.md](references/components/Dropdown.md) |
| `MznScrollbar`     | *(internal)* — custom scrollbar           | [Scrollbar.md](references/components/Scrollbar.md) |

---

## Shared Resources (synced from `using-mezzanine-ui-react`)

Design tokens, icon catalog, and Figma mappings are identical across React and Angular. They're copied into this skill so each can be used independently:

| Document                                                       | Description                    |
| -------------------------------------------------------------- | ------------------------------ |
| [references/DESIGN_TOKENS.md](references/DESIGN_TOKENS.md)     | Palette / spacing / typography tokens (shared with React) |
| [references/ICONS.md](references/ICONS.md)                     | Icon catalog from `@mezzanine-ui/icons` (shared with React) |
| [references/FIGMA_MAPPING.md](references/FIGMA_MAPPING.md)     | Figma node → component map (shared with React) |

---

## Angular-specific Documentation

| Document                                            | Description                                      |
| --------------------------------------------------- | ------------------------------------------------ |
| [references/PATTERNS.md](references/PATTERNS.md)    | Angular pattern cookbook — page scaffolds, forms, layouts |
| [references/SERVICES.md](references/SERVICES.md)    | DI services exported from `@mezzanine-ui/ng/services` |
| [references/COMPONENTS.md](references/COMPONENTS.md)| Consolidated Angular component index with full API |

---

## Maintenance

### Version Sync Command

When `@mezzanine-ui/ng` releases a new version, run the sync orchestrator:

```
/sync-mezzanine-ui 1.0.0 --target angular
```

The orchestrator shares infrastructure with the React sync: fetches TypeScript from GitHub, regenerates cache JSON, refreshes shared design-token / icon / figma-mapping docs.

See companion skill `using-mezzanine-ui-react` for the React side.
