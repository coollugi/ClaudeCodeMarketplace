# Tab

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/tab) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/navigation-tab--docs

Tab 導航元件，用於組織多個內容面板之間的切換。`MznTabs` 為容器，管理 active bar 位置與 active key 狀態；`MznTabItem` 為單一 Tab 按鈕（host element 必須為 `<button>`）。支援受控（`[activeKey]`）與非受控（`[defaultActiveKey]`）兩種模式，以及水平/垂直方向。

> **Aliases** — Tabs · TabBar · mat-tab-group (Angular Material) · 頁籤 · 分頁標籤 · Figma `Tab / *`
> **Not for** — 互斥的檢視／排序切換（用 [`MznRadioGroup type="segment"`](Radio.md)）

## Import

```ts
import { MznTabs, MznTabItem } from '@mezzanine-ui/ng/tab';
import { MZN_TABS_CONTEXT } from '@mezzanine-ui/ng/tab';
import type { TabsContext } from '@mezzanine-ui/ng/tab';
```

## Selector

`<div mznTabs [(activeKey)]="currentTab">` — tabs container

`<button mznTabItem [key]="'tab1'">` — 單一 tab item，host element 必須為 `<button>`

## Children Validation (重要)

`MznTabs` 透過 `contentChildren(MznTabItem)` 蒐集子代，並依靠注入 `MZN_TABS_CONTEXT` 給每個 `MznTabItem` 取得 active state。**只有「直接子代」且 host 為 `<button mznTabItem>` 才會被識別**。

### 常見靜默失敗

```html
<!-- ❌ 包一層 div：mznTabItem 雖渲染但找不到 context，行為錯亂或不顯示 active bar -->
<div mznTabs>
  <div class="tabs">
    <button mznTabItem [key]="'a'">A</button>
  </div>
</div>

<!-- ❌ 用 a / span 套 mznTabItem：directive selector 是 button[mznTabItem]，不會生效 -->
<div mznTabs>
  <a mznTabItem [key]="'a'">A</a>           <!-- 不渲染 mzn 樣式 -->
</div>

<!-- ❌ 忘了在 standalone 元件 imports 內加入 MznTabs / MznTabItem -->

<!-- ✅ 正確：mznTabItem 為 mznTabs 直接子代，host 為 button -->
<div mznTabs [(activeKey)]="active">
  <button mznTabItem [key]="'a'">A</button>
  @for (tab of tabs(); track tab.id) {
    <button mznTabItem [key]="tab.id">{{ tab.label }}</button>
  }
</div>
```

> Tab 內容（每個分頁的 body）放在 `mznTabs` 之外，依 `activeKey` signal 切換，不要寫在 `mznTabs` 內。

## Inputs — MznTabs

| Input            | Type                  | Default | Description                                                                   |
| ---------------- | --------------------- | ------- | ----------------------------------------------------------------------------- |
| `activeKey`      | `string \| number`    | —       | 受控模式：當前選取的 key（不設定則使用非受控模式）                              |
| `defaultActiveKey` | `string \| number`  | `0`     | 非受控模式的初始 active key                                                    |
| `direction`      | `'horizontal' \| 'vertical'` | `'horizontal'` | Tab 排列方向                                                   |
| `size`           | `'main' \| 'sub'`     | `'main'`| Tab 尺寸                                                                      |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs — MznTabs

| Output            | Type                                 | Description                    |
| ----------------- | ------------------------------------ | ------------------------------ |
| `activeKeyChange` | `OutputEmitterRef<string \| number>` | Tab 切換時觸發，發送新的 active key |

## Inputs — MznTabItem

| Input        | Type                    | Default     | Description                                              |
| ------------ | ----------------------- | ----------- | -------------------------------------------------------- |
| `key`        | `string \| number` (required) | —     | 此 Tab 的唯一識別 key                                    |
| `disabled`   | `boolean`               | `false`     | 是否禁用                                                  |
| `error`      | `boolean`               | `false`     | 是否顯示錯誤狀態                                          |
| `icon`       | `IconDefinition`        | —           | Tab 圖示，顯示於文字左側                                  |
| `badgeCount` | `number`                | —           | 未讀計數徽章；未設定不顯示                                |

> Inputs declared with signal API (`input()`, `input.required()`) accept both static and reactive values.

## Outputs — MznTabItem

| Output    | Type                     | Description          |
| --------- | ------------------------ | -------------------- |
| `clicked` | `OutputEmitterRef<void>` | Tab 被點擊時觸發      |

## 版面 padding 契約 (重要 — size 決定是否貼邊)

`mznTabs` 的 `size` input **預設為 `'main'`**（`tabs.component.ts`），而 `size="main"` 在 core SCSS 帶有自己的 gutter：

