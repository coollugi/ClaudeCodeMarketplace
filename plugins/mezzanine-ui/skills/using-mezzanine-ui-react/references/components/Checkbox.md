# Checkbox Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/Checkbox`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Checkbox) · Verified 1.4.1 (2026-07-01)

A checkbox component supporting standalone or group usage, with multiple modes.

## Import

```tsx
import { Checkbox, CheckboxGroup, CheckAll } from '@mezzanine-ui/react';
import type {
  CheckAllProps,
  CheckboxGroupChangeEvent,
  CheckboxGroupChangeEventTarget,
  CheckboxGroupLayout,
  CheckboxGroupOption,
  CheckboxGroupProps,
  CheckboxProps,
} from '@mezzanine-ui/react';

// The following types must be imported from sub-path
import type {
  CheckboxComponent,
  CheckboxGroupLevelConfig,
  CheckboxPropsBase,
  GenericCheckbox,
} from '@mezzanine-ui/react/Checkbox';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-checkbox--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Checkbox Props

| Property         | Type                                                                                                                                                                                        | Default     | Description                                                           |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- | --------------------------------------------------------------------- |
| `checked`        | `boolean`                                                                                                                                                                                   | -           | Controlled checked state                                              |
| `defaultChecked` | `boolean`                                                                                                                                                                                   | `false`     | Default checked state                                                 |
| `description`    | `string`                                                                                                                                                                                    | -           | Description text                                                      |
| `disabled`       | `boolean`                                                                                                                                                                                   | `false`     | Whether disabled                                                      |
| `editableInput`  | `Omit<BaseInputProps, 'variant'>`                                                                                                                                                           | -           | Editable input configuration                                          |
| `id`             | `string`                                                                                                                                                                                    | -           | Element ID                                                            |
| `indeterminate`  | `boolean`                                                                                                                                                                                   | `false`     | Indeterminate state                                                   |
| `inputProps`     | `Omit<NativeElementPropsWithoutKeyAndRef<'input'>, 'checked' \| 'defaultChecked' \| 'disabled' \| 'onChange' \| 'placeholder' \| 'type' \| 'value' \| 'aria-disabled' \| 'aria-checked'>` | -           | Native input element attributes (excludes controlled props)           |
| `inputRef`       | `Ref<HTMLInputElement>`                                                                                                                                                                     | -           | Reference to underlying input element                                 |
| `label`          | `string`                                                                                                                                                                                    | -           | Label text                                                            |
| `mode`           | `CheckboxMode`                                                                                                                                                                              | `'default'` | Display mode                                                          |
| `name`           | `string`                                                                                                                                                                                    | -           | Input name attribute                                                  |
| `onChange`       | `ChangeEventHandler<HTMLInputElement>`                                                                                                                                                      | -           | Change event handler                                                  |
| `severity`       | `'info' \| 'error'`                                                                                                                                                                         | `'info'`    | Severity state for validation feedback                                |
| `size`           | `'main' \| 'sub' \| 'minor'`                                                                                                                                                               | `'main'`    | Checkbox size (`'minor'` only available in chip mode)                 |
| `value`          | `string`                                                                                                                                                                                    | -           | Checkbox value                                                        |
| `withEditInput`  | `boolean`                                                                                                                                                                                   | `false`     | Show editable input when checked. Auto-checks and auto-focuses input. |

---

## Checkbox Modes and Sizes

| Mode      | Available Sizes                    | Description                         |
| --------- | ---------------------------------- | ----------------------------------- |
| `default` | `'main'` \| `'sub'`               | Default mode, standard checkbox     |
| `chip`    | `'main'` \| `'sub'` \| `'minor'`  | Chip mode, tag-button-like appearance |

## Checkbox Severity

The `severity` prop enables semantic form-validation styling:

| Severity | Visual | Use Case                                    |
| -------- | ------ | ------------------------------------------- |
| `'info'` | Normal | Default state; informational checkbox      |
| `'error'` | Error color | Marks invalid form state; use with FormField |

---

## CheckboxGroup Props

`CheckboxGroupProps` is a union type supporting two input methods (mutually exclusive):

- **Options mode**: Pass `options: CheckboxGroupOptionInput[]`; `children` cannot be used
- **Children mode**: Pass `children: ReactNode`; `options` cannot be used

### Common Base Props

| Property       | Type                                        | Default        | Description                                       |
| -------------- | ------------------------------------------- | -------------- | ------------------------------------------------- |
| `defaultValue` | `string[]`                                  | -              | Default selected values                           |
| `disabled`     | `boolean`                                   | -              | Whether disabled                                  |
| `layout`       | `CheckboxGroupLayout`                       | `'horizontal'` | Layout direction (`'horizontal' \| 'vertical'`)   |
| `level`        | `CheckboxGroupLevelConfig`                  | -              | Level control config (select-all checkbox)        |
| `mode`         | `CheckboxMode`                              | -              | Checkbox mode within the group                    |
| `name`         | `string`                                    | -              | Group name                                        |
| `onChange`     | `(event: CheckboxGroupChangeEvent) => void` | -              | Change event (get values via `event.target.values`) |
| `value`        | `string[]`                                  | -              | Controlled selected values                        |

### Options Mode Additional Props

| Property  | Type                         | Description                              |
| --------- | ---------------------------- | ---------------------------------------- |
| `options` | `CheckboxGroupOptionInput[]` | Options array (mutually exclusive with `children`) |

### Children Mode Additional Props

| Property   | Type        | Description                                   |
| ---------- | ----------- | --------------------------------------------- |
| `children` | `ReactNode` | Checkbox children (mutually exclusive with `options`) |

### CheckboxGroupLevelConfig

| Property   | Type                                   | Default     | Description                                |
| ---------- | -------------------------------------- | ----------- | ------------------------------------------ |
| `active`   | `boolean`                              | **Required** | Whether to enable level control           |
| `disabled` | `boolean`                              | `false`     | Whether to disable level control checkbox  |
| `label`    | `string`                               | `''`        | Level control checkbox label (source JSDoc says 'Select all', but runtime fallback is empty string) |
| `mode`     | `CheckboxMode`                         | `'default'` | Level control checkbox mode (matching runtime behavior) |
| `onChange` | `ChangeEventHandler<HTMLInputElement>` | -           | Custom select-all/deselect-all behavior    |

### CheckboxGroupOption

```tsx
interface CheckboxGroupOption {
  disabled?: boolean;
  label: string | number;
  mode?: CheckboxMode;
  value: string;
}
```

> When using `options`, the actual accepted type is `CheckboxGroupOptionInput` (extends `CheckboxGroupOption` with additional `id`, `inputRef`, `inputProps`, etc. Checkbox properties).

### CheckboxGroupChangeEvent

```tsx
type CheckboxGroupChangeEvent = ChangeEvent<HTMLInputElement> & {
  target: CheckboxGroupChangeEventTarget;
};

