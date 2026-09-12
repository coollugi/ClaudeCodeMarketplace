# DatePicker Component

> **Category**: Data Entry
>
> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-datepicker--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/DatePicker) · Verified 1.5.1 (2026-09-12)

Date picker component supporting multiple modes (day, week, month, quarter, half-year, year). Requires `CalendarContext`. Internally composed of `PickerTrigger` and `DatePickerCalendar`.

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
import { DatePicker, CalendarContext } from '@mezzanine-ui/react';
import { DatePickerCalendar } from '@mezzanine-ui/react/DatePicker';
import type { DatePickerProps, DatePickerCalendarProps } from '@mezzanine-ui/react';
```

---

## DatePicker Props

`DatePickerProps` extends `DatePickerCalendarProps` (excluding `anchor`, `calendarRef`, `disableOnDoubleNext`, `disableOnDoublePrev`, `onChange`, `open`, `referenceDate`, `updateReferenceDate`) and `PickerTriggerProps` (excluding `defaultValue`, `format`, `inputRef`, `onChange`, `onClear`, `onClick`, `onIconClick`, `onKeyDown`, `value`).

### Own Props

| Property              | Type                          | Default      | Description                              |
| --------------------- | ----------------------------- | ------------ | ---------------------------------------- |
| `defaultValue`        | `DateType`                    | -            | Default value                            |
| `disableOnDoubleNext` | `boolean`                     | `false`      | Disable double-arrow next                |
| `disableOnDoublePrev` | `boolean`                     | `false`      | Disable double-arrow previous            |
| `format`              | `string`                      | by mode      | Date format (length must match output value) |
| `onCalendarToggle`    | `(open: boolean) => void`     | -            | Calendar open/close event                |
| `onChange`            | `(target?: DateType) => void` | -            | Change event                             |
| `referenceDate`       | `DateType`                    | current time | Reference date                           |

### Inherited from DatePickerCalendarProps

| Property              | Type                              | Default  | Description                    |
| --------------------- | --------------------------------- | -------- | ------------------------------ |
| `calendarProps`       | `Omit<CalendarProps, ...>`        | -        | Props passed to Calendar       |
| `disabledMonthSwitch` | `boolean`                         | `false`  | Disable month switching        |
| `disabledYearSwitch`  | `boolean`                         | `false`  | Disable year switching         |
| `disableOnNext`       | `boolean`                         | -        | Disable next                   |
| `disableOnPrev`       | `boolean`                         | -        | Disable previous               |
| `displayMonthLocale`  | `string`                          | `locale` (from `CalendarContext`) | Month display locale |
| `fadeProps`            | `FadeProps`                       | -        | Fade animation props           |
| `isDateDisabled`      | `(date: DateType) => boolean`     | -        | Date disabled check            |
| `isHalfYearDisabled`  | `(date: DateType) => boolean`     | -        | Half-year disabled check       |
| `isMonthDisabled`     | `(date: DateType) => boolean`     | -        | Month disabled check           |
| `isQuarterDisabled`   | `(date: DateType) => boolean`     | -        | Quarter disabled check         |
| `isWeekDisabled`      | `(date: DateType) => boolean`     | -        | Week disabled check            |
| `isYearDisabled`      | `(date: DateType) => boolean`     | -        | Year disabled check            |
| `mode`                | `CalendarMode`                    | `'day'`  | Date mode                      |
| `onHover`             | `(date: DateType) => void`        | -        | Fired when hovering a calendar cell |
| `onLeave`             | `() => void`                      | -        | Fired when mouse leaves the calendar panel |
| `popperProps`         | `Omit<InputTriggerPopperProps, 'anchor' \| 'children' \| 'fadeProps' \| 'open'>` | - | Popper positioning props |

### Inherited from PickerTriggerProps

| Property        | Type                                  | Default | Description            |
| --------------- | ------------------------------------- | ------- | ---------------------- |
| `className`     | `string`                              | -       | CSS class              |
| `clearable`     | `boolean`                             | `true`  | Whether clearable      |
| `disabled`      | `boolean`                             | `false` | Whether disabled       |
| `error`         | `boolean`                             | `false` | Whether in error state |
| `errorMessages` | `FormattedInputProps['errorMessages']` | -      | Error messages         |
| `fullWidth`     | `boolean`                             | `false` | Whether full width     |
| `inputProps`    | `Omit<NativeInputProps, ...>`         | -       | Props passed to input  |
| `placeholder`   | `string`                              | -       | Placeholder text       |
| `prefix`        | `ReactNode`                           | -       | Prefix                 |
| `readOnly`      | `boolean`                             | `false` | Whether read-only      |
| `required`      | `boolean`                             | `false` | Whether required       |
| `size`          | `'main' \| 'sub'`                     | -       | Size                   |
| `validate`      | `FormattedInputProps['validate']`     | -       | Input validation function |
| `value`         | `DateType`                            | -       | Controlled value       |

---

## CalendarMode Type

| Mode        | Description | Default Format |
| ----------- | ----------- | -------------- |
| `day`       | Day         | `YYYY-MM-DD`   |
| `week`      | Week        | `gggg-[W]ww`   |
| `month`     | Month       | `YYYY-MM`      |
| `quarter`   | Quarter     | `YYYY-[Q]Q`    |
| `half-year` | Half-year   | `YYYY-[H]n`    |
| `year`      | Year        | `YYYY`         |

---

## Portal Behavior (v1.0.4+)

Since v1.0.4 the calendar popper portals out of the DOM subtree by default, so `z-index: popover (1005)` wins against `Modal (1004)`. This fixes clipping when the picker is inside a `Modal` or any ancestor with `overflow: hidden`, and enables viewport-edge flip.

To restore the previous inline (non-portal) rendering per call site:

```tsx
<DatePicker
  popperProps={{ disablePortal: true }}
  value={value}
  onChange={setValue}