```scss
.mzn-tab--horizontal.mzn-tab--main { padding: 16px 16px 0; }  // compact 12 / 14 / 0
.mzn-tab--vertical.mzn-tab--main   { padding: 0 0 0 16px; }   // compact left 14
```

橫向 Tab 的底線是 `::before { inset: 0; border-bottom: ... }`，**必須滿版**才不會被截斷。因此：

- **`size="main"`（頁面級分頁）** — 必須是 page container 的**直接子代**，與 `mznPageHeader` 同層貼齊版面。
- **`size="sub"`（Section 內的分頁）** — host 無 padding，只有 `__item` 有較緊湊的內距。透過 `mznSection` 的 tab 插槽 傳入時，Section 另有 `> .mzn-tab--horizontal.mzn-tab--main { padding: 0 }` 會把 main size 的 padding 歸零。
- 放進套了 `padding-inline` 的 body wrapper 時要改 `size="sub"`，否則是 16 + 16 的雙層內縮。

詳見 SKILL.md → **Page Layout Skeleton (必讀 — 版面 padding 契約)**。

## Usage

```html
<!-- 受控模式（推薦） -->
<div mznTabs [activeKey]="activeTab()" (activeKeyChange)="activeTab.set($event)">
  <button mznTabItem [key]="'overview'">總覽</button>
  <button mznTabItem [key]="'analytics'">分析</button>
  <button mznTabItem [key]="'settings'">設定</button>
</div>

<!-- 雙向綁定 -->
<div mznTabs [(activeKey)]="activeTab">
  <button mznTabItem [key]="'tab1'">頁籤一</button>
  <button mznTabItem [key]="'tab2'">頁籤二</button>
</div>

<!-- 非受控模式 -->
<div mznTabs [defaultActiveKey]="'tab1'">
  <button mznTabItem [key]="'tab1'">頁籤一</button>
  <button mznTabItem [key]="'tab2'">頁籤二</button>
</div>

<!-- 垂直排列 -->
<div mznTabs direction="vertical" [activeKey]="activeTab()">
  <button mznTabItem [key]="0">首頁</button>
  <button mznTabItem [key]="1">設定</button>
</div>

<!-- 帶徽章計數與圖示 -->
<div mznTabs [activeKey]="activeTab()" (activeKeyChange)="activeTab.set($event)">
  <button mznTabItem [key]="'inbox'" [icon]="InboxIcon" [badgeCount]="unreadCount()">
    收件匣
  </button>
  <button mznTabItem [key]="'sent'">已傳送</button>
  <button mznTabItem [key]="'trash'" [error]="hasError()">垃圾桶</button>
  <button mznTabItem [key]="'archived'" [disabled]="true">封存</button>
</div>
```

```ts
import { Component, signal } from '@angular/core';
import { MznTabs, MznTabItem } from '@mezzanine-ui/ng/tab';
import { InboxIcon } from '@mezzanine-ui/icons';
import type { IconDefinition } from '@mezzanine-ui/icons';

@Component({
  selector: 'app-email',
  imports: [MznTabs, MznTabItem],
  template: `
    <div mznTabs [activeKey]="activeTab()" (activeKeyChange)="activeTab.set($event)">
      <button mznTabItem [key]="'inbox'" [icon]="inboxIcon" [badgeCount]="unreadCount()">
        收件匣
      </button>
      <button mznTabItem [key]="'sent'">已傳送</button>
      <button mznTabItem [key]="'drafts'">草稿</button>
    </div>

    @switch (activeTab()) {
      @case ('inbox') { <app-inbox /> }
      @case ('sent') { <app-sent /> }
      @case ('drafts') { <app-drafts /> }
    }
  `,
})
export class EmailComponent {
  readonly inboxIcon: IconDefinition = InboxIcon;
  readonly activeTab = signal<string>('inbox');
  readonly unreadCount = signal(5);
}
```

## Notes

- `MznTabItem` 的 host element **必須是 `<button>`**，以確保鍵盤可及性與正確的 DOM 語意（`type="button"` 由元件自動加上）。
- Active bar（底線/側線）的位置由 `MznTabs` 在 `AfterViewInit` 及 `requestAnimationFrame` 時計算，確保 DOM 已更新後再定位。
- 受控模式：`activeKey` + `(activeKeyChange)`；非受控模式：只設定 `[defaultActiveKey]`，元件內部自行管理狀態。
- `badgeCount` 的顏色會依 active/error 狀態自動調整：`error` → `count-alert`，active → `count-brand`，其他 → `count-inactive`。
- `MZN_TABS_CONTEXT` 為 Angular-only DI token，`MznTabItem` 透過它取得父層 `MznTabs` 的 active key 與 `handleTabClick`。