interface CheckboxGroupChangeEventTarget extends HTMLInputElement {
  values: string[];
}
```

---

## CheckAll Props

A standalone select-all component that wraps a CheckboxGroup.

| Property   | Type                               | Default       | Description                      |
| ---------- | ---------------------------------- | ------------- | -------------------------------- |
| `children` | `ReactElement<CheckboxGroupProps>` | **Required**  | The controlled CheckboxGroup     |
| `disabled` | `boolean`                          | `false`       | Whether disabled                 |
| `label`    | `string`                           | `'Check All'` | Select-all checkbox label        |

---

## Usage Examples

### Basic Usage

```tsx
import { Checkbox } from '@mezzanine-ui/react';

<Checkbox label="Agree to Terms of Service" />
```

### Controlled Mode

```tsx
function ControlledCheckbox() {
  const [checked, setChecked] = useState(false);

  return (
    <Checkbox
      checked={checked}
      onChange={(e) => setChecked(e.target.checked)}
      label="Subscribe to newsletter"
    />
  );
}
```

### With Description

```tsx
<Checkbox
  label="Advanced Settings"
  description="Enabling this option will show more configuration items"
/>
```

### With Severity (Info and Error States)

```tsx
{/* Info state (default) */}
<Checkbox
  label="Info checkbox"
  severity="info"
