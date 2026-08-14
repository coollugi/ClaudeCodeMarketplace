# Description

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/description) · Verified 1.0.0-rc.4 (2026-04-24)

Key–value pair display. `MznDescription` wraps a `MznDescriptionTitle` (label) and a projected `MznDescriptionContent` (value). Group multiple pairs with `MznDescriptionGroup`.

> **Aliases** — Descriptions (Ant Design) · Definition List · Key-Value List · 詳情資訊 · 標題內容對 · Figma `Description / *`
> **Not for** — 可排序／分頁的資料列表（用 [`MznTable`](Table.md)）。單筆資料的欄位展示不要用兩欄 `MznTable` 湊。

## Import

```ts
import {
  MznDescription,
  MznDescriptionGroup,
  MznDescriptionTitle,
  MznDescriptionContent,
  MZN_DESCRIPTION_CONTEXT,
} from '@mezzanine-ui/ng/description';
import type { DescriptionContextValue } from '@mezzanine-ui/ng/description';

import type {
  DescriptionContentVariant,
  DescriptionOrientation,
  DescriptionSize,
  DescriptionWidthType,
} from '@mezzanine-ui/core/description';
```

## Selectors

| Selector                 | Role                                           |
| ------------------------ | ---------------------------------------------- |
| `[mznDescription]`       | Root host; renders title + projected content   |
| `[mznDescriptionTitle]`  | Label cell (auto-rendered by `mznDescription`) |
| `[mznDescriptionContent]`| Value cell (projected via `<ng-content>`)      |
| `[mznDescriptionGroup]`  | Grid/flex container for multiple descriptions  |

## MznDescriptionContent — Inputs

| Input     | Type                          | Default    | Description                                                        |
| --------- | ----------------------------- | ---------- | ------------------------------------------------------------------ |
| `variant` | `DescriptionContentVariant`   | `'normal'` | `'normal' \| 'trend-up' \| 'trend-down' \| 'with-icon'`           |
| `icon`    | `IconDefinition \| undefined` | —          | Icon shown after content (only rendered when `variant='with-icon'`) |
| `size`    | `DescriptionSize \| undefined`| —          | Override size; falls back to parent `MznDescription` context size  |

## MznDescriptionContent — Outputs

| Output      | Type                   | Description                                                                           |
| ----------- | ---------------------- | ------------------------------------------------------------------------------------- |
| `clickIcon` | `EventEmitter<void>`   | Emitted when the `with-icon` icon is clicked. Uses decorator `@Output` (not signal API) so `.observed` can detect whether a listener is bound — the icon cursor changes to pointer only when a listener exists. |

## MznDescriptionTitle — Inputs

| Input              | Type                           | Default     | Description                                           |
| ------------------ | ------------------------------ | ----------- | ----------------------------------------------------- |
| `text`             | `string \| undefined`          | —           | Title text (programmatic); use `<ng-content>` instead when possible |
| `size`             | `DescriptionSize \| undefined` | —           | Override size; falls back to parent `MznDescription` context size   |
| `badge`            | `BadgeDotVariant \| undefined` | —           | Dot badge shown left of title text                    |
| `icon`             | `IconDefinition \| undefined`  | —           | Info icon shown right of title text                   |
| `tooltip`          | `string \| undefined`          | —           | Tooltip on the icon                                   |
| `tooltipPlacement` | `Placement \| undefined`       | `'top'`     | Floating-UI placement for the tooltip                 |
| `widthType`        | `DescriptionWidthType`         | `'stretch'` | Title column width: `'stretch' \| 'narrow' \| 'wide'` |

## MznDescription — Inputs

| Input              | Type                                  | Default        | Description                                            |
| ------------------ | ------------------------------------- | -------------- | ------------------------------------------------------ |
| `title`            | `string` (**required**)              | —              | Label text                                             |
| `orientation`      | `DescriptionOrientation`              | `'horizontal'` | `'horizontal'` or `'vertical'` layout                 |
| `size`             | `DescriptionSize`                     | `'main'`       | Text size; propagated to child content via DI context  |
| `widthType`        | `DescriptionWidthType`                | `'stretch'`    | Title column width: `'stretch' \| 'narrow' \| 'wide'` |
| `badge`            | `BadgeDotVariant \| undefined`        | —              | Dot badge on the title label                           |
| `icon`             | `IconDefinition \| undefined`         | —              | Info icon on the title label                           |
| `tooltip`          | `string \| undefined`                 | —              | Tooltip shown when hovering the icon                   |
| `tooltipPlacement` | `Placement \| undefined`              | —              | Floating-UI placement for the tooltip                  |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## MznDescription / MznDescriptionGroup — Outputs

None. (See `MznDescriptionContent` above for its `clickIcon` output.)

## ControlValueAccessor

No.

## Usage

```html
<!-- Basic horizontal -->
<div mznDescription title="訂購日期" widthType="narrow">
  <span mznDescriptionContent>2025-11-03</span>
</div>

<!-- Vertical layout with badge -->
<div mznDescription title="狀態" orientation="vertical" badge="info">
  <span mznDescriptionContent>處理中</span>
</div>

<!-- Group of descriptions -->
<div mznDescriptionGroup>
  <div mznDescription title="訂單編號"><span mznDescriptionContent>ORD-001</span></div>
  <div mznDescription title="付款方式"><span mznDescriptionContent>信用卡</span></div>
  <div mznDescription title="收件地址"><span mznDescriptionContent>台北市信義區...</span></div>
</div>
```

## DI Tokens

`MZN_DESCRIPTION_CONTEXT` is an `InjectionToken<DescriptionContextValue>` provided by `MznDescription` via a factory that returns live getters bound to the root's `size()` signal. Child components (e.g. `MznDescriptionContent`, `MznDescriptionTitle`) inject it to resolve the size when their own `size` input is not explicitly set.

```ts
interface DescriptionContextValue {
  readonly size: DescriptionSize; // 'main' | 'sub'
}
```

Source: `description.component.ts` (provider factory, lines 45–53) returns `{ get size() { return self.size(); } }`, so consumers always read the current input value.

## Notes

- `title` is `input.required<string>()` — omitting it throws a runtime error.
- The `size` input is injected into child components via `MZN_DESCRIPTION_CONTEXT`. The child `MznDescriptionContent` reads this token to apply the correct text size class automatically.
- Unlike the React counterpart which renders a `<dl>/<dt>/<dd>` structure, the Angular version uses attribute-directive components on arbitrary host elements; choose semantically appropriate HTML elements (e.g. `<div>`, `<span>`) when needed.
- `MznDescriptionGroup` applies a grid layout class (`mzn-description-group`) — no inputs required.
