# MultipleDatePicker Component

> **Category**: Data Entry
>
> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/story/data-entry-multipledatepicker--playground) — 當行為不確定時，Storybook 的互動範例為權威參考。
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/MultipleDatePicker) · Verified 1.4.2 (2026-08-07)

A multiple date picker that allows selecting multiple dates from a calendar, displaying selected dates as Tags. Requires manual confirmation before triggering onChange. Must be used with `CalendarContext`.

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
import MultipleDatePicker, {
  MultipleDatePickerTrigger,
  useMultipleDatePickerValue,
} from '@mezzanine-ui/react/MultipleDatePicker';

import type {
  MultipleDatePickerDateValue,
  MultipleDatePickerProps,
  MultipleDatePickerTriggerProps,
  UseMultipleDatePickerValueProps,
  UseMultipleDatePickerValueReturn,
} from '@mezzanine-ui/react/MultipleDatePicker';
```

---

## MultipleDatePicker Props

| Property               | Type                                        | Default        | Description                          |
| ---------------------- | ------------------------------------------- | -------------- | ------------------------------------ |
| `actions`              | `Partial<CalendarFooterActionsProps['actions']>` | -           | Custom confirm/cancel button props   |
| `calendarProps`        | `CalendarProps` (partial omit)              | -              | Calendar extra props                 |
| `className`            | `string`                                    | -              | Outer container CSS class            |
| `clearable`            | `boolean`                                   | `true`         | Whether clearable                    |
| `disabled`             | `boolean`                                   | `false`        | Whether disabled                     |
| `disabledMonthSwitch`  | `boolean`                                   | `false`        | Disable month switching              |
| `disabledYearSwitch`   | `boolean`                                   | `false`        | Disable year switching               |
| `disableOnDoubleNext`  | `boolean`                                   | -              | Disable double arrow next            |
| `disableOnDoublePrev`  | `boolean`                                   | -              | Disable double arrow prev            |
| `disableOnNext`        | `boolean`                                   | -              | Disable next                         |
| `disableOnPrev`        | `boolean`                                   | -              | Disable prev                         |
| `displayMonthLocale`   | `string`                                    | -              | Month display localization           |
| `error`                | `boolean`                                   | `false`        | Error state                          |
| `format`               | `string`                                    | `'YYYY-MM-DD'` | Date tag display format              |
| `fullWidth`            | `boolean`                                   | `false`        | Whether full width                   |
| `isDateDisabled`       | `(date: DateType) => boolean`               | -              | Date disable check                   |
| `maxSelections`        | `number`                                    | -              | Maximum selectable dates             |
| `onCalendarToggle`     | `(open: boolean) => void`                   | -              | Calendar toggle callback             |
| `onChange`             | `(value: MultipleDatePickerValue) => void`  | -              | Change callback after confirmation   |
| `overflowStrategy`    | `'counter' \| 'wrap'`                       | `'counter'`    | Tag overflow strategy                |
| `placeholder`          | `string`                                    | -              | Placeholder text when none selected  |
| `popperProps`          | `InputTriggerPopperProps` (partial omit)    | -              | Popper positioning props             |
| `prefix`               | `ReactNode`                                 | -              | Prefix element                       |
| `readOnly`             | `boolean`                                   | `false`        | Whether read-only                    |
| `referenceDate`        | `DateType`                                  | -              | Reference date (defaults to now)     |
| `required`             | `boolean`                                   | -              | Whether required                     |
| `size`                 | `'main' \| 'sub'`                           | `'main'`       | Size                                 |
| `value`                | `MultipleDatePickerValue`                   | `[]`           | Selected dates array (controlled)    |

---

## MultipleDatePickerTrigger Props

Extends `TextFieldProps` (excluding `active`, `children`, `defaultChecked`, `disabled`, `readonly`, `typing`).

| Property           | Type                                | Default      | Description                      |
| ------------------ | ----------------------------------- | ------------ | -------------------------------- |
| `active`           | `boolean`                           | `false`      | Whether in open state (styling)  |
| `className`        | `string`                            | -            | CSS class                        |
| `clearable`        | `boolean`                           | `true`       | Whether clearable                |
| `disabled`         | `boolean`                           | `false`      | Whether disabled                 |
| `error`            | `boolean`                           | `false`      | Error state                      |
| `fullWidth`        | `boolean`                           | `false`      | Whether full width               |
| `onTagClose`       | `(date: DateType) => void`          | -            | Tag close (remove date) callback |
| `overflowStrategy` | `'counter' \| 'wrap'`              | `'counter'`  | Tag overflow strategy            |
| `placeholder`      | `string`                            | -            | Placeholder when none selected   |
| `prefix`           | `ReactNode`                         | -            | Prefix element                   |
| `readOnly`         | `boolean`                           | `false`      | Whether read-only                |
| `required`         | `boolean`                           | `false`      | Whether required                 |
| `size`             | `'main' \| 'sub'`                   | `'main'`     | Size                             |
| `suffix`           | `ReactNode`                         | -            | Suffix element (e.g., calendar icon) |
| `value`            | `DateValue[]`                       | `[]`         | Selected date value array        |

---

## useMultipleDatePickerValue Hook

### Props (UseMultipleDatePickerValueProps)

| Property         | Type                        | Default    | Description            |
| ---------------- | --------------------------- | ---------- | ---------------------- |
| `format`         | `string`                    | Required   | Date format string     |
| `maxSelections`  | `number`                    | -          | Maximum selectable     |
| `value`          | `MultipleDatePickerValue`   | `[]`       | Controlled value       |

### Return Value (UseMultipleDatePickerValueReturn)

| Property          | Type                                      | Description                              |
| ----------------- | ----------------------------------------- | ---------------------------------------- |
| `internalValue`   | `MultipleDatePickerValue`                 | Internal temporary value (pending confirm) |
| `toggleDate`      | `(date: DateType) => void`                | Toggle date selection/deselection        |
| `removeDate`      | `(date: DateType) => void`                | Remove a specific date from selection    |
| `clearAll`        | `() => void`                              | Clear all selected dates                 |
| `isDateSelected`  | `(date: DateType) => boolean`             | Check if a date is selected              |
| `isMaxReached`    | `boolean`                                 | Whether max selection count is reached   |
| `getConfirmValue` | `() => MultipleDatePickerValue`           | Get confirmed value (for onChange)        |
| `revertToValue`   | `() => void`                              | Revert to original controlled value (cancel) |
| `formatDate`      | `(date: DateType) => string`              | Format date to display string            |

---

## Portal Behavior (v1.0.4+)

Since v1.0.4 the calendar popper portals out by default, fixing clipping inside `Modal` / `overflow: hidden` ancestors. To restore inline rendering per call site:

```tsx
<MultipleDatePicker
  popperProps={{ disablePortal: true }}
  value={value}
  onChange={setValue}
