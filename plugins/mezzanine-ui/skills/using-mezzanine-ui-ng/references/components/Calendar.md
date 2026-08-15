# Calendar

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/calendar) · Verified 1.0.0-rc.4 (2026-04-24)

Standalone calendar panel for date selection. Supports multiple modes (day, week, month, quarter, half-year, year) and range selection. All date operations are delegated to the injected `MZN_CALENDAR_CONFIG` token — you must provide a `CalendarConfigs` instance (typically backed by `dayjs`) at the application root.

## Import

```ts
import { MznCalendar, MznRangeCalendar, MznCalendarConfigProvider } from '@mezzanine-ui/ng/calendar';
import {
  MZN_CALENDAR_CONFIG,
  createCalendarConfig,
  CalendarLocale,
} from '@mezzanine-ui/ng/calendar';
import type {
  CalendarConfigs,
  CalendarConfigOptions,
  CalendarDayAnnotation,
  CalendarQuickSelectOption,
} from '@mezzanine-ui/ng/calendar';

// Internal / advanced — exposed for custom-layout compositions only
import {
  MznCalendarCell,
  MznCalendarControls,
  MznCalendarDayOfWeek,
  MznCalendarDays,
  MznCalendarHalfYears,
  MznCalendarMonths,
  MznCalendarQuarters,
  MznCalendarWeeks,
  MznCalendarYears,
} from '@mezzanine-ui/ng/calendar';

// Dayjs adapter (most common):
import CalendarMethodsDayjs from '@mezzanine-ui/core/calendarMethodsDayjs';

import type { CalendarMode } from '@mezzanine-ui/core/calendar';
```

## Selector

`[mznCalendar]` — component applied to a container element.

## DI Tokens / Services Required

### MZN_CALENDAR_CONFIG (required)

All calendar and picker components rely on this token for date manipulation methods (add, subtract, format, compare, etc.) and locale settings. Provide it once at the root or feature module level:

```ts
// app.config.ts
import { ApplicationConfig } from '@angular/core';
import { MZN_CALENDAR_CONFIG, createCalendarConfig, CalendarLocale } from '@mezzanine-ui/ng/calendar';
import CalendarMethodsDayjs from '@mezzanine-ui/core/calendarMethodsDayjs';

export const appConfig: ApplicationConfig = {
  providers: [
    {
      provide: MZN_CALENDAR_CONFIG,
      useValue: createCalendarConfig(CalendarMethodsDayjs, {
        locale: CalendarLocale.ZH_TW,
        defaultDateFormat: 'YYYY/MM/DD',
        defaultTimeFormat: 'HH:mm:ss',
      }),
    },
  ],
};
```

Alternatively, use `MznCalendarConfigProvider` as an attribute directive on any ancestor element (see below).

If this token is missing, all Calendar and Picker components will throw at construction time.

## MznCalendar — Inputs

