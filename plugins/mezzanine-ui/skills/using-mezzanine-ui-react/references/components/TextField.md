# TextField Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/TextField`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/TextField) | Verified 1.5.1 (2026-09-12)

Text input field container component providing a unified input box appearance. It is the underlying component for Input, Select, and other components.

## Import

```tsx
import { TextField } from '@mezzanine-ui/react';
import type {
  TextFieldProps,
  TextFieldBaseProps,
  TextFieldAffixProps,
  TextFieldInteractiveStateProps,
  TextFieldPaddingInfo,
  TextFieldSize
} from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/story/internal-textfield--playground) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## TextField Props

> `TextFieldProps = TextFieldBaseProps & TextFieldAffixProps & TextFieldInteractiveStateProps`
>
> `ref` (forwardRef) points to the root `HTMLDivElement`.

| Property    | Type                                                        | Default  | Source                        | Description            |
| ----------- | ----------------------------------------------------------- | -------- | ----------------------------- | ---------------------- |
| `active`    | `boolean`                                                   | `false`  | TextFieldBaseProps            | Whether active state   |
| `children`  | `ReactNode \| ((paddingInfo: TextFieldPaddingInfo) => ReactNode)` | **required** | TextFieldBaseProps      | Content or function    |
| `className` | `string`                                                    | -        | TextFieldBaseProps            | Additional class name applied to the root element |
| `clearable` | `boolean`                                                   | `false`  | TextFieldBaseProps            | Whether clearable      |
| `forceShowClearable` | `boolean`                                          | `false`  | TextFieldBaseProps            | Force clear button visibility (ignore value check) |
| `hideSuffixWhenClearable` | `boolean`                                     | `false`  | TextFieldBaseProps            | Hide suffix and overlay clear icon at suffix position |
| `error`     | `boolean`                                                   | `false`  | TextFieldBaseProps            | Error state            |
| `fullWidth` | `boolean`                                                   | `true`   | TextFieldBaseProps            | Whether full width     |
| `onClear`   | `MouseEventHandler`                                         | -        | TextFieldBaseProps            | Clear button callback  |
| `size`      | `TextFieldSize`                                             | `'main'` | TextFieldBaseProps            | Size                   |
| `warning`   | `boolean`                                                   | `false`  | TextFieldBaseProps            | Warning state          |
| `prefix`    | `ReactNode`                                                 | -        | TextFieldAffixProps           | Prefix content         |
| `suffix`    | `ReactNode`                                                 | -        | TextFieldAffixProps           | Suffix content         |
| `typing`    | `boolean`                                                   | -        | TextFieldInteractiveStateProps | Whether typing         |
| `disabled`  | `boolean`                                                   | `-`      | TextFieldInteractiveStateProps | Whether disabled (no destructuring default — literal `true` required to enter the "disabled" variant) |
| `readonly`  | `boolean`                                                   | `-`      | TextFieldInteractiveStateProps | Whether read-only (no destructuring default — literal `true` required to enter the "readonly" variant) |

---

## ARIA Role (重要 — keeps ARIA input semantics on the native control)

`TextField` is only a **visual frame** around a native control passed in via `children` (an `<input>`, `<textarea>`, etc.). Since 1.5.0, the host `<div>` derives a fallback ARIA `role` for itself:

- `role="button"` when an `onClick` prop is given
- `role="textbox"` otherwise (the default)

This fallback is only correct when the wrapper `<div>` itself is meant to be the interactive control (no nested native input). Any component that nests a real `<input>`/`<textarea>` inside `TextField` — and therefore forwards naming props such as `aria-label` to that inner element — **must pass `role="presentation"` explicitly** to `TextField` so the ARIA semantics stay on the native control (which already has the correct role and naming behavior). Otherwise the wrapper `<div>` claims an ARIA input role it can never correctly name, which fails the axe `aria-input-field-name` rule.

```tsx
// ✅ Wrapping a real <input> — suppress the wrapper's own ARIA role
<TextField role="presentation">
  <input type="text" aria-label="Search" />
</TextField>
```

`role` itself is not a dedicated `TextFieldProps` field — it is accepted through the native `<div>` props inherited by `TextFieldBaseProps`, and any explicit `role` passed by the caller takes precedence over the computed fallback.

---

## TextFieldInteractiveStateProps

`disabled`, `readonly`, and `typing` are mutually exclusive and cannot be used simultaneously:

```tsx
// Normal state (can set typing)
type Normal = { typing?: boolean; disabled?: never; readonly?: never };

// Disabled state
type Disabled = { typing?: never; disabled: true; readonly?: never };

// Read-only state
type Readonly = { typing?: never; disabled?: never; readonly: true };
```

---

## TextFieldPaddingInfo

When children is a function, it receives padding info:

```tsx
interface TextFieldPaddingInfo {
  paddingClassName: string; // Same padding class as TextField
}
```

---

## Usage Examples

### Basic Usage

```tsx
import { TextField } from '@mezzanine-ui/react';

