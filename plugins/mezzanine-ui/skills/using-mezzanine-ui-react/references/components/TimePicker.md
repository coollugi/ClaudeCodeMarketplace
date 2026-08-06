# TimePicker Component

> **Category**: Data Entry
>
> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-timepicker--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。
>
> **Source**: Verified 1.4.1 (2026-07-01)

Time picker for selecting time. Must be used with `CalendarContext`.

## ⚠️ Prerequisite: CalendarConfigProvider

此元件依賴 `CalendarContext`，必須在應用程式根層級（如 `layout.tsx` 或 `App.tsx`）包裹 `CalendarConfigProvider`。
缺少此設定會導致 runtime error: `Cannot find values in your context`.

```tsx
// layout.tsx 或 App.tsx
import { CalendarConfigProvider } from '@mezzanine-ui/react';
import { CalendarMethodsMoment } from '@mezzanine-ui/core/calendar';
// 或使用 dayjs: import { CalendarMethodsDayjs } from '@mezzanine-ui/core/calendar';

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <CalendarConfigProvider methods={CalendarMethodsMoment}>
      {children}
    </CalendarConfigProvider>
  );
}
```

> 也可使用便捷封裝 `CalendarConfigProviderMoment` 或 `CalendarConfigProviderDayjs`。
> 詳見 [Calendar.md](./Calendar.md) 的完整設定說明。

---

## Import

```tsx
import { TimePicker, TimePickerPanel } from '@mezzanine-ui/react';
import type { TimePickerProps, TimePickerPanelProps } from '@mezzanine-ui/react';
```

---

## TimePicker Props

> Extends `TimePickerPanelProps` (excluding anchor, onChange, onCancel, onConfirm, open, value) and `PickerTriggerProps` (excluding format, inputRef, onChange, onClear, suffix, value).
>
> `ref` (forwardRef) points to the root `HTMLDivElement`.

### Own Properties

| Property        | Type                          | Default                                        | Description          |
| --------------- | ----------------------------- | ---------------------------------------------- | -------------------- |
| `defaultValue`  | `DateType`                    | -                                              | Default value        |
| `format`        | `string`                      | `'HH:mm:ss'` (`'HH:mm'` when hideSecond)      | Display format       |
| `onChange`      | `(value?: DateType) => void`  | -                                              | Change callback      |
| `onPanelToggle` | `(open: boolean) => void`     | -                                              | Panel toggle callback |
| `value`         | `DateType`                    | -                                              | Selected value (controlled) |

### Inherited from TimePickerPanelProps

| Property     | Type         | Default | Description              |
| ------------ | ------------ | ------- | ------------------------ |
| `fadeProps`   | `FadeProps`  | -      | Fade animation props     |
| `hideHour`   | `boolean`    | -      | Hide hours               |
| `hideMinute` | `boolean`    | -      | Hide minutes             |
| `hideSecond` | `boolean`    | -      | Hide seconds             |
| `hourStep`   | `number`     | -      | Hour interval            |
| `minuteStep` | `number`     | -      | Minute interval          |
| `popperProps` | `Omit<InputTriggerPopperProps, 'anchor' \| 'children' \| 'fadeProps' \| 'open'>` | - | Popper positioning props |
| `secondStep` | `number`     | -      | Second interval          |

### Inherited from PickerTriggerProps

> `TimePickerProps` uses `Omit` (not `Pick`) over `PickerTriggerProps`, so — unlike `TimeRangePickerProps` below — every non-excluded `PickerTriggerProps`/`TextFieldProps` member is part of the public type, including some (`hoverValue`, `validate`) that `TimePicker` also wires internally.

| Property                  | Type               | Default | Description          |
| ------------------------- | ------------------ | ------- | -------------------- |
| `className`               | `string`           | -       | CSS class             |
| `clearable`               | `boolean`          | `true`  | Whether clearable    |
| `disabled`                | `boolean`          | `false` | Whether disabled     |
| `errorMessages`           | `FormattedInputProps['errorMessages']` | - | Error messages |
| `forceShowClearable`      | `boolean`          | `false` | Force clear button visibility (ignore value check), from `TextFieldProps` |
| `fullWidth`               | `boolean`          | `false` | Whether full width   |
| `hideSuffixWhenClearable` | `boolean`          | `false` | Overlay clear icon at suffix position, from `TextFieldProps` |
| `inputProps`              | `InputProps`       | -       | Input props          |
| `placeholder`             | `string`           | -       | placeholder          |
| `prefix`                  | `ReactNode`        | -       | Prefix element       |
| `readOnly`                | `boolean`          | -       | Whether read-only    |
| `required`                | `boolean`          | `false` | Whether required     |
| `size`                    | `'main' \| 'sub'`  | -       | Size                 |
| `warning`                 | `boolean`          | `false` | Warning state, from `TextFieldProps` |

---

## Portal Behavior (v1.0.4+)

Since v1.0.4 the time panel portals out of the DOM subtree by default, fixing clipping inside `Modal` / `overflow: hidden` ancestors and enabling viewport-edge flip. To restore inline rendering per call site:

