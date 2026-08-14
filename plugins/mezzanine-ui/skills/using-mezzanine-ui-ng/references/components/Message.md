# Message

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/message) · Verified 1.0.0-rc.4 (2026-04-24)

Global toast notification system. The primary API is `MznMessageService` (injectable singleton) which corresponds to React's `Message.success()` / `Message.error()` static methods. `MznMessage` is the individual toast component rendered by the notifier system.

> **Aliases** — Toast · Snackbar (MUI) · MatSnackBar (Angular Material) · message (Ant Design) · 浮動提示 · 操作回饋
> **Not for** — 需要保留可回顧的通知（用 [`MznNotificationCenter`](NotificationCenter.md)）；固定在版面裡的說明（用 [`MznInlineMessage`](InlineMessage.md)）

## Import

```ts
import { MznMessage, MznMessageService } from '@mezzanine-ui/ng/message';
import type { MessageData }               from '@mezzanine-ui/ng/message';
import type { MessageSeverity }           from '@mezzanine-ui/core/message';
```

## Service API

`MznMessageService` is `providedIn: 'root'` — inject it anywhere without additional providers.

```ts
import { inject } from '@angular/core';
import { MznMessageService } from '@mezzanine-ui/ng/message';

private readonly message = inject(MznMessageService);
```

### Methods

| Method                                                       | Returns  | Description                                |
| ------------------------------------------------------------ | -------- | ------------------------------------------ |
| `success(message, props?)`                                   | `string` | Show a success toast; returns unique key   |
| `error(message, props?)`                                     | `string` | Show an error toast                        |
| `info(message, props?)`                                      | `string` | Show an info toast                         |
| `warning(message, props?)`                                   | `string` | Show a warning toast                       |
| `loading(message, props?)`                                   | `string` | Show a persistent loading toast (no auto-close) |
| `add(data: MessageData)`                                     | `string` | Low-level add with full `MessageData`      |
| `remove(key: string)`                                        | `void`   | Remove a specific toast by key             |
| `destroy()`                                                  | `void`   | Remove all toasts                          |
| `config({ duration?, maxCount? })`                           | `void`   | Update global defaults                     |

### MessageData shape

```ts
interface MessageData {
  readonly message: string;
  readonly severity?: MessageSeverity;  // 'success' | 'error' | 'info' | 'warning' | 'loading'
  readonly icon?: IconDefinition;
  readonly duration?: number | false;   // ms before auto-close; false = persistent
  readonly key?: string;                // custom key; auto-generated if omitted
}
```

## MznMessage Component — Inputs

`MznMessage` is rendered internally by the notifier system. You typically do not use it directly.

| Input        | Type                            | Default  | Description                                                               |
| ------------ | ------------------------------- | -------- | ------------------------------------------------------------------------- |
| `message`    | `string` (**required**)         | —        | Toast text                                                                |
| `messageKey` | `string` (**required**)         | —        | Unique key assigned by `MznMessageService`; used to identify and remove the toast. **Set internally — consumers do not provide this.** |
| `severity`   | `MessageSeverity \| undefined`  | —        | Icon and colour variant                                                   |
| `icon`       | `IconDefinition \| undefined`   | —        | Custom icon (overrides severity icon)                                     |
| `duration`   | `number \| false`               | `3000`   | Auto-close delay (ms); `false` = no auto-close                            |
| `reference`  | `string \| number \| undefined` | —        | Unique reference for identification (corresponds to React's `reference` prop) |

## MznMessage Component — Outputs

| Output   | Type                      | Description                                                                                       |
| -------- | ------------------------- | ------------------------------------------------------------------------------------------------- |
| `closed` | `OutputEmitterRef<string>` | Emits the `messageKey` when the auto-close timer fires. Used internally by `MznMessageService` to remove the toast from the queue; not intended for direct consumer use. |

## Selector

`[mznMessage]` — internal rendering component.

## ControlValueAccessor

No.

## Usage

```ts
import { inject, Component } from '@angular/core';
import { MznMessageService } from '@mezzanine-ui/ng/message';

@Component({ /* ... */ })
export class MyComponent {
  private readonly message = inject(MznMessageService);

  onSave(): void {
    const key = this.message.loading('儲存中...');

    this.service.save().subscribe({
      next: () => {
        this.message.remove(key);
        this.message.success('儲存成功！');
      },
      error: () => {
        this.message.remove(key);
        this.message.error('儲存失敗，請重試');
      },
    });
  }

  onDelete(): void {
    this.message.success('已刪除', { duration: 2000 });
  }
}
```

```ts
// Override global defaults (e.g. in AppComponent or root provider)
import { MznMessageService } from '@mezzanine-ui/ng/message';

export class AppComponent {
  constructor() {
    const message = inject(MznMessageService);
    message.config({ duration: 4000, maxCount: 3 });
  }
}
```

## Notes

- `MznMessageService` delegates to `MznNotifierService` internally. The notifier manages the queue and enforces `maxCount`.
- The `loading` method automatically sets `duration: false` — the toast stays until `remove(key)` is called.
- Unlike the React version which uses static class methods (`Message.success(...)`), the Angular version requires injection — this keeps it compatible with Angular's DI and testability patterns.
- There is no `MznMessageContainer` to place in your template; the notifier renders toasts via a portal at the application root automatically.
