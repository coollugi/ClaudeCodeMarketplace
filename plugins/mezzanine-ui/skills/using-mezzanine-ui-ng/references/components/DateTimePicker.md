# DateTimePicker

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/date-time-picker) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-date-time-picker--docs

A combined date-and-time picker with two side-by-side formatted inputs separated by a visual divider. Focusing the left input opens a `MznDatePickerCalendar`; focusing the right opens a `MznTimePickerPanel` (with Ok/Cancel). The component follows React's prop shape exactly: flat inputs mirror React flat props, and `calendarProps` / `inputLeftProps` / `inputRightProps` / `popperProps` / `popperPropsTime` bundles mirror React bundles. Flat props take precedence over corresponding bundle fields. Implements `ControlValueAccessor` binding `DateType | undefined`. Requires `MZN_CALENDAR_CONFIG`.

## Import

```ts
import { MznDateTimePicker } from '@mezzanine-ui/ng/date-time-picker';
// Note: MznDateTimePickerCalendarProps, MznDateTimePickerInputProps, and
// MznDateTimePickerPopperProps are NOT re-exported from the package index.
// Import them directly from the component file if needed:
import type {
  MznDateTimePickerCalendarProps,
  MznDateTimePickerInputProps,
  MznDateTimePickerPopperProps,
} from '@mezzanine-ui/ng/date-time-picker/date-time-picker.component';
import type { DateType } from '@mezzanine-ui/core/calendar';

// Required provider:
import { MznCalendarConfigProvider } from '@mezzanine-ui/ng/calendar';
```

## Selector

`<div mznDateTimePicker ...>` — attribute-directive component

## Inputs

