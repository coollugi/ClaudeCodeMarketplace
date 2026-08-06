# DateRangePicker Component

> **Category**: Data Entry
>
> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-daterangepicker--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/DateRangePicker) · Verified 1.4.1 (2026-07-01)

A date range picker for selecting start and end dates. Must be used with `CalendarContext`. Internally composed of `DateRangePickerCalendar` and `RangePickerTrigger`.

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
import { DateRangePicker } from '@mezzanine-ui/react';
import {
  DateRangePickerCalendar,
  useDateRangeCalendarControls,
  useDateRangePickerValue,
} from '@mezzanine-ui/react/DateRangePicker';
import type {
  DateRangePickerProps,
  DateRangePickerCalendarProps,
  UseDateRangePickerValueProps,
} from '@mezzanine-ui/react';
```

---

## DateRangePicker Props

`DateRangePickerProps` combines properties from `DateRangePickerCalendarProps` and `RangePickerTriggerProps`, plus its own `confirmMode`, `actions`, etc.

| Property               | Type                                              | Default        | Description                    |
| ---------------------- | ------------------------------------------------- | -------------- | ------------------------------ |
| `actions`              | `CalendarFooterActionsProps['actions']`            | -              | Custom action buttons          |
| `calendarProps`        | `DateRangePickerCalendarProps['calendarProps']`    | -              | Calendar props                 |
| `className`            | `string`                                          | -              | Outer container CSS class      |
| `clearable`            | `boolean`                                         | `true`         | Whether clearable              |
| `confirmMode`          | `'immediate' \| 'manual'`                         | `'immediate'`  | Confirmation mode              |
| `defaultValue`         | `[DateType, DateType]`                            | -              | Default value                  |
| `disabled`             | `boolean`                                         | `false`        | Whether disabled               |
| `disabledMonthSwitch`  | `boolean`                                         | `false`        | Disable month switching        |
| `disabledYearSwitch`   | `boolean`                                         | `false`        | Disable year switching         |
| `disableOnDoubleNext`  | `boolean`                                         | -              | Disable double arrow next      |
| `disableOnDoublePrev`  | `boolean`                                         | -              | Disable double arrow prev      |
| `disableOnNext`        | `boolean`                                         | -              | Disable next                   |
| `disableOnPrev`        | `boolean`                                         | -              | Disable prev                   |
| `displayMonthLocale`   | `string`                                          | -              | Month display locale           |
| `displayWeekDayLocale` | `string`                                          | -              | Weekday display locale         |
| `error`                | `boolean`                                         | `false`        | Error state                    |
| `errorMessagesFrom`    | `RangePickerTriggerProps['errorMessagesFrom']`    | -              | Start field error messages     |
| `errorMessagesTo`      | `RangePickerTriggerProps['errorMessagesTo']`      | -              | End field error messages       |
| `fadeProps`             | `FadeProps`                                       | -              | Fade animation props           |
| `firstCalendarRef`     | `RefObject<HTMLDivElement>`                       | -              | First calendar ref             |
| `format`               | `string`                                          | Depends on mode | Display format (determined by mode) |
| `fullWidth`            | `boolean`                                         | `false`        | Whether full width             |
| `inputFromPlaceholder` | `string`                                          | -              | Start field placeholder        |
| `inputFromProps`       | `RangePickerTriggerProps['inputFromProps']`        | -              | Start field props              |
| `inputToPlaceholder`   | `string`                                          | -              | End field placeholder          |
| `inputToProps`         | `RangePickerTriggerProps['inputToProps']`          | -              | End field props                |
| `isDateDisabled`       | `(date: DateType) => boolean`                     | -              | Date disable check             |
| `isHalfYearDisabled`   | `(date: DateType) => boolean`                     | -              | Half-year disable check        |
| `isMonthDisabled`      | `(date: DateType) => boolean`                     | -              | Month disable check            |
| `isQuarterDisabled`    | `(date: DateType) => boolean`                     | -              | Quarter disable check          |
| `isWeekDisabled`       | `(date: DateType) => boolean`                     | -              | Week disable check             |
| `isYearDisabled`       | `(date: DateType) => boolean`                     | -              | Year disable check             |
| `mode`                 | `CalendarMode`                                    | `'day'`        | Selection mode                 |
| `onCalendarToggle`     | `(open: boolean) => void`                         | -              | Calendar toggle callback       |
| `onChange`             | `(target?: RangePickerValue) => void`             | -              | Change callback                |
| `popperProps`          | `Omit<InputTriggerPopperProps, ...>`              | -              | Popper positioning props       |
| `prefix`               | `ReactNode`                                       | -              | Prefix element                 |
| `quickSelect`          | `Pick<CalendarQuickSelectProps, 'activeId' \| 'options'>` | -       | Quick select options           |
| `readOnly`             | `boolean`                                         | -              | Whether read-only              |
| `referenceDate`        | `DateType`                                        | -              | Reference date                 |
| `renderAnnotations`    | `RangeCalendarProps['renderAnnotations']`          | -              | Custom date annotation renderer |
| `required`             | `boolean`                                         | `false`        | Whether required               |
| `secondCalendarRef`    | `RefObject<HTMLDivElement>`                       | -              | Second calendar ref            |
| `size`                 | `'main' \| 'sub'`                                 | -              | Size                           |
| `validateFrom`         | `RangePickerTriggerProps['validateFrom']`          | -              | Start field validation         |
| `validateTo`           | `RangePickerTriggerProps['validateTo']`            | -              | End field validation           |
| `value`                | `RangePickerValue`                                | -              | Selected value (controlled)    |

> **confirmMode behavior**:
> - `'immediate'` (default): Automatically triggers onChange and closes the calendar after selecting two dates
> - `'manual'`: Requires clicking the confirm button to trigger; if `actions` is not provided, confirm/cancel buttons are auto-generated

---

## Portal Behavior (v1.0.4+)

Since v1.0.4 the calendar popper portals out of the DOM subtree by default, fixing clipping inside `Modal` / `overflow: hidden` ancestors and enabling viewport-edge flip. To restore inline (non-portal) rendering per call site:

```tsx
<DateRangePicker
  popperProps={{ disablePortal: true }}
  value={value}
  onChange={setValue}
