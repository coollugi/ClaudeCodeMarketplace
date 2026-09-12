# AutoComplete Component

> **Category**: Data Entry
>
> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-autocomplete--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/AutoComplete) · Verified 1.5.1 (2026-09-12)
>
> ⚠️ **1.4.2 行為變更**：選項比對的預設從**大小寫敏感改為不敏感**。先前的比對 RegExp 漏了 `i` flag，
> 輸入 `vir` 找不到 `Virginia`；1.4.2 修正後預設不分大小寫，並新增 `caseSensitive` prop 供退回舊行為。
> 若你的專案倚賴舊的大小寫敏感行為，升級後需明確傳 `caseSensitive`。
> 同時 `addable` 模式的重複檢查也改為尊重這個 flag（`isSameOptionName()`），
> 避免對清單上已存在、只差大小寫的選項再次提供「建立」動作。

Autocomplete component combining input with dropdown menu. Supports search filtering and dynamic option creation. Internally uses `Dropdown` and `SelectTrigger` composition.

## Import

```tsx
import { AutoComplete } from '@mezzanine-ui/react';
import type {
  AutoCompleteBaseProps,
  AutoCompleteMultipleProps,
  AutoCompleteProps,
  AutoCompleteSingleProps,
} from '@mezzanine-ui/react';
```

---

## Type Definitions

```tsx
// AutoCompleteProps is a discriminated union
type AutoCompleteProps = AutoCompleteSingleProps | AutoCompleteMultipleProps;
```

---

## AutoComplete Props (Common AutoCompleteBaseProps)

| Property                     | Type                                                   | Default                | Description                              |
| ---------------------------- | ------------------------------------------------------ | ---------------------- | ---------------------------------------- |
| `addable`                    | `boolean`                                              | `false`                | Whether options can be dynamically added |
| `asyncData`                  | `boolean`                                              | `false`                | Whether data is async                    |
| `caseSensitive`              | `boolean`                                              | `false`                | **New in 1.4.2.** Whether option matching respects letter casing. When `false` (default), typing `colorado` matches an option named `Colorado`. Applies to both option filtering and the `addable` duplicate check. |
| `clearSearchText`            | `boolean`                                              | `true`                 | Whether to clear search text on blur. When false, typed text persists after blur. In single mode, a clearable icon appears if user typed without selecting. |
| `createSeparators`           | `string[]`                                             | `[',', '+', '\n']`     | Separator characters for creating options |
| `createActionText`           | `(text: string) => string`                             | -                      | Custom create button text function       |
| `createActionTextTemplate`   | `string`                                               | `'建立 "{text}"'`      | Create button text template              |
| `disabledOptionsFilter`      | `boolean`                                              | `false`                | Disable built-in filtering               |
| `dropdownZIndex`             | `number \| string`                                     | -                      | Dropdown z-index                         |
| `emptyText`                  | `string`                                               | `'沒有符合的項目'` (built-in) | Empty result hint text                   |
| `globalPortal`               | `boolean`                                              | `true`                 | Whether to enable Portal                 |
| `id`                         | `string`                                               | -                      | Input element id attribute               |
| `inputPosition`              | `DropdownInputPosition`                                | `'outside'`            | Input position                           |
| `inputProps`                 | `Omit<SelectTriggerInputProps, 'onChange' \| 'placeholder' \| 'role' \| 'value' \| 'aria-controls' \| 'aria-expanded' \| 'aria-owns'>` | - | Props passed to input element |
| `loading`                    | `boolean`                                              | `false`                | Whether loading                          |
| `loadingText`                | `string`                                               | `'載入中...'` (built-in) | Loading hint text                        |
| `loadingPosition`            | `DropdownLoadingPosition`                              | `'bottom'`             | Loading state display position           |
| `menuMaxHeight`              | `number \| string`                                     | -                      | Dropdown max height                      |
| `name`                       | `string`                                               | -                      | Input element name attribute             |
| `onInsert`                   | `(text: string, currentOptions: SelectValue[]) => SelectValue[]` | -            | Insert option callback                   |
| `onLeaveBottom`              | `() => void`                                           | -                      | Dropdown leave bottom callback           |
| `onRemoveCreated`            | `(cleanedOptions: SelectValue[]) => void`              | -                      | Callback on blur with cleaned created items (removes unsaved creations) |
| `onReachBottom`              | `() => void`                                           | -                      | Dropdown reach bottom callback           |
| `onSearch`                   | `(input: string) => void \| Promise<void>`             | -                      | Search callback; selection is committed only on Enter/click or dropdown click, not on typing |
| `onSearchTextChange`         | `(text: string) => void`                               | -                      | Input text change callback (no debounce) |
| `onVisibilityChange`         | `(open: boolean) => void`                              | -                      | Dropdown visibility change callback      |
| `open`                       | `boolean`                                              | -                      | Controlled dropdown open state           |
| `options`                    | `SelectValue[]`                                        | **required**           | Options list                             |
| `placeholder`                | `string`                                               | `''`                   | Placeholder text                         |
| `popperOptions`              | `PopperProps['options']`                               | -                      | Popper options                           |
| `required`                   | `boolean`                                              | `false`                | Whether required                         |
| `searchDebounceTime`         | `number`                                               | `300`                  | Search debounce time (ms)                |
| `searchTextControlRef`       | `RefObject<{ reset: () => void; setSearchText: Dispatch<SetStateAction<string>> } \| undefined>` | - | Ref for external search text control |
| `stepByStepBulkCreate`       | `boolean`                                              | `false`                | Process bulk pasted text item-by-item vs all at once |
| `trimOnCreate`               | `boolean`                                              | `true`                 | Whether to trim whitespace on create     |

