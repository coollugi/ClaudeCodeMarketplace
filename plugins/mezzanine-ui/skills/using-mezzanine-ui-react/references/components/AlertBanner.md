# AlertBanner Component

> **Category**: Others
>
> **Storybook**: `Others/Alert Banner`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/AlertBanner) · Verified 1.5.1 (2026-09-12)

Alert banner component for displaying important system-level notifications. Supports both component-based and imperative APIs. Internally based on `createNotifier`, with sorting rules: non-info first, newest first. Renders using Portal `alert` level.

> **Aliases** — Alert · Banner · System Banner · 系統警示 · 頁面級橫幅 · Figma `Alert Banner`
> **Not for** — 區塊內的說明／警語（用 [`InlineMessage`](InlineMessage.md)）。`AlertBanner` 走 Portal 的 `alert` 層（`position: sticky; top: 0`），**不會待在你放它的位置**，而是浮到頁面頂端蓋住 `PageHeader`。

## Import

```tsx
import { AlertBanner } from '@mezzanine-ui/react';
import type { AlertBannerProps } from '@mezzanine-ui/react';

// AlertBannerSeverity must be imported from core
import type { AlertBannerSeverity } from '@mezzanine-ui/core/alert-banner';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-alert-banner--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## AlertBannerProps (Component-based)

Extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'children' | 'title'>`.

| Property   | Type                  | Default | Description              |
| ---------- | --------------------- | ------- | ------------------------ |
| `actions`       | `AlertBannerAction[]` | -       | Action buttons (max 2)   |
| `closable`      | `boolean`             | `true`  | Whether closable         |
| `disablePortal` | `boolean`             | `false` | **Internal use only** — disables Portal rendering, used internally by grouped rendering. Not intended for direct app usage. |
| `icon`          | `IconDefinition`      | -       | Custom icon              |
| `message`       | `string`              | -       | Required, message content |
| `onClose`       | `() => void`          | -       | Close callback           |
| `severity`      | `AlertBannerSeverity` | -       | Required, severity level |

---

## AlertBannerSeverity Type

| Severity  | Description | Default Icon          |
| --------- | ----------- | --------------------- |
| `info`    | Info        | InfoFilledIcon        |
| `warning` | Warning     | WarningFilledIcon     |
| `error`   | Error       | ErrorFilledIcon       |

---

## AlertBannerAction Type

```tsx
interface AlertBannerAction {
  content?: string;                              // Button text
  onClick: (event: MouseEvent) => void;          // Click callback
  // ...other Button props
}
```

---

## Imperative API

### Basic Methods

| Method                    | Description            |
| ------------------------- | ---------------------- |
| `AlertBanner.add()`       | Add alert              |
| `AlertBanner.remove(key)` | Remove specific alert  |
| `AlertBanner.destroy()`   | Clear all alerts       |
| `AlertBanner.config()`    | Set global config      |
| `AlertBanner.getConfig()` | Get current config     |

### Shortcut Methods

| Method                   | Description   |
| ------------------------ | ------------- |
| `AlertBanner.info()`    | Info alert    |
| `AlertBanner.warning()` | Warning alert |
| `AlertBanner.error()`   | Error alert   |

### AlertBannerData (`add()` parameter type)

Extends `Omit<NotifierData, 'onClose'>` and `AlertBannerConfigProps` (= `NotifierConfig`).

| Property    | Type                  | Default      | Description              |
| ----------- | --------------------- | ------------ | ------------------------ |
| `actions`   | `AlertBannerAction[]` | -            | Action buttons (max 2)   |
| `closable`  | `boolean`             | -            | Whether closable         |
| `duration`  | `number \| false`     | -            | Auto-close duration (ms) |
| `icon`      | `IconDefinition`      | -            | Custom icon              |
| `message`   | `string`              | **required** | Message content          |
| `onClose`   | `() => void`          | -            | Close callback           |
| `reference` | `Key`                 | -            | Identification key       |
| `severity`  | `AlertBannerSeverity` | **required** | Severity level           |

---

## Usage Examples

### Component-based Usage

```tsx
import { AlertBanner } from '@mezzanine-ui/react';
import { useState } from 'react';

function AlertBannerExample() {
  const [visible, setVisible] = useState(true);

  if (!visible) return null;

  return (
    <AlertBanner
      severity="info"
      message="This is an info notification"
      closable
      onClose={() => setVisible(false)}
    />
  );
}
```

### With Action Buttons

```tsx
<AlertBanner
  severity="warning"
  message="Your account is about to expire"
  actions={[
    {
      content: 'Renew Now',
      onClick: () => handleRenew(),
    },
    {
      content: 'Remind Later',
      onClick: () => handleRemindLater(),
    },
  ]}
/>
```

### Imperative Usage

```tsx
import { AlertBanner, Button } from '@mezzanine-ui/react';

// Shortcut methods
<Button onClick={() => AlertBanner.info('This is info')}>
  Info
</Button>

<Button onClick={() => AlertBanner.warning('Please note!')}>
  Warning
</Button>

<Button onClick={() => AlertBanner.error('An error occurred!')}>
  Error
</Button>
```

### Using add Method

```tsx
// Basic usage
AlertBanner.add({
  message: 'This is an alert message',
  severity: 'info',
});

// With action buttons
AlertBanner.add({
  message: 'System maintenance in progress',
  severity: 'warning',
  actions: [
    {
      content: 'Learn More',
      onClick: () => window.open('/maintenance'),
    },
  ],
});

// Non-closable
AlertBanner.add({
  message: 'Important notice',
  severity: 'error',
  closable: false,
});
```

### Alert with Key

