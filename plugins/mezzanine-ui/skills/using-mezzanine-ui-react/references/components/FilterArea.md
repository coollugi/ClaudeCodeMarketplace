# FilterArea Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/FilterArea`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/FilterArea) · Verified 1.4.1 (2026-07-01)

A filter area component for building search and filter forms. Contains three sub-components: FilterArea, FilterLine, and Filter. Expand/collapse buttons use `ChevronDownIcon` / `ChevronUpIcon`.

## Import

```tsx
import { FilterArea, FilterLine, Filter } from '@mezzanine-ui/react';
import type { FilterAreaProps, FilterLineProps, FilterProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-filterarea--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## FilterArea Props

`FilterAreaProps` extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'children' | 'onSubmit' | 'onReset'>`.

| Property           | Type                                                     | Default    | Description              |
| ------------------ | -------------------------------------------------------- | ---------- | ------------------------ |
| `actionsAlign`     | `FilterAreaActionsAlign`                                 | `'end'`    | Action button alignment  |
| `children`         | `ReactElement<FilterLineProps> \| ReactElement<FilterLineProps>[]` | **Required** | FilterLine children |
| `isDirty`          | `boolean`                                                | `true`     | Whether form is modified |
| `onReset`          | `() => void`                                             | -          | Reset callback           |
| `onSubmit`         | `() => void`                                             | -          | Submit callback          |
| `resetText`        | `string`                                                 | `'Reset'`  | Reset button text        |
| `rowAlign`         | `'start' \| 'center' \| 'end'`                           | `'center'` | Row vertical alignment (cross-axis align-items) |
| `size`             | `FilterAreaSize`                                         | `'main'`   | Size                     |
| `submitText`       | `string`                                                 | `'Search'` | Submit button text       |
| `resetButtonType`  | `ComponentPropsWithoutRef<'button'>['type']`             | `'button'` | Reset button type        |
| `submitButtonType` | `ComponentPropsWithoutRef<'button'>['type']`             | `'button'` | Submit button type       |

> **Core types**:
> - `FilterAreaActionsAlign = 'start' | 'center' | 'end'`
> - `FilterAreaSize = 'main' | 'sub'`

---

## FilterLine Props

`FilterLineProps` extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'children'>`.

| Property   | Type                                                        | Description       |
| ---------- | ----------------------------------------------------------- | ----------------- |
| `children` | `ReactElement<FilterProps> \| ReactElement<FilterProps>[]`  | Filter children   |

---

## Filter Props

`FilterProps` extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'children'>`.

| Property   | Type                                                              | Default     | Description                     |
| ---------- | ----------------------------------------------------------------- | ----------- | ------------------------------- |
| `align`    | `FilterAlign`                                                     | `'stretch'` | Vertical alignment              |
| `children` | `ReactElement<FormFieldProps> \| ReactElement<FormFieldProps>[]`  | **Required** | FormField children             |
| `grow`     | `boolean`                                                         | `false`     | Whether to auto-expand to fill  |
| `minWidth` | `string \| number`                                                | -           | Minimum width                   |
| `span`     | `FilterSpan`                                                      | `2`         | Grid columns to span            |

> **Core types**:
> - `FilterAlign = 'start' | 'center' | 'end' | 'stretch'`
> - `FilterSpan = 1 | 2 | 3 | 4 | 5 | 6`

---

## 版面 padding 契約 (重要 — size 決定是否貼邊)

`FilterArea` 的 `size` **預設為 `'main'`**，而 `size="main"` 在 core SCSS 帶有自己的 gutter：

```scss
.mzn-filter-area--main {
  padding-inline: var(--mzn-spacing-padding-horizontal-spacious); // 16px / compact 14px
  padding-top: var(--mzn-spacing-padding-vertical-spacious);      // 16px / compact 12px
}
```

與 `PageHeader` 同構（同樣沒有 bottom padding，靠 container `row-gap` 分隔）。因此：

- **`size="main"`（頁面級 filter）** — 必須是 page container 的**直接子代**，與 `PageHeader` 同層貼齊版面。放進套了 `padding-inline` 的 body wrapper 會變成 16 + 16 = 32px 的雙層內縮。
- **`size="sub"`（Section 內的 filter）** — 沒有任何 padding，由 `Section` 的 16px 負責。透過 `Section` 的 `filterArea` prop 傳入時，Section 會**自動**改寫成 `size="sub"`，不需手動指定。
- 手動把 `FilterArea` 放進 `Section` 的 children（而非 `filterArea` prop）時，**要自己指定 `size="sub"`**，否則會多出 16px。

