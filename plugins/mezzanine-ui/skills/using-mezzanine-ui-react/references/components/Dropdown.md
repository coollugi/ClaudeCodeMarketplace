# Dropdown Component

> **Category**: Internal
>
> **Storybook**: `Internal/Dropdown`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Dropdown) · Verified 1.4.1 (2026-07-01)

A low-level dropdown component for displaying option lists. Typically used as the internal implementation of higher-level components like Select and AutoComplete, but can also be used independently with Button or Input. Supports flat list, grouped, and tree structures, with built-in scrolling, loading states, keyboard shortcuts, and action buttons.

## Import

```tsx
import {
  Dropdown,
  DropdownAction,
  DropdownItem,
  DropdownItemCard,
  DropdownStatus,
} from '@mezzanine-ui/react';
import type {
  DropdownProps,
  DropdownActionProps,
  DropdownItemProps,
  DropdownItemCardProps,
  DropdownStatusProps,
} from '@mezzanine-ui/react';

// Core type definitions (re-exported via @mezzanine-ui/react)
import type {
  DropdownCheckPosition,
  DropdownInputPosition,
  DropdownItemLevel,
  DropdownItemSharedProps,
  DropdownItemValidate,
  DropdownMode,
  DropdownOption,
  DropdownOptionFlat,
  DropdownOptionGrouped,
  DropdownOptionTree,
  DropdownOptionsByType,
  DropdownStatusType,
  DropdownType,
} from '@mezzanine-ui/react';

// DropdownLoadingPosition must be imported from core
import type { DropdownLoadingPosition } from '@mezzanine-ui/core/dropdown';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/internal-dropdown--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

> **Note**: The `scrollbar*` props in Dropdown are for internal dropdown scrolling configuration, backed internally by the `Scrollbar` component. `Scrollbar` still exists in the source tree in 1.4.1 but is **not exported** from the `@mezzanine-ui/react` package entrypoint — do not import or use it directly; configure scrolling exclusively through the `scrollbar*` props documented here.

---

## Props / Sub-components

### Dropdown

Main container component, responsible for trigger element, popup positioning (Popper), toggle logic, and option rendering. Internally uses `Translate` transition and `Popper` positioning.

Extends `DropdownItemSharedProps`.

| Property                  | Type                                                                       | Default     | Description                                                                     |
| ------------------------- | -------------------------------------------------------------------------- | ----------- | ------------------------------------------------------------------------------- |
| `children`                | `ReactElement<ButtonProps> \| ReactElement<InputProps>`                    | -           | Trigger element (Button or Input)                                               |
| `options`                 | `DropdownOption[]`                                                         | `[]`        | Option list (structure varies by `type`)                                        |
| `type`                    | `DropdownType`                                                             | `'default'` | Dropdown type: `'default'` (flat) / `'grouped'` / `'tree'`                     |
| `mode`                    | `DropdownMode`                                                             | `'single'`  | Selection mode: `'single'` / `'multiple'`                                       |
| `value`                   | `string \| string[]`                                                      | -           | Selected value(s)                                                               |
| `disabled`                | `boolean`                                                                  | `false`     | Whether disabled                                                                |
| `open`                    | `boolean`                                                                  | -           | Controlled open state                                                           |
| `activeIndex`             | `number \| null`                                                          | -           | Currently highlighted option index                                              |
| `keyboardActiveIndex`     | `number \| null`                                                          | -           | Index with keyboard focus ring styling                                          |
| `id`                      | `string`                                                                   | -           | Container DOM id                                                                |
| `inputPosition`           | `DropdownInputPosition`                                                    | `'outside'` | Input position mode: `'outside'` (popup) / `'inside'` (inline)                 |
| `isMatchInputValue`       | `boolean`                                                                  | `false`     | Whether to match input value and highlight option text                          |
| `followText`              | `string`                                                                   | -           | Custom highlight match text (takes priority over auto-extraction from children) |
| `placement`               | `PopperPlacement`                                                          | `'bottom-start'` | Popup placement (aligns with trigger left edge)                                  |
| `customWidth`             | `number \| string`                                                        | -           | Custom dropdown width (takes priority over `sameWidth`)                         |
| `sameWidth`               | `boolean`                                                                  | `false`     | Whether to match trigger element width                                          |
| `flip`                    | `boolean`                                                                  | `false`     | Enable floating-ui `flip` middleware; flips to the opposite side (main-axis only) when the dropdown would overflow the viewport |
| `maxHeight`               | `number \| string`                                                        | -           | Max height of dropdown list (enables scrolling when set)                        |
| `minWidth`                | `number \| string`                                                        | spacing token `size-container-tiny` | Override the default min-width; pass `0` to remove constraint |
| `zIndex`                  | `number \| string`                                                        | `-`         | z-index                                                                         |
| `globalPortal`            | `boolean`                                                                  | `true`      | Whether to use Portal (only effective when `inputPosition='outside'`)           |
| `listboxId`               | `string`                                                                   | -           | Listbox DOM id (for ARIA)                                                       |
| `listboxLabel`            | `string`                                                                   | -           | Listbox aria-label                                                              |
| `onSelect`                | `(option: DropdownOption) => void`                                        | -           | Selection callback                                                              |
| `onOpen`                  | `() => void`                                                               | -           | Open callback                                                                   |
| `onClose`                 | `() => void`                                                               | -           | Close callback                                                                  |
| `onVisibilityChange`      | `(open: boolean) => void`                                                 | -           | Visibility change callback                                                      |
| `onItemHover`             | `(index: number) => void`                                                 | -           | Item hover callback                                                             |
| `status`                  | `DropdownStatusType`                                                       | -           | Dropdown status: `'loading'` / `'empty'`                                        |
| `loadingText`             | `string`                                                                   | -           | Loading text                                                                    |
| `emptyText`               | `string`                                                                   | -           | Empty state text                                                                |
| `emptyIcon`               | `IconDefinition`                                                           | -           | Empty state icon                                                                |
| `loadingPosition`         | `DropdownLoadingPosition`                                                  | `'full'`    | Loading position: `'full'` / `'bottom'` (append loading)                        |
| `showDropdownActions`     | `boolean`                                                                  | `false`     | Whether to show action button bar                                               |
| `toggleCheckedOnClick`    | `boolean`                                                                  | -           | Whether clicking an option row should toggle checked state in multiple mode     |
| `actionCancelText`        | `string`                                                                   | -           | Cancel button text                                                              |
| `actionConfirmText`       | `string`                                                                   | -           | Confirm button text                                                             |
| `actionClearText`         | `string`                                                                   | -           | Clear button text                                                               |
| `actionText`              | `string`                                                                   | -           | Custom button text                                                              |
| `actionCustomButtonProps` | `ButtonProps`                                                              | -           | Custom button props                                                             |
| `showActionShowTopBar`    | `boolean`                                                                  | `false`     | Whether to show separator above action bar                                      |
| `onActionConfirm`         | `() => void`                                                               | -           | Confirm button callback                                                         |
| `onActionCancel`          | `() => void`                                                               | -           | Cancel button callback                                                          |
| `onActionCustom`          | `() => void`                                                               | -           | Custom button callback                                                          |
| `onActionClear`           | `() => void`                                                               | -           | Clear button callback                                                           |
| `onReachBottom`           | `() => void`                                                               | -           | Scroll to bottom callback (requires `maxHeight`)                                |
| `onLeaveBottom`           | `() => void`                                                               | -           | Leave bottom callback                                                           |
| `onScroll`                | `(computed: { scrollTop; maxScrollTop }, target) => void`                  | -           | Scroll event callback                                                           |
| `scrollbarDefer`          | `boolean \| object`                                                       | `true`      | Whether to defer OverlayScrollbars initialization                               |
| `scrollbarDisabled`       | `boolean`                                                                  | `false`     | Disable custom scrollbar, use native scrolling                                  |
| `scrollbarMaxWidth`       | `number \| string`                                                        | -           | Scrollbar container max width                                                   |
| `scrollbarOptions`        | `PartialOptions`                                                           | -           | OverlayScrollbars additional options                                            |

---

### DropdownAction

Action button bar at the bottom of the dropdown, supporting cancel/confirm/clear/custom buttons.

| Property                  | Type          | Default    | Description                        |
| ------------------------- | ------------- | ---------- | ---------------------------------- |
| `showActions`             | `boolean`     | `false`    | Whether to show action bar         |
| `showTopBar`              | `boolean`     | `false`    | Whether to show top separator      |
| `cancelText`              | `string`      | `'Cancel'` | Cancel button text                 |
| `confirmText`             | `string`      | `'Confirm'`| Confirm button text                |
| `clearText`               | `string`      | `'Clear Options'`| Clear button text            |
| `actionText`              | `string`      | `'Custom Action'`| Custom button text           |
| `customActionButtonProps` | `ButtonProps`  | -         | Custom button props                |
| `onCancel`                | `() => void`  | -         | Cancel button callback             |
| `onConfirm`               | `() => void`  | -         | Confirm button callback            |
| `onClear`                 | `() => void`  | -         | Clear button callback (enables clear mode) |
| `onClick`                 | `() => void`  | -         | Custom button callback (enables custom mode) |

> **Action mode logic**:
> - **Default mode**: Provide both `onCancel` and `onConfirm`, shows cancel/confirm buttons.
> - **Clear mode**: Provide only `onClear` (without `onClick`), shows clear button (with CloseIcon).
> - **Custom mode**: Provide only `onClick` (without `onClear`), shows custom button.

---

### DropdownItem

Option list render container, responsible for rendering options by `type` (default / grouped / tree), and managing scrolling, status display, and action bar.

Extends `Omit<DropdownItemSharedProps, 'type'>`.

| Property           | Type                       | Default   | Description                                                         |
| ------------------ | -------------------------- | --------- | ------------------------------------------------------------------- |
| `actionConfig`     | `DropdownActionProps`      | -         | Action button configuration                                         |
| `activeIndex`      | `number \| null`          | -         | Currently highlighted option index                                  |
| `keyboardActiveIndex` | `number \| null`        | -         | Keyboard-only active index (falls back to `activeIndex`)            |
| `disabled`         | `boolean`                  | -         | Whether disabled (from `DropdownItemSharedProps`)                   |
| `expandedNodes`    | `Set<string>`              | -         | Controlled set of expanded node IDs (tree type)                     |
| `onToggleExpand`   | `(id: string) => void`     | -         | Toggle expansion of a tree node (required when `expandedNodes` is set) |
| `followText`       | `string`                   | -         | Highlight match text                                                |
| `headerContent`    | `ReactNode`                | -         | Custom content at the top of the list (e.g., inline mode trigger)   |
| `listboxId`        | `string`                   | -         | Listbox DOM id                                                      |
| `listboxLabel`     | `string`                   | -         | Listbox aria-label                                                  |
| `maxHeight`        | `number \| string`        | -         | List max height                                                     |
| `minWidth`         | `number \| string`        | spacing token `size-container-tiny` | Override the default min-width; pass `0` to remove constraint |
| `mode`             | `DropdownMode`             | -         | Selection mode (from `DropdownItemSharedProps`)                     |
| `sameWidth`        | `boolean`                  | `false`   | Whether to match trigger element width                              |
| `onHover`          | `(index: number) => void` | -         | Option hover callback                                               |
| `onSelect`         | `(option: DropdownOption) => void` | -  | Selection callback (from `DropdownItemSharedProps`)                 |
| `options`          | `DropdownOptionsByType<T>` | -         | Option list (type depends on `type`)                                |
| `toggleCheckedOnClick` | `boolean`               | -         | Whether clicking an option row toggles checked state in multiple mode |
| `type`             | `DropdownType`             | -         | Dropdown type                                                       |
| `value`            | `string \| string[]`       | -         | Selected value(s) (from `DropdownItemSharedProps`)                  |
| `status`           | `DropdownStatusType`       | -         | Status: `'loading'` / `'empty'`                                     |
| `loadingText`      | `string`                   | -         | Loading text                                                        |
| `emptyText`        | `string`                   | -         | Empty state text                                                    |
| `emptyIcon`        | `IconDefinition`           | -         | Empty state icon                                                    |
| `loadingPosition`  | `DropdownLoadingPosition`  | `'full'`  | Loading position: `'full'` / `'bottom'`                             |
| `onReachBottom`    | `() => void`               | -         | Scroll to bottom callback                                           |
| `onLeaveBottom`    | `() => void`               | -         | Leave bottom callback                                               |
| `onScroll`         | `(computed, target) => void` | -       | Scroll event callback                                               |
| `scrollbarDefer`   | `boolean \| object`       | `true`    | Defer scrollbar initialization                                      |
| `scrollbarDisabled`| `boolean`                  | `false`   | Disable custom scrollbar                                            |
| `scrollbarMaxWidth`| `number \| string`        | -         | Scrollbar container max width                                       |
| `scrollbarOptions` | `PartialOptions`           | -         | OverlayScrollbars options                                           |

---

### DropdownItemCard

Single option card render component, responsible for displaying label, icon, checkbox, highlight text, and shortcut key text.

| Property          | Type                      | Default     | Description                                          |
| ----------------- | ------------------------- | ----------- | ---------------------------------------------------- |
| `active`          | `boolean`                 | `false`     | Whether currently highlighted (controls `aria-selected`) |
| `checked`         | `boolean`                 | -           | Controlled checked state                             |
| `defaultChecked`  | `boolean`                 | `false`     | Uncontrolled default checked state                   |
| `indeterminate`   | `boolean`                 | `false`     | Indeterminate state (for tree mode partial selection) |
| `disabled`        | `boolean`                 | -           | Whether disabled                                     |
| `mode`            | `DropdownMode`            | -           | Selection mode (`'single'` / `'multiple'`)           |
| `label`           | `string`                  | -           | Display label                                        |
| `name`            | `string`                  | -           | Accessible name (falls back to `label`)              |
| `subTitle`        | `string`                  | -           | Subtitle                                             |
| `id`              | `string`                  | -           | DOM id (for `aria-activedescendant`)                 |
| `level`           | `DropdownItemLevel`       | `0`         | Level (`0` / `1` / `2`, for tree mode indentation)   |
| `followText`      | `string`                  | -           | Highlight match text                                 |
| `checkSite`       | `DropdownCheckPosition`   | `'none'`    | Checkbox position: `'prefix'` / `'suffix'` / `'none'` |
| `prependIcon`     | `IconDefinition`          | -           | Prepend icon                                         |
| `appendIcon`      | `IconDefinition`          | -           | Append icon                                          |
| `appendContent`   | `string`                  | -           | Append text content (e.g., shortcut key text)        |
| `showUnderline`   | `boolean`                 | `false`     | Whether to show bottom separator                     |
| `toggleCheckedOnClick` | `boolean`             | `true`      | Whether clicking the row toggles checked state in multiple mode |
| `validate`        | `DropdownItemValidate`    | `'default'` | Validation state: `'default'` / `'danger'`           |
| `className`       | `string`                  | -           | Additional className                                 |
| `onClick`         | `() => void`              | -           | Click callback                                       |
| `onCheckedChange` | `(checked: boolean) => void` | -        | Checked state change callback                        |
| `onMouseEnter`    | `() => void`              | -           | Mouse enter callback                                 |

---

### DropdownStatus

Loading and empty state display component.

| Property      | Type                 | Default                  | Description                     |
| ------------- | -------------------- | ------------------------ | ------------------------------- |
| `status`      | `DropdownStatusType` | -                        | Status: `'loading'` / `'empty'` |
| `loadingText` | `string`             | `'Loading...'`           | Loading text                    |
| `emptyText`   | `string`             | `'No matching options.'` | Empty state text                |
| `emptyIcon`   | `IconDefinition`     | `FolderOpenIcon`         | Empty state icon                |

---

## Type Definitions

```ts
// === Core types (from @mezzanine-ui/core/dropdown) ===

