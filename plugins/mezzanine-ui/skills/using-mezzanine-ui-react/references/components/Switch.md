# Switch Component

> ⚠️ **`Switch` is gone, and it left in two stages — neither of them 1.4.1.**
>
> 1. **`1.0.0-canary.3`** — the source directory `src/Switch/` was deleted and `src/Toggle/` took its place (verified: `src/Switch/Switch.tsx` returns 200 at `1.0.0-canary.2` and 404 at `1.0.0-canary.3`, while `src/Toggle/Toggle.tsx` does the reverse). From here on `Switch` survived only as a compatibility alias in `src/index.ts`: `export { default as Switch } from './Toggle'`, with `SwitchProps = ToggleProps` and `SwitchSize = ToggleSize`.
> 2. **`1.0.0`** — that alias was dropped too (still present in `1.0.0-canary.4`'s `src/index.ts`, absent in `1.0.0`).
>
> It was never marked `@deprecated` at any point. Use [`Toggle`](Toggle.md). Note that the unrelated hook `useSwitchControlValue` still ships and is still exported from the main entry in 1.5.1 — its name is not evidence that the component exists.
> **Use [Toggle](Toggle.md) instead.** The component was replaced by Toggle; import and use Toggle directly.

> **Category**: Data Entry (removed)
>
> **Storybook**: `Data Entry/Toggle` (successor component)
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Toggle) · **Alias dropped** in 1.0.0 (verified against the published `src/index.ts` of `1.0.0-canary.4` and `1.0.0`)

Toggle switch component for switching between two states (on/off). **The `Switch` component was renamed to `Toggle` in 1.0.0.** This document is retained for migration reference only — all new code should import and use `Toggle` directly. See [Toggle.md](Toggle.md) for the canonical 1.0.0 API.

## Migration from Switch to Toggle

```tsx
// ❌ Before (deprecated, removed in 1.0.0)
import { Switch } from '@mezzanine-ui/react';
import type { SwitchProps, SwitchSize } from '@mezzanine-ui/react';

<Switch checked={value} onChange={handleChange} />

// ✅ After (1.0.0)
import { Toggle } from '@mezzanine-ui/react';
import type { ToggleProps, ToggleSize } from '@mezzanine-ui/react';

<Toggle checked={value} onChange={handleChange} />
```

> **Note**: The API surface is identical between the removed `Switch` and the canonical `Toggle`. Only the component name and type names changed (`Switch`/`SwitchProps`/`SwitchSize` → `Toggle`/`ToggleProps`/`ToggleSize`). All prop names, defaults, and behaviors are preserved.

## Import (Historical — No Longer Works in 1.0.0)

```tsx
// ⚠️ These imports no longer work in 1.0.0
import { Switch } from '@mezzanine-ui/react';
import type { SwitchProps, SwitchSize } from '@mezzanine-ui/react';
```

---

## Switch Props

> Extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'onChange'>`, `ref` points to the root `HTMLDivElement`.

| Property         | Type                                   | Default                      | Description                          |
| ---------------- | -------------------------------------- | ---------------------------- | ------------------------------------ |
| `checked`        | `boolean`                              | -                            | Controlled on state                  |
| `defaultChecked` | `boolean`                              | -                            | Uncontrolled default state           |
| `disabled`       | `boolean`                              | `false` (inherits FormControl) | Whether disabled                   |
| `inputProps`     | `Omit<InputHTMLAttributes, ...>`       | -                            | Props passed to native input element |
| `label`          | `string`                               | -                            | Label text                           |
| `onChange`       | `ChangeEventHandler<HTMLInputElement>` | -                            | Change event                         |
| `size`           | `SwitchSize`                           | `'main'`                     | Size                                 |
| `supportingText` | `string`                               | -                            | Supporting text below label          |

---

## SwitchSize Type

| Size   | Description    |
| ------ | -------------- |
| `main` | Primary size   |
| `sub`  | Secondary size |

---

## Usage Examples

> ⚠️ **Historical Reference Only** — The following examples use the deprecated `Switch` API and will **not compile** against 1.0.0. They are retained only to help migrate legacy v1 code. For working 1.0.0 examples, see [Toggle.md](Toggle.md).

### Basic Usage

```tsx
import { Switch } from '@mezzanine-ui/react';

// Uncontrolled
<Switch defaultChecked />

// Controlled
const [checked, setChecked] = useState(false);

<Switch
  checked={checked}
  onChange={(e) => setChecked(e.target.checked)}
/>
```

### With Label

```tsx
<Switch
  label="Enable Notifications"
  checked={checked}
  onChange={handleChange}
/>
```

### With Supporting Text

```tsx
<Switch
  label="Auto Update"
  supportingText="System will automatically check and install updates in the background"
  checked={checked}
  onChange={handleChange}
/>
```

### Different Sizes

```tsx
// Primary size (default)
<Switch size="main" label="Primary Size" />

// Secondary size
<Switch size="sub" label="Secondary Size" />
```

### Disabled State

```tsx
<Switch disabled label="Disabled" />
<Switch disabled checked label="Disabled but On" />
```

### Settings Group

```tsx
function SettingsForm() {
  const [settings, setSettings] = useState({
    notifications: true,
    autoUpdate: false,
    darkMode: false,
  });

  const handleChange = (key: string) => (e: ChangeEvent<HTMLInputElement>) => {
    setSettings({
      ...settings,
      [key]: e.target.checked,
    });
  };

  return (
    <div>
      <Switch
        label="Push Notifications"
        supportingText="Receive important message notifications"
        checked={settings.notifications}
        onChange={handleChange('notifications')}
      />
      <Switch
        label="Auto Update"
        supportingText="Automatically download and install updates"
        checked={settings.autoUpdate}
        onChange={handleChange('autoUpdate')}
      />
      <Switch
        label="Dark Mode"
        supportingText="Use dark interface theme"
        checked={settings.darkMode}
        onChange={handleChange('darkMode')}
      />
    </div>
  );
}
```

### With FormField

```tsx
import { FormField, Switch } from '@mezzanine-ui/react';

<FormField
  name="enableFeature"
  label="Feature Settings"
  layout="vertical"
>
  <Switch
    label="Enable New Feature"
    checked={checked}
    onChange={handleChange}
  />
</FormField>
```

---

## Figma Mapping

| Figma Variant               | React Props                        |
| --------------------------- | ---------------------------------- |
| `Switch / Main`             | `size="main"`                      |
| `Switch / Sub`              | `size="sub"`                       |
| `Switch / Checked`          | `checked`                          |
| `Switch / Unchecked`        | Default                            |
| `Switch / Disabled`         | `disabled`                         |
| `Switch / With Label`       | `label="..."`                      |
| `Switch / With Supporting`  | `label="..." supportingText="..."` |

---

## Internal Implementation Notes

- Uses `useSwitchControlValue` hook for managing controlled/uncontrolled state
- Inherits `disabled` state from `FormControlContext`
- Internal structure: `div` > `span` (knob) + hidden `checkbox` input

---

## Best Practices

1. **Use label**: Always provide a clear `label` describing the switch function
2. **Immediate effect**: Switch is suitable for settings that take effect immediately; use Checkbox for non-immediate ones
3. **Provide description**: Use `supportingText` for complex settings
4. **Controlled vs uncontrolled**: Use controlled mode for forms, uncontrolled for standalone use
5. **Disabled state**: Clearly show disabled state when the value cannot be changed