| Input                    | Type                                     | Default    | Description                                                     |
| ------------------------ | ---------------------------------------- | ---------- | --------------------------------------------------------------- |
| `value`                  | `DateType`                               | —          | Controlled date-time value                                      |
| `defaultValue`           | `DateType`                               | —          | Initial uncontrolled value                                      |
| `mode`                   | `CalendarMode`                           | `'day'`    | Calendar date mode (currently `'day'` only)                     |
| `formatDate`             | `string`                                 | —          | Left input date format; defaults to config default              |
| `formatTime`             | `string`                                 | —          | Right input time format; depends on `hideSecond`                |
| `placeholderLeft`        | `string`                                 | —          | Left input placeholder                                          |
| `placeholderRight`       | `string`                                 | —          | Right input placeholder                                         |
| `disabled`               | `boolean`                                | `false`    | Disabled state                                                  |
| `readOnly`               | `boolean`                                | `false`    | Read-only state                                                 |
| `error`                  | `boolean`                                | `false`    | Error state styling                                             |
| `fullWidth`              | `boolean`                                | `false`    | Stretch to container width                                      |
| `clearable`              | `boolean`                                | `true`     | Show clear button                                               |
| `forceShowClearable`     | `boolean`                                | `false`    | Always show clear button                                        |
| `hideSuffixWhenClearable`| `boolean`                                | `false`    | Hide suffix icon when clear button is showing                   |
| `hideHour`               | `boolean`                                | `false`    | Hide hour column in time panel                                  |
| `hideMinute`             | `boolean`                                | `false`    | Hide minute column in time panel                                |
| `hideSecond`             | `boolean`                                | `false`    | Hide second column in time panel                                |
| `hourStep`               | `number`                                 | `1`        | Hour scroll step                                                |
| `minuteStep`             | `number`                                 | `1`        | Minute scroll step                                              |
| `secondStep`             | `number`                                 | `1`        | Second scroll step                                              |
| `required`               | `boolean`                                | `false`    | Required state                                                  |
| `hoverValueLeft`         | `string`                                 | —          | Left input hover preview value                                  |
| `disableOnNext`          | `boolean`                                | —          | Disable calendar "next" nav                                     |
| `disableOnPrev`          | `boolean`                                | —          | Disable calendar "prev" nav                                     |
| `disableOnDoubleNext`    | `boolean`                                | —          | Disable calendar "double next" nav                              |
| `disableOnDoublePrev`    | `boolean`                                | —          | Disable calendar "double prev" nav                              |
| `displayMonthLocale`     | `string`                                 | —          | Locale for calendar month labels (flat; overrides `calendarProps`) |
| `isDateDisabled`         | `(date: DateType) => boolean`            | —          | Disable specific dates (flat; overrides `calendarProps`)        |
| `isMonthDisabled`        | `(date: DateType) => boolean`            | —          | Disable months                                                  |
| `isYearDisabled`         | `(date: DateType) => boolean`            | —          | Disable years                                                   |
| `isWeekDisabled`         | `(date: DateType) => boolean`            | —          | Disable weeks                                                   |
| `isQuarterDisabled`      | `(date: DateType) => boolean`            | —          | Disable quarters                                                |
| `isHalfYearDisabled`     | `(date: DateType) => boolean`            | —          | Disable half-years                                              |
| `errorMessagesLeft`      | `FormattedInputErrorMessages`            | —          | Left input error messages config                                |
| `errorMessagesRight`     | `FormattedInputErrorMessages`            | —          | Right input error messages config                               |
| `validateLeft`           | `(isoDate: string) => boolean`           | —          | Custom validator for left input typed value                     |
| `validateRight`          | `(isoDate: string) => boolean`           | —          | Custom validator for right input typed value                    |
| `size`                   | `TextFieldSize`                          | `'main'`   | Input field size: `'main' \| 'sub'`                             |
| `warning`                | `boolean`                                | `false`    | Warning state styling                                           |
| `disabledMonthSwitch`    | `boolean`                                | —          | Disable calendar month-switch button (flat; overrides `calendarProps`) |
| `disabledYearSwitch`     | `boolean`                                | —          | Disable calendar year-switch button (flat; overrides `calendarProps`)  |
| `calendarProps`          | `MznDateTimePickerCalendarProps`         | —          | Bundle: calendar escape-hatch props                             |
| `inputLeftProps`         | `MznDateTimePickerInputProps`            | —          | Bundle: left input escape-hatch props (`ariaLabel`)             |
| `inputRightProps`        | `MznDateTimePickerInputProps`            | —          | Bundle: right input escape-hatch props                          |
| `popperProps`            | `MznDateTimePickerPopperProps`           | —          | Bundle: calendar popper options                                 |
| `popperPropsTime`        | `MznDateTimePickerPopperProps`           | —          | Bundle: time panel popper options                               |
| `referenceDate` | `DateType \| undefined` | `undefined` | 面板初次開啟時的參考日期（未選值時決定顯示哪個月份） |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output                | Type                                                    | Description                                                   |
| --------------------- | ------------------------------------------------------- | ------------------------------------------------------------- |
| `change`              | `OutputEmitterRef<DateType \| undefined>`               | Emitted when the combined date-time value changes             |
| `blurLeft`            | `OutputEmitterRef<FocusEvent>`                          | Left input blurred                                            |
| `blurRight`           | `OutputEmitterRef<FocusEvent>`                          | Right input blurred                                           |
| `cancel`              | `OutputEmitterRef<void>`                                | Time panel cancelled                                          |
| `changeLeft`          | `OutputEmitterRef<string>`                              | Left input typed value changed (ISO date string)              |
| `changeRight`         | `OutputEmitterRef<string>`                              | Right input typed value changed (ISO time string)             |
| `clear`               | `OutputEmitterRef<MouseEvent>`                          | Clear button clicked                                          |
| `confirm`             | `OutputEmitterRef<void>`                                | Time panel confirmed                                          |
| `focusLeft`           | `OutputEmitterRef<FocusEvent>`                          | Left input focused                                            |
| `focusRight`          | `OutputEmitterRef<FocusEvent>`                          | Right input focused                                           |
| `hover`               | `OutputEmitterRef<DateType>`                            | Calendar date hovered (for preview)                           |
| `leave`               | `OutputEmitterRef<void>`                                | Calendar mouseleave                                           |
| `leftComplete`        | `OutputEmitterRef<void>`                                | Left input mask fully filled                                  |
| `panelToggle`         | `OutputEmitterRef<{ open: boolean; focusedInput: 'left' \| 'right' \| null }>` | Panel open/close toggle     |
| `pasteIsoValueLeft`   | `OutputEmitterRef<string>`                              | Valid ISO date pasted into left input                         |
| `pasteIsoValueRight`  | `OutputEmitterRef<string>`                              | Valid ISO time pasted into right input                        |
| `rightComplete`       | `OutputEmitterRef<void>`                                | Right input mask fully filled                                 |

## ControlValueAccessor

`MznDateTimePicker` implements `ControlValueAccessor` binding `DateType | undefined`.

