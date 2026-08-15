# Select Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/Select`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Select) · Verified 1.4.1 (2026-07-01)

Dropdown select component supporting single-select and multi-select modes. Internally uses the Dropdown component to render the option list.

> **Aliases** — Select · Combobox · 下拉選單 · 下拉選擇
> **Not for** — 觸發動作的選單（用 [`Dropdown`](Dropdown.md)）；邊打字邊過濾（用 [`AutoComplete`](AutoComplete.md)）；有階層的選項（用 [`Cascader`](Cascader.md)）

## Import

```tsx
import {
  Select,
  SelectControlContext,
  SelectTrigger,
  SelectTriggerTags,
} from '@mezzanine-ui/react';

import type {
  SelectProps,
  SelectTriggerInputProps,
  SelectTriggerProps,
  SelectTriggerTagsProps,
  SelectValue,
  SelectControl,
} from '@mezzanine-ui/react';

// The following types are not exported from the main entry; import from sub-path
import type {
  SelectTriggerBaseProps,
  SelectTriggerSingleProps,
  SelectTriggerMultipleProps,
  SelectTriggerComponentProps,
} from '@mezzanine-ui/react/Select';
```

> **Note**: Select no longer exports the `Option` component. Options are provided via the `options` prop in `DropdownOption[]` format.

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-select--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Select Props

### Common Props (SelectBaseProps)

Extends `SelectTriggerProps`, which includes trigger-related properties.

| Property           | Type                                                                                     | Default     | Description                            |
| ------------------ | ---------------------------------------------------------------------------------------- | ----------- | -------------------------------------- |
| `clearable`        | `boolean`                                                                                | `false`     | Whether clearable                      |
| `disabled`         | `boolean`                                                                                | `false`     | Whether disabled (inheritable from FormControlContext) |
| `dropdownZIndex`   | `number \| string`                                                                       | -           | Dropdown z-index                       |
| `error`            | `boolean`                                                                                | `false`     | Whether in error state (auto when severity='error') |
| `flip`             | `boolean`                                                                                | `false`     | Whether to enable floating-ui `flip` middleware for the dropdown menu; flips from below to above the input (and back) if it would overflow the viewport, keeping width and horizontal alignment. Forwarded to `Dropdown` |
| `fullWidth`        | `boolean`                                                                                | `false`     | Whether full width (inheritable from FormControlContext) |
| `globalPortal`     | `boolean`                                                                                | `true`      | Whether to enable Portal               |
| `inputProps`       | `Omit<SelectTriggerInputProps, 'onBlur' \| 'onChange' \| 'onFocus' \| 'placeholder' \| 'role' \| 'value' \| 'aria-controls' \| 'aria-expanded' \| 'aria-owns'>` | - | Props passed to input |
| `inputRef`         | `Ref<HTMLInputElement>`                                                                  | -           | Input element ref                      |
| `menuMaxHeight`    | `number \| string`                                                                       | -           | Menu max height                        |
| `onBlur`           | `() => void`                                                                             | -           | Blur event                             |
| `onClear`          | `(e: MouseEvent) => void`                                                                | -           | Clear event                            |
| `onFocus`          | `() => void`                                                                             | -           | Focus event                            |
| `onScroll`         | `(computed: { scrollTop: number; maxScrollTop: number }, target: HTMLDivElement) => void` | -           | Menu scroll event                      |
| `options`          | `DropdownOption[]`                                                                       | -           | Option list (supports tree structure)  |
| `placeholder`      | `string`                                                                                 | `''`        | Placeholder text                       |
| `prefix`           | `ReactNode`                                                                              | -           | Prefix content                         |
| `readOnly`         | `boolean`                                                                                | `false`     | Whether read-only                      |
| `renderValue`      | `(values) => string`                                                                     | -           | Custom value rendering                 |
| `required`         | `boolean`                                                                                | `false`     | Whether required (inheritable from FormControlContext) |
| `size`             | `SelectInputSize`                                                                        | -           | Input size                             |
| `suffixActionIcon` | `ReactElement<IconProps, typeof Icon>`                                                   | -           | Suffix action icon                     |
| `loading`          | `boolean`                                                                                | `false`     | Whether in loading state               |
| `loadingPosition`  | `DropdownLoadingPosition`                                                                | `'bottom'`  | Loading indicator position             |
| `loadingText`      | `string`                                                                                 | -           | Text displayed while loading           |
| `onLeaveBottom`    | `() => void`                                                                             | -           | Callback when dropdown list leaves bottom |
| `onReachBottom`    | `() => void`                                                                             | -           | Callback when dropdown list reaches bottom |
| `type`             | `DropdownType`                                                                           | `'default'` | Dropdown type                          |