/>
```

### Keyboard Navigation (v1.1.0+)

`Tab` / `Shift+Tab` navigation between the trigger inputs and the portalled calendar is restored in v1.1.0 via an explicit logical focus loop, reliable even inside a `Modal` focus trap.

---

## Type Definitions

```tsx
type CalendarMode = 'day' | 'week' | 'month' | 'year' | 'quarter' | 'half-year';

// From @mezzanine-ui/core/picker
type RangePickerValue<T = DateType> = undefined[] | [T, T];

// Item structure within quickSelect.options
interface CalendarQuickSelectOption {
  id: string;
  name: string;
  disabled?: boolean;
  onClick: VoidFunction;
}
```

---

## Usage Examples

### Basic Usage

```tsx
import { DateRangePicker } from '@mezzanine-ui/react';
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';

function BasicExample() {
  const [value, setValue] = useState<[string, string] | undefined>();

  return (
    <CalendarConfigProviderDayjs>
      <DateRangePicker
        value={value}
        onChange={setValue}
      />
    </CalendarConfigProviderDayjs>
  );
}
```

### With Default Value

```tsx
<DateRangePicker
  defaultValue={['2024-01-01', '2024-01-31']}
  onChange={handleChange}
/>
```

### Custom Format

```tsx
<DateRangePicker
  format="YYYY/MM/DD"
  inputFromPlaceholder="Start date"
  inputToPlaceholder="End date"
  onChange={handleChange}
/>
```

### Manual Confirm Mode

```tsx
<DateRangePicker
  confirmMode="manual"
  onChange={handleChange}
/>
```

### Disable Specific Dates

```tsx
<DateRangePicker
  isDateDisabled={(date) => {
    // Disable weekends
    const dayOfWeek = dayjs(date).day();
    return dayOfWeek === 0 || dayOfWeek === 6;
  }}
  onChange={handleChange}
/>
```

### Month Selection Mode

```tsx
<DateRangePicker
  mode="month"
  format="YYYY-MM"
  onChange={handleChange}
/>
```

### With Quick Select

```tsx
<DateRangePicker
  quickSelect={{
    activeId: activeQuickSelectId,
    options: [
      { id: 'today', name: 'Today', onClick: () => handleQuickSelect([today, today]) },
      { id: 'week', name: 'This Week', onClick: () => handleQuickSelect([startOfWeek, endOfWeek]) },
      { id: 'month', name: 'This Month', onClick: () => handleQuickSelect([startOfMonth, endOfMonth]) },
    ],
  }}
  onChange={handleChange}
/>
```

### Custom Action Buttons

```tsx
<DateRangePicker
  actions={{
    primaryButtonProps: {
      children: 'Confirm',
      onClick: handleConfirm,
    },
    secondaryButtonProps: {
      children: 'Cancel',
      onClick: handleCancel,
    },
  }}
  onChange={handleChange}
/>
```

---

## Figma Mapping

| Figma Variant                    | React Props                |
| -------------------------------- | -------------------------- |
| `DateRangePicker / Default`      | Default                    |
| `DateRangePicker / Disabled`     | `disabled`                 |
| `DateRangePicker / Error`        | `error`                    |
| `DateRangePicker / With Value`   | `value` is set             |
| `DateRangePicker / Day Mode`     | `mode="day"`               |
| `DateRangePicker / Month Mode`   | `mode="month"`             |

---

## Behavior Notes

- **Suffix overlay when clearable**: When `clearable` is true, the clear icon overlays the calendar suffix icon. The calendar icon is hidden while the clear button is visible.

---

## Best Practices

1. **Context required**: Must be wrapped in CalendarContext.Provider
2. **Date library choice**: Can use dayjs, luxon, or moment
3. **Disable logic**: Use `isDateDisabled` and similar functions to disable specific dates
4. **Confirm mode**: Use `confirmMode="manual"` when explicit confirmation is needed
5. **Quick select**: Provide quick select options for commonly used date ranges