| Input                   | Type                                                         | Default   | Description                                                                             |
| ----------------------- | ------------------------------------------------------------ | --------- | --------------------------------------------------------------------------------------- |
| `mode`                  | `CalendarMode`                                               | `'day'`   | `'day' \| 'week' \| 'month' \| 'quarter' \| 'half-year' \| 'year'`                    |
| `value`                 | `DateType \| ReadonlyArray<DateType> \| undefined`           | —         | Selected date or range                                                                  |
| `referenceDate`         | `DateType`                                                   | `''`      | Controls the displayed month/year when uncontrolled                                     |
| `noShadow`              | `boolean`                                                    | `false`   | Remove card shadow (embed in other containers)                                          |
| `disabledFooterControl` | `boolean`                                                    | `false`   | Disable footer "Today / This week / …" button                                           |
| `disabledMonthSwitch`   | `boolean`                                                    | `false`   | Disable month control button in header                                                  |
| `disabledYearSwitch`    | `boolean`                                                    | `false`   | Disable year control button in header                                                   |
| `disableOnNext`         | `boolean`                                                    | `false`   | Disable next-period arrow                                                               |
| `disableOnDoubleNext`   | `boolean`                                                    | `false`   | Disable skip-forward (double) arrow                                                     |
| `disableOnPrev`         | `boolean`                                                    | `false`   | Disable prev-period arrow                                                               |
| `disableOnDoublePrev`   | `boolean`                                                    | `false`   | Disable skip-backward (double) arrow                                                    |
| `isDateDisabled`        | `((date: DateType) => boolean) \| undefined`                 | —         | Disable specific dates                                                                  |
| `isDateInRange`         | `((date: DateType) => boolean) \| undefined`                 | —         | Highlight dates in a range                                                              |
| `isMonthDisabled`       | `((date: DateType) => boolean) \| undefined`                 | —         | Disable specific months                                                                 |
| `isMonthInRange`        | `((date: DateType) => boolean) \| undefined`                 | —         | Highlight months in a range                                                             |
| `isYearDisabled`        | `((date: DateType) => boolean) \| undefined`                 | —         | Disable specific years                                                                  |
| `isYearInRange`         | `((date: DateType) => boolean) \| undefined`                 | —         | Highlight years in a range                                                              |
| `isWeekDisabled`        | `((date: DateType) => boolean) \| undefined`                 | —         | Disable specific weeks                                                                  |
| `isWeekInRange`         | `((date: DateType) => boolean) \| undefined`                 | —         | Highlight weeks in a range                                                              |
| `isQuarterDisabled`     | `((date: DateType) => boolean) \| undefined`                 | —         | Disable specific quarters                                                               |
| `isQuarterInRange`      | `((date: DateType) => boolean) \| undefined`                 | —         | Highlight quarters in a range                                                           |
| `isHalfYearDisabled`    | `((date: DateType) => boolean) \| undefined`                 | —         | Disable specific half-years                                                             |
| `isHalfYearInRange`     | `((date: DateType) => boolean) \| undefined`                 | —         | Highlight half-years in a range                                                         |
| `quickSelect`           | `{ activeId?: string; options: ReadonlyArray<CalendarQuickSelectOption> } \| undefined` | — | Quick-select panel shown on the left side |
| `renderAnnotations`     | `((date: DateType) => CalendarDayAnnotation) \| undefined`   | —         | Per-cell annotation badge rendered below the date number                                |
| `displayWeekDayLocale`  | `string \| undefined`                                        | —         | Override locale for weekday header labels                                               |
| `displayMonthLocale`    | `string \| undefined`                                        | —         | Override locale for month labels                                                        |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## MznCalendar — Outputs

| Output               | Type                               | Description                                          |
| -------------------- | ---------------------------------- | ---------------------------------------------------- |
| `dateChanged`        | `OutputEmitterRef<DateType>`       | Fires when a date/month/year cell is selected        |
| `cellHover`          | `OutputEmitterRef<DateType>`       | Fires when a date cell is hovered                    |
| `prevClicked`        | `OutputEmitterRef<CalendarMode>`   | Fires when the prev-period (‹) arrow is clicked      |
| `doublePrevClicked`  | `OutputEmitterRef<CalendarMode>`   | Fires when the skip-backward (‹‹) arrow is clicked  |
| `nextClicked`        | `OutputEmitterRef<CalendarMode>`   | Fires when the next-period (›) arrow is clicked      |
| `doubleNextClicked`  | `OutputEmitterRef<CalendarMode>`   | Fires when the skip-forward (››) arrow is clicked   |
| `monthControlClicked`| `OutputEmitterRef<void>`           | Fires when the month label button in the header is clicked |
| `yearControlClicked` | `OutputEmitterRef<void>`           | Fires when the year label button in the header is clicked  |

## CalendarDayAnnotation

```ts
interface CalendarDayAnnotation {
  readonly value: string;
  readonly color?: TypographyColor; // e.g. 'text-warning', 'text-error', 'brand'
}
```

## CalendarQuickSelectOption

