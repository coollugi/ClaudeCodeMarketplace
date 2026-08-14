# Message Component

> **Category**: Feedback
>
> **Storybook**: `Feedback/Message`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Message) · Verified 1.4.1 (2026-07-01)

A global message notification component for displaying operation feedback, system notifications, and other lightweight messages. Uses an imperative API.

> **Aliases** — Toast · Snackbar (MUI) · message (Ant Design) · 浮動提示 · 操作回饋
> **Not for** — 需要保留可回顧的通知（用 [`NotificationCenter`](NotificationCenter.md)）；固定在版面裡的說明（用 [`InlineMessage`](InlineMessage.md)）

## Import

```tsx
import { Message } from '@mezzanine-ui/react';
import type { MessageData, MessageSeverity, MessageType } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-message--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Message API

Message uses an imperative API; no element rendering is required.

### Basic Methods

| Method                | Description         |
| --------------------- | ------------------- |
| `Message.add(data)`   | Add a message       |
| `Message.remove(key)` | Remove a message    |
| `Message.destroy()`   | Clear all messages  |
| `Message.config(cfg)` | Set global config   |

### Shortcut Methods

| Method                              | Description     |
| ----------------------------------- | --------------- |
| `Message.success(content, props?)`  | Success message |
| `Message.warning(content, props?)`  | Warning message |
| `Message.error(content, props?)`    | Error message   |
| `Message.info(content, props?)`     | Info message    |
| `Message.loading(content, props?)`  | Loading message |

Shortcut methods return a `Key`, which can be used with `Message.remove(key)`.

---

## MessageData Type

Extends `Omit<NotifierData, 'onClose'>` and `MessageConfigProps` (including Translate transition props).

| Property      | Type                | Default | Description                                      |
| ------------- | ------------------- | ------- | ------------------------------------------------ |
| `children`    | `ReactNode`         | -       | Message content (inherited from NotifierData)    |
| `duration`    | `number \| false`   | `3000`  | Display time (ms); loading defaults to no auto-close |
| `icon`        | `IconDefinition`    | -       | Custom icon                                      |
| `reference`   | `Key`               | -       | Message identification key                       |
| `severity`    | `MessageSeverity`   | -       | Severity level                                   |
| `easing`      | `TranslateProps['easing']` | - | Transition easing                                |
| `from`        | `TranslateProps['from']`   | - | Transition direction                             |
| `onEnter`     | `() => void`        | -       | Enter transition start                           |
| `onEntering`  | `() => void`        | -       | Enter transition in progress                     |
| `onEntered`   | `() => void`        | -       | Enter transition complete                        |
| `onExit`      | `() => void`        | -       | Exit transition start                            |
| `onExiting`   | `() => void`        | -       | Exit transition in progress                      |
| `onExited`    | `(node: HTMLElement) => void` | - | Exit transition complete                     |

---

## MessageType Type

```tsx
// Actual source definition — the type is simply the shape of the Message constant itself:
type MessageType = typeof Message;

// Which resolves structurally to:
// FC<MessageData> (renders a single message element)
// & { add, config, destroy, remove } (from createNotifier<MessageData, MessageConfigProps>)
// & { error, info, loading, success, warning } (severity shorthand methods, each:
//     (message: MessageData['children'], props?: Omit<MessageData, 'children' | 'severity' | 'icon'> & { key?: Key }) => Key
//   )
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-message--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## MessageSeverity Type

| Severity  | Description | Default Icon        |
| --------- | ----------- | ------------------- |
| `success` | Success     | CheckedFilledIcon   |
| `warning` | Warning     | WarningFilledIcon   |
| `error`   | Error       | ErrorFilledIcon     |
| `info`    | Info        | InfoFilledIcon      |
| `loading` | Loading     | SpinnerIcon (spinning) |

---

## Usage Examples

### Shortcut Methods

```tsx
import { Message, Button } from '@mezzanine-ui/react';

// Success message
<Button onClick={() => Message.success('Operation successful!')}>
  Success
</Button>

// Warning message
<Button onClick={() => Message.warning('Please note!')}>
  Warning
</Button>

// Error message
<Button onClick={() => Message.error('Operation failed!')}>
  Error
</Button>

// Info message
<Button onClick={() => Message.info('This is information')}>
  Info
</Button>
```

### Loading Message

