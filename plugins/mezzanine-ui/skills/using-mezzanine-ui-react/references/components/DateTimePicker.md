# DateTimePicker Component

> **Category**: Data Entry
>
> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-datetimepicker--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/DateTimePicker) · Verified 1.5.1 (2026-09-12)

A date-time picker that allows selecting both date and time simultaneously. Must be used with `CalendarContext`. Internally composed of `DatePickerCalendar`, `TimePickerPanel`, and `PickerTriggerWithSeparator`.

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
import { DateTimePicker } from '@mezzanine-ui/react';
import type { DateTimePickerProps } from '@mezzanine-ui/react';
```

---

## DateTimePicker Props

`DateTimePickerProps` extends three interfaces (each excluding some internal properties):
- `DatePickerCalendarProps` (excludes `anchor`, `onChange`, `open`, `referenceDate`, `value`)
- `TimePickerPanelProps` (excludes `anchor`, `onChange`, `open`, `popperProps`, `value`)
- `PickerTriggerWithSeparatorProps` (excludes multiple internal input-related properties)

### Own Props

| Property         | Type                                                     | Default                                  | Description              |
| ---------------- | -------------------------------------------------------- | ---------------------------------------- | ------------------------ |
| `defaultValue`   | `DateType`                                               | -                                        | Default value            |
| `formatDate`     | `string`                                                 | From `CalendarContext` (typically `'YYYY-MM-DD'`) | Date display format      |
| `formatTime`     | `string`                                                 | From `CalendarContext` (typically `'HH:mm:ss'` or `'HH:mm'` when `hideSecond`) | Time display format      |
| `onChange`       | `(target?: DateType) => void`                            | -                                        | Change callback          |
| `onPanelToggle`  | `(open: boolean, focusedInput: FocusedInput) => void`    | -                                        | Panel toggle callback    |
| `popperPropsTime`| `TimePickerPanelProps['popperProps']`                    | -                                        | Time Popper props        |
| `referenceDate`  | `DateType`                                               | -                                        | Reference date           |
| `value`          | `DateType`                                               | -                                        | Selected value (controlled) |

> `FocusedInput = 'left' | 'right' | null`

### Inherited from DatePickerCalendarProps

| Property              | Type                                    | Default  | Description              |
| --------------------- | --------------------------------------- | -------- | ------------------------ |
| `calendarProps`       | `Omit<CalendarProps, ...>`              | -        | Calendar props           |
| `calendarRef`         | `RefObject<HTMLDivElement \| null>`     | -        | Calendar ref             |
| `disabledMonthSwitch` | `boolean`                               | `false`  | Disable month switching  |
| `disabledYearSwitch`  | `boolean`                               | `false`  | Disable year switching   |
| `disableOnDoubleNext` | `boolean`                               | -        | Disable double arrow next |
| `disableOnDoublePrev` | `boolean`                               | -        | Disable double arrow prev |
| `disableOnNext`       | `boolean`                               | -        | Disable next             |
| `disableOnPrev`       | `boolean`                               | -        | Disable prev             |
| `displayMonthLocale`  | `string`                                | `locale` (from `CalendarContext`) | Month display locale |
| `fadeProps`            | `FadeProps`                             | -        | Fade animation props     |
| `isDateDisabled`      | `(date: DateType) => boolean`           | -        | Date disable check       |
| `isHalfYearDisabled`  | `(date: DateType) => boolean`           | -        | Half-year disable check  |
| `isMonthDisabled`     | `(date: DateType) => boolean`           | -        | Month disable check      |
| `isQuarterDisabled`   | `(date: DateType) => boolean`           | -        | Quarter disable check    |
| `isWeekDisabled`      | `(date: DateType) => boolean`           | -        | Week disable check       |
| `isYearDisabled`      | `(date: DateType) => boolean`           | -        | Year disable check       |
| `mode`                | `CalendarMode`                          | `'day'`  | Calendar selection mode  |
| `onHover`             | `(date: DateType) => void`              | -        | Fired when hovering a calendar cell |
| `onLeave`             | `() => void`                            | -        | Fired when mouse leaves the calendar panel |
| `popperProps`         | `Omit<InputTriggerPopperProps, ...>`    | -        | Calendar Popper props    |

### Inherited from TimePickerPanelProps

| Property      | Type      | Default | Description  |
| ------------- | --------- | ------- | ------------ |
| `hideHour`    | `boolean` | -       | Hide hours   |
| `hideMinute`  | `boolean` | -       | Hide minutes |
| `hideSecond`  | `boolean` | -       | Hide seconds |
| `hourStep`    | `number`  | -       | Hour step    |
| `minuteStep`  | `number`  | -       | Minute step  |
| `secondStep`  | `number`  | -       | Second step  |

### Inherited from PickerTriggerWithSeparatorProps

| Property           | Type               | Default | Description              |
| ------------------ | ------------------ | ------- | ------------------------ |
| `className`        | `string`           | -       | CSS class                |
| `clearable`        | `boolean`          | `true`  | Whether clearable        |
| `disabled`         | `boolean`          | `false` | Whether disabled         |
| `error`            | `boolean`          | `false` | Error state              |
| `errorMessagesLeft` | `FormattedInputProps['errorMessages']` | - | Date field error messages |
| `errorMessagesRight` | `FormattedInputProps['errorMessages']` | - | Time field error messages |
| `fullWidth`        | `boolean`          | `false` | Whether full width       |
| `inputLeftProps`   | `Omit<NativeInputProps, ...>` | -  | Props passed to the date input |
| `inputRightProps`  | `Omit<NativeInputProps, ...>` | -  | Props passed to the time input |
| `onClear`          | `MouseEventHandler` | -      | Clear callback           |
| `placeholderLeft`  | `string`           | `formatDate` | Date field placeholder |
| `placeholderRight` | `string`           | `formatTime` | Time field placeholder |
| `prefix`           | `ReactNode`        | -       | Prefix element           |
| `readOnly`         | `boolean`          | -       | Whether read-only        |
| `required`         | `boolean`          | `false` | Whether required         |
| `size`             | `'main' \| 'sub'`  | -       | Size                     |
| `validateLeft`     | `(isoDate: string) => boolean` | - | Date field validation function |
| `validateRight`    | `(isoDate: string) => boolean` | - | Time field validation function |

---

## Portal Behavior (v1.0.4+)

Since v1.0.4 the calendar and time pickers portal out by default, fixing clipping inside `Modal` / `overflow: hidden` ancestors. To restore inline rendering per call site use `popperProps={{ disablePortal: true }}` (for the calendar) or `popperPropsTime={{ disablePortal: true }}` (for the time panel).

### Keyboard Navigation (v1.1.0+)

`Tab` / `Shift+Tab` navigation between the trigger inputs and the portalled panels is restored in v1.1.0 via an explicit logical focus loop, reliable even inside a `Modal` focus trap.

---

## Usage Examples

### Basic Usage

```tsx
import { DateTimePicker } from '@mezzanine-ui/react';
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';