```tsx
<TimePicker
  popperProps={{ disablePortal: true }}
  value={value}
  onChange={setValue}
/>
```

### Keyboard Navigation (v1.1.0+)

`Tab` / `Shift+Tab` navigation between the trigger input and the portalled time panel is restored in v1.1.0 via an explicit logical focus loop, reliable even inside a `Modal` focus trap.

---

## Usage Examples

### Basic Usage

```tsx
import { TimePicker } from '@mezzanine-ui/react';
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';

function BasicExample() {
  const [value, setValue] = useState<string | undefined>();

  return (
    <CalendarConfigProviderDayjs>
      <TimePicker
        value={value}
        onChange={setValue}
      />
    </CalendarConfigProviderDayjs>
  );
}
```

### Custom Format

```tsx
<TimePicker
  format="HH:mm"
  hideSecond
  placeholder="Select time"
  onChange={handleChange}
/>
```

### Time Interval

```tsx
<TimePicker
  hourStep={1}
  minuteStep={15}
  onChange={handleChange}
/>
```

### Show Only Hours and Minutes

```tsx
<TimePicker
  hideSecond
  format="HH:mm"
  onChange={handleChange}
/>
```

### Controlled Mode

```tsx
function ControlledTimePicker() {
  const [value, setValue] = useState<string | undefined>();

  return (
    <>
      <TimePicker
        value={value}
        onChange={setValue}
      />
      <Button onClick={() => setValue(dayjs().toISOString())}>
        Set to now
      </Button>
      <Button onClick={() => setValue(undefined)}>
        Clear
      </Button>
    </>
  );
}
```

### With Default Value

```tsx
<TimePicker
  defaultValue="2024-01-01T14:30:00"
  onChange={handleChange}
/>
```

### 30-Minute Interval

```tsx
<TimePicker
  minuteStep={30}
  secondStep={60}
  onChange={handleChange}
/>
```

### Keyboard Input

Keyboard input commits immediately and typed values show as pending preview:

```tsx
<TimePicker
  format="HH:mm"
  hideSecond
  onChange={handleChange}
/>

// User can directly type in the input field:
// - Typing "1430" shows as pending preview (14:30)
// - Pressing Enter/Tab commits the value
// - Clicking outside confirms the value
```

---

## TimePickerPanel Props

> Extends `TimePanelProps` (className, hideHour, hideMinute, hideSecond, hourStep, minuteStep, secondStep, style) and `InputTriggerPopperProps` (anchor, fadeProps, open).

| Property      | Type                                                              | Default | Description            |
| ------------- | ----------------------------------------------------------------- | ------- | ---------------------- |
| `onCancel`    | `VoidFunction`                                                    | -       | Cancel button click callback |
| `onChange`    | `(value?: DateType) => void`                                      | -       | Selection change callback |
| `onConfirm`   | `VoidFunction`                                                    | -       | Confirm/Ok button click callback |
| `popperProps` | `Omit<InputTriggerPopperProps, 'anchor' \| 'children' \| 'fadeProps' \| 'open'>` | -      | Additional Popper props |
| `value`       | `DateType`                                                        | -       | Panel display value    |

---

## Time Panel Structure

The time panel contains three scrollable columns:

```
┌─────────────────────────────┐
│  Hour   │  Minute │  Second  │
│ ────────│─────────│───────── │
│   00    │   00    │   00     │
│   01    │   01    │   01     │
│   02    │   02    │   02     │
│   ...   │   ...   │   ...    │
│   23    │   59    │   59     │
└─────────────────────────────┘
```

Use `hideHour`, `hideMinute`, `hideSecond` to hide the corresponding columns.

---

## Step Validation

When step props are set, the component validates whether the input value matches the interval:
- `hourStep={2}` → Only allows 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22
- `minuteStep={15}` → Only allows 0, 15, 30, 45
- `secondStep={30}` → Only allows 0, 30

---

## Figma Mapping

| Figma Variant                | React Props                              |
| ---------------------------- | ---------------------------------------- |
| `TimePicker / Default`       | Default                                  |
| `TimePicker / Disabled`      | `disabled`                               |
| `TimePicker / Error`         | `error`                                  |
| `TimePicker / With Value`    | `value` has a value                      |
| `TimePicker / Hide Second`   | `hideSecond`                             |

---

## Internal Implementation Notes

- Uses `isValidStep()` to validate whether time values match step settings
- Keyboard Enter closes the panel
- Uses `usePickerDocumentEventClose` to handle click outside to close

---

## Best Practices

1. **Context required**: Must be wrapped in a CalendarContext.Provider
2. **Format matching**: `format` should match hide settings (e.g. use `HH:mm` when `hideSecond`)
3. **Reasonable intervals**: Step values should be reasonable time intervals (e.g. 5, 10, 15, 30 minutes)
4. **Keyboard support**: Supports keyboard input and Enter to confirm
5. **Clear functionality**: Clearable is enabled by default, allowing selected values to be cleared
