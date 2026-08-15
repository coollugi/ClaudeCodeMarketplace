# Card

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/card) · Verified 1.0.0-rc.4 (2026-04-24)

Card family for content containers. Includes `MznBaseCard` (titled card with optional action / overflow / toggle in the header), `MznQuickActionCard` (icon + title entry point), and `MznCardGroup` (CSS Grid layout wrapper with built-in skeleton loading).

> **Aliases** — Card · Tile · mat-card (Angular Material) · 卡片 · 商品卡 · 圖文卡 · Figma `Card / *`
> **Not for** — 頁面級的內容區塊（用 [`MznSection`](Section.md)）；可選取的卡片（用 [`MznSelectionCard`](SelectionCard.md)）

## Import

```ts
import {
  MznBaseCard,
  MznBaseCardSkeleton,
  MznQuickActionCard,
  MznQuickActionCardSkeleton,
  MznCardGroup,
} from '@mezzanine-ui/ng/card';

// Types
import type { BaseCardType, BaseCardActionVariant, CardGroupType } from '@mezzanine-ui/ng/card';

// Thumbnail card variants live in separate packages:
import { MznSingleThumbnailCard } from '@mezzanine-ui/ng/single-thumbnail-card';
import { MznFourThumbnailCard }   from '@mezzanine-ui/ng/four-thumbnail-card';
```

## Selectors

| Selector              | Role                                         |
| --------------------- | -------------------------------------------- |
| `[mznBaseCard]`       | Titled card with optional header action      |
| `[mznQuickActionCard]` | Compact icon-title action entry point       |
| `[mznCardGroup]`      | CSS Grid container with skeleton loading     |

## MznBaseCard — Inputs

| Input                    | Type                                           | Default           | Description                                       |
| ------------------------ | ---------------------------------------------- | ----------------- | ------------------------------------------------- |
| `title`                  | `string \| undefined`                          | —                 | Card title text                                   |
| `description`            | `string \| undefined`                          | —                 | Subtitle text below the title                     |
| `type`                   | `BaseCardType`                                 | `'default'`       | Header action type: `default \| action \| overflow \| toggle` |
| `actionName`             | `string \| undefined`                          | —                 | Button label when `type='action'`                 |
| `actionVariant`          | `BaseCardActionVariant`                        | `'base-text-link'` | Button variant when `type='action'`               |
| `active`                 | `boolean`                                      | `false`           | Selected/active highlight                         |
| `disabled`               | `boolean`                                      | `false`           | Disables all interactions                         |
| `readOnly`               | `boolean`                                      | `false`           | Read-only state                                   |
| `checked`                | `boolean \| undefined`                         | —                 | Controlled toggle state (`type='toggle'`)         |
| `defaultChecked`         | `boolean \| undefined`                         | —                 | Initial toggle state (uncontrolled)               |
| `toggleLabel`            | `string \| undefined`                          | —                 | Toggle label (`type='toggle'`)                    |
| `toggleSize`             | `ToggleSize \| undefined`                      | —                 | Toggle size (`type='toggle'`)                     |
| `toggleSupportingText`   | `string \| undefined`                          | —                 | Toggle supporting text (`type='toggle'`)          |
| `options`                | `ReadonlyArray<DropdownOption>`                | `[]`              | Dropdown options when `type='overflow'`           |

## MznBaseCard — Outputs

| Output          | Type                        | Description                                        |
| --------------- | --------------------------- | -------------------------------------------------- |
| `actionClick`   | `OutputEmitterRef<MouseEvent>` | Header action button clicked (`type='action'`)  |
| `optionSelect`  | `OutputEmitterRef<DropdownOption>` | Overflow option selected (`type='overflow'`) |
| `toggleChange`  | `OutputEmitterRef<boolean>` | Toggle state changed (`type='toggle'`)             |

## MznQuickActionCard — Inputs

| Input      | Type                      | Default        | Description           |
| ---------- | ------------------------- | -------------- | --------------------- |
| `icon`     | `IconDefinition \| undefined` | —          | Icon shown on the left |
| `title`    | `string \| undefined`     | —              | Main label text       |
| `subtitle` | `string \| undefined`     | —              | Secondary label text  |
| `mode`     | `'horizontal' \| 'vertical'` | `'horizontal'` | Layout direction   |
| `disabled` | `boolean`                 | `false`        | Disables interaction  |
| `readOnly` | `boolean`                 | `false`        | Read-only state       |

