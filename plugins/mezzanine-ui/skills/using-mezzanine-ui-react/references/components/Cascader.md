# Cascader Component

> **Category**: Data Entry
>
> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/story/data-entry-cascader--playground) — 當行為不確定時，Storybook 的互動範例為權威參考。
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Cascader) · Verified 1.4.1 (2026-07-01)

A hierarchical dropdown selector that lets users drill through multi-level option trees. The selected path (from root to leaf) is represented as an array of `CascaderOption` objects. Selection is only committed when a leaf node is clicked or confirmed via keyboard. Overflow handling uses automatic path truncation and tooltip display.

## Import

```tsx
import { Cascader, CascaderPanel } from '@mezzanine-ui/react';
import type { CascaderOption, CascaderProps, CascaderSize } from '@mezzanine-ui/react';
```

## Basic Usage

```tsx
import { useState } from 'react';
import { Cascader } from '@mezzanine-ui/react';
import type { CascaderOption } from '@mezzanine-ui/react';

const options: CascaderOption[] = [
  {
    id: 'north',
    name: '北部',
    children: [
      { id: 'taipei', name: '台北市' },
      { id: 'newtaipei', name: '新北市' },
      { id: 'keelung', name: '基隆市' },
    ],
  },
  {
    id: 'south',
    name: '南部',
    children: [
      { id: 'tainan', name: '台南市' },
      { id: 'kaohsiung', name: '高雄市' },
    ],
  },
];

function Example() {
  const [value, setValue] = useState<CascaderOption[]>([]);

  return (
    <Cascader
      fullWidth
      options={options}
      placeholder="選擇地區 / 縣市"
      value={value}
      onChange={setValue}
    />
  );
}
```

### Uncontrolled with default value

```tsx
<Cascader
  options={options}
  placeholder="選擇地區"
  defaultValue={[
    { id: 'north', name: '北部' },
    { id: 'taipei', name: '台北市' },
  ]}
/>
```

### Clearable

```tsx
<Cascader
  clearable
  fullWidth
  options={options}
  placeholder="選擇地區"
  value={value}
  onChange={setValue}
/>
```

The clear button appears on hover when `clearable` is true, a value is selected, and the component is neither `disabled` nor `readOnly`.

### Error state

```tsx
<Cascader
  error
  fullWidth
  options={options}
  placeholder="請選擇地區"
  value={value}
  onChange={setValue}
/>
```

### With `menuMaxHeight`

```tsx
<Cascader
  fullWidth
  menuMaxHeight={200}
  options={options}
  placeholder="選擇地區"
  value={value}
  onChange={setValue}
/>
```

Constrains the height of each panel column; columns become scrollable when options overflow.

## Props

### `CascaderProps`

| Name             | Type                              | Default     | Description                                                                 |
| ---------------- | --------------------------------- | ----------- | --------------------------------------------------------------------------- |
| `options`        | `CascaderOption[]`                | —           | Required. The tree of selectable options.                                   |
| `value`          | `CascaderOption[]`                | —           | Controlled value: ordered array from root to leaf.                          |
| `defaultValue`   | `CascaderOption[]`                | `[]`        | Uncontrolled initial value.                                                 |
| `onChange`       | `(value: CascaderOption[]) => void` | —         | Called when a leaf option is confirmed. Receives the full path array.       |
| `placeholder`    | `string`                          | `''`        | Placeholder text shown when no value is selected.                           |
| `size`           | `'main' \| 'sub'`                 | `'main'`    | Trigger input size.                                                         |
| `fullWidth`      | `boolean`                         | `false`     | Makes the trigger stretch to fill its container.                            |
| `clearable`      | `boolean`                         | `false`     | Shows a clear button on hover when a value is selected.                     |
| `disabled`       | `boolean`                         | `false`     | Disables the component. Also inherited from `FormControlContext`.           |
| `readOnly`       | `boolean`                         | `false`     | Prevents opening the dropdown while displaying the current value.           |
| `error`          | `boolean`                         | `false`     | Puts the trigger in an error visual state. Also set by `FormControlContext` severity `'error'`. |
| `required`       | `boolean`                         | `false`     | Marks the field as required. Also inherited from `FormControlContext`.      |
| `menuMaxHeight`  | `number \| string`                | —           | Max height of each panel column. Accepts CSS values or pixel numbers.       |
| `dropdownZIndex` | `number \| string`                | —           | Overrides the z-index of the floating dropdown.                             |
| `globalPortal`   | `boolean`                         | `true`      | Renders the dropdown via a portal (appended to `document.body`).           |
| `onFocus`        | `() => void`                      | —           | Called when the dropdown opens.                                             |
| `onBlur`         | `() => void`                      | —           | Called when the dropdown closes.                                            |
| `className`      | `string`                          | —           | Additional CSS class applied to the host element.                           |

