# Form Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/Form`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Form) · Verified 1.5.1 (2026-09-12)

Form-related components including field containers, labels, hint text, and more.

## Import

```tsx
import {
  FormField,
  FormLabel,
  FormHintText,
  FormControlContext,
} from '@mezzanine-ui/react';

import type {
  FormFieldProps,
  FormLabelProps,
  FormHintTextProps,
  FormControl,
} from '@mezzanine-ui/react';

// FormElementFocusHandlers must be imported from sub-path
import type { FormElementFocusHandlers } from '@mezzanine-ui/react/Form';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-form--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## FormField Props

An integrated form field component including label, input area, hint text, etc.

| Property                 | Type                       | Default                       | Description                                |
| ------------------------ | -------------------------- | ----------------------------- | ------------------------------------------ |
| `name`                   | `string`                   | **Required**                  | Field name (also used as label's htmlFor)  |
| `label`                  | `string`                   | -                             | Label text                                 |
| `layout`                 | `FormFieldLayout`          | `FormFieldLayout.HORIZONTAL`  | Layout direction                           |
| `density`                | `FormFieldDensity`         | -                             | Density (label/data entry width ratio)     |
| `controlFieldSlotLayout` | `ControlFieldSlotLayout`   | `ControlFieldSlotLayout.MAIN` | Control area layout                        |
| `controlFieldSlotColumns` | `ControlFieldSlotColumns`  | `-`                           | Number of grid columns for control field slot layout. When set, the control area uses CSS grid with the specified column count. |
| `labelSpacing`           | `FormFieldLabelSpacing`    | `FormFieldLabelSpacing.MAIN`  | Label spacing (effective in horizontal/stretch mode) |
| `required`               | `boolean`                  | `false`                       | Whether required                           |
| `disabled`               | `boolean`                  | `false`                       | Whether disabled                           |
| `fullWidth`              | `boolean`                  | `false`                       | Whether full width                         |
| `severity`               | `SeverityWithInfo`         | `'info'`                      | Severity level                             |
| `showHintTextIcon`       | `boolean`                  | `true`                        | Whether to display the hint text icon      |
| `hintText`               | `string`                   | -                             | Hint text                                  |
| `hintTextIcon`           | `IconDefinition`           | -                             | Hint text icon                             |
| `counter`                | `string`                   | -                             | Counter text                               |
| `counterColor`           | `FormFieldCounterColor`    | `FormFieldCounterColor.INFO`  | Counter color                              |
| `labelInformationIcon`   | `IconDefinition`           | -                             | Label information icon (shows tooltip)     |
| `labelInformationText`   | `string`                   | -                             | Label information tooltip text             |
| `labelOptionalMarker`    | `string`                   | -                             | Label optional marker (e.g., "(Optional)") |

---

## FormFieldLayout Enum

| Layout       | Description                | Notes                                  |
| ------------ | -------------------------- | -------------------------------------- |
| `horizontal` | Horizontal (label on left) | Supports density, labelSpacing         |
| `vertical`   | Vertical (label on top)    | density and labelSpacing are ignored   |
| `stretch`    | Stretch layout             | Supports density, labelSpacing         |

## FormFieldDensity Enum

| Density  | Description    |
| -------- | -------------- |
| `base`   | Base density   |
| `tight`  | Tight density  |
| `narrow` | Narrow density |
| `wide`   | Wide density   |

## FormFieldLabelSpacing Enum

| LabelSpacing | Description   |
| ------------ | ------------- |
| `main`       | Main spacing  |
| `sub`        | Sub spacing   |

## FormFieldCounterColor Enum

| CounterColor | Description          |
| ------------ | -------------------- |
| `info`       | Info color (default) |
| `warning`    | Warning color        |
| `error`      | Error color          |

## ControlFieldSlotLayout Enum

| SlotLayout | Description |
| ---------- | ----------- |
| `main`     | Main layout |
| `sub`      | Sub layout  |

> Note: `ControlFieldSlotLayout` only has `main` / `sub` variants. There is no `auto`/`grid` layout value — the grid behavior is enabled separately via the `controlFieldSlotColumns` prop, whose type is `ControlFieldSlotColumns = 2 | 3 | 4`.

---

## Usage Examples

### Basic Usage (Vertical Layout)

```tsx
import { FormField, Input } from '@mezzanine-ui/react';

<FormField
  name="username"
  label="Username"
  layout="vertical"
  required
>
  <Input placeholder="Enter username" />
</FormField>
```

### Horizontal Layout

```tsx
<FormField
  name="email"
  label="Email"
  layout="horizontal"
  required