// Note: When imported from @mezzanine-ui/react, the name is DropdownStatusType
type DropdownStatusType = 'loading' | 'empty';
type DropdownMode = 'single' | 'multiple';
type DropdownType = 'default' | 'tree' | 'grouped';
type DropdownItemLevel = 0 | 1 | 2;
type DropdownItemValidate = 'default' | 'danger';
type DropdownCheckPosition = 'prefix' | 'suffix' | 'none';
type DropdownInputPosition = 'inside' | 'outside';
type DropdownLoadingPosition = 'full' | 'bottom';

interface DropdownOption {
  name: string;
  id: string;
  showCheckbox?: boolean;
  showUnderline?: boolean;
  icon?: IconDefinition;
  validate?: DropdownItemValidate;
  checkSite?: DropdownCheckPosition;
  children?: DropdownOption[];
  shortcutKeys?: Array<string | number>;
  shortcutText?: string;
}

// Flat option (for type='default')
type DropdownOptionFlat = Omit<DropdownOption, 'children'>;

// Grouped option (for type='grouped', children cannot be nested further)
interface DropdownOptionGrouped extends Omit<DropdownOption, 'children'> {
  children: DropdownOptionFlat[];
}

// Tree option (for type='tree', max 3 levels)
type DropdownOptionTree = DropdownOptionTreeLevel3;