### Single Select Mode (mode: 'single')

| Property       | Type                                        | Default    | Description        |
| -------------- | ------------------------------------------- | ---------- | ------------------ |
| `mode`         | `'single'`                                  | `'single'` | Single select mode |
| `defaultValue` | `SelectValue`                               | -          | Default value      |
| `value`        | `SelectValue \| null`                       | -          | Controlled value   |
| `onChange`     | `(newOption: SelectValue \| null) => void`  | -          | Change event       |
| `renderValue`  | `(value: SelectValue \| null) => string`    | -          | Custom display     |

### Multi Select Mode (mode: 'multiple')

| Property       | Type                                   | Default | Description              |
| -------------- | -------------------------------------- | ------- | ------------------------ |
| `mode`         | `'multiple'`                           | -       | Multi select (required)  |
| `defaultValue` | `SelectValue[]`                        | -       | Default value            |
| `value`        | `SelectValue[]`                        | -       | Controlled value         |
| `onChange`     | `(newOptions: SelectValue[]) => void`  | -       | Change event             |
| `renderValue`  | `(values: SelectValue[]) => string`    | -       | Custom display           |
| `overflowStrategy` | `'counter' \| 'wrap'`              | `'counter'` | Tag overflow strategy: `counter` collapses extra tags into a counter tag; `wrap` wraps to new lines to show all tags. Forwarded to the multi-select trigger's tag display |

---

## SelectValue and SelectControl Types

```tsx
interface SelectValue<T = string> {
  id: T;
  name: string;
}

interface SelectControl<T = string> {
  value: SelectValue<T>[] | SelectValue<T> | null;
  onChange: (
    v: SelectValue<T> | null,
  ) => SelectValue<T>[] | SelectValue<T> | null;
}
```

---

## DropdownOption Type

```tsx
interface DropdownOption {
  id: string;
  name: string;
  showCheckbox?: boolean;
  showUnderline?: boolean;
  icon?: IconDefinition;
  validate?: DropdownItemValidate;
  checkSite?: DropdownCheckPosition;
  children?: DropdownOption[];  // For tree structure
  shortcutKeys?: Array<string | number>;
  shortcutText?: string;
}
```

---

## Usage Examples

### Basic Single Select

```tsx
import { Select } from '@mezzanine-ui/react';

function BasicSelect() {
  const [value, setValue] = useState<SelectValue | null>(null);

  const options = [
    { id: '1', name: 'Option 1' },
    { id: '2', name: 'Option 2' },
    { id: '3', name: 'Option 3' },
  ];

  return (
    <Select
      options={options}
      placeholder="Please select"
      value={value}
      onChange={setValue}
    />
  );
}
```

### Multi Select Mode

```tsx
function MultiSelect() {
  const [values, setValues] = useState<SelectValue[]>([]);

  const options = [
    { id: 'a', name: 'Apple' },
    { id: 'b', name: 'Banana' },
    { id: 'c', name: 'Cherry' },
  ];

  return (
    <Select
      mode="multiple"
      options={options}
      placeholder="Select multiple"
      value={values}
      onChange={setValues}
      clearable
    />
  );
}
```

### Clearable

```tsx
<Select
  options={options}
  placeholder="Clearable select"
  value={value}
  onChange={setValue}
  clearable
/>
```

### Custom Display Value

```tsx
<Select
  options={options}
  value={value}
  onChange={setValue}
  renderValue={(val) => val ? `Selected: ${val.name}` : 'Please select'}
/>
```

### With Prefix Icon

```tsx
import { UserIcon } from '@mezzanine-ui/icons';
import { Icon } from '@mezzanine-ui/react';

<Select
  options={options}
  prefix={<Icon icon={UserIcon} />}
  placeholder="Select user"
  value={value}
  onChange={setValue}
/>
```

### Error State

```tsx
<Select
  options={options}
  error
  placeholder="Required field"
  value={value}
  onChange={setValue}
/>
```

### Infinite Scroll Loading

```tsx
<Select
  options={options}
  placeholder="Scroll to load more"
  value={value}
  onChange={setValue}
  onScroll={({ scrollTop, maxScrollTop }) => {
    if (scrollTop >= maxScrollTop - 10) {
      loadMoreOptions();
    }
  }}
/>
```

### Tree Structure Options (multi-select mode)

```tsx
const treeOptions = [
  {
    id: 'fruit',
    name: 'Fruit',
    children: [
      { id: 'apple', name: 'Apple' },
      { id: 'banana', name: 'Banana' },
    ],
  },
  {
    id: 'vegetable',
    name: 'Vegetable',
    children: [
      { id: 'carrot', name: 'Carrot' },
    ],
  },
];

<Select
  mode="multiple"
  options={treeOptions}
  value={values}
  onChange={setValues}
/>
```