function BasicExample() {
  const [value, setValue] = useState<string | undefined>();

  return (
    <CalendarConfigProviderDayjs>
      <DateTimePicker
        value={value}
        onChange={setValue}
      />
    </CalendarConfigProviderDayjs>
  );
}
```

### Custom Format

```tsx
<DateTimePicker
  formatDate="YYYY/MM/DD"
  formatTime="HH:mm"
  placeholderLeft="Select date"
  placeholderRight="Select time"
  onChange={handleChange}
/>
```

### Hide Seconds

```tsx
<DateTimePicker
  hideSecond
  formatTime="HH:mm"
  onChange={handleChange}
/>
```

### Time Steps

```tsx
<DateTimePicker
  hourStep={1}
  minuteStep={15}
  secondStep={30}
  onChange={handleChange}
/>
```

### Disable Specific Dates

```tsx
<DateTimePicker
  isDateDisabled={(date) => {
    // Disable past dates
    return dayjs(date).isBefore(dayjs(), 'day');
  }}
  onChange={handleChange}
/>
```

### With Default Value

```tsx
<DateTimePicker
  defaultValue="2024-01-15T10:30:00"
  onChange={handleChange}
/>
```

### Controlled Mode

```tsx
function ControlledExample() {
  const [value, setValue] = useState<string | undefined>();

  return (
    <>
      <DateTimePicker
        value={value}
        onChange={setValue}
      />
      <Button onClick={() => setValue(dayjs().toISOString())}>
        Set to Now
      </Button>
    </>
  );
}
```

---

## Component Structure

DateTimePicker consists of two independent input fields and panels:
1. **Left input**: Date selection, shows calendar panel on focus
2. **Right input**: Time selection, shows time panel on focus

```
┌─────────────────────────────────────┐
│ [Date Input] ~ [Time Input]  📅    │
└─────────────────────────────────────┘
         ↓                    ↓
   ┌───────────┐        ┌───────────┐
   │ Calendar   │        │ Time      │
   │ Panel      │        │ Panel     │
   └───────────┘        └───────────┘