/>
```

### Keyboard Navigation (v1.1.0+)

`Tab` / `Shift+Tab` navigation between the trigger and the portalled calendar is restored in v1.1.0 via an explicit logical focus loop.

---

## Type Definitions

```tsx
// Date array value
type MultipleDatePickerValue = DateType[];

// Trigger display date value
interface MultipleDatePickerDateValue {
  id: string;
  name: string;
  date: DateType;
}

// Overflow strategy
type OverflowStrategy = 'counter' | 'wrap';
```

---

## Usage Examples

### Basic Usage

```tsx
import { CalendarConfigProviderDayjs } from '@mezzanine-ui/react/Calendar';
import MultipleDatePicker from '@mezzanine-ui/react/MultipleDatePicker';
// MultipleDatePickerValue (= DateType[]) is not exported from the react package, use DateType[] directly
// Or from core: import type { MultipleDatePickerValue } from '@mezzanine-ui/core/multiple-date-picker';

function BasicExample() {
  const [value, setValue] = useState<DateType[]>([]);

  return (
    <CalendarConfigProviderDayjs>
      <MultipleDatePicker
        placeholder="Select multiple dates"
        value={value}
        onChange={setValue}
      />
    </CalendarConfigProviderDayjs>
  );
}
```

### Limit Selection Count

```tsx
<MultipleDatePicker
  maxSelections={5}
  placeholder="Select up to 5 dates"
  value={value}
  onChange={setValue}
/>
```

### Custom Format and Overflow Strategy

```tsx
<MultipleDatePicker
  format="MM/DD"
  overflowStrategy="wrap"
  fullWidth
  value={value}
  onChange={setValue}