/>

{/* Error state for form validation */}
<Checkbox
  label="Error checkbox"
  severity="error"
  description="This field is required"
/>
```

### Chip Mode

```tsx
<Checkbox mode="chip" label="Tag 1" value="tag1" />
<Checkbox mode="chip" label="Tag 2" value="tag2" />
```

### With Editable Input

```tsx
<Checkbox
  label="Other"
  withEditInput
  editableInput={{
    placeholder: 'Enter other option',
    value: otherValue,
    onChange: (e) => setOtherValue(e.target.value),
  }}
/>
```

### Checkbox Group (using options)

```tsx
function CheckboxGroupExample() {
  const [values, setValues] = useState<string[]>([]);

  return (
    <CheckboxGroup
      name="fruits"
      value={values}
      onChange={(e) => setValues(e.target.values)}
      options={[
        { label: 'Apple', value: 'apple' },
        { label: 'Banana', value: 'banana' },
        { label: 'Cherry', value: 'cherry' },
      ]}
      layout="vertical"
    />
  );
}
```

### Checkbox Group (using children)

```tsx
function CheckboxGroupChildren() {
  const [values, setValues] = useState<string[]>([]);

  return (
    <CheckboxGroup
      name="fruits"
      value={values}
      onChange={(e) => setValues(e.target.values)}
      layout="horizontal"
    >
      <Checkbox value="apple" label="Apple" />
      <Checkbox value="banana" label="Banana" />
      <Checkbox value="cherry" label="Cherry" />
    </CheckboxGroup>
  );
}
```

### Using level (Built-in Select All)

```tsx
<CheckboxGroup
  name="features"
  value={values}
  onChange={(e) => setValues(e.target.values)}
  options={featureOptions}
  level={{ active: true, label: 'Select All' }}
/>
```

### Using CheckAll Component

```tsx
<CheckAll label="Select All">
  <CheckboxGroup
    name="items"
    value={values}
    onChange={(e) => setValues(e.target.values)}
    options={itemOptions}
  />
</CheckAll>
```

### Integration with react-hook-form

```tsx
import { useForm, Controller } from 'react-hook-form';

function FormExample() {
  const { control, handleSubmit } = useForm();

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <Controller
        name="interests"
        control={control}
        render={({ field }) => (
          <CheckboxGroup
            name="interests"
            value={field.value || []}
            onChange={(e) => field.onChange(e.target.values)}
            options={[
              { label: 'Reading', value: 'reading' },
              { label: 'Coding', value: 'coding' },
            ]}
          />
        )}
      />
    </form>
  );
}
```

---

## Figma Mapping

| Figma Variant                  | React Props                    |
| ------------------------------ | ------------------------------ |
| `Checkbox / Default`           | `<Checkbox mode="default">`    |
| `Checkbox / Chip`              | `<Checkbox mode="chip">`       |
| `Checkbox / Checked`           | `<Checkbox checked>`           |
| `Checkbox / Indeterminate`     | `<Checkbox indeterminate>`     |
| `Checkbox / Disabled`          | `<Checkbox disabled>`          |
| `Checkbox / With Description`  | `<Checkbox description="...">`  |

---

## Best Practices

1. **Provide value within groups**: Checkboxes inside CheckboxGroup must have a `value`
2. **Use level or CheckAll**: For "select all" functionality
3. **Provide name attribute**: Ensure `name` is set when integrating with forms
4. **Chip mode for tag selection**: Use `mode="chip"` when tag-style UI is needed
5. **Pair with FormField**: Use FormField wrapper to provide labels and error messages
6. **Use severity for validation**: Set `severity="error"` when displaying validation errors; rely on FormField for automatic context handling
