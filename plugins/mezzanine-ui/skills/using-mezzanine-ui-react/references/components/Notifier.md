# Notifier / createNotifier

> **Category**: Utility
>
> **Storybook**: `Utility/Notifier`
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Notifier)  · Verified 1.5.1 (2026-09-12)

Notifier factory function for creating custom notification systems. It is the underlying implementation of Message, NotificationCenter, and other components.

> **Aliases** — Notification factory · createNotifier · 自訂通知系統底層
> **Not for** — 一般的操作提示（直接用 [`Message`](Message.md)）；通知中心（用 [`NotificationCenter`](NotificationCenter.md)）。只有需要自建一整套通知型別時才直接用它。

## Import

```tsx
import { createNotifier } from '@mezzanine-ui/react';
import type {
  Notifier,
  NotifierConfig,
  NotifierData,
  RenderNotifier,
  CreateNotifierProps,
} from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/internal-notifier--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## createNotifier Parameters

`createNotifier<N, C>(props: CreateNotifierProps<N, C>)` — `CreateNotifierProps<N, C>` extends `NotifierConfig` (`duration`, `maxCount`).

| Parameter         | Type                                                        | Required | Description                 |
| ------------------ | ----------------------------------------------------------- | -------- | --------------------------- |
| `config`           | `C extends NotifierConfig`                                   | -        | Custom notifier config      |
| `duration`         | `number \| false`                                            | -        | Default display time (ms)   |
| `maxCount`         | `number`                                                     | -        | Max visible count           |
| `render`           | `(notifier: N & { key: Key }) => ReactNode`                  | **Yes**  | Notification render fn      |
| `renderContainer`  | `(children: ReactNode) => ReactNode`                         | -        | Container render fn         |
| `setRoot`          | `(root: HTMLDivElement) => void`                             | -        | Set root element attributes |
| `sortBeforeUpdate` | `(notifiers: (N & { key: Key })[]) => (N & { key: Key })[]`  | -        | Sort function                |

> `createNotifier` renders its notifiers through an internal (unexported) `NotifierManager` component. Its `controllerRef` and `defaultNotifiers` props are implementation details wired up automatically by `createNotifier` itself — they are not part of `CreateNotifierProps` and are never passed by a caller of `createNotifier`.

---

## Notifier Return Object

| Method       | Type                                  | Description                    |
| ------------ | ------------------------------------- | ------------------------------ |
| `add`        | `(notifier: N & { key?: Key }) => Key`| Add a notification             |
| `remove`     | `(key: Key) => void`                  | Remove a specific notification |
| `destroy`    | `() => void`                          | Remove all and destroy         |
| `config`     | `(config: C) => void`                 | Update configuration           |
| `getConfig`  | `() => C`                             | Get current configuration      |

---

## NotifierData

```tsx
interface NotifierData extends Pick<NotifierConfig, 'duration'> {
  children?: ReactNode;
  // duration is inherited from Pick<NotifierConfig, 'duration'>, type is number | false
  onClose?: (key: Key) => void;
}
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/internal-notifier--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Usage Examples

### Create a Custom Notifier

```tsx
import { createNotifier } from '@mezzanine-ui/react';

interface MyNotificationData {
  key?: number;
  title: string;
  message: string;
  type: 'success' | 'error' | 'info';
  duration?: number | false;
  onClose?: (key: number) => void;
}

const MyNotification = createNotifier<MyNotificationData>({
  duration: 3000,
  maxCount: 5,
  render: (notifier) => (
    <div className={`notification notification--${notifier.type}`}>
      <h4>{notifier.title}</h4>
      <p>{notifier.message}</p>
      <button onClick={() => notifier.onClose?.(notifier.key)}>Close</button>
    </div>
  ),
  setRoot: (root) => {
    root.className = 'my-notification-container';
  },
});

// Usage
MyNotification.add({
  title: 'Success',
  message: 'Operation completed',
  type: 'success',
});
```

### With Container Render

```tsx
const AlertBannerNotifier = createNotifier<AlertBannerData>({
  duration: false,
  render: (notifier) => (
    <AlertBanner
      severity={notifier.severity}
      onClose={() => notifier.onClose?.(notifier.key)}
    >
      {notifier.message}
    </AlertBanner>
  ),
  renderContainer: (children) => (
    <div className="alert-banner-container">
      {children}
    </div>
  ),
});
```

### Custom Sorting

```tsx
const PriorityNotifier = createNotifier<PriorityNotificationData>({
  render: (notifier) => (
    <Notification {...notifier} onClose={() => notifier.onClose?.(notifier.key)} />
  ),
  sortBeforeUpdate: (notifiers) => {
    return notifiers.sort((a, b) => b.priority - a.priority);
  },
});
```

### Update Configuration

```tsx
// Create notifier
const Notification = createNotifier<NotificationData>({
  duration: 3000,
  render: (notifier) => (
    <NotificationUI {...notifier} onClose={() => notifier.onClose?.(notifier.key)} />
  ),
});

// Update default duration
Notification.config({ duration: 5000 });

// Get current configuration
const currentConfig = Notification.getConfig();
```

### Manually Remove Notifications

```tsx
// Get key when adding
const key = Notification.add({
  title: 'Processing',
  message: 'Please wait...',
  duration: false, // No auto-close
});

// Manually remove after completion
await someAsyncOperation();
Notification.remove(key);
```

### Destroy Notifier