> Also inherits `SelectTriggerProps` (excluding `active`, `clearable`, `forceHideSuffixActionIcon`, `fullWidth`, `mode`, `onClick`, `onKeyDown`, `onChange`, `renderValue`, `inputProps`, `suffixActionIcon`, `value`), including `className`, `disabled`, `error`, `inputRef`, `onClear`, `prefix`, `size`, etc. Note: `fullWidth` is excluded — the component always renders full width internally.

---

## Single Mode Props

| Property       | Type                                    | Default    | Description          |
| -------------- | --------------------------------------- | ---------- | -------------------- |
| `mode`         | `'single'`                              | `'single'` | Single select mode   |
| `value`        | `SelectValue \| null`                   | -          | Selected value       |
| `defaultValue` | `SelectValue`                           | -          | Default value        |
| `onChange`      | `(newOptions: SelectValue) => void`     | -          | Change event         |
| `selector`     | `AutoCompleteSelector`                  | `'input'`  | Input selector type  |

---

## Multiple Mode Props

| Property            | Type                                  | Default     | Description          |
| ------------------- | ------------------------------------- | ----------- | -------------------- |
| `mode`              | `'multiple'`                          | -           | Multiple mode (required) |
| `value`             | `SelectValue[]`                       | -           | Selected values array |
| `defaultValue`      | `SelectValue[]`                       | -           | Default values array |
| `onChange`           | `(newOptions: SelectValue[]) => void` | -           | Change callback; committed only on Enter/click or dropdown click, not on typing          |
| `overflowStrategy`  | `'counter' \| 'wrap'`                | `'counter'` | Tag overflow strategy; shows "+N" with 'counter', displays all with 'wrap' |
| `selector`          | `AutoCompleteSelector`                | `'input'`   | Input selector type  |

---

## Usage Examples

### Basic Usage (Single)

```tsx
import { AutoComplete } from '@mezzanine-ui/react';
import { useState } from 'react';

const options = [
  { id: '1', name: 'Option 1' },
  { id: '2', name: 'Option 2' },
  { id: '3', name: 'Option 3' },
];

function BasicAutoComplete() {
  const [value, setValue] = useState<SelectValue | null>(null);

  return (
    <AutoComplete
      options={options}
      value={value}
      onChange={setValue}
      placeholder="Search..."
    />
  );
}
```

### Multiple Mode

```tsx
function MultipleAutoComplete() {
  const [values, setValues] = useState<SelectValue[]>([]);

  return (
    <AutoComplete
      mode="multiple"
      options={options}
      value={values}
      onChange={setValues}
      placeholder="Select..."
    />
  );
}
```

### Async Search

