# Calendar Component

> **Category**: Utility
>
> **Storybook**: `Utility/Calendar`
>
> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/internal-calendar--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Calendar) · Verified 1.4.2 (2026-08-07)

Calendar component for displaying and selecting dates. Requires `CalendarConfigProvider` (which provides `CalendarContext`). Supports six modes: day, week, month, year, quarter, and half-year.

## ⚠️ Prerequisite: CalendarConfigProvider

所有日曆/日期/時間相關元件（Calendar, DatePicker, DateRangePicker, DateTimePicker, DateTimeRangePicker, MultipleDatePicker, TimePicker, TimeRangePicker, TimePanel）都依賴 `CalendarContext`。
**必須**在應用程式根層級（如 `layout.tsx` 或 `App.tsx`）包裹 `CalendarConfigProvider`，否則會拋出 runtime error：

```
Cannot find values in your context. Make sure you use `CalendarConfigProvider`
in your app and pass in one of the following as methods: `CalendarMethodsMoment`.
```

### 基本設定（選擇一種日期庫）

```tsx
// layout.tsx 或 App.tsx
import { CalendarConfigProvider } from '@mezzanine-ui/react';
import { CalendarMethodsMoment } from '@mezzanine-ui/core/calendar';
// 或 dayjs: import { CalendarMethodsDayjs } from '@mezzanine-ui/core/calendar';

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <CalendarConfigProvider methods={CalendarMethodsMoment}>
      {children}
    </CalendarConfigProvider>
  );
}
```

### 便捷封裝（推薦）

```tsx
// 使用 Moment.js
import { CalendarConfigProviderMoment } from '@mezzanine-ui/react/Calendar';

<CalendarConfigProviderMoment locale="zh-TW">
  {children}
</CalendarConfigProviderMoment>

// 使用 Day.js
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';

<CalendarConfigProviderDayjs locale="zh-TW">
  {children}
</CalendarConfigProviderDayjs>
```

### CalendarConfigProvider Props

| Property            | Type                   | Default             | Description            |
| ------------------- | ---------------------- | ------------------- | ---------------------- |
| `methods`           | `CalendarMethods`      | **required**        | 日期運算方法（Moment/Dayjs） |
| `locale`            | `CalendarLocaleValue`  | `CalendarLocale.EN_US` | 語系（影響星期起始日、月份名稱） |
| `defaultDateFormat` | `string`               | `'YYYY-MM-DD'`     | 預設日期格式           |
| `defaultTimeFormat` | `string`               | `'HH:mm:ss'`       | 預設時間格式           |

---

## Import

```tsx
import {
  Calendar,
  CalendarCell,
  CalendarConfigProvider,
  CalendarContext,
  CalendarControls,
  CalendarDayOfWeek,
  CalendarDays,
  CalendarHalfYears,
  CalendarMonths,
  CalendarQuarters,
  CalendarWeeks,
  CalendarYears,
  RangeCalendar,
  useCalendarContext,
  useCalendarControlModifiers,
  useCalendarControls,
  useCalendarModeStack,
  useRangeCalendarControls,
} from '@mezzanine-ui/react';

// CalendarConfigProviderDayjs / Luxon / Moment must be imported from sub-path
import {
  CalendarConfigProviderDayjs,
  CalendarConfigProviderLuxon,
  CalendarConfigProviderMoment,
} from '@mezzanine-ui/react/Calendar';

import type {
  CalendarProps,
  CalendarCellProps,
  CalendarConfigProviderProps,
  CalendarConfigs,
  CalendarControlsProps,
  CalendarDayOfWeekProps,
  CalendarDaysProps,
  CalendarHalfYearsProps,
  CalendarMonthsProps,
  CalendarQuartersProps,
  CalendarWeeksProps,
  CalendarYearsProps,
  CalendarControlModifier,
  UseCalendarControlModifiersResult,
  RangeCalendarProps,
} from '@mezzanine-ui/react';

// CalendarLocale must be imported from sub-path
import type { CalendarLocale } from '@mezzanine-ui/react/Calendar';
```

---

## Calendar Props