```html
<!-- formControlName -->
<form [formGroup]="form">
  <div mznDateTimePicker formControlName="scheduledAt" [fullWidth]="true"></div>
</form>

<!-- formControl -->
<div mznDateTimePicker [formControl]="appointmentCtrl" [hideSecond]="true"></div>

<!-- ngModel -->
<div mznDateTimePicker [(ngModel)]="eventTime" placeholderLeft="Date" placeholderRight="Time"></div>
```

## Required Provider

```ts
// app.config.ts
import { MznCalendarConfigProvider } from '@mezzanine-ui/ng/calendar';

export const appConfig: ApplicationConfig = {
  providers: [
    MznCalendarConfigProvider({ firstDayOfWeek: 1, locale: 'zh-TW' }),
  ],
};
```

## Usage

```html
<!-- Appointment scheduler with flat props -->
<div mznFormField name="appointmentTime" label="Appointment">
  <div mznDateTimePicker
    formControlName="appointmentTime"
    placeholderLeft="Date"
    placeholderRight="Time"
    [hideSecond]="true"
    [isDateDisabled]="isPastDate"
    [fullWidth]="true">
  </div>
</div>

<!-- Using calendarProps bundle (prefer hoisting to a field to avoid OnPush issues) -->
<div mznDateTimePicker
  [(ngModel)]="eventDateTime"
  [calendarProps]="calBundle">
</div>
```

```ts
import { MznDateTimePicker } from '@mezzanine-ui/ng/date-time-picker';
import type { MznDateTimePickerCalendarProps } from '@mezzanine-ui/ng/date-time-picker';
import type { DateType } from '@mezzanine-ui/core/calendar';

@Component({
  imports: [MznDateTimePicker, MznFormField, ReactiveFormsModule],
})
export class ScheduleFormComponent {
  // Hoist bundle to a field to ensure stable reference for OnPush
  readonly calBundle: MznDateTimePickerCalendarProps = {
    displayMonthLocale: 'zh-TW',
    isDateDisabled: (d: DateType) => d < '2024-01-01',
  };

  readonly isPastDate = (d: DateType): boolean =>
    d < new Date().toISOString().split('T')[0];

  readonly form = new FormGroup({
    appointmentTime: new FormControl<DateType | undefined>(undefined),
  });
}
```

## MznDateTimePickerCalendarProps Fields

| Field                  | Type                             | Description                                               |
| ---------------------- | -------------------------------- | --------------------------------------------------------- |
| `disabledMonthSwitch`  | `boolean`                        | Disable calendar month-switch button                      |
| `disabledYearSwitch`   | `boolean`                        | Disable calendar year-switch button                       |
| `displayMonthLocale`   | `string`                         | Locale for month label headers                            |
| `displayWeekDayLocale` | `string`                         | Locale for weekday column headers (bundle-only)           |
| `isDateDisabled`       | `(date: DateType) => boolean`    | Custom date disable predicate                             |
| `isHalfYearDisabled`   | `(date: DateType) => boolean`    | Custom half-year disable predicate                        |
| `isMonthDisabled`      | `(date: DateType) => boolean`    | Custom month disable predicate                            |
| `isQuarterDisabled`    | `(date: DateType) => boolean`    | Custom quarter disable predicate                          |
| `isWeekDisabled`       | `(date: DateType) => boolean`    | Custom week disable predicate                             |
| `isYearDisabled`       | `(date: DateType) => boolean`    | Custom year disable predicate                             |
| `referenceDate`        | `DateType`                       | Initial reference date for calendar display               |

## Dependency Injection

`MznDateTimePicker` injects the following services internally:

| Token / Service        | Purpose                                                        |
| ---------------------- | -------------------------------------------------------------- |
| `MZN_CALENDAR_CONFIG`  | Date parsing, formatting, locale — required at app or feature level |
| `ClickAwayService`     | Closes calendar/time panel on outside clicks (`ngAfterViewInit`) |

## Notes

- **Flat vs. bundle inputs**: Flat inputs (e.g. `[isDateDisabled]`) always override the corresponding field in `calendarProps`. Use flat props for individual options; use `calendarProps` bundle when passing many calendar options as a group (matches React's `calendarProps` escape hatch).
- **Always hoist bundle inputs** to component fields (`readonly calBundle = {...}`) — inline object literals in templates cause infinite change detection loops under OnPush.
- The time panel uses a two-phase commit: changes are `pending` until the user clicks "Ok". Clicking "Cancel" discards pending time changes.
- The `hideSecond: true` shortcut also adjusts the `formatTime` default to `'HH:mm'`.
- Requires `MZN_CALENDAR_CONFIG`. See `DatePicker.md` for `MznCalendarConfigProvider` setup.