```tsx
function AsyncAutoComplete() {
  const [options, setOptions] = useState<SelectValue[]>([]);
  const [value, setValue] = useState<SelectValue | null>(null);

  const handleSearch = async (input: string) => {
    const result = await api.searchUsers(input);
    setOptions(result.map((user) => ({
      id: user.id,
      name: user.name,
    })));
  };

  return (
    <AutoComplete
      asyncData
      options={options}
      value={value}
      onChange={setValue}
      onSearch={handleSearch}
      placeholder="Search users..."
      loadingText="Searching..."
      emptyText="No results found"
    />
  );
}
```

### Addable Options

```tsx
function AddableAutoComplete() {
  const [options, setOptions] = useState([
    { id: '1', name: 'React' },
    { id: '2', name: 'Vue' },
  ]);
  const [values, setValues] = useState<SelectValue[]>([]);

  const handleInsert = (text: string, currentOptions: SelectValue[]) => {
    const newOption = { id: `new-${Date.now()}`, name: text };
    return [...currentOptions, newOption];
  };

  return (
    <AutoComplete
      mode="multiple"
      addable
      options={options}
      value={values}
      onChange={(newValues) => {
        setValues(newValues);
        const newOptions = newValues.filter(
          (v) => !options.some((o) => o.id === v.id)
        );
        setOptions([...options, ...newOptions]);
      }}
      onInsert={handleInsert}
      placeholder="Enter tags..."
      createActionTextTemplate='Create "{text}"'
    />
  );
}
```

### Custom Search Logic

```tsx
function CustomFilterAutoComplete() {
  const [value, setValue] = useState<SelectValue | null>(null);
  const [filteredOptions, setFilteredOptions] = useState(allOptions);

  const handleSearch = (input: string) => {
    const filtered = allOptions.filter((opt) =>
      opt.name.toLowerCase().includes(input.toLowerCase())
    );
    setFilteredOptions(filtered);
  };

  return (
    <AutoComplete
      disabledOptionsFilter
      options={filteredOptions}
      value={value}
      onChange={setValue}
      onSearch={handleSearch}
      placeholder="Search..."
    />
  );
}
```

### SearchTextControlRef

The `searchTextControlRef` provides imperative control over the search text:
- `setSearchText('')` — clears input text only, leaving selected values and dropdown state unchanged.
- `reset()` — fully resets: clears search text, cancels pending searches, and re-triggers an empty search to restore options.

```tsx
import { AutoComplete, Button } from '@mezzanine-ui/react';
import { Dispatch, SetStateAction, useRef, useState } from 'react';

type SearchTextControlRef = {
  reset: () => void;
  setSearchText: Dispatch<SetStateAction<string>>;
};

function SubmitWithReset() {
  const [value, setValue] = useState<SelectValue[]>([]);
  const [submitted, setSubmitted] = useState<SelectValue[]>([]);
  const controlRef = useRef<SearchTextControlRef | undefined>(undefined);

  const handleSubmit = () => {
    if (!value.length) return;
    setSubmitted((prev) => [...prev, ...value]);
    setValue([]);
    controlRef.current?.reset();
  };

  return (
    <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
      <AutoComplete
        fullWidth
        mode="multiple"
        onChange={setValue}
        options={originOptions}
        placeholder="選取項目後送出"
        searchTextControlRef={controlRef}
        value={value}
      />
      <Button disabled={!value.length} onClick={handleSubmit}>
        送出
      </Button>
    </div>
  );
}
```

### With FormField

```tsx
<FormField
  name="tags"
  label="Tags"
  layout="vertical"
>
  <AutoComplete
    mode="multiple"
    options={tagOptions}
    value={selectedTags}
    onChange={setSelectedTags}
    placeholder="Select or add tags..."
    addable
    onInsert={handleInsert}
  />
</FormField>
```

---

## Related Type Definitions

```tsx
interface SelectValue {
  id: string;
  name: string;
}

// Input selector mode
type AutoCompleteSelector = 'input' | 'selection';
```

---

## Figma Mapping

| Figma Variant                    | React Props                                  |
| -------------------------------- | -------------------------------------------- |
| `AutoComplete / Single`          | `mode="single"`                              |
| `AutoComplete / Multiple`        | `mode="multiple"`                            |
| `AutoComplete / With Tags`       | `mode="multiple"` (selected items as Tags)   |
| `AutoComplete / Addable`         | `addable`                                    |
| `AutoComplete / Loading`         | `loading`                                    |

