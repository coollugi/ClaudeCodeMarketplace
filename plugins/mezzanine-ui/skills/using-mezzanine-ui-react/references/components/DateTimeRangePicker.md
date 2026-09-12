# DateTimeRangePicker Component

> **Category**: Data Entry
>
> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/story/data-entry-datetimerangepicker--playground) — 當行為不確定時，Storybook 的互動範例為權威參考。
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/DateTimeRangePicker) · Verified 1.5.1 (2026-09-12)

A date-time range picker that combines two DateTimePickers to select start and end date-times. Must be used with `CalendarContext`. The direction icon switches between `LongTailArrowRightIcon` / `LongTailArrowDownIcon` based on the `direction` prop.

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
import { DateTimeRangePicker } from '@mezzanine-ui/react';
import type {
  DateTimeRangePickerProps,
  DateTimeRangePickerValue,
} from '@mezzanine-ui/react';
```

---

## DateTimeRangePicker Props

`DateTimeRangePickerProps` extends `Omit<DateTimePickerProps, 'defaultValue' | 'onChange' | 'value' | 'ref' | 'prefix'>`. All inherited props are applied to both DateTimePickers simultaneously.

### Own Props

| Property    | Type                                        | Default | Description              |
| ----------- | ------------------------------------------- | ------- | ------------------------ |
| `className` | `string`                                    | -       | Outer container CSS class |
| `direction` | `'row' \| 'column'`                         | `'row'` | Layout direction of the two pickers |
| `onChange`  | `(value: DateTimeRangePickerValue) => void` | -       | Range value change callback |
| `value`     | `DateTimeRangePickerValue`                  | -       | Selected value (controlled) |

### Inherited from DateTimePickerProps (shared by both DateTimePickers)

| Property               | Type                                           | Default         | Description              |
| ---------------------- | ---------------------------------------------- | --------------- | ------------------------ |
| `calendarProps`        | `Omit<CalendarProps, ...>`                     | -               | Calendar props           |
| `calendarRef`          | `RefObject<HTMLDivElement \| null>`            | -               | Calendar ref             |
| `clearable`            | `boolean`                                      | `true`          | Whether clearable        |
| `disabled`             | `boolean`                                      | `false`         | Whether disabled         |
| `disabledMonthSwitch`  | `boolean`                                      | `false`         | Disable month switching  |
| `disabledYearSwitch`   | `boolean`                                      | `false`         | Disable year switching   |
| `disableOnDoubleNext`  | `boolean`                                      | -               | Disable double arrow next |
| `disableOnDoublePrev`  | `boolean`                                      | -               | Disable double arrow prev |
| `disableOnNext`        | `boolean`                                      | -               | Disable next             |
| `disableOnPrev`        | `boolean`                                      | -               | Disable prev             |
| `displayMonthLocale`   | `string`                                       | `locale` (from `CalendarContext`, resolved inside each inner `DateTimePicker`) | Month display locale |
| `error`                | `boolean`                                      | `false`         | Error state              |
| `fadeProps`             | `FadeProps`                                    | -               | Fade animation props     |
| `formatDate`           | `string`                                       | Depends on mode | Date display format      |
| `formatTime`           | `string`                                       | `'HH:mm:ss'`   | Time display format (defaults to `'HH:mm'` when `hideSecond`) |
| `fullWidth`            | `boolean`                                      | `false`         | Whether full width       |
| `hideHour`             | `boolean`                                      | -               | Hide hours               |
| `hideMinute`           | `boolean`                                      | -               | Hide minutes             |
| `hideSecond`           | `boolean`                                      | -               | Hide seconds             |
| `hourStep`             | `number`                                       | -               | Hour step                |
| `isDateDisabled`       | `(date: DateType) => boolean`                  | -               | Date disable check       |
| `isHalfYearDisabled`   | `(date: DateType) => boolean`                  | -               | Half-year disable check  |
| `isMonthDisabled`      | `(date: DateType) => boolean`                  | -               | Month disable check      |
| `isQuarterDisabled`    | `(date: DateType) => boolean`                  | -               | Quarter disable check    |
| `isWeekDisabled`       | `(date: DateType) => boolean`                  | -               | Week disable check       |
| `isYearDisabled`       | `(date: DateType) => boolean`                  | -               | Year disable check       |
| `minuteStep`           | `number`                                       | -               | Minute step              |
| `mode`                 | `CalendarMode`                                 | `'day'`         | Calendar selection mode  |
| `onClear`              | `MouseEventHandler`                            | -               | Clear callback           |
| `onPanelToggle`        | `(open: boolean, focusedInput: FocusedInput) => void` | -        | Panel toggle callback    |
| `placeholderLeft`      | `string`                                       | -               | Date field placeholder   |
| `placeholderRight`     | `string`                                       | -               | Time field placeholder   |
| `popperProps`          | `Omit<InputTriggerPopperProps, ...>`           | -               | Calendar Popper props    |
| `popperPropsTime`      | `TimePickerPanelProps['popperProps']`           | -               | Time Popper props        |
| `readOnly`             | `boolean`                                      | -               | Whether read-only        |
| `referenceDate`        | `DateType`                                     | Current time    | Reference date           |
| `required`             | `boolean`                                      | `false`         | Whether required         |
| `secondStep`           | `number`                                       | -               | Second step              |
| `size`                 | `'main' \| 'sub'`                              | -               | Size                     |

---

## Portal Behavior (v1.0.4+)

Since v1.0.4 the calendar and time pickers inside each DateTimePicker portal out by default, fixing clipping inside `Modal` / `overflow: hidden` ancestors. To restore inline rendering, pass `popperProps={{ disablePortal: true }}` or `popperPropsTime={{ disablePortal: true }}` — these are applied to both inner DateTimePickers simultaneously.

### Keyboard Navigation (v1.1.0+)

`Tab` / `Shift+Tab` navigation between trigger inputs and portalled panels is restored in v1.1.0 via an explicit logical focus loop, reliable inside a `Modal` focus trap.

---

## Type Definitions

```tsx
type DateTimeRangePickerValue = [DateType | undefined, DateType | undefined];
type FocusedInput = 'left' | 'right' | null;
```

---

## Usage Examples

### Basic Usage

```tsx
import { DateTimeRangePicker } from '@mezzanine-ui/react';
import type { DateTimeRangePickerValue } from '@mezzanine-ui/react';
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';

