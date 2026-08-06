# NotificationCenter Component

> **Category**: Feedback
>
> **Storybook**: `Feedback/Notification Center`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/NotificationCenter) · Verified 1.4.1 (2026-07-01)

Notification center component for displaying global notifications. Supports both popup notification and drawer list modes.

## Import

```tsx
import { NotificationCenter } from '@mezzanine-ui/react';
import type { NotificationData, NotificationSeverity } from '@mezzanine-ui/react';

// NotificationCenterDrawer is not exported from '@mezzanine-ui/react' main entry; must be imported from sub-path
import { NotificationCenterDrawer } from '@mezzanine-ui/react/NotificationCenter';
import type {
  NotificationCenterDrawerProps,
  NotificationConfigProps,
} from '@mezzanine-ui/react/NotificationCenter';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-notification-center--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## API Methods

| Method                          | Description                    |
| ------------------------------- | ------------------------------ |
| `NotificationCenter.add(data)`  | Add a notification             |
| `NotificationCenter.remove(key)`| Remove a specific notification |
| `NotificationCenter.destroy()`  | Remove all notifications       |
| `NotificationCenter.config(cfg)`| Set global configuration       |
| `NotificationCenter.success()`  | Success notification (sugar)   |
| `NotificationCenter.warning()`  | Warning notification (sugar)   |
| `NotificationCenter.error()`    | Error notification (sugar)     |
| `NotificationCenter.info()`     | Info notification (sugar)      |

---

## NotificationData Props

Extends `NotifierData` (`children`, `onClose`, `duration`) and `NotificationConfigProps` (`onViewAll`, `viewAllButtonText`, and other Slide transition props).

| Property                     | Type                                    | Default           | Description                                 |
| ---------------------------- | --------------------------------------- | ----------------- | ------------------------------------------- |
| `children`                   | `ReactNode`                             | -                 | Notification content (inherited from NotifierData) |
| `appendTips`                 | `string`                                | -                 | Append tips (drawer mode)                   |
| `cancelButtonProps`          | `ButtonProps`                           | -                 | Cancel button props                         |
| `cancelButtonText`           | `string`                                | `'Cancel'`        | Cancel button text                          |
| `confirmButtonProps`         | `ButtonProps`                           | -                 | Confirm button props                        |
| `confirmButtonText`          | `string`                                | `'Confirm'`       | Confirm button text                         |
| `description`                | `string`                                | -                 | Notification description                    |
| `duration`                   | `number \| false`                       | `false`           | Auto-close time (ms); `false` means no auto-close |
| `maxVisibleNotifications`    | `number`                                | `3`               | Max visible count (notification mode only)  |
| `onBadgeClick`               | `() => void`                            | -                 | Badge click (drawer mode)                   |
| `onBadgeSelect`              | `(option: DropdownOption) => void`      | -                 | Badge select (drawer mode)                  |
| `onCancel`                   | `() => void`                            | -                 | Cancel callback                             |
| `onClose`                    | `(key: Key) => void`                    | -                 | Close callback                              |
| `onConfirm`                  | `() => void`                            | -                 | Confirm callback                            |
| `onViewAll`                  | `() => void`                            | -                 | View all callback                           |
| `options`                    | `DropdownOption[]`                      | -                 | Dropdown options (drawer mode)              |
| `prependTips`                | `string`                                | -                 | Prepend tips (drawer mode)                  |
| `reference`                  | `Key`                                   | -                 | Notification identifier key                 |
| `severity`                   | `NotificationSeverity`                  | `'info'`          | Severity level                              |
| `showBadge`                  | `boolean`                               | -                 | Show badge (drawer mode)                    |
| `timeStamp`                  | `string \| number`                      | Current time      | Timestamp                                   |
| `timeStampLocale`            | `string`                                | `'zh-TW'`         | Timestamp locale                            |
| `title`                      | `string`                                | -                 | Notification title                          |
| `type`                       | `NotificationType`                      | `'notification'`  | Notification type: `'notification'` / `'drawer'` |
| `viewAllButtonText`          | `string`                                | `'查看更多'`       | View all button text                        |

---

## NotificationSeverity

```tsx
type NotificationSeverity = 'success' | 'warning' | 'error' | 'info';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-notification-center--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Usage Examples

### Basic Usage

```tsx
import { NotificationCenter, Button } from '@mezzanine-ui/react';

function App() {
  const handleClick = () => {
    NotificationCenter.add({
      title: 'Notification Title',
      description: 'This is the notification content',
      severity: 'info',
    });
  };

  return <Button onClick={handleClick}>Show Notification</Button>;
}
```

### Using Sugar Methods