| Property                | Type                                                               | Default | Description                          |
| ----------------------- | ------------------------------------------------------------------ | ------- | ------------------------------------ |
| `calendarDaysProps`     | `Omit<CalendarDaysProps, ...>`                                     | -       | Additional props for day view        |
| `calendarMonthsProps`   | `Omit<CalendarMonthsProps, ...>`                                   | -       | Additional props for month view      |
| `calendarWeeksProps`    | `Omit<CalendarWeeksProps, ...>`                                    | -       | Additional props for week view       |
| `calendarYearsProps`    | `Omit<CalendarYearsProps, ...>`                                    | -       | Additional props for year view       |
| `calendarQuartersProps` | `Omit<CalendarQuartersProps, ...>`                                 | -       | Additional props for quarter view    |
| `calendarHalfYearsProps`| `Omit<CalendarHalfYearsProps, ...>`                                | -       | Additional props for half-year view  |
| `disableOnDoubleNext`   | `boolean`                                                          | -       | Disable year fast-forward            |
| `disableOnDoublePrev`   | `boolean`                                                          | -       | Disable year fast-backward           |
| `disableOnNext`         | `boolean`                                                          | -       | Disable month fast-forward           |
| `disableOnPrev`         | `boolean`                                                          | -       | Disable month fast-backward          |
| `displayMonthLocale`    | `string`                                                           | -       | Month display localization           |
| `displayWeekDayLocale`  | `string`                                                           | -       | Weekday display localization         |
| `isDateDisabled`        | `(date: DateType) => boolean`                                      | -       | Date disabled check                  |
| `isDateInRange`         | `(date: DateType) => boolean`                                      | -       | Date range check                     |
| `isHalfYearDisabled`    | `(date: DateType) => boolean`                                      | -       | Half-year disabled check             |
| `isHalfYearInRange`     | `(date: DateType) => boolean`                                      | -       | Half-year range check                |
| `isMonthDisabled`       | `(date: DateType) => boolean`                                      | -       | Month disabled check                 |
| `isMonthInRange`        | `(date: DateType) => boolean`                                      | -       | Month range check                    |
| `isQuarterDisabled`     | `(date: DateType) => boolean`                                      | -       | Quarter disabled check               |
| `isQuarterInRange`      | `(date: DateType) => boolean`                                      | -       | Quarter range check                  |
| `isWeekDisabled`        | `(date: DateType) => boolean`                                      | -       | Week disabled check                  |
| `isWeekInRange`         | `(date: DateType) => boolean`                                      | -       | Week range check                     |
| `isYearDisabled`        | `(date: DateType) => boolean`                                      | -       | Year disabled check                  |
| `isYearInRange`         | `(date: DateType) => boolean`                                      | -       | Year range check                     |
| `onDateHover`           | `(date: DateType) => void`                                         | -       | Date hover callback                  |
| `onHalfYearHover`       | `(date: DateType) => void`                                         | -       | Half-year hover callback             |
| `onMonthHover`          | `(date: DateType) => void`                                         | -       | Month hover callback                 |
| `onQuarterHover`        | `(date: DateType) => void`                                         | -       | Quarter hover callback               |
| `onWeekHover`           | `(date: DateType) => void`                                         | -       | Week hover callback                  |
| `onYearHover`           | `(date: DateType) => void`                                         | -       | Year hover callback                  |
| `renderAnnotations`     | `(date: DateType) => { value: string; color?: TypographyColor }`   | -       | Custom date annotations              |
| `disabledFooterControl` | `boolean`                                                          | `false` | Disable footer control element       |
| `disabledMonthSwitch`   | `boolean`                                                          | `false` | Disable Month calendar button click  |
| `disabledYearSwitch`    | `boolean`                                                          | `false` | Disable Year calendar button click   |
| `mode`                  | `CalendarMode`                                                     | `'day'` | Calendar display mode                |
| `onChange`              | `(target: DateType) => void`                                       | -       | Click handler for every calendar cell |
| `onMonthControlClick`   | `VoidFunction`                                                     | -       | Click handler for month control button |
| `onNext`                | `(currentMode: CalendarMode) => void`                              | -       | Click handler for next button        |
| `onDoubleNext`          | `(currentMode: CalendarMode) => void`                              | -       | Click handler for double-next button |
| `onPrev`                | `(currentMode: CalendarMode) => void`                              | -       | Click handler for prev button        |
| `onDoublePrev`          | `(currentMode: CalendarMode) => void`                              | -       | Click handler for double-prev button |
| `onYearControlClick`    | `VoidFunction`                                                     | -       | Click handler for year control button |
| `quickSelect`           | `Pick<CalendarQuickSelectProps, 'activeId' \| 'options'>`          | -       | Quick select options                 |
| `referenceDate`         | `DateType`                                                         | **required** | Reference date for the calendar  |
| `value`                 | `DateType \| DateType[]`                                           | -       | Selected date(s)                     |

