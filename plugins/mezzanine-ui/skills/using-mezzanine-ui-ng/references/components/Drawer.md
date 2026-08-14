# Drawer

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/drawer) · Verified 1.0.0-rc.4 (2026-04-24)

Slide-in panel from the right side of the screen. All header, footer, and filter-area features are flat props — no sub-component nesting required. Escape-key handling uses `EscapeKeyService` + `TopStackService` identical to `MznModal`.

## Import

```ts
import { MznDrawer } from '@mezzanine-ui/ng/drawer';
import type { DrawerSize } from '@mezzanine-ui/core/drawer';
```

## Selector

`[mznDrawer]` — component applied to a host element.

## Inputs

### Core

| Input                          | Type           | Default    | Description                                    |
| ------------------------------ | -------------- | ---------- | ---------------------------------------------- |
| `open`                         | `boolean`      | `false`    | Controls drawer visibility                     |
| `size`                         | `DrawerSize`   | `'medium'` | `'small' \| 'medium' \| 'large'`              |
| `isHeaderDisplay`              | `boolean`      | `false`    | Show header section                            |
| `headerTitle`                  | `string \| undefined` | —   | Header title text                              |
| `isBottomDisplay`              | `boolean`      | `false`    | Show bottom action buttons                     |
| `disableCloseOnBackdropClick`  | `boolean`      | `false`    | Prevent backdrop click from closing            |
| `disableCloseOnEscapeKeyDown`  | `boolean`      | `false`    | Prevent Escape key from closing                |
| `disablePortal`                | `boolean`      | `false`    | Render in-place instead of portal              |
| `container`                    | `HTMLElement \| undefined` | — | Custom portal target element               |
| `contentKey`                   | `string \| number \| undefined` | — | Key for content re-mount on change         |
| `className`                    | `string \| undefined` | —   | Extra CSS class on drawer panel                |

### Bottom Action Buttons

Each action slot (primary, secondary, ghost) shares the same set of inputs:

| Input                           | Type             | Default            | Description                          |
| ------------------------------- | ---------------- | ------------------ | ------------------------------------ |
| `bottomPrimaryActionText`       | `string`         | —                  | Button label; button hidden if empty |
| `bottomPrimaryActionVariant`    | `ButtonVariant`  | `'base-primary'`   | Button variant                       |
| `bottomPrimaryActionLoading`    | `boolean`        | `false`            | Loading spinner state                |
| `bottomPrimaryActionDisabled`   | `boolean`        | `false`            | Disabled state                       |
| `bottomPrimaryActionIcon`       | `IconDefinition` | —                  | Leading icon                         |
| `bottomPrimaryActionIconType`   | `ButtonIconType` | —                  | Icon button type                     |
| `bottomPrimaryActionSize`       | `ButtonSize`     | —                  | Button size                          |
| `bottomSecondaryActionText`     | `string`         | —                  | Button label; button hidden if empty |
| `bottomSecondaryActionVariant`  | `ButtonVariant`  | `'base-secondary'` | Button variant                       |
| `bottomSecondaryActionLoading`  | `boolean`        | `false`            | Loading spinner state                |
| `bottomSecondaryActionDisabled` | `boolean`        | `false`            | Disabled state                       |
| `bottomSecondaryActionIcon`     | `IconDefinition` | —                  | Leading icon                         |
| `bottomSecondaryActionIconType` | `ButtonIconType` | —                  | Icon button type                     |
| `bottomSecondaryActionSize`     | `ButtonSize`     | —                  | Button size                          |
| `bottomGhostActionText`         | `string`         | —                  | Button label; button hidden if empty |
| `bottomGhostActionVariant`      | `ButtonVariant`  | `'base-ghost'`     | Button variant                       |
| `bottomGhostActionLoading`      | `boolean`        | `false`            | Loading spinner state                |
| `bottomGhostActionDisabled`     | `boolean`        | `false`            | Disabled state                       |
| `bottomGhostActionIcon`         | `IconDefinition` | —                  | Leading icon                         |
| `bottomGhostActionIconType`     | `ButtonIconType` | —                  | Icon button type                     |
| `bottomGhostActionSize`         | `ButtonSize`     | —                  | Button size                          |

### Filter Area (Notification-style drawer)

