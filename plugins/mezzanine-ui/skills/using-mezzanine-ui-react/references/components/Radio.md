# Radio Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/Radio`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Radio) · Verified 1.5.1 (2026-09-12)

Radio button component supporting normal mode and segment mode.

> **別名（重要）** — `type="segment"` 的 `RadioGroup` 就是一般所稱的
> **Segmented Control / 分段控制項 / 分段切換 / Toggle Button Group / Segmented (Ant Design) / ToggleButtonGroup (MUI)**
> （Figma 元件名為 `Segmented Control` / `Segmented Control Set`）。
> 互斥的**檢視切換、排序切換、篩選切換**一律用它，
> **不要用多顆 `Button` 的 variant 差異模擬選中狀態**。

> **Aliases** — Radio · Radio Button · 單選 · Segmented Control · 分段控制項 · 分段切換 · 檢視切換 · 排序切換 · Toggle Button Group · Segmented (AntD) · Figma `Segmented Control`
> **Not for** — 多選（用 [`Checkbox`](Checkbox.md) / `CheckboxGroup`）；卡片式選取（用 [`SelectionCard`](SelectionCard.md)）

> **這個元件歸類在 Data Entry，但 `segment` 模式不限於表單。** 排序切換、檢視切換這類非表單的互斥切換也用它 —— 見下方 [Segment Mode](#segment-mode) 的排序切換範例。

## Import

```tsx
import { Radio, RadioGroup } from '@mezzanine-ui/react';
import type {
  RadioSize,
  RadioGroupOrientation,
  RadioProps,
  RadioGroupProps,
} from '@mezzanine-ui/react';

// The following types must be imported from sub-path
import type {
  RadioNormalProps,
  RadioSegmentProps,
  RadioGroupNormalOption,
  RadioGroupSegmentOption,
} from '@mezzanine-ui/react/Radio';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-radio--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Radio Props

### Common Props (RadioBaseProps)

Extends `InputCheckProps` (excluding `control`, `htmlFor`).

| Property         | Type                                                             | Default   | Description              |
| ---------------- | ---------------------------------------------------------------- | --------- | ------------------------ |
| `checked`        | `boolean`                                                        | -         | Controlled checked state |
| `defaultChecked` | `boolean`                                                        | `false`   | Default checked state    |
| `disabled`       | `boolean`                                                        | `false`   | Whether disabled         |
| `error`          | `boolean`                                                        | `false`   | Whether in error state   |
| `inputProps`     | `Omit<NativeElementPropsWithoutKeyAndRef<'input'>, ...excluded>` | -         | Props passed to input. `inputProps.name` defaults to the parent `RadioGroup`'s `name` when not explicitly provided. |
| `onChange`       | `ChangeEventHandler<HTMLInputElement>`                           | -         | Change event             |
| `size`           | `RadioSize` (`'main' \| 'sub'`)                                  | `'main'`  | Size                     |
| `value`          | `string`                                                         | -         | Value                    |

### RadioNormalProps (type: 'radio')

| Property          | Type                                                    | Default   | Description                                   |
| ----------------- | ------------------------------------------------------- | --------- | --------------------------------------------- |
| `type`            | `'radio'`                                               | `'radio'` | Normal mode                                   |
| `hint`            | `string`                                                | -         | Hint text                                     |
| `withInputConfig` | `Pick<BaseInputProps, ...> & { width?: number }`        | -         | Attached input config (default width 120px)    |
| `icon`            | `never`                                                 | -         | Icon not allowed                              |

### RadioSegmentProps (type: 'segment')

| Property          | Type             | Description                  |
| ----------------- | ---------------- | ---------------------------- |
| `type`            | `'segment'`      | Segment mode (required)      |
| `icon`            | `IconDefinition` | Prefix icon                  |
| `hint`            | `never`          | Hint not allowed             |
| `withInputConfig` | `never`          | Attached input not allowed   |

### RadioProps

```tsx
type RadioProps = RadioNormalProps | RadioSegmentProps;
```

---

## RadioGroup Props

RadioGroup supports two input methods: `options` array or `children` (Radio child elements), choose one. When `children` is provided, `options` is ignored.

### Common Props (RadioGroupBaseProps)

Extends `InputCheckGroupProps` (excluding `onChange`, `type`).

| Property       | Type                                                     | Default        | Description                                |
| -------------- | -------------------------------------------------------- | -------------- | ------------------------------------------ |
| `children`     | `ReactNode`                                              | -              | Radio child elements (mutually exclusive with `options`) |
| `defaultValue` | `string`                                                 | -              | Default selected value                     |
| `disabled`     | `boolean`                                                | -              | Whether disabled                           |
| `name`         | `string`                                                 | -              | Group name                                 |
| `onChange`     | `ChangeEventHandler<HTMLInputElement>`                   | -              | Change event                               |
| `orientation`  | `RadioGroupOrientation` (`'horizontal' \| 'vertical'`)   | `'horizontal'` | Layout direction                           |
| `size`         | `RadioSize` (`'main' \| 'sub'`)                           | `'main'`       | Size                                       |
| `value`        | `string`                                                 | -              | Controlled selected value                  |

### RadioGroupNormalProps (type: 'radio')

| Property  | Type                       | Default   | Description    |
| --------- | -------------------------- | --------- | -------------- |
| `type`    | `'radio'`                  | `'radio'` | Normal mode    |
| `options` | `RadioGroupNormalOption[]`  | `[]`      | Options array  |

### RadioGroupSegmentProps (type: 'segment')

| Property  | Type                        | Description              |
| --------- | --------------------------- | ------------------------ |
| `type`    | `'segment'`                 | Segment mode (required)  |
| `options` | `RadioGroupSegmentOption[]` | Options array            |

### RadioGroupProps

```tsx
type RadioGroupProps = RadioGroupNormalProps | RadioGroupSegmentProps;
```

### RadioGroupNormalOption

> **Note**: The `icon` picked from `RadioNormalProps` is of type `never` (normal mode does not support icon).

```tsx
interface RadioGroupNormalOption
  extends Pick<RadioNormalProps, 'disabled' | 'error' | 'icon' | 'hint' | 'withInputConfig'> {
  id: string;
  name: string | number;
}
```

### RadioGroupSegmentOption

> **Note**: The `hint` and `withInputConfig` picked from `RadioSegmentProps` are of type `never` (segment mode does not support hint and withInputConfig).

```tsx
interface RadioGroupSegmentOption
  extends Pick<RadioSegmentProps, 'disabled' | 'error' | 'icon' | 'hint' | 'withInputConfig'> {
  id: string;
  name: string | number;
}
```

---

## Usage Examples

### Basic Usage (using children)

```tsx
import { Radio, RadioGroup } from '@mezzanine-ui/react';

function BasicRadio() {
  const [value, setValue] = useState('');

  return (
    <RadioGroup
      value={value}
      onChange={(e) => setValue(e.target.value)}
    >
      <Radio value="a">Option A</Radio>
      <Radio value="b">Option B</Radio>
      <Radio value="c">Option C</Radio>
    </RadioGroup>
  );
}
```

### Using options

```tsx
function OptionsRadio() {
  const [value, setValue] = useState('');

  return (
    <RadioGroup
      value={value}
      onChange={(e) => setValue(e.target.value)}
      options={[
        { id: 'a', name: 'Option A' },
        { id: 'b', name: 'Option B' },
        { id: 'c', name: 'Option C' },
      ]}
    />
  );
}
```

### Vertical Layout

```tsx
<RadioGroup
  orientation="vertical"
  value={value}
  onChange={(e) => setValue(e.target.value)}
>
  <Radio value="option1">First Option</Radio>
  <Radio value="option2">Second Option</Radio>
  <Radio value="option3">Third Option</Radio>
</RadioGroup>
```

### With Hint Text

```tsx
<RadioGroup value={value} onChange={(e) => setValue(e.target.value)}>
  <Radio value="free" hint="Free plan with limited features">
    Free
  </Radio>
  <Radio value="pro" hint="$99/month with full features">
    Pro
  </Radio>
</RadioGroup>
```

### With Input Field

```tsx
<RadioGroup value={value} onChange={(e) => setValue(e.target.value)}>
  <Radio value="fixed">Fixed Amount</Radio>
  <Radio
    value="custom"
    withInputConfig={{
      placeholder: 'Enter amount',
      value: customAmount,
      onChange: (e) => setCustomAmount(e.target.value),
      width: 150,
    }}
  >
    Custom Amount
  </Radio>
</RadioGroup>
```

### Segment Mode

```tsx
import { HomeIcon, UserIcon, SettingIcon } from '@mezzanine-ui/icons';

<RadioGroup
  type="segment"
  value={value}
  onChange={(e) => setValue(e.target.value)}
>
  <Radio type="segment" value="home" icon={HomeIcon}>
    Home
  </Radio>
  <Radio type="segment" value="profile" icon={UserIcon}>
    Profile
  </Radio>
  <Radio type="segment" value="settings" icon={SettingIcon}>
    Settings
  </Radio>
</RadioGroup>
```

### Segment Icon Only

```tsx
<RadioGroup
  type="segment"
  value={value}
  onChange={(e) => setValue(e.target.value)}
>
  <Radio type="segment" value="grid" icon={GridIcon} />
  <Radio type="segment" value="list" icon={ListIcon} />
</RadioGroup>
```

### Segment Mode — 非表單情境（排序切換 / 檢視切換）

`segment` 模式最常見的用途其實**不是表單欄位**，而是列表上方的排序、檢視、篩選切換。這種情境不需要 `Form` / `FormField`，直接用受控的 `RadioGroup` 即可。

```tsx
const SORTS = [
  { key: 'sla', label: '時效由近到遠' },
  { key: 'amount', label: '金額由大到小' },
] as const;

function OrderListToolbar(): JSX.Element {
  const [sort, setSort] = useState<string>('sla');

  return (
    <RadioGroup
      type="segment"
      size="sub"
      value={sort}
      onChange={(e) => setSort(e.target.value)}
    >
      {SORTS.map((option) => (
        <Radio key={option.key} type="segment" value={option.key}>
          {option.label}
        </Radio>
      ))}
    </RadioGroup>
  );
}
```

```tsx
// ❌ 反例：用兩顆 Button 的 variant 差異模擬選中狀態
// 語意不對（不是 radiogroup，鍵盤操作與 a11y 都不同）、視覺也不是設計稿上的 Segmented Control
{SORTS.map((option) => (
  <Button
    key={option.key}
    variant={sort === option.key ? 'base-secondary' : 'base-tertiary'}
    onClick={() => setSort(option.key)}
  >
    {option.label}
  </Button>
))}
```

### Error State

```tsx
<RadioGroup value={value} onChange={(e) => setValue(e.target.value)}>
  <Radio value="a" error>
    Option A
  </Radio>
  <Radio value="b">Option B</Radio>
</RadioGroup>
```

### Integration with react-hook-form

```tsx
import { useForm, Controller } from 'react-hook-form';

function FormExample() {
  const { control, handleSubmit } = useForm();

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <Controller
        name="plan"
        control={control}
        rules={{ required: 'Please select a plan' }}
        render={({ field }) => (
          <RadioGroup
            value={field.value}
            onChange={(e) => field.onChange(e.target.value)}
          >
            <Radio value="free">Free</Radio>
            <Radio value="pro">Pro</Radio>
          </RadioGroup>
        )}
      />
    </form>
  );
}
```

---

## Figma Mapping

| Figma Variant               | React Props                          |
| --------------------------- | ------------------------------------ |
| `Radio / Main`              | `<Radio size="main">`                |
| `Radio / Sub`               | `<Radio size="sub">`                 |
| `Radio / Segment`           | `<Radio type="segment">`             |
| `Radio / Checked`           | `<Radio checked>`                    |
| `Radio / Disabled`          | `<Radio disabled>`                   |
| `Radio / Error`             | `<Radio error>`                      |
| `Radio / With Hint`         | `<Radio hint="...">`                 |
| `Radio / With Input`        | `<Radio withInputConfig={...}>`      |

---

## Scenario-Oriented Best Practices

### 場景推薦

| 使用場景 | 建議做法 | 原因 |
| -------- | -------- | ---- |
| 單個獨立單選項 | 直接使用 `<Radio />` 搭配 `checked` 和 `onChange` | 簡單場景不需要 RadioGroup 的複雜度 |
| 多個相關選項的單選 | 使用 `<RadioGroup>` 包裝多個 `<Radio />` | RadioGroup 負責管理單選邏輯，自動排斥其他選項 |
| 視圖切換或顯示模式選擇 | 使用 `type="segment"` 配合 icon | Segment 模式視覺上明確區分不同狀態，適合模式切換 |
| 排序切換 / 篩選切換（非表單） | 使用 `type="segment"` 的受控 `RadioGroup` | 這就是設計稿上的 Segmented Control，不需要 Form 也能用 |
| 選項需要額外說明 | 使用 `hint` prop | 為複雜或不明確的選項提供補充說明，減少用戶困惑 |
| 用戶需要在選項旁輸入值 | 使用 `withInputConfig` | 例如「自訂金額」場景，讓用戶既選擇又輸入 |

### 常見錯誤

- **在 RadioGroup 外使用多個 Radio 但預期單選行為**：單選需要 RadioGroup 管理，否則不同 Radio 互不影響
- **忘記為 RadioGroup 設置 name**：建議設置 `name` 屬性便於表單提交和 accessibility
- **Segment 模式搭配 hint**：Segment 模式不支援 hint，會被忽略。應改用 normal 模式或在其他位置提供說明
- **在 Segment 模式使用 withInputConfig**：Segment 模式不支援附加輸入框，應改用 normal 模式
- **icon 搭配 normal 模式**：Normal 模式的 icon 類型為 `never`，Segment 模式才支援 icon
- **用多顆 `Button` 模擬分段控制項**：設計稿上的 Segmented Control 一律是 `RadioGroup type="segment"`。用 `Button` 的 variant 差異模擬選中狀態，語意（不是 radiogroup）、鍵盤操作與視覺都不對

## Best Practices

1. **Use RadioGroup for grouping**: Ensures correct single-selection behavior
2. **Provide value**: Each Radio must have a unique `value`
3. **Segment for view switching**: Suitable for view switching or mode selection. **`type="segment"` 就是 Segmented Control** —— 排序 / 檢視 / 篩選切換都用它，不要用多顆 `Button` 模擬
4. **Pair with FormField**: Use FormField when labels and validation are needed
5. **Use hint appropriately**: Provide additional explanation for complex options