```tsx
// Destroy on component unmount
useEffect(() => {
  return () => {
    Notification.destroy();
  };
}, []);
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/internal-notifier--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Message and NotificationCenter Implementation

```tsx
// Message internal implementation (similar to)
const Message = createNotifier<MessageData>({
  duration: 3000,
  maxCount: 4,
  render: (message) => (
    <Message {...message} reference={message.key} key={undefined} />
  ),
  setRoot: (root) => {
    root?.setAttribute('class', classes.root);
  },
});

// NotificationCenter internal implementation (similar to)
// Note: Visible count is not controlled by createNotifier's maxCount,
// but by NotificationData's maxVisibleNotifications prop (default 3).
// renderContainer uses NotificationCenterContainer to truncate visible notifications.
const NotificationCenter = createNotifier<NotificationData>({
  duration: false,
  render: (notif) => (
    <NotificationCenter {...notif} reference={notif.key} key={notif.key} />
  ),
  renderContainer: (children) => (
    <NotificationCenterContainer>{children}</NotificationCenterContainer>
  ),
  setRoot: (root) => {
    root?.setAttribute('class', classes.root);
  },
});
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/internal-notifier--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Sugar Method Pattern

```tsx
// Add sugar methods to Notifier
const Message = createNotifier<MessageData>({
  render: (notifier) => (
    <MessageUI {...notifier} onClose={() => notifier.onClose?.(notifier.key)} />
  ),
});

// Add success, error, etc. methods
const MessageWithSugar = {
  ...Message,
  success: (message: string) => Message.add({ message, severity: 'success' }),
  error: (message: string) => Message.add({ message, severity: 'error' }),
  warning: (message: string) => Message.add({ message, severity: 'warning' }),
  info: (message: string) => Message.add({ message, severity: 'info' }),
};

// Usage
MessageWithSugar.success('Operation successful!');
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/internal-notifier--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Behavior Notes

- **`maxCount` overflow queues rather than drops**: once the number of displayed notifiers reaches `maxCount`, a new `add()` call does not render immediately — it is placed in an internal queue and displayed automatically as soon as an existing notifier is removed and a slot frees up. If `sortBeforeUpdate` is provided, it re-sorts the combined displayed+incoming set on every `add()` that would otherwise exceed `maxCount`, so a high-priority notifier can still bump a lower-priority one into the queue instead of being queued itself.
- **`add()` with a repeated `key` updates in place**: calling `add()` again with a `key` that matches an already-displayed notifier replaces that notifier's data rather than appending a duplicate.

---

## Figma Mapping

Notifier is a pure functional factory with no corresponding visual element in Figma. The rendered content is determined by the `render` function.

---

## Best Practices (最佳實踐)

### 場景推薦 (Scenario Recommendations)

| 場景 | 推薦做法 | 相關參數 |
| --- | --- | --- |
| 快速操作提示 | 使用 `Message` 組件而非直接 `createNotifier` | `duration: 3000` |
| 複雜通知系統 | 直接使用 `NotificationCenter` 或自訂 `createNotifier` | `render`, `renderContainer` |
| 優先級通知 | 使用 `sortBeforeUpdate` 排序重要通知 | `sortBeforeUpdate` |
| 無限期通知 | 設定 `duration: false` 並提供手動關閉機制 | `duration`, `onClose` |
| 通知堆積限制 | 設定 `maxCount` 限制可見通知數量 | `maxCount` |
| 自訂容器樣式 | 使用 `renderContainer` 包裝通知內容 | `renderContainer`, `setRoot` |
| 動態配置 | 使用 `config()` 方法更新全域設定 | `config()`, `getConfig()` |

### 常見錯誤 (Common Mistakes)

1. **過度使用 createNotifier**
   - ❌ 誤：為簡單提示創建自訂 Notifier
   - ✅ 正確：使用現成的 `Message` 或 `NotificationCenter`
   - 影響：減少複雜性，提升維護性

2. **不設定自動關閉時間**
   - ❌ 誤：所有通知都設 `duration: false`
   - ✅ 正確：重要消息無自動關閉，簡短提示設 `duration: 3000`
   - 範例：錯誤警告 `duration: false`，成功提示 `duration: 3000`

3. **過多可見通知**
   - ❌ 誤：不設 `maxCount`，同時顯示 20+ 個通知
   - ✅ 正確：設定合理的 `maxCount` (通常 3-5)
   - 影響：避免視覺混亂，提升用戶體驗

4. **忘記清理資源**
   - ❌ 誤：組件卸載時未調用 `destroy()`
   - ✅ 正確：在 `useEffect` 清理函數中調用 `destroy()`
   - 範例：`useEffect(() => () => notifier.destroy(), [])`

5. **排序邏輯不清**
   - ❌ 誤：`sortBeforeUpdate` 返回新陣列但未排序
   - ✅ 正確：確保返回的陣列按優先級排序
   - 範例：`notifiers.sort((a, b) => b.priority - a.priority)`

6. **忽視 render 函數中的 key**
   - ❌ 誤：在 render 中使用不穩定的 key
   - ✅ 正確：使用 `notifier.key` 作為 React key
   - 範例：`<NotificationUI key={notifier.key} {...notifier} />`

### 核心建議 (Core Recommendations)

1. **使用現成組件**：通常優先使用 `Message` 或 `NotificationCenter`，而非直接 `createNotifier`
2. **適當的時間設定**：根據消息重要性設定 `duration`
3. **限制通知數量**：使用 `maxCount` 避免過多通知
4. **資源清理**：在組件卸載時調用 `destroy()` 清理資源
5. **優先級排序**：使用 `sortBeforeUpdate` 優先顯示重要通知