>
  <Input inputType="email" placeholder="Enter email" />
</FormField>
```

### With Hint Text

```tsx
<FormField
  name="password"
  label="Password"
  layout="vertical"
  required
  hintText="Password must be at least 8 characters"
>
  <Input variant="password" placeholder="Enter password" />
</FormField>
```

### With Error State

```tsx
<FormField
  name="email"
  label="Email"
  layout="vertical"
  required
  severity="error"
  hintText="Invalid email format"
>
  <Input inputType="email" error />
</FormField>
```

### With Character Counter

```tsx
function TextareaWithCounter() {
  const [value, setValue] = useState('');
  const maxLength = 100;

  return (
    <FormField
      name="description"
      label="Description"
      layout="vertical"
      counter={`${value.length}/${maxLength}`}
      counterColor={value.length > maxLength ? 'error' : 'info'}
    >
      <Textarea
        value={value}
        onChange={(e) => setValue(e.target.value)}
        placeholder="Enter description"
      />
    </FormField>
  );
}
```

### With Label Information

```tsx
import { QuestionOutlineIcon } from '@mezzanine-ui/icons';

<FormField
  name="apiKey"
  label="API Key"
  layout="vertical"
  labelInformationIcon={QuestionOutlineIcon}
  labelInformationText="API Key can be obtained from the settings page"
>
  <Input placeholder="Enter API Key" />
</FormField>
```

### Optional Field

```tsx
<FormField
  name="nickname"
  label="Nickname"
  layout="vertical"
  labelOptionalMarker="(Optional)"
>
  <Input placeholder="Enter nickname" />
</FormField>
```

### Hide Hint Text Icon

```tsx
<FormField
  name="note"
  label="Note"
  layout="vertical"
  hintText="This hint has no icon"
  showHintTextIcon={false}
>
  <Input placeholder="Enter note" />
</FormField>

// Standalone FormHintText without icon
<FormHintText
  hintText="Plain hint text"
  severity="info"
  showHintTextIcon={false}
/>
```

### Multi-Column Control Field Layout

```tsx
<FormField
  label="Credit Card"
  name="creditCard"
  layout="vertical"
  controlFieldSlotColumns={2}
>
  <Input placeholder="Card Number" />
  <Input placeholder="Expiry" />
  <Input placeholder="CVV" />
  <Input placeholder="Cardholder Name" />
</FormField>
```

### Complete Form Example

```tsx
function ContactForm() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    message: '',
  });
  const [errors, setErrors] = useState({});

  const handleSubmit = () => {
    // Validation logic
  };

  return (
    <form onSubmit={handleSubmit}>
      <FormField
        name="name"
        label="Name"
        layout="vertical"
        required
        severity={errors.name ? 'error' : 'info'}
        hintText={errors.name}
      >
        <Input
          value={formData.name}
          onChange={(e) =>
            setFormData((prev) => ({ ...prev, name: e.target.value }))
          }
          placeholder="Enter name"
          error={!!errors.name}
        />
      </FormField>

      <FormField
        name="email"
        label="Email"
        layout="vertical"
        required
        severity={errors.email ? 'error' : 'info'}
        hintText={errors.email || 'We will not share your email'}
      >
        <Input
          inputType="email"
          value={formData.email}
          onChange={(e) =>
            setFormData((prev) => ({ ...prev, email: e.target.value }))
          }
          placeholder="Enter email"
          error={!!errors.email}
        />
      </FormField>

      <FormField
        name="message"
        label="Message"
        layout="vertical"
        required
        counter={`${formData.message.length}/500`}
      >
        <Textarea
          value={formData.message}
          onChange={(e) =>
            setFormData((prev) => ({ ...prev, message: e.target.value }))
          }
          placeholder="Enter message"
          rows={4}
        />
      </FormField>

      <Button type="submit" variant="base-primary">
        Submit
      </Button>
    </form>
  );
}
```

---

## FormLabel

A standalone label component (underlying element is `<label>`).

### Props

| Property          | Type             | Description                                    |
| ----------------- | ---------------- | ---------------------------------------------- |
| `htmlFor`         | `string`         | Associated input id                            |
| `labelText`       | `string`         | **Required**, label text                       |
| `informationIcon` | `IconDefinition` | Information icon                               |
| `informationText` | `string`         | Information tooltip text                       |
| `optionalMarker`  | `ReactNode`      | Optional marker                                |

> Note: `required` state is automatically obtained via `FormControlContext`, displaying a required asterisk marker.

```tsx
import { FormLabel } from '@mezzanine-ui/react';

