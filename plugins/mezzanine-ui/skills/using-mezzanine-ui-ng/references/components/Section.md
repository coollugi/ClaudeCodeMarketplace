# Section

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/section) · Verified 1.0.0-rc.4 (2026-04-24)

Layout container that composes a `MznContentHeader`, an optional `MznFilterArea`, optional tabs, and the main content area. Uses named `ng-content` selectors to position each child in the correct slot.

> **Aliases** — Panel · Fieldset · Well · Card（作為頁面區塊時）· 區塊 · 卡片式區塊 · Figma `Section / *`
> **Not for** — 圖文卡片／商品卡（用 [`MznBaseCard`](Card.md) 家族）。`MznSection` 自帶 16px 內距與底色，**不要再幫它補 padding**，外側 gutter 由 page body wrapper 提供。

## Import

```ts
import { MznSection, MznSectionGroup } from '@mezzanine-ui/ng/section';
import type { SectionGroupDirection }  from '@mezzanine-ui/ng/section';
// Usually paired with:
import { MznContentHeader } from '@mezzanine-ui/ng/content-header';
import { MznFilterArea }    from '@mezzanine-ui/ng/filter-area';
```

## Selectors

| Selector              | Role                                               |
| --------------------- | -------------------------------------------------- |
| `[mznSection]`        | Root section container                             |
| `[mznSectionGroup]`   | Wrapper for multiple side-by-side `MznSection`s    |

## MznSection — Inputs

None — `MznSection` is a pure layout shell. All configuration is done on projected child components.

## MznSectionGroup — Inputs

| Input       | Type                   | Default      | Description                                                                 |
| ----------- | ---------------------- | ------------ | --------------------------------------------------------------------------- |
| `direction` | `SectionGroupDirection` | `'vertical'` | Arrangement direction: `'horizontal'` (side-by-side) or `'vertical'` (stacked) |

`SectionGroupDirection = 'horizontal' | 'vertical'`

## ControlValueAccessor

No.

## Content Projection Slots

`MznSection` projects children into predefined slots:

| Slot selector                     | Projected component                    |
| --------------------------------- | -------------------------------------- |
| `[mznContentHeader]`              | `MznContentHeader`                     |
| `[mznFilterArea]`                 | `MznFilterArea`                        |
| `[mznTabs], [sectionTab]`         | `MznTabs` or a custom tab component    |
| *(default)*                       | Main content area (wrapped in `__content` div) |

## Usage

```html
<!-- Basic section with header -->
<div mznSection>
  <header mznContentHeader title="使用者清單" size="sub"></header>
  <table><!-- table content --></table>
</div>

<!-- Section with filter area -->
<div mznSection>
  <header mznContentHeader title="訂單管理"></header>
  <div mznFilterArea>
    <!-- filter controls -->
  </div>
  <div>主要內容</div>
</div>

<!-- Multiple sections side by side -->
<div mznSectionGroup>
  <div mznSection>
    <header mznContentHeader title="左側區塊"></header>
    <p>左側內容</p>
  </div>
  <div mznSection>
    <header mznContentHeader title="右側區塊"></header>
    <p>右側內容</p>
  </div>
</div>
```

## Notes

- `MznSection` has no inputs of its own — all styling is via projected children. This differs from the React counterpart which accepts `title` and `size` props directly on `<Section>`.
- The default content slot is wrapped in a `<div class="mzn-section__content">` container; other slots are projected directly without an additional wrapper.
- **版面 padding 契約**：`mznSection` 自帶 `padding: vertical-spacious horizontal-spacious`（預設 16px、compact 12/14px）、圓角與卡片底色，但**沒有 margin**。外側 gutter 仍要由 body wrapper 的 `padding-inline: var(--mzn-spacing-padding-horizontal-spacious)` 提供 — 直接掛在無水平 padding 的 page container 下會**貼齊版面邊緣**；內側 16px 由元件自己提供，**不要**再對它或它的直接子元素補 padding。對齊結果：卡片左緣 = `mznContentHeader` 標題文字左緣（16px），卡片內容再內縮 16px。詳見 [PATTERNS.md → Page Body Alignment with MznPageHeader](../PATTERNS.md#page-body-alignment-with-mznpageheader-重要--容易忽略)。
- `MznSectionGroup` arranges multiple sections using CSS flexbox. The **default direction is `'vertical'`** (stacked). Pass `direction="horizontal"` to place sections side by side. The `direction` attribute is removed from the DOM host (set to `null`) — use the Angular input binding only.