## MznBaseCardSkeleton

Skeleton placeholder that mimics the `MznBaseCard` layout (header title + description rows, and optionally a content area). Use inside `MznCardGroup` when `[loading]="true"` or standalone.

**Selector**: `[mznBaseCardSkeleton]`

| Input         | Type      | Default | Description                                     |
| ------------- | --------- | ------- | ----------------------------------------------- |
| `showContent` | `boolean` | `true`  | Whether to render the content area skeleton rows |

```html
<!-- Loading placeholder replacing a base card -->
<div mznBaseCardSkeleton></div>
<div mznBaseCardSkeleton [showContent]="false"></div>
```

## MznQuickActionCardSkeleton

Skeleton placeholder that mimics the `MznQuickActionCard` layout (circle icon + two text rows).

**Selector**: `[mznQuickActionCardSkeleton]`

| Input  | Type                           | Default        | Description               |
| ------ | ------------------------------ | -------------- | ------------------------- |
| `mode` | `'horizontal' \| 'vertical'`  | `'horizontal'` | Layout direction to match |

```html
<!-- Matches horizontal QuickActionCard layout -->
<div mznQuickActionCardSkeleton></div>

<!-- Matches vertical QuickActionCard layout -->
<div mznQuickActionCardSkeleton mode="vertical"></div>
```

## MznCardGroup — Inputs

| Input                       | Type                  | Default  | Description                                              |
| --------------------------- | --------------------- | -------- | -------------------------------------------------------- |
| `cardType`                  | `CardGroupType`       | `'base'` | Layout variant: `base \| quick-action \| single-thumbnail \| four-thumbnail` |
| `loading`                   | `boolean`             | `false`  | Show skeleton placeholders                               |
| `loadingCount`              | `number`              | `3`      | Number of skeleton items                                 |
| `loadingThumbnailAspectRatio` | `string \| undefined` | —      | Thumbnail skeleton aspect ratio (thumbnail card types)   |
| `loadingThumbnailWidth`     | `number \| string \| undefined` | — | Thumbnail skeleton width (thumbnail card types)      |

## ControlValueAccessor

No — Card components are display/interaction components with no form binding.

## Usage

```html
<!-- BaseCard with action button -->
<div mznBaseCard title="使用者設定" description="管理您的帳號" type="action" actionName="編輯" (actionClick)="onEdit()">
  <p>卡片內容區域</p>
</div>

<!-- BaseCard with overflow menu -->
<div mznBaseCard title="資料項目" type="overflow" [options]="menuOptions" (optionSelect)="onOption($event)">
  <p>內容</p>
</div>

<!-- BaseCard with toggle -->
<div mznBaseCard title="通知設定" type="toggle" toggleLabel="啟用通知" [checked]="notifyEnabled" (toggleChange)="notifyEnabled = $event">
  <p>設定詳情</p>
</div>

<!-- QuickActionCard -->
<button mznQuickActionCard [icon]="addIcon" title="新增項目" (click)="onAdd()"></button>

<!-- CardGroup with loading skeleton -->
<div mznCardGroup cardType="base" [loading]="isLoading" [loadingCount]="4">
  @for (item of items; track item.id) {
    <div mznBaseCard [title]="item.title">{{ item.content }}</div>
  }
</div>
```

```ts
import { MznBaseCard, MznCardGroup } from '@mezzanine-ui/ng/card';
import type { DropdownOption } from '@mezzanine-ui/core/dropdown';

readonly menuOptions: ReadonlyArray<DropdownOption> = [
  { id: 'edit', label: '編輯' },
  { id: 'delete', label: '刪除' },
];
```

## Notes

- `type='overflow'` renders a `[mznDropdown]` with `mode='single'`. The dropdown's open state is managed internally via a `signal`.
- The `defaultChecked` input follows React `useState(defaultValue)` semantics: it is read once at `ngOnInit` and subsequent input changes do not reset state. Use `[checked]` for controlled mode.
- The Angular `MznBaseCard` template has a single unnamed `<ng-content />` inside the content wrapper. There is no named `[header-action]` slot — custom header elements are not content-projected; use `type="action"`, `type="overflow"`, or `type="toggle"` inputs to add header controls.
- `MznCardGroup` with `cardType='single-thumbnail'` or `'four-thumbnail'` automatically renders the corresponding skeleton component. Import the matching card component separately from its own package.