```

---

## Figma Mapping

| Figma Variant                   | React Props                |
| ------------------------------- | -------------------------- |
| `DateTimePicker / Default`      | Default                    |
| `DateTimePicker / Disabled`     | `disabled`                 |
| `DateTimePicker / Error`        | `error`                    |
| `DateTimePicker / With Value`   | `value` is set             |
| `DateTimePicker / Hide Second`  | `hideSecond`               |

---

## Behavior Notes

- **Suffix overlay when clearable**: When `clearable` is true, the clear icon overlays the calendar-time suffix icon. The suffix icon is hidden while the clear button is visible.

---

## Best Practices

### 場景推薦

| 使用場景 | 推薦設定 | 說明 |
|---------|--------|------|
| 訂單時間範圍查詢 | `hideSecond=true`, `minuteStep={15}` | 隱藏秒數，分鐘以15分鐘遞增 |
| 系統日誌查詢 | `formatTime="HH:mm:ss"` | 顯示完整時間含秒數 |
| 會議預約 | `hourStep={1}`, `minuteStep={30}` | 以小時和30分鐘遞增 |
| 數據導出排程 | `isDateDisabled` + 過去日期檢查 | 禁用過去日期，只允許未來日期 |
| 報表生成 | `popperPropsTime` 自訂位置 | 根據容器寬度調整時間面板位置 |

### 常見錯誤

1. **未包裝 CalendarContext**
   ```tsx
   // ❌ 錯誤：缺少 CalendarContext
   <DateTimePicker value={value} onChange={setValue} />

   // ✅ 正確：使用適當的日期庫提供者
   <CalendarConfigProviderDayjs>
     <DateTimePicker value={value} onChange={setValue} />
   </CalendarConfigProviderDayjs>
   ```

2. **未對齊格式字符串**
   ```tsx
   // ❌ 錯誤：formatTime 與 hideSecond 不一致
   <DateTimePicker hideSecond formatTime="HH:mm:ss" />

   // ✅ 正確：隱藏秒數時調整格式
   <DateTimePicker hideSecond formatTime="HH:mm" />
   ```

3. **忽略受控/非受控模式**
   ```tsx
   // ❌ 錯誤：混合受控與非受控
   const [value, setValue] = useState();
   <DateTimePicker value={value} defaultValue="2024-01-01" onChange={setValue} />

   // ✅ 正確：選擇其中一種模式
   <DateTimePicker defaultValue="2024-01-01" onChange={setValue} />
   ```

4. **時間步長設定不當**
   ```tsx
   // ❌ 錯誤：步長過小導致選項過多
   <DateTimePicker minuteStep={1} secondStep={1} />

   // ✅ 正確：依使用場景設定合理步長
   <DateTimePicker minuteStep={15} secondStep={30} />
   ```

### 核心原則

1. **上下文必需**: 必須包裝在 CalendarContext.Provider 中
2. **格式一致性**: `formatDate` 和 `formatTime` 應與實際用途相符
3. **時間粒度**: 使用步長 props 限制可選的時間
4. **前期驗證**: 元件會自動驗證輸入格式
5. **完整選擇流程**: 當兩個輸入欄位都有值時，onChange 才會觸發