// Auto-infer option type by type
type DropdownOptionsByType<T extends DropdownType | undefined> =
  T extends 'default' ? DropdownOptionFlat[]
  : T extends 'grouped' ? DropdownOptionGrouped[]
  : T extends 'tree' ? DropdownOptionTree[]
  : DropdownOption[];

interface DropdownItemSharedProps {
  disabled?: boolean;
  mode?: DropdownMode;
  onSelect?: (option: DropdownOption) => void;
  type?: DropdownType;
  value?: string | string[];
}
```

---

## Usage Examples

### Basic Usage (with Button)

```tsx
import { Dropdown, Button } from '@mezzanine-ui/react';
import type { DropdownOption } from '@mezzanine-ui/react';

const options: DropdownOption[] = [
  { id: '1', name: 'Option 1' },
  { id: '2', name: 'Option 2' },
  { id: '3', name: 'Option 3' },
];

function BasicDropdown() {
  return (
    <Dropdown
      options={options}
      onSelect={(option) => console.log('Selected:', option)}
    >
      <Button>Open Menu</Button>
    </Dropdown>
  );
}
```

### With Input (text highlighting)

```tsx
import { useState } from 'react';
import { Dropdown, Input } from '@mezzanine-ui/react';

function InputDropdown() {
  const [keyword, setKeyword] = useState('');

  return (
    <Dropdown
      options={options}
      onSelect={(option) => setKeyword(option.name)}
      isMatchInputValue
      sameWidth
    >
      <Input
        placeholder="Search..."
        value={keyword}
        onChange={(e) => setKeyword(e.target.value)}
      />
    </Dropdown>
  );
}
```

### Grouped Options

```tsx
import { Dropdown, Button } from '@mezzanine-ui/react';
import type { DropdownOptionGrouped } from '@mezzanine-ui/react';