```ts
interface CalendarQuickSelectOption {
  readonly id: string;
  readonly name: string;
  readonly disabled?: boolean;
  readonly onClick: () => void;
}
```

`quickSelect` input shape:

```ts
{
  activeId?: string;                              // id of the currently active option
  options: ReadonlyArray<CalendarQuickSelectOption>;
}
```

## ControlValueAccessor

No — `MznCalendar` is a panel component. Use `MznDatePicker` or `MznDateRangePicker` for form integration.

## Usage

```html
<!-- Basic day calendar -->
<div mznCalendar
  mode="day"
  [value]="selectedDate"
  (dateChanged)="selectedDate = $event"
></div>

<!-- Month mode with disabled dates -->
<div mznCalendar
  mode="month"
  [value]="selectedMonth"
  [isMonthDisabled]="isMonthDisabled"
  (dateChanged)="selectedMonth = $event"
></div>

<!-- Embedded (no shadow) with quick select -->
<div mznCalendar
  [noShadow]="true"
  [quickSelect]="quickSelectOptions"
  [renderAnnotations]="annotationFn"
  (dateChanged)="onDateChange($event)"
></div>
```

```ts
import { MznCalendar } from '@mezzanine-ui/ng/calendar';
import type { DateType } from '@mezzanine-ui/core/calendar';
import type { CalendarDayAnnotation, CalendarQuickSelectOption } from '@mezzanine-ui/ng/calendar';

selectedDate: DateType = '';

isMonthDisabled = (date: DateType): boolean => {
  return this.config.isAfter(date, this.config.getNow());
};

readonly quickSelectOptions = {
  activeId: 'today',
  options: [
    { id: 'today', name: '今天', onClick: () => { this.selectedDate = this.config.getNow(); } },
    { id: 'yesterday', name: '昨天', onClick: () => { this.selectedDate = this.config.addDay(this.config.getNow(), -1); } },
  ] satisfies CalendarQuickSelectOption[],
};

annotationFn = (date: DateType): CalendarDayAnnotation => ({
  value: this.hasEvent(date) ? '●' : '',
  color: 'brand',
});
```

---

## MznRangeCalendar

Dual-calendar range selection component. Renders two `MznCalendar` side-by-side. First click sets start; second click sets end (auto-normalised to `[start, end]`). Supports hover preview highlighting.

### Selector

`[mznRangeCalendar]`

### MznRangeCalendar — Inputs