| Input                         | Type                              | Default       | Description                              |
| ----------------------------- | --------------------------------- | ------------- | ---------------------------------------- |
| `filterAreaShow`              | `boolean`                         | `false`       | Display the filter area                  |
| `filterAreaOptions`           | `ReadonlyArray<DropdownOption>`   | —             | Dropdown filter options                  |
| `filterAreaValue`             | `string \| undefined`             | —             | Selected filter value (controlled)       |
| `filterAreaDefaultValue`      | `string \| undefined`             | —             | Initial filter value (uncontrolled)      |
| `filterAreaIsEmpty`           | `boolean`                         | `false`       | Show empty state in filter               |
| `filterAreaAllRadioLabel`     | `string`                          | —             | "All" radio label                        |
| `filterAreaReadRadioLabel`    | `string`                          | —             | "Read" radio label                       |
| `filterAreaUnreadRadioLabel`  | `string`                          | —             | "Unread" radio label                     |
| `filterAreaCustomButtonLabel` | `string`                          | `'全部已讀'`  | "Mark all read" button label             |
| `filterAreaShowUnreadButton`  | `boolean`                         | `false`       | Show the unread-filter button            |

> Inputs declared with signal API (`input()`, `model()`) accept both static and reactive values.

## Outputs

| Output                       | Type                          | Description                               |
| ---------------------------- | ----------------------------- | ----------------------------------------- |
| `closed`                     | `OutputEmitterRef<void>`      | Fires when drawer closes                  |
| `backdropClick`              | `OutputEmitterRef<void>`      | Fires on backdrop click                   |
| `bottomPrimaryActionClick`   | `OutputEmitterRef<void>`      | Primary button clicked                    |
| `bottomSecondaryActionClick` | `OutputEmitterRef<void>`      | Secondary button clicked                  |
| `bottomGhostActionClick`     | `OutputEmitterRef<void>`      | Ghost button clicked                      |
| `filterAreaRadioChange`      | `OutputEmitterRef<string>`    | Filter radio selection changed            |
| `filterAreaSelect`           | `OutputEmitterRef<DropdownOption>` | Filter dropdown option selected      |
| `filterAreaCustomButtonClick`| `OutputEmitterRef<void>`      | "Mark all read" button clicked            |

## Injected Services

`MznDrawer` auto-injects the following services — no manual provider setup is needed:

| Service            | Purpose                                              |
| ------------------ | ---------------------------------------------------- |
| `EscapeKeyService` | Tracks Escape keydown globally (singleton)           |
| `TopStackService`  | Ensures only the topmost overlay closes on Escape    |

## ControlValueAccessor

No.

## Usage

```html
<!-- Basic drawer with header and footer -->
<div mznDrawer
  [open]="isOpen"
  size="medium"
  isHeaderDisplay
  headerTitle="編輯項目"
  isBottomDisplay
  bottomPrimaryActionText="儲存"
  bottomSecondaryActionText="取消"
  [bottomPrimaryActionLoading]="isSaving"
  (bottomPrimaryActionClick)="onSave()"
  (bottomSecondaryActionClick)="isOpen = false"
  (closed)="isOpen = false"
>
  <p>抽屜內容區域</p>
</div>

<!-- Notification drawer with filter area -->
<div mznDrawer
  [open]="isOpen"
  isHeaderDisplay
  headerTitle="通知"
  filterAreaShow
  [filterAreaOptions]="filterOptions"
  filterAreaShowUnreadButton
  filterAreaCustomButtonLabel="全部已讀"
  (filterAreaRadioChange)="onFilterChange($event)"
  (filterAreaCustomButtonClick)="markAllRead()"
  (closed)="isOpen = false"
>
  <!-- Notification list -->
</div>
```

```ts
import { MznDrawer } from '@mezzanine-ui/ng/drawer';

isOpen = false;
isSaving = false;

async onSave(): Promise<void> {
  this.isSaving = true;
  await this.service.save();
  this.isSaving = false;
  this.isOpen = false;
}
```

## Notes

- `booleanAttribute` transform is applied to `open`, `isHeaderDisplay`, `isBottomDisplay`, and similar boolean inputs — these can be used as attribute flags without explicit `[binding]="true"` binding.
- Unlike `MznModal`, `MznDrawer` encapsulates header and footer as flat props rather than sub-components. There is no `MznDrawerHeader` or `MznDrawerFooter` to import.
- The filter area is intended for notification-center-style drawers and renders a radio group + optional dropdown at the top of the content area.
- The `contentKey` input unmounts and remounts the projected content when its value changes, which is useful for resetting form state between different edit targets.
