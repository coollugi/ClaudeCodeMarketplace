# Notifier

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/notifier) · Verified 1.0.0-rc.4 (2026-04-24)

Low-level notification queue manager. `MznNotifierService` is the singleton backbone used by `MznMessageService` and `MznAlertBannerService`. It manages a displayed list and a queue, enforcing `maxCount` with automatic promotion.

> **Aliases** — Notification factory · 自訂通知系統底層
> **Not for** — 一般的操作提示（直接用 [`MznMessage`](Message.md)）；通知中心（用 [`MznNotificationCenter`](NotificationCenter.md)）。只有需要自建一整套通知型別時才直接用它。

## Import

```ts
import { MznNotifierService } from '@mezzanine-ui/ng/notifier';
import type { NotifierData, NotifierConfig, SortBeforeUpdate } from '@mezzanine-ui/ng/notifier';
```

## Service API

`MznNotifierService` is `providedIn: 'root'`.

```ts
import { inject } from '@angular/core';
import { MznNotifierService } from '@mezzanine-ui/ng/notifier';

private readonly notifier = inject(MznNotifierService);
```

### Methods

| Method                                                                    | Returns                   | Description                                                    |
| ------------------------------------------------------------------------- | ------------------------- | -------------------------------------------------------------- |
| `add(data: Omit<NotifierData, 'key'> & { key?: string })`                 | `string`                  | Add a notification; `key` is auto-generated if omitted; returns the key used |
| `remove(key: string)`                                                     | `void`                    | Remove by key; promotes queued item if slot opens              |
| `destroy()`                                                               | `void`                    | Remove all displayed and queued notifications                  |
| `config(cfg: Partial<NotifierConfig>)`                                    | `void`                    | Partially update `duration` and/or `maxCount`                  |
| `getConfig()`                                                             | `Readonly<NotifierConfig>`| Read the current notifier configuration                        |
| `setSortBeforeUpdate(fn: SortBeforeUpdate \| null)`                       | `void`                    | Set a sort function applied before each display update         |

### Readable Signals

| Signal       | Type                          | Description                    |
| ------------ | ----------------------------- | ------------------------------ |
| `displayed`  | `Signal<ReadonlyArray<NotifierData>>` | Currently visible items  |
| `queued`     | `Signal<ReadonlyArray<NotifierData>>` | Waiting items (over limit) |

### NotifierData shape

```ts
interface NotifierData {
  readonly key: string;               // required in the stored record; optional when calling add()
  readonly message?: string;
  readonly duration?: number | false; // per-item override; false = persistent
  readonly onClose?: (key: string) => void;
  readonly [prop: string]: unknown;   // extra fields for component-specific data
}
```

> When calling `add()`, pass `Omit<NotifierData, 'key'> & { key?: string }` — omitting `key` causes the service to auto-generate one. The generated key is returned from `add()`.

### NotifierConfig

```ts
interface NotifierConfig {
  readonly duration?: number | false;  // default 3000 ms
  readonly maxCount?: number;          // default 4
}
```

## ControlValueAccessor

No — `MznNotifierService` is a pure service with no component.

## Usage

```ts
import { inject, Component, computed } from '@angular/core';
import { MznNotifierService } from '@mezzanine-ui/ng/notifier';

@Component({ /* ... */ })
export class ToastContainerComponent {
  private readonly notifier = inject(MznNotifierService);

  // Read displayed signal for template rendering
  readonly toasts = this.notifier.displayed;

  // Override global config
  constructor() {
    this.notifier.config({ duration: 5000, maxCount: 3 });
  }

  dismiss(key: string): void {
    this.notifier.remove(key);
  }
}
```

```html
<!-- Render the notifier list manually (low-level usage) -->
@for (toast of toasts(); track toast.key) {
  <div class="toast" (click)="dismiss(toast.key)">
    {{ toast.message }}
  </div>
}
```

## Notes

- In most cases you should use `MznMessageService` (for toasts) or `MznAlertBannerService` rather than `MznNotifierService` directly. The notifier is an infrastructure-level service.
- When `maxCount` is reached, new items enter the `queued` signal. When any displayed item is removed, the first queued item is automatically promoted to `displayed`.
- `setSortBeforeUpdate` allows priority-based ordering — e.g. showing errors before info messages. The sort function receives and returns a `ReadonlyArray<NotifierData>`.
- There is no React counterpart for this service — the React `createNotifier` factory function plays the same role but is not a class/service.