<TextField>
  <input type="text" placeholder="Enter..." />
</TextField>
```

### Function Children (controlling padding)

```tsx
<TextField>
  {({ paddingClassName }) => (
    <input
      type="text"
      className={paddingClassName}
      placeholder="Control padding yourself"
    />
  )}
</TextField>
```

### With Prefix and Suffix

```tsx
import { SearchIcon, CalendarIcon } from '@mezzanine-ui/icons';
import { Icon } from '@mezzanine-ui/react';

<TextField
  prefix={<Icon icon={SearchIcon} />}
  suffix={<Icon icon={CalendarIcon} />}
>
  <input type="text" />
</TextField>
```

### Clearable

```tsx
<TextField
  clearable
  onClear={() => setValue('')}
>
  <input type="text" value={value} onChange={handleChange} />
</TextField>
```

### Error State

```tsx
<TextField error>
  <input type="text" />
</TextField>
```

### Warning State

```tsx
<TextField warning>
  <input type="text" />
</TextField>
```

### Disabled State

```tsx
<TextField disabled>
  <input type="text" disabled />
</TextField>
```

### Read-only State

```tsx
<TextField readonly>
  <input type="text" readOnly />
</TextField>
```

### Small Size

```tsx
<TextField size="sub">
  <input type="text" />
</TextField>
```

### Active State (e.g., dropdown open)

```tsx
<TextField active>
  <input type="text" />
</TextField>
```

### Suffix Overlay Clear (hideSuffixWhenClearable)

```tsx
import { CalendarIcon } from '@mezzanine-ui/icons';
import { Icon, TextField } from '@mezzanine-ui/react';

<TextField
  clearable
  hideSuffixWhenClearable
  onClear={() => setValue('')}
  suffix={<Icon icon={CalendarIcon} />}
>
  <input type="text" value={value} onChange={handleChange} />
</TextField>
```

When the user hovers/focuses and a value exists, the clear icon replaces the calendar icon at the same position.

---

## Relationship with Input Component

The `Input` component internally uses `TextField` as its container:

```tsx
// Approximate internal structure of Input component
function Input(props) {
  return (
    <TextField
      prefix={props.prefix}
      suffix={props.suffix}
      clearable={props.clearable}
      // ...other TextField props
    >
      <input {...inputProps} />
    </TextField>
  );
}
```

---

## Auto Typing Detection

When `typing` is not explicitly set, the component auto-detects:
- Listens to internal input/textarea `input` and `mousedown` events to set typing
- Listens to `blur` event to cancel typing state

---

## Clear Button Display Logic

The clear button (clearable) is visible when:
1. `clearable` is enabled
2. A value exists
3. Any of the following: hovered **or** typing **or** focused

### Suffix Overlay Mode (`hideSuffixWhenClearable`)

When `hideSuffixWhenClearable` is `true`, the clear icon **overlays the suffix position** instead of being placed separately:

- The standalone clear icon is **not rendered** (no separate `ClearActions`).
- The suffix container gets the `mzn-text-field__suffix--overlay` class.
- Inside the suffix container, the original suffix content is wrapped in `mzn-text-field__suffix-content`, and a `ClearActions` is placed alongside it.
- When the clear button should be visible (`clearable` + has value + hover/focus/typing), the `mzn-text-field--clearing` class is added to the host, which can be used to hide the suffix content and show the clear icon via CSS.

This pattern is useful when suffix and clear icon should share the same space (e.g., DatePicker calendar icon / clear icon toggle).

> Note: `ClearActions` is no longer exported from the `@mezzanine-ui/react` package root as of this release, but it is still used internally by `TextField` (imported via relative path, not the public entry) — it has not been deleted. This is an internal implementation detail; the clear button is controlled via the `clearable` prop and `onClear` callback.

---

## Figma Mapping

| Figma Variant              | React Props                              |
| -------------------------- | ---------------------------------------- |
| `TextField / Default`      | Default                                  |
| `TextField / Active`       | `active`                                 |
| `TextField / Typing`       | `typing`                                 |
| `TextField / Error`        | `error`                                  |
| `TextField / Warning`      | `warning`                                |
| `TextField / Disabled`     | `disabled`                               |
| `TextField / Readonly`     | `readonly`                               |
| `TextField / With Prefix`  | `prefix` has value                       |
| `TextField / With Suffix`  | `suffix` has value                       |
| `TextField / Clearable`    | `clearable`                              |
| `TextField / Clearable Overlay` | `clearable` + `hideSuffixWhenClearable` |
| `TextField / Main`         | `size="main"` (default)                  |
| `TextField / Sub`          | `size="sub"`                             |

---

## Best Practices

1. **Use Input component**: In general, use the Input component directly instead of TextField
2. **Function children**: Use function form when precise padding control is needed
3. **State mutual exclusion**: disabled, readonly, typing are mutually exclusive
4. **Clear functionality**: Implement the onClear callback when enabling clearable
5. **Accessibility**: Internal input must set corresponding disabled/readOnly attributes