---

## CalendarMode Type

```tsx
type CalendarMode = 'day' | 'week' | 'month' | 'year' | 'quarter' | 'half-year';
```

---

## Usage Examples

### Basic Usage with useCalendarControls

```tsx
import { Calendar, useCalendarControls } from '@mezzanine-ui/react';
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';
import dayjs from 'dayjs';

function BasicCalendar() {
  const [value, setValue] = useState<string | undefined>();
  const defaultRef = dayjs().toISOString();

  const {
    currentMode,
    referenceDate,
    onMonthControlClick,
    onYearControlClick,
    onNext,
    onPrev,
    onDoubleNext,
    onDoublePrev,
    popModeStack,
    updateReferenceDate,
  } = useCalendarControls(defaultRef);

  return (
    <CalendarConfigProviderDayjs>
      <Calendar
        calendarDaysProps={{}}
        isDateDisabled={(date) => {
          // Disable weekends
          const dayOfWeek = dayjs(date).day();
          return dayOfWeek === 0 || dayOfWeek === 6;
        }}
        onDateHover={(date) => {
          // Handle date hover
        }}
      />
    </CalendarConfigProviderDayjs>
  );
}
```

### Date Range Highlighting

```tsx
<Calendar
  isDateInRange={(date) => {
    return dayjs(date).isBetween(startDate, endDate);
  }}
  onDateHover={(date) => {
    // Handle hover for range display
  }}
/>
```

### Custom Date Annotations

```tsx
<Calendar
  renderAnnotations={(date) => {
    const event = events.find(e => dayjs(e.date).isSame(date, 'day'));
    return {
      value: event ? event.label : '--',
      color: event ? 'primary' : 'text-neutral',
    };
  }}
/>
```

### Using RangeCalendar for Date Ranges

```tsx
import { RangeCalendar, useRangeCalendarControls } from '@mezzanine-ui/react';

function DateRangeExample() {
  const [value, setValue] = useState<[string, string | undefined]>(['', undefined]);

  const {
    currentMode,
    referenceDates,
    updateFirstReferenceDate,
    updateSecondReferenceDate,
    onFirstNext,
    onFirstPrev,
    onFirstDoubleNext,
    onFirstDoublePrev,
    onSecondNext,
    onSecondPrev,
    onSecondDoubleNext,
    onSecondDoublePrev,
  } = useRangeCalendarControls(dayjs().toISOString());

  return (
    <RangeCalendar
      referenceDate={referenceDates[0]}
      value={value}
      onChange={setValue}
      isDateInRange={(date) => {
        const [start, end] = value;
        if (!end) return false;
        return dayjs(date).isBetween(start, end, null, '[]');
      }}
    />
  );
}
```

---

## CalendarConfigProviderProps

| Property            | Type                  | Default                 | Description                                    |
| ------------------- | --------------------- | ----------------------- | ---------------------------------------------- |
| `children`          | `ReactNode`           | -                       | Child content                                  |
| `defaultDateFormat` | `string`              | `'YYYY-MM-DD'`          | Default date format                            |
| `defaultTimeFormat` | `string`              | `'HH:mm:ss'`            | Default time format                            |
| `locale`            | `CalendarLocaleValue` | `CalendarLocale.EN_US`  | Localization (affects week start day, etc.)     |
| `methods`           | `CalendarMethods`     | **required**            | Date methods (e.g., CalendarMethodsDayjs)       |

---

## useCalendarControls

```tsx
function useCalendarControls(
  referenceDateProp: DateType,
  mode?: CalendarMode,
): {
  currentMode: CalendarMode;
  referenceDate: DateType;
  updateReferenceDate: (date: DateType) => void;
  popModeStack: () => void;
  onMonthControlClick: () => void;
  onYearControlClick: () => void;
  onNext?: () => void;
  onPrev?: () => void;
  onDoubleNext?: () => void;
  onDoublePrev?: () => void;
};
```