const groupedOptions: DropdownOptionGrouped[] = [
  {
    id: 'group-1',
    name: 'Fruits',
    children: [
      { id: 'apple', name: 'Apple' },
      { id: 'banana', name: 'Banana' },
    ],
  },
  {
    id: 'group-2',
    name: 'Vegetables',
    children: [
      { id: 'carrot', name: 'Carrot' },
      { id: 'spinach', name: 'Spinach' },
    ],
  },
];

function GroupedDropdown() {
  return (
    <Dropdown
      type="grouped"
      options={groupedOptions}
      onSelect={(option) => console.log(option)}
    >
      <Button>Grouped Menu</Button>
    </Dropdown>
  );
}
```

### Tree Structure (multiple selection + checkbox)

```tsx
import { useState } from 'react';
import { Dropdown, Button } from '@mezzanine-ui/react';
import type { DropdownOptionTree } from '@mezzanine-ui/react';

const treeOptions: DropdownOptionTree[] = [
  {
    id: 'dept-1',
    name: 'Engineering',
    showCheckbox: true,
    children: [
      { id: 'team-1', name: 'Frontend Team', showCheckbox: true },
      { id: 'team-2', name: 'Backend Team', showCheckbox: true },
    ],
  },
  {
    id: 'dept-2',
    name: 'Design',
    showCheckbox: true,
    children: [
      { id: 'team-3', name: 'UI Team', showCheckbox: true },
      { id: 'team-4', name: 'UX Team', showCheckbox: true },
    ],
  },
];