```tsx
// Success notification
NotificationCenter.success({
  title: 'Operation Successful',
  description: 'Data has been saved',
});

// Warning notification
NotificationCenter.warning({
  title: 'Attention',
  description: 'This operation may be risky',
});

// Error notification
NotificationCenter.error({
  title: 'Error',
  description: 'Operation failed, please try again',
});

// Info notification
NotificationCenter.info({
  title: 'Notice',
  description: 'A new version has been released',
});
```

### Auto-close

```tsx
NotificationCenter.success({
  title: 'Operation Successful',
  description: 'Auto-closes in 3 seconds',
  duration: 3000,
});
```

### With Action Buttons

```tsx
NotificationCenter.add({
  title: 'Confirm Delete',
  description: 'Are you sure you want to delete this item?',
  severity: 'warning',
  confirmButtonText: 'Confirm',
  cancelButtonText: 'Cancel',
  onConfirm: () => {
    // Execute delete
  },
  onCancel: () => {
    // Cancel operation
  },
});
```

### Global Configuration

```tsx
// Set default duration
NotificationCenter.config({
  duration: 5000,
});
```

### Drawer Mode

```tsx
// For displaying notification lists
const notifications = [
  {
    type: 'drawer' as const,
    title: 'New Message',
    description: 'You have a new message',
    timeStamp: new Date().toISOString(),
    showBadge: true,
    options: [
      { id: 'mark-read', name: 'Mark as Read' },
      { id: 'delete', name: 'Delete' },
    ],
    onBadgeSelect: (option) => {
      console.log('Selected:', option);
    },
  },
];
```

### Limit Visible Count

```tsx
NotificationCenter.add({
  title: 'Notification',
  description: 'Shows "View More" when exceeding 3',
  maxVisibleNotifications: 3,
  onViewAll: () => {
    // Navigate to notification list page
    router.push('/notifications');
  },
});
```

### Remove Notifications