---

## useRangeCalendarControls

```tsx
function useRangeCalendarControls(
  referenceDateProp: DateType,
  mode?: CalendarMode,
): {
  currentMode: CalendarMode;
  referenceDates: [DateType, DateType];
  updateFirstReferenceDate: (date: DateType) => void;
  updateSecondReferenceDate: (date: DateType) => void;
  popModeStack: () => void;
  onMonthControlClick: () => void;
  onYearControlClick: () => void;
  onFirstNext?: () => void;
  onFirstPrev?: () => void;
  onFirstDoubleNext?: () => void;
  onFirstDoublePrev?: () => void;
  onSecondNext?: () => void;
  onSecondPrev?: () => void;
  onSecondDoubleNext?: () => void;
  onSecondDoublePrev?: () => void;
};
```

---

## RangeCalendar Props

> Inherits from a Pick of `CalendarProps`: `renderAnnotations`, all `is*Disabled`/`is*InRange`/`on*Hover` props, `displayWeekDayLocale`, `displayMonthLocale`, `disabledMonthSwitch`, `disabledYearSwitch`, `disableOnNext`/`disableOnPrev`/`disableOnDoubleNext`/`disableOnDoublePrev`.
>
> `ref` (forwardRef) points to the root `HTMLDivElement`.

### Own Props

| Property             | Type                                                      | Default  | Description                    |
| -------------------- | --------------------------------------------------------- | -------- | ------------------------------ |
| `actions`            | `CalendarFooterActionsProps['actions']`                    | -        | Footer action buttons          |
| `calendarProps`      | `Omit<CalendarProps, 'mode' \| 'value' \| 'onChange' \| ...>` | -    | Props passed to each calendar  |
| `firstCalendarRef`   | `RefObject<HTMLDivElement \| null>`                        | -        | Ref for the first calendar     |
| `mode`               | `CalendarMode`                                            | `'day'`  | Display mode                   |
| `onChange`           | `(value: [DateType, DateType \| undefined]) => void`       | -        | Date range selection callback  |
| `quickSelect`        | `Pick<CalendarQuickSelectProps, 'activeId' \| 'options'>` | -        | Quick select options           |
| `referenceDate`      | `DateType`                                                | **required** | Reference date             |
| `secondCalendarRef`  | `RefObject<HTMLDivElement \| null>`                        | -        | Ref for the second calendar    |
| `value`              | `DateType \| DateType[]`                                  | -        | Selected date(s)               |

### Inherited from CalendarProps

| Property                | Type                                                             | Default | Description                    |
| ----------------------- | ---------------------------------------------------------------- | ------- | ------------------------------ |
| `disableOnDoubleNext`   | `boolean`                                                        | -       | Disable year fast-forward      |
| `disableOnDoublePrev`   | `boolean`                                                        | -       | Disable year fast-backward     |
| `disableOnNext`         | `boolean`                                                        | -       | Disable month fast-forward     |
| `disableOnPrev`         | `boolean`                                                        | -       | Disable month fast-backward    |
| `disabledMonthSwitch`   | `boolean`                                                        | -       | Disable Month calendar button click |
| `disabledYearSwitch`    | `boolean`                                                        | -       | Disable Year calendar button click  |
| `displayMonthLocale`    | `string`                                                         | -       | Month display localization     |
| `displayWeekDayLocale`  | `string`                                                         | -       | Weekday display localization   |
| `isDateDisabled`        | `(date: DateType) => boolean`                                    | -       | Date disabled check            |
| `isDateInRange`         | `(date: DateType) => boolean`                                    | -       | Date range check               |
| `isHalfYearDisabled`    | `(date: DateType) => boolean`                                    | -       | Half-year disabled check       |
| `isHalfYearInRange`     | `(date: DateType) => boolean`                                    | -       | Half-year range check          |
| `isMonthDisabled`       | `(date: DateType) => boolean`                                    | -       | Month disabled check           |
| `isMonthInRange`        | `(date: DateType) => boolean`                                    | -       | Month range check              |
| `isQuarterDisabled`     | `(date: DateType) => boolean`                                    | -       | Quarter disabled check         |
| `isQuarterInRange`      | `(date: DateType) => boolean`                                    | -       | Quarter range check            |
| `isWeekDisabled`        | `(date: DateType) => boolean`                                    | -       | Week disabled check            |
| `isWeekInRange`         | `(date: DateType) => boolean`                                    | -       | Week range check               |
| `isYearDisabled`        | `(date: DateType) => boolean`                                    | -       | Year disabled check            |
| `isYearInRange`         | `(date: DateType) => boolean`                                    | -       | Year range check               |
| `onDateHover`           | `(date: DateType) => void`                                       | -       | Date hover callback            |
| `onHalfYearHover`       | `(date: DateType) => void`                                       | -       | Half-year hover callback       |
| `onMonthHover`          | `(date: DateType) => void`                                       | -       | Month hover callback           |
| `onQuarterHover`        | `(date: DateType) => void`                                       | -       | Quarter hover callback         |
| `onWeekHover`           | `(date: DateType) => void`                                       | -       | Week hover callback            |
| `onYearHover`           | `(date: DateType) => void`                                       | -       | Year hover callback            |
| `renderAnnotations`     | `(date: DateType) => { value: string; color?: TypographyColor }` | -       | Custom date annotations        |