function TreeDropdown() {
  const [selected, setSelected] = useState<string[]>([]);

  const handleSelect = (option: DropdownOptionTree) => {
    setSelected((prev) =>
      prev.includes(option.id)
        ? prev.filter((id) => id !== option.id)
        : [...prev, option.id],
    );
  };

  return (
    <Dropdown
      type="tree"
      mode="multiple"
      options={treeOptions}
      value={selected}
      onSelect={handleSelect}
      maxHeight={300}
    >
      <Button>Tree Multi-select</Button>
    </Dropdown>
  );
}
```

### With Action Buttons and Loading State

```tsx
import { Dropdown, Button } from '@mezzanine-ui/react';

function DropdownWithActions() {
  return (
    <Dropdown
      options={options}
      onSelect={handleSelect}
      showDropdownActions
      actionConfirmText="Confirm"
      actionCancelText="Cancel"
      onActionConfirm={handleConfirm}
      onActionCancel={handleCancel}
      showActionShowTopBar
      status={isLoading ? 'loading' : undefined}
      loadingText="Loading..."
      loadingPosition="bottom"
      maxHeight={300}
    >
      <Button>Select</Button>
    </Dropdown>
  );
}
```

### Inline Input Mode

```tsx
import { Dropdown, Input } from '@mezzanine-ui/react';