/>
```

### Keyboard Navigation (v1.1.0+)

`Tab` / `Shift+Tab` navigation between the trigger input and the portalled calendar is restored in v1.1.0. The popper establishes an explicit logical focus loop so the browser does not skip the calendar when the portal severs natural DOM order. This is particularly reliable inside a `Modal` focus trap.

---

## CalendarContext is Required

DatePicker must be used within a `CalendarContext.Provider` with a date library adapter.

### Using Day.js

```tsx
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';

function App() {
  return (
    <CalendarConfigProviderDayjs>
      <DatePicker />
    </CalendarConfigProviderDayjs>
  );
}
```

### Using Luxon

```tsx
import { CalendarConfigProviderLuxon } from '@mezzanine-ui/react/Calendar';

<CalendarConfigProviderLuxon>
  <DatePicker />
</CalendarConfigProviderLuxon>
```

### Using Moment

```tsx
import { CalendarConfigProviderMoment } from '@mezzanine-ui/react/Calendar';

<CalendarConfigProviderMoment>
  <DatePicker />
</CalendarConfigProviderMoment>
```

---

## Usage Examples

### Basic Date Selection

```tsx
import { DatePicker } from '@mezzanine-ui/react';
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';

function BasicDatePicker() {
  const [date, setDate] = useState<string | undefined>();

  return (
    <CalendarConfigProviderDayjs>
      <DatePicker
        value={date}
        onChange={setDate}
        placeholder="Select date"
      />
    </CalendarConfigProviderDayjs>
  );
}
```

### Month Selection

```tsx
<DatePicker
  mode="month"
  value={month}
  onChange={setMonth}
  placeholder="Select month"
/>
```

### Year Selection

```tsx
<DatePicker
  mode="year"
  value={year}
  onChange={setYear}
  placeholder="Select year"
/>
```

### Week Selection

```tsx
<DatePicker
  mode="week"
  value={week}
  onChange={setWeek}
  placeholder="Select week"
/>
```

### Disabling Specific Dates

```tsx
<DatePicker
  value={date}
  onChange={setDate}
  isDateDisabled={(dateStr) => {
    const date = dayjs(dateStr);
    // Disable weekends
    return date.day() === 0 || date.day() === 6;
  }}
/>
```

### Restricting Date Range

```tsx
<DatePicker
  value={date}
  onChange={setDate}
  isDateDisabled={(dateStr) => {
    const date = dayjs(dateStr);
    const minDate = dayjs('2024-01-01');
    const maxDate = dayjs('2024-12-31');
    return date.isBefore(minDate) || date.isAfter(maxDate);
  }}
/>
```

### Custom Format

```tsx
<DatePicker
  value={date}
  onChange={setDate}
  format="YYYY/MM/DD"
  placeholder="YYYY/MM/DD"
/>
```

### Error State

```tsx
<DatePicker
  value={date}
  onChange={setDate}
  error
  errorMessages={['Please select a valid date']}
/>
```

---

## Related Components

- [DateRangePicker](./DateRangePicker.md) - Date range selection
- [DateTimePicker](./DateTimePicker.md) - Date and time selection
- [TimePicker](./TimePicker.md) - Time selection
- [Calendar](./Calendar.md) - Calendar (internal component)

---

## Figma Mapping

| Figma Variant                | React Props                              |
| ---------------------------- | ---------------------------------------- |
| `DatePicker / Day`           | `<DatePicker mode="day">`                |
| `DatePicker / Month`         | `<DatePicker mode="month">`              |
| `DatePicker / Year`          | `<DatePicker mode="year">`               |
| `DatePicker / Week`          | `<DatePicker mode="week">`               |
| `DatePicker / Disabled`      | `<DatePicker disabled>`                  |
| `DatePicker / Error`         | `<DatePicker error>`                     |

---

## Behavior Notes

- **Suffix overlay when clearable**: When `clearable` is true, the clear icon overlays the calendar suffix icon. The calendar icon is hidden while the clear button is visible, providing a cleaner UX.

---

## Best Practices

1. **Provide CalendarContext**: Ensure usage within a Provider
2. **Choose appropriate date library**: Select dayjs/luxon/moment based on project needs
3. **Set reasonable default formats**: Adjust date format based on regional conventions
4. **Provide date restrictions**: Use `isDateDisabled` to restrict selectable range
5. **Pair with FormField**: Provide labels and error messages