---

## useCalendarModeStack

```tsx
function useCalendarModeStack(
  mode: CalendarMode,
): {
  currentMode: CalendarMode;
  pushModeStack: (newMode: CalendarMode) => void;
  popModeStack: () => void;
};
```

---

## useCalendarControlModifiers

```tsx
type CalendarControlModifier = (value: DateType) => DateType;

type UseCalendarControlModifiersResult = Record<
  CalendarMode,
  {
    single: [CalendarControlModifier, CalendarControlModifier] | null;
    double: [CalendarControlModifier, CalendarControlModifier] | null;
  }
>;

function useCalendarControlModifiers(): UseCalendarControlModifiersResult;
```

Returns prev/next modifier functions for each CalendarMode (single corresponds to month/segment switching, double corresponds to year switching). Some modes do not have double (e.g., month, year, quarter, half-year).

---

## CalendarQuickSelectProps

| Property   | Type                                                              | Default    | Description                      |
| ---------- | ----------------------------------------------------------------- | ---------- | -------------------------------- |
| `activeId` | `string`                                                          | -          | Currently selected option id     |
| `options`  | `{ id: string; name: string; disabled?: boolean; onClick: VoidFunction }[]` | **required** | Quick select option list |

---

## CalendarFooterActionsProps

| Property  | Type                                                                      | Default | Description            |
| --------- | ------------------------------------------------------------------------- | ------- | ---------------------- |
| `actions` | `{ secondaryButtonProps: ButtonProps; primaryButtonProps: ButtonProps }`    | -       | Footer action buttons  |

---

## CalendarConfigProviderDayjs / Luxon / Moment

Convenience calendar Provider components with built-in date library methods. Props are the same as `CalendarConfigProviderProps` (excluding `methods`).

```tsx
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';

<CalendarConfigProviderDayjs locale={CalendarLocale.ZH_TW}>
  <Calendar ... />
</CalendarConfigProviderDayjs>
```

---

---

## Figma Mapping

| Figma Variant                      | React Props                              |
| ---------------------------------- | ---------------------------------------- |
| `Calendar / Day`                   | Default calendar display                 |
| `Calendar / With Annotations`      | `renderAnnotations` prop provided        |

---

## Best Practices

### 場景推薦

| 使用情境 | 推薦用法 | 原因 |
| ------- | ------- | ---- |
| 單一日期選擇 | `mode="day"` + `value={selectedDate}` | 預設模式，直覺易用 |
| 月份選擇 | `mode="month"` + `useCalendarControls` | 跳過日期層級，加快選擇 |
| 年份選擇 | `mode="year"` + `useCalendarControls` | 快速選擇跨年份日期 |
| 日期區間選擇 | `<RangeCalendar>` + `useRangeCalendarControls` | 雙日曆，同時選擇開始和結束 |
| 禁用特定日期 | `isDateDisabled={date => weekends.includes(date)}` | 限制只能選工作日 |
| 顯示日期範圍 | `isDateInRange={date => isBetween(date, start, end)}` | 視覺標記日期區間 |
| 快速選擇預設值 | `quickSelect={{activeId: 'today', options: [...]}}` | 便捷按鈕（如「今天」、「本月」） |
| 自訂日期註記 | `renderAnnotations={date => ({value: count, color: 'primary'})}` | 在日期上顯示事件計數 |
| 多套日期庫支援 | `<CalendarConfigProviderDayjs \| Luxon \| Moment>` | 根據專案選擇日期工具 |
| 國際化 | `locale={CalendarLocale.ZH_TW}` | 設定週首、月份名稱等語言 |