function InlineDropdown() {
  return (
    <Dropdown
      inputPosition="inside"
      options={options}
      onSelect={handleSelect}
    >
      <Input placeholder="Search..." />
    </Dropdown>
  );
}
```

### Infinite Scroll Loading

```tsx
import { useState, useCallback } from 'react';
import { Dropdown, Button } from '@mezzanine-ui/react';

function InfiniteScrollDropdown() {
  const [options, setOptions] = useState(initialOptions);
  const [loading, setLoading] = useState(false);

  const handleReachBottom = useCallback(() => {
    setLoading(true);
    fetchMoreOptions().then((newOptions) => {
      setOptions((prev) => [...prev, ...newOptions]);
      setLoading(false);
    });
  }, []);

  return (
    <Dropdown
      options={options}
      onSelect={handleSelect}
      maxHeight={300}
      onReachBottom={handleReachBottom}
      status={loading ? 'loading' : undefined}
      loadingPosition="bottom"
      loadingText="Loading more..."
    >
      <Button>Infinite Scroll</Button>
    </Dropdown>
  );
}
```

### Viewport-aware Flip

```tsx
import { Dropdown, Button } from '@mezzanine-ui/react';

function FlippingDropdown() {
  return (
    <Dropdown
      options={options}
      onSelect={handleSelect}
      flip
      sameWidth
    >
      <Button>Near viewport edge</Button>
    </Dropdown>
  );
}
```

> `flip` flips the dropdown to the opposite side along the main axis (e.g. `bottom-start` → `top-start`) when it would overflow the viewport. It is main-axis only (no `shift`/`crossAxis`), so a `sameWidth` menu stays horizontally aligned with its anchor. Off by default to preserve existing placement behavior.

---

## Behavior Notes

- **Empty status with `loadingPosition='bottom'`**: When `loadingPosition='bottom'` is set and `status='empty'`, the empty status always renders as full-area regardless of `loadingPosition`, ensuring it is visible.

---

## Best Practices

### 場景推薦

| 使用場景 | 推薦設定 | 說明 |
|---------|--------|------|
| 基本選擇器 | `type="default"`, `mode="single"` | 單選平面列表 |
| 多選篩選 | `type="default"`, `mode="multiple"`, `showDropdownActions` | 多選模式需搭配確認按鈕 |
| 分組列表 | `type="grouped"`, 結構化options | 將相關選項分組展示 |
| 級聯選擇 | `type="tree"`, `mode="single"` | 最多支援3層級結構 |
| 搜尋建議 | `inputPosition="inside"`, `isMatchInputValue=true` | 在輸入框內搜尋和高亮 |
| 分頁載入 | `maxHeight={300}`, `onReachBottom`, `loadingPosition="bottom"` | 捲動到底部載入更多 |

### 常見錯誤

1. **預設位置對齊**
   ```tsx
   // ❌ 錯誤：明確指定舊版置中對齊
   <Dropdown placement="bottom" options={options}>
     <Button>Select</Button>
   </Dropdown>

   // ✅ 正確：預設 'bottom-start' 自動對齊觸發元素左緣，無需明確指定
   <Dropdown options={options}>
     <Button>Select</Button>
   </Dropdown>

   // ✅ 需要垂直置中可明確指定
   <Dropdown placement="bottom" options={options}>
     <Button>Select</Button>
   </Dropdown>
   ```

2. **多選時忘記確認按鈕**
   ```tsx
   // ❌ 錯誤：多選但無法確認選擇
   <Dropdown type="default" mode="multiple" options={options} />

   // ✅ 正確：多選需搭配確認流程
   <Dropdown
     type="default"
     mode="multiple"
     options={options}
     showDropdownActions
     actionConfirmText="Confirm"
     onActionConfirm={handleConfirm}
   />
   ```

3. **觸發元素類型錯誤**
   ```tsx
   // ❌ 錯誤：使用不支援的元素
   <Dropdown options={options}>
     <div>Click me</div>
   </Dropdown>

   // ✅ 正確：使用 Button 或 Input
   <Dropdown options={options}>
     <Button>Click me</Button>
   </Dropdown>
   ```

4. **樹形結構層級過深**
   ```tsx
   // ❌ 錯誤：超過3層會被截斷
   const deepTreeOptions = [
     {
       value: '1',
       content: 'Level 1',
       children: [
         { value: '1-1', content: 'Level 2', children: [
           { value: '1-1-1', content: 'Level 3', children: [
             { value: '1-1-1-1', content: 'Level 4 (被截斷)' }
           ]}
         ]}
       ]
     }
   ];

   // ✅ 正確：保持在3層以內
   const properTreeOptions = [{ value: '1', content: 'Level 1', ... }];
   ```

5. **混淆受控與非受控模式**
   ```tsx
   // ❌ 錯誤：同時設定 open 和 value，但無法協調
   <Dropdown open value="option1" options={options} />

   // ✅ 正確：受控模式需處理兩者的變更
   const [open, setOpen] = useState(false);
   const [value, setValue] = useState('option1');
   <Dropdown
     open={open}
     onVisibilityChange={setOpen}
     value={value}
     onSelect={(option) => setValue(option.value)}
     options={options}
   />
   ```

### 核心原則

1. **觸發元素**: 使用 `Button` 或 `Input` 作為 `children`；其他元素可能導致預期外行為。
2. **寬度控制**: 使用 `sameWidth` 匹配觸發元素寬度，或使用 `customWidth` 固定寬度。
3. **無限捲動**: 結合 `maxHeight`、`onReachBottom` 和 `loadingPosition="bottom"` 實現分頁載入。
4. **樹形結構限制**: 樹形選項支援最多3層級；更深層級在運行時會被截斷並顯示錯誤訊息。
5. **鍵盤快捷鍵**: 透過 `DropdownOption` 的 `shortcutKeys` 設定快捷鍵，支援 `cmd`/`ctrl`/`alt`/`shift` 修飾符組合。
6. **操作欄模式**: `onClear` 和 `onClick` 相互排斥，決定操作欄渲染模式（清空模式 vs 自訂模式 vs 預設模式）。
7. **受控 vs 非受控**: 無 `open` 時為非受控（自動管理開閉）；有 `open` 時為受控。
8. **低階元件**: 一般用途優先使用高階包裝元件如 `Select`。
9. **預設位置**: 預設 `placement` 為 `'bottom-start'`，與觸發元素左對齊。