<FormLabel
  htmlFor="username"
  labelText="Username"
/>
```

---

## FormHintText

A standalone hint text component (underlying element is `<span>`).

### Props

| Property       | Type                                              | Default  | Description                               |
| -------------- | ------------------------------------------------- | -------- | ----------------------------------------- |
| `hintText`     | `string`                                          | -        | Hint text                                 |
| `hintTextIcon` | `IconDefinition`                                  | -        | Custom icon (priority over severity default icon) |
| `severity`     | `'success' \| 'warning' \| 'error' \| 'info'`    | `'info'` | Severity level                            |
| `showHintTextIcon` | `boolean`                                     | `true`   | Whether to display the hint text icon     |

```tsx
import { FormHintText } from '@mezzanine-ui/react';

<FormHintText
  hintText="Password must be at least 8 characters"
  severity="info"
/>

<FormHintText
  hintText="Invalid email format"
  severity="error"
/>
```

---

## FormControlContext

Form control context for retrieving form state in custom components.

```tsx
interface FormControl {
  disabled: boolean;
  fullWidth: boolean;
  required: boolean;
  severity?: SeverityWithInfo;
}
```

```tsx
import { FormControlContext } from '@mezzanine-ui/react';
import { useContext } from 'react';

function CustomInput() {
  const formControl = useContext(FormControlContext);

  return (
    <input
      disabled={formControl?.disabled}
      required={formControl?.required}
    />
  );
}
```

---

## FormElementFocusHandlers

Type definition for form element focus events.

```tsx
type FormElementFocusHandlers = {
  onBlur?: VoidFunction;
  onFocus?: VoidFunction;
};
```

---

## Form Hooks

Hooks for controlling form input state. All are re-exported from the `@mezzanine-ui/react` main entry (`export * from './Form/use*'`).

### `useControlValueState<V>(props)`

The underlying controlled/uncontrolled state primitive every other hook in this section builds on.

| Property       | Type                        | Default            | Description |
| -------------- | --------------------------- | ------------------- | ----------- |
| `defaultValue` | `V`                         | **required**        | Uncontrolled initial value |
| `value`        | `V`                         | -                   | Controlled value |
| `equalityFn`   | `(a: V, b: V) => boolean`   | `(a, b) => a === b` | Used to detect external `value` changes and to skip redundant updates |

Returns `[value, setValue, equalityFn] as const`.

### `useInputControlValue<E extends HTMLInputElement | HTMLTextAreaElement>(props)`

| Property       | Type                    | Default | Description |
| -------------- | ------------------------ | ------- | ----------- |
| `value`        | `string`                 | -       | Controlled value |
| `defaultValue` | `string`                 | `''`    | Uncontrolled initial value |
| `onChange`     | `ChangeEventHandler<E>`  | -       | Change callback |

Returns `[value, onChange] as const`.

### `useInputWithClearControlValue<E extends HTMLInputElement | HTMLTextAreaElement>(props)`

Extends `useInputControlValue`'s props, adding:

| Property | Type                   | Default      | Description |
| -------- | ---------------------- | ------------ | ----------- |
| `ref`    | `RefObject<E \| null>` | **required** | Ref to the underlying input/textarea, used to synthesize a change event when clearing |

Returns `[value, onChange, onClear] as const`.

### `useCheckboxControlValue(props)`

| Property        | Type                                                  | Default | Description |
| --------------- | ------------------------------------------------------ | ------- | ----------- |
| `checked`       | `boolean`                                              | -       | Controlled checked state |
| `defaultChecked`| `boolean`                                              | `false` | Uncontrolled initial checked state |
| `onChange`      | `ChangeEventHandler<HTMLInputElement>`                 | -       | Change callback |
| `checkboxGroup` | `{ value?: string[]; onChange?: ChangeEventHandler<HTMLInputElement> }` | -       | When provided (i.e. used inside a `CheckboxGroup`), checked state is derived from whether `checkboxGroup.value` includes this checkbox's own `value`, and `checkboxGroup.onChange` is called alongside `onChange` |
| `value`         | `string`                                               | -       | This checkbox's own value, used to test membership in `checkboxGroup.value` |

Returns `[checked, setChecked] as const` (`setChecked` is a `ChangeEventHandler<HTMLInputElement>`).

### `useRadioControlValue(props)`

Same shape as `useCheckboxControlValue`, but for single-select semantics:

| Property     | Type                                                   | Default | Description |
| ------------ | ------------------------------------------------------- | ------- | ----------- |
| `checked`    | `boolean`                                               | -       | Controlled checked state |
| `defaultChecked` | `boolean`                                            | `false` | Uncontrolled initial checked state |
| `onChange`   | `ChangeEventHandler<HTMLInputElement>`                  | -       | Change callback |
| `radioGroup` | `{ value?: string; onChange?: ChangeEventHandler<HTMLInputElement> }` | -       | When provided (i.e. used inside a `RadioGroup`), checked is `radioGroup.value === value`, and `radioGroup.onChange` is called alongside `onChange` |
| `value`      | `string`                                                | -       | This radio's own value, compared against `radioGroup.value` |

Returns `[checked, setChecked] as const`.

### `useSwitchControlValue(props)`

| Property        | Type                                    | Default | Description |
| --------------- | ----------------------------------------- | ------- | ----------- |
| `checked`       | `boolean`                                 | -       | Controlled checked state |
| `defaultChecked`| `boolean`                                 | `false` | Uncontrolled initial checked state |
| `onChange`      | `ChangeEventHandler<HTMLInputElement>`    | -       | Change callback |

Returns `[checked, onChange] as const`.

### `useCustomControlValue<V>(props)`

Generic, type-parameterized version of `useControlValueState` for controls whose value isn't a native form event (e.g. a custom picker).

| Property       | Type                        | Default            | Description |
| -------------- | ---------------------------- | ------------------- | ----------- |
| `defaultValue` | `V`                          | **required**        | Uncontrolled initial value |
| `value`        | `V`                          | -                   | Controlled value |
| `equalityFn`   | `(a: V, b: V) => boolean`    | `(a, b) => a === b` | Change/skip detection |
| `onChange`     | `(value: V) => void`         | -                   | Change callback |

Returns `[value, onChange, equalityFn] as const`.

### `useSelectValueControl(props)`

Discriminated by `mode`, mirroring `Select`'s own single/multiple split.

| Property       | Type                                                          | Default | Description |
| -------------- | ---------------------------------------------------------------- | ------- | ----------- |
| `mode`         | `'single' \| 'multiple'`                                        | **required** | Selection mode |
| `value`        | `SelectValue \| null` (single) / `SelectValue[]` (multiple)      | -       | Controlled value |
| `defaultValue` | `SelectValue` (single) / `SelectValue[]` (multiple)              | -       | Uncontrolled initial value (multiple defaults internally to `[]`, single to `null`) |
| `onChange`     | `(v: SelectValue \| null) => void` (single) / `(v: SelectValue[]) => void` (multiple) | -       | Change callback |
| `onClear`      | `(e: MouseEvent<Element>) => void`                              | -       | Clear callback |
| `onClose`      | `() => void`                                                    | -       | Called before commit in single mode (closes the dropdown on selection) |

Returns `{ value, onChange, onClear }` — `onChange` and `onClear` here are the resolved handlers that update internal state and invoke the callbacks above; they are not the same function references you passed in.

### `useAutoCompleteValueControl(props)`

The value-control hook backing `AutoComplete`. Discriminated by `mode` like `useSelectValueControl`, plus:

| Property                | Type                                        | Default      | Description |
| ------------------------ | -------------------------------------------- | ------------ | ----------- |
| `mode`                   | `'single' \| 'multiple'`                     | **required** | Selection mode |
| `options`                | `SelectValue[]`                              | **required** | The full options list (used to compute `selectedOptions`/`unselectedOptions`) |
| `disabledOptionsFilter`  | `boolean`                                     | **required** | Whether built-in text filtering is disabled |
| `caseSensitive`          | `boolean`                                     | `false`      | Whether filtering matches respect letter casing |
| `getOptionsFilterQuery`  | `(searchText: string) => string \| undefined` | -            | Override what text is matched against options |
| `value` / `defaultValue` | Same shape as `useSelectValueControl`         | -            | Controlled/uncontrolled value |
| `onChange`               | Same shape as `useSelectValueControl`         | -            | Change callback |
| `onClear`                | `(e: MouseEvent<Element>) => void`            | -            | Clear callback |
| `onClose`                | `() => void`                                  | -            | Close callback |
| `onSearch`                | `(input: string) => any`                     | -            | Search callback |

Returns `{ focused, onClear, onFocus, options, searchText, selectedOptions, setSearchText, unselectedOptions, onChange, value }`.

> **Not exported**: `useInputWithTagsModeValue` (in `Form/useInputWithTagsModeValue.ts`, with an `initialTagsValue` / `maxTagsLength` / `onTagsChange` / `skip` / `tagValueMaxLength` prop shape) exists in the source tree but is **not** re-exported from `@mezzanine-ui/react`'s main entry or the `@mezzanine-ui/react/Form` sub-path, and nothing else in the package imports it — treat it as dead/internal code, not part of the public API. Do not document it as importable.

---

## Figma Mapping

| Figma Variant                  | React Props                               |
| ------------------------------ | ----------------------------------------- |
| `FormField / Vertical`         | `<FormField layout="vertical">`           |
| `FormField / Horizontal`       | `<FormField layout="horizontal">`         |
| `FormField / Required`         | `<FormField required>`                    |
| `FormField / Error`            | `<FormField severity="error">`            |
| `FormField / With Hint`        | `<FormField hintText="...">`              |

---

## FormGroup

A form field group component for grouping multiple `FormField` elements with a group title.

### Import

```tsx
// FormGroup is not exported from main package, must import from sub-path
import { FormGroup } from '@mezzanine-ui/react/Form';
import type { FormGroupProps } from '@mezzanine-ui/react/Form';
```

### Props

| Property                   | Type        | Default    | Description                    |
| -------------------------- | ----------- | ---------- | ------------------------------ |
| `title`                    | `string`    | **Required** | Group title                  |
| `fieldsContainerClassName` | `string`    | -          | Fields container CSS class     |
| `children`                 | `ReactNode` | -          | Form fields within the group   |

### Usage Example

```tsx
import { FormField, Input, Select } from '@mezzanine-ui/react';
import { FormGroup } from '@mezzanine-ui/react/Form';