### `CascaderOption`

| Name       | Type                 | Required | Description                                                              |
| ---------- | -------------------- | -------- | ------------------------------------------------------------------------ |
| `id`       | `string`             | Yes      | Unique identifier used for selection matching and ARIA attributes.       |
| `name`     | `string`             | Yes      | Display label for the option.                                            |
| `children` | `CascaderOption[]`   | No       | Child options. If absent or empty the option is treated as a leaf node.  |
| `disabled` | `boolean`            | No       | Prevents the option from being selected or keyboard-focused.             |

## Size Variants

| Size     | Description                                        |
| -------- | -------------------------------------------------- |
| `'main'` | Default size. Matches standard form input height.  |
| `'sub'`  | Compact size. Suitable for dense layouts.          |

```tsx
<Cascader size="main" options={options} placeholder="Main size" />
<Cascader size="sub"  options={options} placeholder="Sub size"  />
```

## Keyboard Interactions

| Key                     | Behaviour                                                                               |
| ----------------------- | --------------------------------------------------------------------------------------- |
| `Space` / `Enter`       | Opens the dropdown when the trigger is focused and the panel is closed.                 |
| `Escape`                | Closes the dropdown without committing any change.                                      |
| `ArrowDown`             | Moves keyboard focus to the next enabled option in the current panel column.            |
| `ArrowUp`               | Moves keyboard focus to the previous enabled option in the current panel column.        |
| `ArrowRight` / `Enter` / `Space` | Selects the focused option. If it has children, expands to the next column. If it is a leaf, commits the selection and closes. |
| `ArrowLeft`             | Collapses back to the parent column, restoring focus to the previously active item.     |

> Disabled options are automatically skipped during `ArrowDown` / `ArrowUp` navigation.

## Overflow Display Behavior

When the selected path is too long to fit in the trigger input width, the Cascader automatically collapses the display:

**Collapsed Display Format**: `first_name / … / last_name`
- Shows only the first and last items in the path
- Intermediate items are replaced with `…` (ellipsis)
- Activates when 3+ path items and container width is constrained (≈160px minimum)

**Hover Tooltip**: When collapsed, hovering over the trigger displays a tooltip showing the full path with all intermediate items.

**Scrollable Panels**: Each `CascaderPanel` column internally wraps its option list with the Mezzanine `Scrollbar` component (internal, deprecated in 1.4.1), which activates custom scrolling styles when `maxHeight` (passed from `menuMaxHeight`) is set and options exceed the available height. This is an internal implementation detail — scrolling behavior is configured exclusively through the props documented above.

### Example with Long Path

```tsx
<Cascader
  options={options}
  placeholder="Select region / city / district"
  value={[
    { id: 'north', name: '北部' },
    { id: 'taipei', name: '台北市' },
    { id: 'zhongshan', name: '中山區' },
  ]}
  // In narrow containers, displays as: "北部 / … / 中山區"
  // Hover shows tooltip: "北部 > 台北市 > 中山區"
/>
```

## Integration with FormField

`Cascader` reads `disabled`, `fullWidth`, `required`, and `severity` from the nearest `FormControlContext`. Wrapping it inside a `FormField` automatically wires these states.

```tsx
import { FormField, FormLabel, FormHintText } from '@mezzanine-ui/react';
import { Cascader } from '@mezzanine-ui/react';

<FormField required>
  <FormLabel>所在地區</FormLabel>
  <Cascader
    fullWidth
    options={options}
    placeholder="選擇地區"
    value={value}
    onChange={setValue}
  />
  <FormHintText>請選擇倉庫所在縣市及區域</FormHintText>
</FormField>
```

## `CascaderPanel` (Advanced)

`CascaderPanel` is the internal panel column component. It is exported for advanced customization scenarios where you need to build a custom cascader layout.

```tsx
import { CascaderPanel } from '@mezzanine-ui/react';
import type { CascaderPanelProps } from '@mezzanine-ui/react';
```

### `CascaderPanelProps`

| Name         | Type                                               | Required | Description                                                             |
| ------------ | -------------------------------------------------- | -------- | ----------------------------------------------------------------------- |
| `options`    | `CascaderOption[]`                                 | Yes      | Options to render in this panel column.                                 |
| `onSelect`   | `(option: CascaderOption, isLeaf: boolean) => void` | Yes     | Called when an option is clicked. `isLeaf` is true when it has no children. |
| `activeId`   | `string`                                           | No       | The id of the currently navigating (expanded) option.                   |
| `selectedId` | `string`                                           | No       | The id of the confirmed selected option at this level.                  |
| `focusedId`  | `string`                                           | No       | The id of the keyboard-focused option in this panel.                    |
| `maxHeight`  | `number \| string`                                 | No       | Max height of the panel. Accepts CSS values or pixel numbers.           |