| Input                   | Type                                                         | Default   | Description                                                     |
| ----------------------- | ------------------------------------------------------------ | --------- | --------------------------------------------------------------- |
| `mode`                  | `CalendarMode`                                               | `'day'`   | Calendar mode                                                   |
| `value`                 | `DateType \| ReadonlyArray<DateType> \| undefined`           | —         | Currently selected or partially selected range                  |
| `referenceDate`         | `DateType`                                                   | `''`      | Initial reference date for the left calendar                    |
| `showFooterActions`     | `boolean`                                                    | `false`   | Show Confirm / Cancel footer buttons                            |
| `quickSelect`           | `{ activeId?: string; options: ReadonlyArray<CalendarQuickSelectOption> } \| undefined` | — | Quick-select panel |
| `isDateDisabled`        | `((date: DateType) => boolean) \| undefined`                 | —         | Disable specific dates                                          |
| `isDateInRange`         | `((date: DateType) => boolean) \| undefined`                 | —         | External in-range predicate (overridden by hover range)         |
| `isMonthDisabled`       | `((date: DateType) => boolean) \| undefined`                 | —         | Disable specific months                                         |
| `isMonthInRange`        | `((date: DateType) => boolean) \| undefined`                 | —         | Highlight months in range                                       |
| `isWeekDisabled`        | `((date: DateType) => boolean) \| undefined`                 | —         | Disable specific weeks                                          |
| `isWeekInRange`         | `((date: DateType) => boolean) \| undefined`                 | —         | Highlight weeks in range                                        |
| `isYearDisabled`        | `((date: DateType) => boolean) \| undefined`                 | —         | Disable specific years                                          |
| `isYearInRange`         | `((date: DateType) => boolean) \| undefined`                 | —         | Highlight years in range                                        |
| `isQuarterDisabled`     | `((date: DateType) => boolean) \| undefined`                 | —         | Disable specific quarters                                       |
| `isQuarterInRange`      | `((date: DateType) => boolean) \| undefined`                 | —         | Highlight quarters in range                                     |
| `isHalfYearDisabled`    | `((date: DateType) => boolean) \| undefined`                 | —         | Disable specific half-years                                     |
| `isHalfYearInRange`     | `((date: DateType) => boolean) \| undefined`                 | —         | Highlight half-years in range                                   |
| `disabledMonthSwitch`   | `boolean`                                                    | `false`   | Disable month switch buttons on both calendars                  |
| `disabledYearSwitch`    | `boolean`                                                    | `false`   | Disable year switch buttons on both calendars                   |
| `disableOnNext`         | `boolean`                                                    | `false`   | Disable next arrow on the right calendar                        |
| `disableOnDoubleNext`   | `boolean`                                                    | `false`   | Disable double-next arrow on the right calendar                 |
| `disableOnPrev`         | `boolean`                                                    | `false`   | Disable prev arrow on the left calendar                         |
| `disableOnDoublePrev`   | `boolean`                                                    | `false`   | Disable double-prev arrow on the left calendar                  |
| `displayWeekDayLocale`  | `string \| undefined`                                        | —         | Override locale for weekday header labels                       |
| `displayMonthLocale`    | `string \| undefined`                                        | —         | Override locale for month labels                                |
| `renderAnnotations`     | `((date: DateType) => CalendarDayAnnotation) \| undefined`   | —         | Per-cell annotation badge                                       |

### MznRangeCalendar — Outputs

| Output        | Type                                                   | Description                                               |
| ------------- | ------------------------------------------------------ | --------------------------------------------------------- |
| `rangeChanged`| `OutputEmitterRef<[DateType, DateType \| undefined]>`  | Fires on each click; second item is `undefined` after first click |
| `cellHover`   | `OutputEmitterRef<DateType>`                           | Fires when a date cell is hovered                         |
| `confirmed`   | `OutputEmitterRef<void>`                               | Confirm button clicked (`showFooterActions=true`)         |
| `cancelled`   | `OutputEmitterRef<void>`                               | Cancel button clicked (`showFooterActions=true`)          |

```html
<div mznRangeCalendar
  [value]="selectedRange"
  [showFooterActions]="true"
  (rangeChanged)="onRangeChange($event)"
  (confirmed)="applyRange()"
  (cancelled)="closePanel()"
></div>
```

---

## MznCalendarConfigProvider

Attribute directive that provides `CalendarConfigs` to all descendant calendar/picker components via DI — without touching `app.config.ts`. Useful for lazy-loaded modules.

### Selector

`[mznCalendarConfigProvider]`

### MznCalendarConfigProvider — Inputs

| Input               | Type              | Default        | Description                                                       |
| ------------------- | ----------------- | -------------- | ----------------------------------------------------------------- |
| `methods`           | `CalendarMethods` | **(required)** | Date library implementation (e.g. `CalendarMethodsDayjs`)         |
| `locale`            | `CalendarLocaleValue` | `'en-US'`  | Locale string for weekday/month names and week-start-day          |
| `defaultDateFormat` | `string`          | `'YYYY-MM-DD'` | Default date format string                                        |
| `defaultTimeFormat` | `string`          | `'HH:mm:ss'`  | Default time format string                                        |

```html
<div mznCalendarConfigProvider [methods]="dayjsMethods" locale="zh-TW">
  <mzn-date-picker [(ngModel)]="date" />
</div>
```

---

## Internal sub-components

These are internal pieces normally composed inside `MznCalendar` / `MznRangeCalendar`; exposed for advanced custom-layout use cases only. Prefer using `MznCalendar` directly.