function BasicExample() {
  const [value, setValue] = useState<DateTimeRangePickerValue>([
    undefined,
    undefined,
  ]);

  return (
    <CalendarConfigProviderDayjs>
      <DateTimeRangePicker
        value={value}
        onChange={setValue}
      />
    </CalendarConfigProviderDayjs>
  );
}
```

### Vertical Layout

```tsx
<DateTimeRangePicker
  direction="column"
  value={value}
  onChange={setValue}
/>
```

### Custom Format and Hide Seconds

```tsx
<DateTimeRangePicker
  formatDate="YYYY/MM/DD"
  formatTime="HH:mm"
  hideSecond
  placeholderLeft="Select date"
  placeholderRight="Select time"
  value={value}
  onChange={setValue}
/>
```

### Disable Specific Dates

```tsx
<DateTimeRangePicker
  isDateDisabled={(date) => {
    // Disable past dates
    return dayjs(date).isBefore(dayjs(), 'day');
  }}
  value={value}
  onChange={setValue}
/>
```

### Set Time Steps

```tsx
<DateTimeRangePicker
  hourStep={1}
  minuteStep={15}
  hideSecond
  formatTime="HH:mm"
  value={value}
  onChange={setValue}
/>
```

---

## Component Structure

DateTimeRangePicker is composed of two DateTimePickers separated by an arrow icon:

```
direction="row":
┌──────────────────────────┐   →   ┌──────────────────────────┐
│ [Date] ~ [Time]       📅 │       │ [Date] ~ [Time]       📅 │
└──────────────────────────┘       └──────────────────────────┘

direction="column":
┌──────────────────────────┐
│ [Date] ~ [Time]       📅 │
└──────────────────────────┘
              ↓