---

## Best Practices

### 場景推薦

| 使用情境 | 推薦用法 | 原因 |
| ------- | ------- | ---- |
| 單一選項，小選項列表 | `mode="single"` + `options={smallList}` | 簡化 UI，快速選擇 |
| 多重選項，少量標籤 | `mode="multiple" overflowStrategy="wrap"` | 展示所有選項，清晰可見 |
| 多重選項，大量標籤 | `mode="multiple" overflowStrategy="counter"` | 節省空間，顯示 "+N" |
| 動態建立選項 | `addable onInsert={handleInsert}` | 允許使用者新增自訂選項 |
| 大型資料集搜尋 | `asyncData onSearch={handleAsync}` | 非同步載入，避免前端卡頓 |
| 貼上多個項目 | `stepByStepBulkCreate={true}` | 逐一建立項目，便於驗證 |
| 需控制搜尋文字 | `searchTextControlRef={controlRef}` | 程式化重置或清除搜尋 |

### 常見錯誤

#### ❌ 選項提交時機不正確
```tsx
// 錯誤：預期輸入時就提交選項
<AutoComplete
  mode="multiple"
  onChange={(val) => submitToServer(val)}  // 每次輸入都提交
  options={options}
/>
```

#### ✅ 正確做法：等待 Enter/點擊提交
```tsx
<AutoComplete
  mode="multiple"
  onChange={setLocalValue}  // 只更新本地狀態
  options={options}
/>
<Button onClick={() => submitToServer(localValue)}>
  提交
</Button>
```

#### ❌ 忽視動態建立項目的清理
```tsx
// 錯誤：未選中的已建立項目留在清單中
const handleInsert = (text, options) => {
  return [...options, { id: `new-${Date.now()}`, name: text }];
  // 使用者若未選中該項，仍會留在 options
};
```

#### ✅ 正確做法：利用 onRemoveCreated 清理
```tsx
const handleInsert = (text, options) => {
  return [...options, { id: `new-${Date.now()}`, name: text }];
};

const handleRemoveCreated = (cleanedOptions) => {
  // cleanedOptions 已移除未選中的已建立項
  setOptions(cleanedOptions);
};

<AutoComplete
  addable
  onInsert={handleInsert}
  onRemoveCreated={handleRemoveCreated}
  options={options}
/>
```

#### ❌ 溢出策略配置不當
```tsx
// 錯誤：預期顯示所有標籤但使用 counter
<AutoComplete
  mode="multiple"
  overflowStrategy="counter"  // 會顯示 "+N"
  value={manyTags}
/>
```

#### ✅ 正確做法：根據空間選擇策略
```tsx
// 空間有限：使用 counter
<AutoComplete mode="multiple" overflowStrategy="counter" />

// 空間充足：使用 wrap
<AutoComplete mode="multiple" overflowStrategy="wrap" />
```

#### ❌ 非同步搜尋未設定 asyncData
```tsx
const handleSearch = async (input) => {
  const results = await api.search(input);
  setOptions(results);  // 無反應，未設 asyncData
};

<AutoComplete onSearch={handleSearch} options={options} />
```

#### ✅ 正確做法：設定 asyncData 和 loadingText
```tsx
<AutoComplete
  asyncData
  loading={isLoading}
  loadingText="搜尋中…"
  onSearch={async (input) => {
    const results = await api.search(input);
    setOptions(results);
  }}
  options={options}
/>
```

### 核心要點

1. **選項提交時機**：選項僅在按下 Enter 或點擊時提交，不再在搜尋或輸入時自動提交
2. **內建文字預設值**：`emptyText` 和 `loadingText` 已有內建中文預設值（'沒有符合的項目'、'載入中...'），毋需額外設定
3. **loadingPosition 預設值**：預設為 'bottom'
4. **overflowStrategy 預設值**：多重模式預設為 'counter'（顯示 "+N"），若需顯示所有標籤改為 'wrap'
5. **新增 onRemoveCreated**：允許在模糊時自動清理未選中的已建立項目