| Class                   | Selector                 | Role                                                                |
| ----------------------- | ------------------------ | ------------------------------------------------------------------- |
| `MznCalendarCell`       | `[mznCalendarCell]`      | Single day/month/year cell (active / today / disabled states)       |
| `MznCalendarControls`   | `[mznCalendarControls]`  | Header control row with prev/next + skip arrows                     |
| `MznCalendarDayOfWeek`  | `[mznCalendarDayOfWeek]` | Row of weekday name labels (Sun/Mon/…)                              |
| `MznCalendarDays`       | `[mznCalendarDays]`      | Day-mode panel — one month of date cells                            |
| `MznCalendarWeeks`      | `[mznCalendarWeeks]`     | Week-mode panel — rows of week-ranges                               |
| `MznCalendarMonths`     | `[mznCalendarMonths]`    | Month-mode panel — 12 month cells                                   |
| `MznCalendarQuarters`   | `[mznCalendarQuarters]`  | Quarter-mode panel — 3 years × 4 quarters grid                      |
| `MznCalendarHalfYears`  | `[mznCalendarHalfYears]` | Half-year-mode panel — 5 years × 2 halves grid                      |
| `MznCalendarYears`      | `[mznCalendarYears]`     | Year-mode panel — 20-year grid                                      |

### MznCalendarCell — Inputs

**Selector**: `[mznCalendarCell]`

| Input            | Type                  | Default     | Description                                    |
| ---------------- | --------------------- | ----------- | ---------------------------------------------- |
| `active`         | `boolean`             | `false`     | 此格為目前選取值                               |
| `today`          | `boolean`             | `false`     | 此格為今天                                     |
| `disabled`       | `boolean`             | `false`     | 停用（不可選）                                 |
| `isRangeStart`   | `boolean`             | `false`     | 區間選取的起點格                               |
| `isRangeEnd`     | `boolean`             | `false`     | 區間選取的終點格                               |
| `isWeekend`      | `boolean`             | `false`     | 週末樣式                                       |
| `withAnnotation` | `boolean`             | `false`     | 顯示註記標記（搭配 `CalendarDayAnnotation`）   |
| `role`           | `string \| undefined` | `undefined` | 覆寫 host 的 `role` 屬性（無障礙用）           |

### MznCalendarControls — Inputs

**Selector**: `[mznCalendarControls]`

| Input            | Type      | Default | Description                        |
| ---------------- | --------- | ------- | ---------------------------------- |
| `showPrev`       | `boolean` | `false` | 顯示上一頁箭頭                     |
| `showNext`       | `boolean` | `false` | 顯示下一頁箭頭                     |
| `showDoublePrev` | `boolean` | `false` | 顯示快速上一頁（雙箭頭，跳一個年度單位） |
| `showDoubleNext` | `boolean` | `false` | 顯示快速下一頁（雙箭頭）           |

`CalendarConfigs` / `CalendarConfigOptions` types (imported above) describe the value supplied to `MZN_CALENDAR_CONFIG` / `createCalendarConfig` — useful when you need to accept or re-expose the config from your own service.

---

## Notes

- `MZN_CALENDAR_CONFIG` **must** be provided before any Calendar/Picker component is used. Either use the `providers` array in `app.config.ts` or wrap with `[mznCalendarConfigProvider]`.
- `DateType` is a string or Day.js object depending on the adapter. With `CalendarMethodsDayjs`, it is a `Dayjs` or an ISO string accepted by dayjs.
- `MznCalendar` is a panel — it does not manage input/trigger UI. For picker behaviour (trigger + popover), use `MznDatePicker`, `MznDateRangePicker`, `MznDateTimePicker`, or `MznDateTimeRangePicker`.
- `referenceDate` controls the visible month when `value` is empty. This is useful for range pickers that want to anchor the calendar view independently of the selected value.
- `quickSelect` items define `onClick` directly — the consumer is responsible for updating the `value` input inside `onClick`.
- `renderAnnotations` returns a single `CalendarDayAnnotation` object (not an array) per date cell.