function UserInfoForm() {
  return (
    <form>
      <FormGroup title="Basic Information">
        <FormField name="name" label="Name" layout="vertical" required>
          <Input placeholder="Enter name" />
        </FormField>
        <FormField name="email" label="Email" layout="vertical" required>
          <Input inputType="email" placeholder="Enter email" />
        </FormField>
      </FormGroup>

      <FormGroup title="Contact Information">
        <FormField name="phone" label="Phone" layout="vertical">
          <Input placeholder="Enter phone" />
        </FormField>
        <FormField name="address" label="Address" layout="vertical">
          <Input placeholder="Enter address" />
        </FormField>
      </FormGroup>
    </form>
  );
}
```

---

## Best Practices

### 場景推薦

| 使用場景 | 建議方案 | 說明 |
| ------- | ------- | ---- |
| 短表單（< 5 欄位） | `layout="vertical"` | 標籤在上方，輸入框下方，垂直堆疊 |
| 設定表單 | `layout="horizontal"` | 標籤在左側，輸入框在右側，節省垂直空間 |
| 長表單（> 10 欄位） | `layout="vertical"` + `FormGroup` | 按邏輯分組，提升可讀性 |
| 密集佈局 | `density="tight"` 或 `"narrow"` | 減少標籤和輸入框的寬度比例 |
| 無標籤欄位 | `layout="stretch"` | 輸入框填滿容器寬度 |

### 常見錯誤

1. **未提供標籤文字**
   - ❌ 錯誤：`<FormField required><Input /></FormField>`（name 存在但無 label）
   - ✅ 正確：`<FormField name="email" label="Email" required><Input /></FormField>`

2. **錯誤提示未配合 severity**
   - ❌ 錯誤：`<FormField severity="error" hintText="Required field"><Input /></FormField>`（無視覺反饋）
   - ✅ 正確：`<FormField severity="error" hintText="Required"><Input error /></FormField>`

3. **必填標示遺漏**
   - ❌ 錯誤：重要欄位未標記 `required`
   - ✅ 正確：`<FormField required label="Email"><Input /></FormField>`

4. **過多欄位未分組**
   - ❌ 錯誤：20 個欄位全部平鋪，無法理解邏輯
   - ✅ 正確：使用 `<FormGroup>` 按類別分組（基本資訊、聯絡方式等）

5. **density 和 labelSpacing 在非適用 layout 使用**
   - ❌ 錯誤：`<FormField layout="vertical" density="tight">`（vertical 會忽略此屬性）
   - ✅ 正確：在 `layout="horizontal"` 或 `"stretch"` 時使用 density

### 實作建議

1. **一致地使用 FormField**：所有表單控制項都應透過 FormField 包裝，確保樣式和行為一致
2. **提供明確標籤**：每個輸入框都應有對應的標籤
3. **即時顯示錯誤**：使用 `severity="error"` 配合 `hintText` 提供即時驗證反饋
4. **標記必填欄位**：使用 `required` prop 自動顯示必填標示符號
5. **選擇合適的 layout**：短表單用垂直佈局，設定表單考慮水平佈局
6. **使用 FormGroup 組織**：大型表單應按邏輯分組相關欄位，提升可用性