---

## Other Exports

| Export Name              | Description                            |
| ----------------------- | -------------------------------------- |
| `SelectControlContext`  | Select control context (`SelectControl \| undefined`) |
| `SelectTrigger`         | Select trigger component (internal)    |
| `SelectTriggerTags`     | Multi-select tag display (internal)    |

### SelectTriggerBaseProps — Notable Props

| Property            | Type      | Default | Description                                                     |
| ------------------- | --------- | ------- | --------------------------------------------------------------- |
| `isForceClearable`  | `boolean` | `false` | Force show clearable icon regardless of value state             |

> `SelectTriggerBaseProps` extends `TextFieldProps` (with omissions) and contains shared trigger configuration. The `isForceClearable` prop bypasses the default clearable logic (which requires `mode='multiple'` with selected values) and always shows the clear button. Useful for multi-select scenarios where the clear button should remain visible.

---

### SelectTriggerTagsProps

| Property                    | Type                                          | Description              |
| --------------------------- | --------------------------------------------- | ------------------------ |
| `disabled`                  | `boolean`                                     | Whether disabled         |
| `inputProps`                | `Omit<NativeElementPropsWithoutKeyAndRef<'input'>, ...>` | Input props (excluding autoComplete, children, defaultValue, etc.) |
| `inputRef`                  | `Ref<HTMLInputElement>`                       | Input ref                |
| `onTagClose`                | `(target: SelectValue) => void`               | Tag close callback       |
| `overflowStrategy`         | `'counter' \| 'wrap'`                         | **Required**, overflow strategy |
| `readOnly`                  | `boolean`                                     | Whether read-only        |
| `required`                  | `boolean`                                     | Whether required         |
| `searchText`                | `string`                                      | Search text              |
| `showTextInputAfterTags`    | `boolean`                                     | Show input after tags    |
| `size`                      | `TagSize`                                     | Tag size                 |
| `value`                     | `SelectValue[]`                               | Selected values array    |

---

## Figma Mapping

| Figma Variant               | React Props                          |
| --------------------------- | ------------------------------------ |
| `Select / Single`           | `<Select mode="single">`            |
| `Select / Multiple`         | `<Select mode="multiple">`          |
| `Select / Disabled`         | `<Select disabled>`                 |
| `Select / Error`            | `<Select error>`                    |
| `Select / Clearable`        | `<Select clearable>`               |
| `Select / With Prefix`      | `<Select prefix={...}>`            |

---

## Scenario-Oriented Best Practices

### 場景推薦

| 使用場景 | 建議做法 | 原因 |
| -------- | -------- | ---- |
| 簡單單一選擇 | 使用 `mode="single"` 搭配 `clearable={true}` | 用戶可選擇或清除，提高靈活性 |
| 多項選擇（如標籤或權限） | 使用 `mode="multiple"` 搭配 Tag 顯示 | SelectTriggerTags 自動處理多選顯示，支援 wrap 和 counter 溢出策略 |
| 大型選項列表（1000+ 項） | 使用 `onScroll` 實現無限滾動 | 虛擬化加載防止初始化阻塞，提升性能 |
| 需要搜尋功能 | 在 `options` 前加入搜尋邏輯，篩選提供的選項 | Select 本身不提供搜尋，由外層元件控制 options 內容 |
| 多層級分類選項 | 使用樹狀 `options` 結構搭配 `children` | DropdownOption 支援 `children` 構建層級結構 |
| 多選且需要始終保持清除按鈕 | 使用 SelectTrigger 搭配 `isForceClearable={true}` | 強制顯示清除按鈕，即使無選中值 |

### 常見錯誤

- **期望 Select 內建搜尋功能**：Select 無內建搜尋，應透過篩選 options 實現
- **在 single 模式使用 SelectTriggerTags**：SelectTriggerTags 專為 multiple 模式設計，single 模式應使用 SelectTrigger
- **樹狀選項使用 single 模式**：樹狀結構邏輯上適合 multiple 模式，single 模式下層級展開行為不清晰
- **未設置 `menuMaxHeight` 導致選項列表過長**：應設置合理高度避免頁面溢出
- **多選模式下誤用 `onChange` 回傳單一值**：Multiple 模式回傳 SelectValue[]，應對應處理陣列類型

## Best Practices

1. **Use options prop**: Provide options via `DropdownOption[]`
2. **Meaningful placeholder**: Clearly describe the expected selection
3. **Use clearable appropriately**: Allow users to deselect
4. **Consider Tag display for multi-select**: Multi-select displays selected items as Tags
5. **Pair with FormField**: Provide labels and error messages
6. **Use onScroll for large option sets**: Implement infinite scroll loading