詳見 SKILL.md → **Page Layout Skeleton (必讀 — 版面 padding 契約)**。

## Usage Examples

### Basic Usage

```tsx
import { FilterArea, FilterLine, Filter, FormField, Input, Select } from '@mezzanine-ui/react';

<FilterArea
  onSubmit={handleSearch}
  onReset={handleReset}
  submitText="Search"
  resetText="Reset"
>
  <FilterLine>
    <Filter>
      <FormField label="Name">
        <Input placeholder="Enter name" />
      </FormField>
    </Filter>
    <Filter>
      <FormField label="Status">
        <Select options={statusOptions} placeholder="Select" />
      </FormField>
    </Filter>
  </FilterLine>
</FilterArea>
```

### Multi-line Filter (expandable)

```tsx
<FilterArea
  onSubmit={handleSearch}
  onReset={handleReset}
>
  <FilterLine>
    <Filter>
      <FormField label="Name">
        <Input />
      </FormField>
    </Filter>
    <Filter>
      <FormField label="Status">
        <Select options={statusOptions} />
      </FormField>
    </Filter>
  </FilterLine>
  <FilterLine>
    <Filter>
      <FormField label="Date">
        <DatePicker />
      </FormField>
    </Filter>
    <Filter>
      <FormField label="Type">
        <Select options={typeOptions} />
      </FormField>
    </Filter>
  </FilterLine>
</FilterArea>
```

### Custom Field Width

```tsx
<FilterArea onSubmit={handleSearch}>
  <FilterLine>
    <Filter span={3}>
      <FormField label="Keyword">
        <Input />
      </FormField>
    </Filter>
    <Filter span={2}>
      <FormField label="Status">
        <Select options={statusOptions} />
      </FormField>
    </Filter>
    <Filter grow>
      <FormField label="Notes">
        <Input />
      </FormField>
    </Filter>
  </FilterLine>
</FilterArea>
```

### With react-hook-form

```tsx
import { useForm, FormProvider } from 'react-hook-form';

function FilterExample() {
  const methods = useForm({
    defaultValues: { name: '', status: '' },
  });

  const handleSearch = methods.handleSubmit((data) => {
    console.log(data);
  });

  const handleReset = () => {
    methods.reset();
  };

  return (
    <FormProvider {...methods}>
      <form onSubmit={handleSearch}>
        <FilterArea
          onSubmit={handleSearch}
          onReset={handleReset}
          isDirty={methods.formState.isDirty}
          submitButtonType="submit"
        >
          <FilterLine>
            <Filter>
              <FormField label="Name">
                <Input {...methods.register('name')} />
              </FormField>
            </Filter>
          </FilterLine>
        </FilterArea>
      </form>
    </FormProvider>
  );
}
```

### Control Reset Button State

```tsx
<FilterArea
  onSubmit={handleSearch}
  onReset={handleReset}
  isDirty={formState.isDirty}  // Disable reset button when not modified
>
  <FilterLine>
    <Filter>
      <FormField label="Search">
        <Input />
      </FormField>
    </Filter>
  </FilterLine>
</FilterArea>
```

---

## Expand/Collapse Behavior

- When there are multiple FilterLines, an expand/collapse button is displayed
- Collapsed state shows only the first line
- Expanded state shows all filter lines

---

## Grid System

The Filter component uses a 6-column grid system:
- `span={2}` takes 2/6 width (default)
- `span={6}` takes full row
- `grow` auto-expands to fill remaining space (equivalent to `span={6}`)

---

## Figma Mapping

| Figma Variant                 | React Props                              |
| ----------------------------- | ---------------------------------------- |
| `FilterArea / Collapsed`      | Default state for multi-line             |
| `FilterArea / Expanded`       | Expanded state                           |
| `FilterArea / Single Line`    | Single line filter                       |

---

## Best Practices

### 場景推薦