```tsx
function LoadingExample() {
  const handleClick = async () => {
    // Show loading (won't auto-close)
    const key = Message.loading('Loading...');

    try {
      await fetchData();
      Message.remove(key);
      Message.success('Loading complete!');
    } catch {
      Message.remove(key);
      Message.error('Loading failed!');
    }
  };

  return <Button onClick={handleClick}>Load Data</Button>;
}
```

### Using add Method

```tsx
// Basic usage
Message.add({
  children: 'This is message content',
  severity: 'info',
});

// Custom duration
Message.add({
  children: 'This message shows for 5 seconds',
  severity: 'success',
  duration: 5000,
});
```

### Message with Key

```tsx
// Add message with reference
Message.add({
  children: 'Message content',
  severity: 'success',
  reference: 'unique-key',
});

// Remove later
Message.remove('unique-key');
```

### Global Configuration

```tsx
// Set default duration
Message.config({
  duration: 5000,  // Default 3000
});
```

### Destroy All Messages

```tsx
// Clear all messages
Message.destroy();
```

### Custom Icon

```tsx
import { StarFilledIcon } from '@mezzanine-ui/icons';

Message.add({
  children: 'Message with custom icon',
  icon: StarFilledIcon,
});
```

### With Additional Config

```tsx
Message.success('Success message', {
  duration: 5000,
  reference: 'custom-key',
});
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-message--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Global Configuration Options

Set via `Message.config()`:

| Config     | Type     | Default | Description              |
| ---------- | -------- | ------- | ------------------------ |
| `duration` | `number` | `3000`  | Default display time (ms)|

> Note: `loading` severity does not auto-close by default. Maximum simultaneous display count is 4.

---

## Behavioral Characteristics

- Default `duration` is 3000ms (loading severity does not auto-close by default)
- Maximum simultaneous display count is 4
- Timer pauses/resumes on browser blur and mouse hover
- Animation effect slides in from below with fade in

---

## Figma Mapping

| Figma Variant         | React Method        |
| --------------------- | ------------------- |
| `Message / Success`   | `Message.success()` |
| `Message / Warning`   | `Message.warning()` |
| `Message / Error`     | `Message.error()`   |
| `Message / Info`      | `Message.info()`    |
| `Message / Loading`   | `Message.loading()` |

---

## Best Practices

### 場景推薦

| 使用場景 | 建議方案 | 說明 |
| ------- | ------- | ---- |
| 操作成功反饋 | `Message.success()` | 表單提交、檔案上傳等成功操作 |
| 操作失敗 | `Message.error()` | 操作失敗時的錯誤提示 |
| 警告通知 | `Message.warning()` | 操作前的警告（但仍允許繼續） |
| 資訊提示 | `Message.info()` | 一般資訊通知 |
| 長時間操作 | `Message.loading()` | 需要手動關閉的載入狀態 |
| 需確認的訊息 | 使用 `Modal` | 重要決定需要用戶確認 |

### 常見錯誤

1. **loading 訊息未手動關閉**
   - ❌ 錯誤：`Message.loading('Loading...')`（使用者無法看到結果）
   - ✅ 正確：`const key = Message.loading('...')` 然後 `Message.remove(key)`

2. **同時顯示超過 4 條訊息**
   - ❌ 錯誤：快速觸發多個 `Message.success()` 而不清理
   - ✅ 正確：等待訊息自動消失或主動清理舊訊息

3. **錯誤訊息使用 info severity**
   - ❌ 錯誤：`Message.info('Operation failed!')`
   - ✅ 正確：`Message.error('Operation failed!')`

4. **使用 Message 代替需要確認的對話框**
   - ❌ 錯誤：`Message.warning('Delete this item?')`（使用者無法確認/取消）
   - ✅ 正確：使用 `<Modal>` 進行確認

5. **訊息過長或複雜**
   - ❌ 錯誤：`Message.error('An error occurred with the following details: ...')`
   - ✅ 正確：保持簡潔：`Message.error('Save failed, please try again')`

### 實作建議

1. **選擇適當的類型**：根據訊息性質選擇嚴重程度
2. **保持簡潔**：訊息內容應簡明扼要
3. **清理載入訊息**：`loading` 訊息必須手動移除
4. **重要訊息用 Modal**：需要用戶確認的訊息應使用 Modal 而非 Message
5. **監聽計時器**：hover 時計時器暫停，離開時繼續，充分利用自動消失機制