```tsx
// Add alert with key
const key = AlertBanner.error('Error message', { key: 'error-alert' });

// Remove later
AlertBanner.remove(key);
```

### With Close Callback

```tsx
AlertBanner.add({
  message: 'About to close',
  severity: 'info',
  onClose: () => {
    console.log('Alert closed');
  },
});
```

### Destroy All Alerts

```tsx
AlertBanner.destroy();
```

---

## Internal Behavior

1. **Sorting rules**: When multiple AlertBanners are displayed simultaneously, non-`info` severity (`error`, `warning`) appears first; same priority sorted by creation time (newest first)
2. **Animation**: Entry/exit uses `isEntering` / `isExiting` state for animation management, exit animation lasts 250ms (moderate duration)
3. **Portal**: Renders in Portal `alert` level

---

## Figma Mapping

| Figma Variant                 | React Props                          |
| ----------------------------- | ------------------------------------ |
| `AlertBanner / Info`          | `severity="info"`                    |
| `AlertBanner / Warning`       | `severity="warning"`                 |
| `AlertBanner / Error`         | `severity="error"`                   |
| `AlertBanner / With Actions`  | `actions={[...]}`                    |
| `AlertBanner / Closable`      | `closable`                           |

---

## Best Practices

### 場景推薦

| 使用情境 | 推薦用法 | 原因 |
| ------- | ------- | ---- |
| 資訊提示 | `<AlertBanner severity="info" />` 或 `AlertBanner.info()` | 輕量級通知 |
| 警告通知 | `<AlertBanner severity="warning" />` 或 `AlertBanner.warning()` | 需注意但非緊急 |
| 錯誤通知 | `<AlertBanner severity="error" />` 或 `AlertBanner.error()` | 需要立即處理 |
| 固定位置通知 | 組件式 `<AlertBanner>` | 放在頁面固定區域 |
| 全域系統通知 | 命令式 `AlertBanner.add()` | 全局隊列，自動排序 |
| 需要用戶操作 | 加 `actions` 屬性 | 讓用戶立即回應 |
| 自動消失 | `duration={3000}` (命令式) | 低優先級訊息 |
| 需持久顯示 | `closable={false}` 或 `duration={false}` | 重要告示 |

### 常見錯誤

#### ❌ 訊息冗長
```tsx
// 不好：太長，用戶無法快速理解
<AlertBanner
  severity="error"
  message="系統在進行定期維護，預計於 2026 年 3 月 13 日下午 2 點至 4 點進行，期間服務將無法使用，給您造成不便敬請見諒"
/>
```

#### ✅ 正確做法：簡潔清晰
```tsx
<AlertBanner
  severity="error"
  message="系統維護中，2-4 PM 期間無法使用"
  actions={[
    {
      content: '了解詳情',
      onClick: () => window.open('/maintenance-info'),
    },
  ]}
/>
```

#### ❌ 超過 2 個行動按鈕
```tsx
// 不好：選擇過多，影響決策
<AlertBanner
  severity="warning"
  message="帳戶即將過期"
  actions={[
    { content: '續約', onClick: renew },
    { content: '忽略', onClick: dismiss },
    { content: '升級', onClick: upgrade },  {/* 太多 */}
  ]}
/>
```

#### ✅ 正確做法：最多 2 個動作
```tsx
<AlertBanner
  severity="warning"
  message="帳戶即將過期"
  actions={[
    { content: '續約', onClick: renew },
    { content: '詳情', onClick: showDetails },
  ]}
/>
```

#### ❌ 錯誤訊息設定自動消失
```tsx
// 不好：錯誤需要用戶注意，不應自動消失
AlertBanner.error('付款失敗', { duration: 3000 });
```

#### ✅ 正確做法：錯誤應持久顯示
```tsx
// 方式 1：不設 duration（預設不消失）
AlertBanner.error('付款失敗', { closable: true });

// 方式 2：明確禁用自動消失
AlertBanner.error('付款失敗', { duration: false });
```

#### ❌ 混用組件式和命令式
```tsx
// 不夠清晰：邏輯分散
const [showAlert, setShowAlert] = useState(false);

return (
  <>
    {showAlert && <AlertBanner severity="info" message="Info" />}
    <Button
      onClick={() => {
        AlertBanner.warning('Warning');  {/* 又用命令式 */}
      }}
    />
  </>
);
```

#### ✅ 正確做法：一致的用法
```tsx
// 全用命令式，簡潔
<Button
  onClick={() => {
    AlertBanner.info('Info');
    AlertBanner.warning('Warning');
  }}
/>

// 或全用組件式，可控
const [alerts, setAlerts] = useState([]);
return (
  <>
    {alerts.map((alert) => (
      <AlertBanner key={alert.id} {...alert} />
    ))}
  </>
);
```

#### ❌ 自訂圖示卻未設定 severity
```tsx
// 問題：圖示自訂但 severity 不明確
<AlertBanner
  icon={CustomIcon}
  message="Something happened"
  {/* 用戶不知道嚴重性 */}
/>
```

#### ✅ 正確做法：保持 severity 語義
```tsx
<AlertBanner
  severity="warning"
  icon={CustomWarningIcon}  {/* 配合 severity */}
  message="Important notice"
/>
```

### 核心要點

1. **選擇合適 severity**：資訊 < 警告 < 錯誤，影響視覺突出度
2. **訊息簡潔**：一行為佳，方便快速理解
3. **最多 2 動作**：過多選擇導致決策困難
4. **錯誤不自動消失**：需要用戶主動確認
5. **命令式適合全局**：多個通知時自動排序和去重
6. **組件式適合固定區域**：頁面特定位置的提示