┌──────────────────────────┐
│ [Date] ~ [Time]       📅 │
└──────────────────────────┘
```

---

## Best Practices

### 場景推薦

| 使用場景 | 推薦設定 | 說明 |
|---------|--------|------|
| 時間區間查詢 | `direction="row"`, 足夠寬度 | 橫向排列，節省垂直空間 |
| 報表日期篩選 | `hideSecond=true`, `minuteStep={15}` | 隱藏秒數，分鐘步長 15 |
| 日誌時間範圍 | `formatTime="HH:mm:ss"` | 顯示完整時間含秒數 |
| 窄容器佈局 | `direction="column"` | 使用縱向排列適配窄容器 |
| 排除過去時間 | `isDateDisabled` 檢查 | 禁用過去日期，只允許未來 |

### 常見錯誤

1. **兩個日期選擇器使用不同格式**
   ```tsx
   // ❌ 錯誤：無法保持一致的格式
   <DateTimeRangePicker
     formatDate="YYYY-MM-DD"
     formatTime="HH:mm"
     value={value}
     onChange={setValue}
   />
   // 轉換後可能導致格式不一致

   // ✅ 正確：格式在兩個選擇器都統一應用
   <DateTimeRangePicker
     formatDate="YYYY-MM-DD"
     formatTime="HH:mm"
     value={value}
     onChange={setValue}
   />
   ```

2. **未正確驗證日期範圍**
   ```tsx
   // ❌ 錯誤：允許結束日期早於開始日期
   <DateTimeRangePicker
     value={value}
     onChange={setValue}
   />

   // ✅ 正確：在 onChange 中驗證範圍
   const handleChange = (newValue: DateTimeRangePickerValue) => {
     const [from, to] = newValue;
     if (from && to && dayjs(to).isBefore(from)) {
       console.warn('End date must be after start date');
       return;
     }
     setValue(newValue);
   };
   <DateTimeRangePicker
     value={value}
     onChange={handleChange}
   />
   ```

3. **縱向佈局時未調整容器寬度**
   ```tsx
   // ❌ 錯誤：縱向排列導致視覺擁擠
   <div style={{ width: '100px' }}>
     <DateTimeRangePicker direction="column" value={value} onChange={setValue} />
   </div>

   // ✅ 正確：縱向佈局需要適當的容器寬度
   <div style={{ width: '300px' }}>
     <DateTimeRangePicker direction="column" value={value} onChange={setValue} />
   </div>
   ```

4. **未考慮部分選擇狀態**
   ```tsx
   // ❌ 錯誤：未處理只有開始日期的狀態
   const [value, setValue] = useState<DateTimeRangePickerValue>(['2024-01-01', '2024-12-31']);
   // 用戶可能只選擇了開始日期

   // ✅ 正確：檢查完整的日期範圍
   const isRangeValid = (value: DateTimeRangePickerValue) => {
     const [from, to] = value;
     return from !== undefined && to !== undefined && dayjs(to).isAfter(from);
   };
   ```

5. **禁用規則邏輯過於嚴格**
   ```tsx
   // ❌ 錯誤：禁用了所有過去日期，導致無法編輯歷史記錄
   <DateTimeRangePicker
     isDateDisabled={(date) => dayjs(date).isBefore(dayjs(), 'day')}
     value={value}
     onChange={setValue}
   />

   // ✅ 正確：根據實際需求設定禁用規則
   <DateTimeRangePicker
     isDateDisabled={(date) => {
       // 只禁用當前日期之後（若用於查詢過去）
       return dayjs(date).isAfter(dayjs(), 'day');
     }}
     value={value}
     onChange={setValue}
   />
   ```

### 核心原則

1. **上下文必需**: 必須包裝在 CalendarContext.Provider 中
2. **方向選擇**: 空間充足時使用 `row`；窄佈局時使用 `column`
3. **共享屬性**: 所有 DateTimePicker 相關屬性同時應用於兩個選擇器
4. **格式一致**: `formatDate` 和 `formatTime` 應與實際用途相符
5. **受控模式**: value 是 `[from, to]` 陣列；任一端改變時 onChange 觸發
6. **範圍驗證**: 在應用層驗證 `to` 晚於 `from` 的條件
7. **無障礙考慮**: 提供清晰的佔位符文本幫助用戶理解選擇順序