/>
```

### Disable Specific Dates

```tsx
<MultipleDatePicker
  isDateDisabled={(date) => {
    // Disable weekends
    const dayOfWeek = dayjs(date).day();
    return dayOfWeek === 0 || dayOfWeek === 6;
  }}
  value={value}
  onChange={setValue}
/>
```

### Custom Action Button Text

```tsx
<MultipleDatePicker
  actions={{
    primaryButtonProps: { children: 'OK' },
    secondaryButtonProps: { children: 'Cancel' },
  }}
  value={value}
  onChange={setValue}
/>
```

### Using useMultipleDatePickerValue Hook (Custom Composition)

```tsx
import { useMultipleDatePickerValue } from '@mezzanine-ui/react/MultipleDatePicker';

function CustomMultipleDatePicker() {
  const [value, setValue] = useState<MultipleDatePickerValue>([]);

  const {
    internalValue,
    toggleDate,
    isDateSelected,
    isMaxReached,
    getConfirmValue,
    revertToValue,
    formatDate,
  } = useMultipleDatePickerValue({
    format: 'YYYY-MM-DD',
    maxSelections: 3,
    value,
  });

  const handleConfirm = () => {
    setValue(getConfirmValue());
  };

  return (
    <div>
      <p>{internalValue.length} dates selected</p>
      {internalValue.map((date) => (
        <span key={formatDate(date)}>{formatDate(date)}</span>
      ))}
      <button onClick={handleConfirm}>Confirm</button>
      <button onClick={revertToValue}>Cancel</button>
    </div>
  );
}
```

---

## Component Structure

MultipleDatePicker consists of a trigger and a calendar popup:

```
┌─────────────────────────────────────────┐
│ [Tag1] [Tag2] [+3]              📅     │  ← MultipleDatePickerTrigger
└─────────────────────────────────────────┘
         ↓
┌─────────────────────┐
│    Calendar Panel    │
│  ┌─────────────┐    │
│  │  Select Date │    │
│  └─────────────┘    │
│ [Cancel]   [Confirm] │  ← CalendarFooterActions
└─────────────────────┘
```

---

## Best Practices

### 場景推薦

| 使用場景 | 建議方案 | 說明 |
| ------- | ------- | ---- |
| 選擇假期 | `maxSelections={5}` | 限制選擇數量，超出後無法繼續選 |
| 時間範圍選擇 | `maxSelections={2}` | 開始日期和結束日期，限制 2 天 |
| 標籤溢出 - 空間有限 | `overflowStrategy="counter"` | 顯示 "+N" 計數，節省空間 |
| 標籤溢出 - 空間充足 | `overflowStrategy="wrap"` | 多行顯示所有標籤 |
| 週末禁用 | `isDateDisabled={(date) => {...}}` | 傳入驗證函式 |
| 響應式設計 | `fullWidth` + size | 在不同寬度下調整 |

### 常見錯誤

1. **未在 CalendarContext 中使用**
   - ❌ 錯誤：`<MultipleDatePicker />` 直接使用
   - ✅ 正確：`<CalendarConfigProviderDayjs><MultipleDatePicker /></CalendarConfigProviderDayjs>`

2. **搞混 onChange 的觸發時機**
   - ❌ 錯誤：期望點擊日期時立即觸發 onChange
   - ✅ 正確：只在確認按鈕點擊時才觸發 onChange

3. **未提供 maxSelections 但期望限制**
   - ❌ 錯誤：`<MultipleDatePicker />`（使用者可選無限多天）
   - ✅ 正確：如需限制，設定 `maxSelections={N}`

4. **未禁用已選日期**
   - ❌ 錯誤：`<MultipleDatePicker maxSelections={2} />`（已選日期仍可再選）
   - ✅ 正確：當達到上限時，其他日期自動禁用

5. **日期格式不一致**
   - ❌ 錯誤：`format="MM/DD"` 但期望 `YYYY-MM-DD` 格式
   - ✅ 正確：確保 format 和實際日期值格式匹配

### 實作建議

1. **必須在上下文中使用**：必須被包裝在 CalendarContext 提供者中
2. **手動確認模式**：此元件使用手動確認；onChange 僅在確認時觸發
3. **標籤溢出處理**：預設為 `counter` 策略顯示 `+N`；`wrap` 策略會換行顯示
4. **選擇限制**：使用 `maxSelections` 限制可選日期；達到上限時，未選日期自動禁用
5. **日期排序**：選定日期內部自動按時間順序排序