| 使用場景 | 推薦設定 | 說明 |
|---------|--------|------|
| 簡單搜尋 | 單行 FilterLine, 2-3 個篩選項 | 最常用的搜尋條件 |
| 高級篩選 | 多行 FilterLine，自動展開/摺疊 | 更多篩選條件分行展示 |
| 表格查詢 | 結合 Table，isDirty 控制重設按鈕 | 控制表格資料顯示 |
| 自訂按鈕文案 | submitText="Query", resetText="Clear" | 根據業務場景自訂 |
| 響應式佈局 | 使用 `span` 控制欄寬 | 不同屏幕尺寸適配 |

### 常見錯誤

1. **按鈕文案與場景不符**
   ```tsx
   // ❌ 錯誤：使用通用文案
   <FilterArea
     submitText="Search"
     resetText="Reset"
     onSubmit={handleQuery}
   >
     ...
   </FilterArea>

   // ✅ 正確：根據業務場景選擇文案
   <FilterArea
     submitText="Query Orders"
     resetText="Clear Filters"
     onSubmit={handleQuery}
   >
     ...
   </FilterArea>
   ```

2. **未控制重設按鈕狀態**
   ```tsx
   // ❌ 錯誤：重設按鈕始終啟用
   <FilterArea onReset={handleReset}>
     ...
   </FilterArea>

   // ✅ 正確：使用 isDirty 控制按鈕狀態
   <FilterArea
     isDirty={formState.isDirty}
     onReset={handleReset}
   >
     ...
   </FilterArea>
   ```

3. **篩選項分組不當**
   ```tsx
   // ❌ 錯誤：所有篩選項堆在第一行
   <FilterArea onSubmit={handleSearch}>
     <FilterLine>
       <Filter>Field1</Filter>
       <Filter>Field2</Filter>
       <Filter>Field3</Filter>
       <Filter>Field4</Filter>
       <Filter>Field5</Filter>
     </FilterLine>
   </FilterArea>

   // ✅ 正確：常用篩選項在第一行，高級選項在後續行
   <FilterArea onSubmit={handleSearch}>
     <FilterLine>
       <Filter>Keyword</Filter>
       <Filter>Status</Filter>
       <Filter>Date Range</Filter>
     </FilterLine>
     <FilterLine>
       <Filter>Advanced Option 1</Filter>
       <Filter>Advanced Option 2</Filter>
     </FilterLine>
   </FilterArea>
   ```

4. **欄位寬度設定不當**
   ```tsx
   // ❌ 錯誤：寬度不一致導致視覺混亂
   <FilterArea onSubmit={handleSearch}>
     <FilterLine>
       <Filter span={1}>Keyword</Filter>
       <Filter span={5}>Status</Filter>
       <Filter>Date</Filter>
     </FilterLine>
   </FilterArea>

   // ✅ 正確：合理分配寬度
   <FilterArea onSubmit={handleSearch}>
     <FilterLine>
       <Filter span={3}>Keyword</Filter>
       <Filter span={3}>Status</Filter>
       <Filter span={3}>Date</Filter>
       <Filter grow>Expand</Filter>
     </FilterLine>
   </FilterArea>
   ```

5. **與表單庫集成不當**
   ```tsx
   // ❌ 錯誤：未連接表單狀態
   <FilterArea onSubmit={handleSearch}>
     <FilterLine>
       <Filter>
         <Input />
       </Filter>
     </FilterLine>
   </FilterArea>

   // ✅ 正確：使用 react-hook-form
   const { register, handleSubmit, formState, reset } = useForm();
   <FilterArea
     onSubmit={handleSubmit(handleSearch)}
     onReset={() => reset()}
     isDirty={formState.isDirty}
   >
     <FilterLine>
       <Filter>
         <FormField label="Keyword">
           <Input {...register('keyword')} />
         </FormField>
       </Filter>
     </FilterLine>
   </FilterArea>
   ```

### 核心原則

1. **優先常用篩選項**: 把最常用的篩選條件放在第一行
2. **寬度合理控制**: 使用 `span` 控制欄位寬度以保持視覺平衡
3. **重設按鈕狀態**: 使用 `isDirty` 控制重設按鈕的啟用狀態
4. **搭配表單庫**: 建議使用 react-hook-form 進行表單狀態管理
5. **文案語境化**: 根據業務場景自訂按鈕文案（Search/Filter/Query）
6. **多行展開/摺疊**: 多行篩選會自動添加展開/摺疊按鈕
7. **網格系統**: 使用 6 列網格系統，`span` 預設值為 2