```tsx
// Get key when adding
const key = NotificationCenter.success({
  title: 'Processing',
  description: 'Please wait...',
  duration: false,
});

// Remove later
NotificationCenter.remove(key);

// Remove all
NotificationCenter.destroy();
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-notification-center--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## NotificationCenterDrawer

Notification list drawer component that displays notifications in a Drawer format. Groups by time (Today, Yesterday, Past 7 Days, Earlier).

### Props

> `NotificationCenterDrawerProps` is a discriminated union: provide **either** `children` **or** `notificationList`, never both (the other is typed as `never` in each branch).

| Property                         | Type                                     | Default                    | Description                                    |
| -------------------------------- | ---------------------------------------- | -------------------------- | ---------------------------------------------- |
| `children`                       | `ReactElement<ComponentProps<typeof NotificationCenter>> \| ReactElement<...>[]` | -   | Manually pass NotificationCenter elements (mutually exclusive with `notificationList`) |
| `notificationList`               | `NotificationDataForDrawer[]`            | -                          | Notification data list; each item needs `key` and `type: 'drawer'` (mutually exclusive with `children`) |
| `drawerSize`                     | `DrawerSize`                             | `'narrow'`                 | Drawer size                                    |
| `title`                          | `string`                                 | -                          | Drawer title                                   |
| `open`                           | `boolean`                                | -                          | Whether open (from `Pick<DrawerProps, 'open'>`) |
| `onClose`                        | `() => void`                             | -                          | Close callback (from `Pick<DrawerProps, 'onClose'>`) |
| `todayLabel`                     | `string`                                 | `'今天'`                   | Today group label                              |
| `yesterdayLabel`                  | `string`                                 | `'昨天'`                   | Yesterday group label                          |
| `past7DaysLabel`                 | `string`                                 | `'過去七天'`               | Past 7 days group label                        |
| `earlierLabel`                   | `string`                                 | `'更早'`                   | Earlier group label                            |
| `emptyNotificationTitle`         | `string`                                 | `'目前沒有新的通知'`       | Empty notification title                       |
| `emptyNotificationDescription`   | `string`                                 | `'當有新的系統通知時，將會顯示在這裡。'` | Empty notification description    |
| `filterBarShow`                  | `DrawerProps['filterAreaShow']`          | -                          | Whether to show the filter bar                 |
| `filterBarDefaultValue`          | `DrawerProps['filterAreaDefaultValue']`  | -                          | Filter bar default value                       |
| `filterBarValue`                 | `DrawerProps['filterAreaValue']`         | -                          | Filter bar controlled value                    |
| `filterBarOnRadioChange`         | `DrawerProps['filterAreaOnRadioChange']` | -                          | Radio change callback                          |
| `filterBarAllRadioLabel`         | `DrawerProps['filterAreaAllRadioLabel']` | -                          | All radio label                                |
| `filterBarReadRadioLabel`        | `DrawerProps['filterAreaReadRadioLabel']`| -                          | Read radio label                               |
| `filterBarUnreadRadioLabel`      | `DrawerProps['filterAreaUnreadRadioLabel']` | -                       | Unread radio label                             |
| `filterBarShowUnreadButton`      | `DrawerProps['filterAreaShowUnreadButton']` | -                       | Whether to show the "unread only" shortcut button |
| `filterBarCustomButtonLabel`     | `DrawerProps['filterAreaCustomButtonLabel']` | -                      | Custom action button label                     |
| `filterBarOnCustomButtonClick`   | `DrawerProps['filterAreaOnCustomButtonClick']` | -                    | Custom action button click callback            |
| `filterBarOptions`               | `DrawerProps['filterAreaOptions']`       | -                          | Filter bar dropdown options; when non-empty, replaces the filter area button with a `DotHorizontalIcon`-triggered Dropdown |
| `filterBarOnSelect`              | `DrawerProps['filterAreaOnSelect']`      | -                          | Filter bar dropdown select callback (only used when `filterBarOptions` is non-empty) |

> **Note (breaking rename)**: as of the current source, all `filterArea*` props documented in older versions were renamed to `filterBar*` (e.g. `filterAreaShow` → `filterBarShow`). The `emptyNotificationIcon` prop and `renderFilterArea` render-prop no longer exist; `emptyNotificationDescription` is new.

---

## Differences from Message

| Feature      | NotificationCenter     | Message               |
| ------------ | ---------------------- | --------------------- |
| Position     | Top-right              | Top-center            |
| Content      | Title + Description    | Message only          |
| Action Buttons | Supported            | Not supported         |
| Use Case     | Complex notifications, requiring confirmation | Simple tips |
| Duration     | No auto-close by default | Auto-close by default |
| Animation    | Slide in               | Slide in              |

---

## Figma Mapping

| Figma Variant                       | React Props                              |
| ----------------------------------- | ---------------------------------------- |
| `Notification / Success`            | `severity="success"`                     |
| `Notification / Warning`            | `severity="warning"`                     |
| `Notification / Error`              | `severity="error"`                       |
| `Notification / Info`               | `severity="info"` (default)              |
| `Notification / With Actions`       | `onConfirm` has value                    |
| `Notification / Drawer`             | `type="drawer"`                          |

---

## Best Practices (最佳實踐)

### 場景推薦 (Scenario Recommendations)

| 場景 | 推薦做法 | 相關 Props |
| --- | --- | --- |
| 簡短操作成功提示 | 使用 `severity="success"` 搭配 `duration: 3000` | `severity`, `duration` |
| 警告或風險操作 | 使用 `severity="warning"` 搭配確認按鈕 | `severity`, `confirmButtonText` |
| 錯誤通知 | 使用 `severity="error"` 並提供重試選項 | `severity`, `onConfirm` |
| 一般信息通知 | 使用 `severity="info"` (預設) 可自動關閉 | `severity`, `duration` |
| 需要用戶確認 | 提供 `confirmButtonText` 和 `cancelButtonText` | `onConfirm`, `onCancel` |
| 通知列表模式 | 使用 `type="drawer"` 顯示通知歷史 | `type`, `showBadge` |
| 過多通知 | 設定 `maxVisibleNotifications` 並提供 `onViewAll` | `maxVisibleNotifications` |

### 常見錯誤 (Common Mistakes)

1. **嚴重性選擇不當**
   - ❌ 誤：所有通知都使用 `severity="error"`
   - ✅ 正確：根據重要性選擇適當的嚴重性等級
   - 範例：保存成功用 `success`，API 錯誤用 `error`

2. **過長標題或描述**
   - ❌ 誤：`title="Operation completed successfully and all data has been saved to the server"`
   - ✅ 正確：`title="操作成功"` 搭配 `description="資料已保存"`
   - 影響：易於快速掃讀，提升用戶體驗

3. **不設定自動關閉時間**
   - ❌ 誤：所有非關鍵通知都設 `duration: false`
   - ✅ 正確：非關鍵通知設 `duration: 3000-5000`
   - 影響：避免通知堆積，提升界面整潔性

4. **過多可見通知**
   - ❌ 誤：同時顯示 10+ 個通知
   - ✅ 正確：設定 `maxVisibleNotifications: 3` 並提供 `onViewAll`
   - 範例：超過限制自動顯示「查看更多」按鈕

5. **缺少回調處理**
   - ❌ 誤：提供確認按鈕但未設 `onConfirm`
   - ✅ 正確：所有按鈕都對應相應回調
   - 範例：刪除操作應設 `onConfirm` 和 `onCancel`

### 核心建議 (Core Recommendations)

1. **適當的嚴重性**：根據消息重要性選擇嚴重性等級
2. **簡潔標題**：標題應簡短清晰
3. **自動關閉**：非關鍵通知設定 `duration`
4. **操作按鈕**：需要用戶確認時提供 `onConfirm`/`onCancel`
5. **限制數量**：使用 `maxVisibleNotifications` 避免視覺混亂