### 常見錯誤

#### ❌ 未包裹 CalendarConfigProvider
```tsx
// 錯誤：無提供者，日期處理失敗
<Calendar referenceDate={date} onChange={handleChange} />
```

#### ✅ 正確做法：必須包裹提供者
```tsx
<CalendarConfigProviderDayjs locale={CalendarLocale.ZH_TW}>
  <Calendar referenceDate={date} onChange={handleChange} />
</CalendarConfigProviderDayjs>
```

#### ❌ 頻繁重建控制函數
```tsx
const MyCalendar = ({ referenceDate }) => {
  // 每次渲染重建控制邏輯，效能低落
  const controls = useCalendarControls(referenceDate);
  return <Calendar {...controls} />;
};
```

#### ✅ 正確做法：穩定化控制邏輯
```tsx
const MyCalendar = ({ initialDate }) => {
  const [referenceDate, setReferenceDate] = useState(initialDate);
  const controls = useMemo(
    () => useCalendarControls(referenceDate),
    [referenceDate]
  );
  return <Calendar {...controls} />;
};
```

#### ❌ 雙向日期選擇未使用 RangeCalendar
```tsx
// 錯誤：兩個獨立 Calendar，狀態難同步
<Calendar value={startDate} onChange={setStartDate} />
<Calendar value={endDate} onChange={setEndDate} />
```

#### ✅ 正確做法：使用 RangeCalendar
```tsx
<RangeCalendar
  referenceDate={referenceDate}
  value={[startDate, endDate]}
  onChange={([start, end]) => {
    setStartDate(start);
    setEndDate(end);
  }}
/>
```

#### ❌ 禁用日期條件複雜
```tsx
const isDateDisabled = (date) => {
  // 每次呼叫都重新計算，效能差
  return generateBlacklistDates().includes(date);
};
```

#### ✅ 正確做法：預先計算禁用日期集
```tsx
const disabledDates = useMemo(
  () => new Set(generateBlacklistDates()),
  []
);

const isDateDisabled = useCallback(
  (date) => disabledDates.has(date),
  [disabledDates]
);
```

#### ❌ 日期註記未優化
```tsx
<Calendar
  renderAnnotations={(date) => {
    // 每個日期都執行複雜查詢，導致卡頓
    return { value: queryDatabase(date).length.toString() };
  }}
/>
```

#### ✅ 正確做法：預先構建註記快取
```tsx
const eventCounts = useMemo(
  () => createEventCountMap(events),
  [events]
);

<Calendar
  renderAnnotations={(date) => ({
    value: eventCounts[date] || '0',
  })}
/>
```

#### ❌ 模式切換手動管理
```tsx
const [mode, setMode] = useState('day');
// 手動追蹤模式歷史，容易出錯
```

#### ✅ 正確做法：使用 useCalendarModeStack
```tsx
const { currentMode, pushModeStack, popModeStack } =
  useCalendarModeStack('day');

// 切換模式時自動管理歷史
<Calendar
  mode={currentMode}
  onMonthControlClick={() => pushModeStack('month')}
/>
```

### 核心要點

1. **CalendarConfigProvider 必需**：提供日期處理方法（dayjs/luxon/moment）
2. **控制邏輯分離**：使用 hooks（useCalendarControls、useRangeCalendarControls）管理狀態
3. **效能優化**：禁用日期檢查和註記應使用 useMemo/useCallback
4. **模式堆疊**：useCalendarModeStack 自動管理日→月→年切換歷史
5. **區間選擇**：優先用 RangeCalendar 而非兩個獨立 Calendar
6. **國際化支援**：透過 locale prop 自動調整週首、月份名稱
