# InlineMessage Component

> **Category**: Feedback
>
> **Storybook**: `Feedback/Inline Messages`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/InlineMessage) · Verified 1.5.1 (2026-09-12)

An inline message component for displaying contextual feedback messages.

> **Aliases** — Alert (MUI) · Callout · Inline Alert · Helper Text · 區塊說明 · 警語 · 表單提示
> **Not for** — 頁面級／系統級公告（用 [`AlertBanner`](AlertBanner.md)）；一閃即逝的操作回饋（用 [`Message`](Message.md)）

## Import

```tsx
import { InlineMessage, InlineMessageGroup } from '@mezzanine-ui/react';
import type {
  InlineMessageProps,
  InlineMessageGroupProps,
  InlineMessageGroupItem,
} from '@mezzanine-ui/react';

// InlineMessageSeverity must be imported from core
import type { InlineMessageSeverity } from '@mezzanine-ui/core/inline-message';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-inline-messages--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## InlineMessage Props

Extends `NativeElementPropsWithoutKeyAndRef<'div'>`.

| Property    | Type                                | Default    | Description                      |
| ----------- | ----------------------------------- | ---------- | -------------------------------- |
| `content`   | `string`                            | **Required** | Message content (string only)  |
| `className` | `string`                            | -          | Additional className             |
| `icon`      | `IconDefinition`                    | -          | Custom icon                      |
| `onClose`   | `() => void`                        | -          | Close callback                   |
| `severity`  | `InlineMessageSeverity`             | **Required** | Severity level                 |

---

## InlineMessageSeverity Type

```tsx
type InlineMessageSeverity = 'info' | 'warning' | 'error';
```

Note: InlineMessage does not support `success` type (unlike Alert).

---

## Usage Examples

### Basic Usage

```tsx
import { InlineMessage } from '@mezzanine-ui/react';

<InlineMessage severity="info" content="This is an info message" />
<InlineMessage severity="warning" content="This is a warning message" />
<InlineMessage severity="error" content="This is an error message" />
```

### With Close Button

```tsx
// Only severity="info" displays a close button
<InlineMessage
  severity="info"
  content="This is a closable message"
  onClose={() => console.log('closed')}
/>
```

### Custom Icon

```tsx
import { InfoIcon } from '@mezzanine-ui/icons';

<InlineMessage
  severity="info"
  content="Message with custom icon"
  icon={InfoIcon}
/>
```

### Form Field Hint

```tsx
function FormFieldWithHint() {
  const [hasError, setHasError] = useState(false);

  return (
    <div>
      <Input
        error={hasError}
        onChange={(e) => setHasError(!e.target.value)}
      />
      {hasError && (
        <InlineMessage
          severity="error"
          content="This field is required"
        />
      )}
    </div>
  );
}
```

### Warning Hint

```tsx
<InlineMessage
  severity="warning"
  content="This action cannot be undone"
/>
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-inline-messages--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## InlineMessageGroup

A group component that combines multiple InlineMessages together.

### InlineMessageGroup Props

| Property      | Type                        | Default | Description                                 |
| ------------- | --------------------------- | ------- | ------------------------------------------- |
| `items`       | `InlineMessageGroupItem[]`  | -       | Message items (ignored when children exists) |
| `children`    | `ReactNode`                 | -       | Custom message nodes                        |
| `onItemClose` | `(key: Key) => void`        | -       | Item close callback                         |

### InlineMessageGroupItem

```tsx
interface InlineMessageGroupItem extends Omit<InlineMessageProps, 'content'> {
  key: Key;
  content: string;
}
```

### InlineMessageGroup Usage Example

```tsx
import { InlineMessageGroup } from '@mezzanine-ui/react';

<InlineMessageGroup
  items={[
    { key: '1', severity: 'info', content: 'Info message' },
    { key: '2', severity: 'warning', content: 'Warning message' },
    { key: '3', severity: 'error', content: 'Error message' },
  ]}
  onItemClose={(key) => console.log('closed', key)}
/>
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-inline-messages--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## InlineMessage vs AlertBanner

| Feature       | InlineMessage              | AlertBanner                   |
| ------------- | -------------------------- | ----------------------------- |
| Position      | Inline, near fields        | Page top (Portal alert layer) |
| Close button  | Info only                  | Yes (configurable closable)   |
| Severity      | info / warning / error     | info / warning / error        |
| Action buttons| None                       | Up to 2                       |
| API           | Component only             | Component + imperative        |
| Use case      | Form validation, field hints | Global system notifications |
| Animation     | Fade in/out                | CSS transition (entering/exiting) |

---

## Close Behavior

- **severity="info"**: Displays a close button, controlled by the `onClose` prop
- **severity="warning" / "error"**: No close button

This is because warning and error messages typically require user action to resolve and should not be directly dismissed.

> Implementation note: The close button is rendered internally using the `ClearActions` component, which still ships as a real component in `packages/react/src/ClearActions` but is **not exported** from the `@mezzanine-ui/react` package entrypoint (only via sub-path `@mezzanine-ui/react/ClearActions`). This is an internal detail — do not import or use `ClearActions` directly here. Interact with the close button exclusively through the `onClose` prop.

---

## Figma Mapping

| Figma Variant                  | React Props                              |
| ------------------------------ | ---------------------------------------- |
| `InlineMessage / Info`         | `severity="info"`                        |
| `InlineMessage / Warning`      | `severity="warning"`                     |
| `InlineMessage / Error`        | `severity="error"`                       |

---

## Best Practices

### 場景推薦

| 使用場景 | 建議方案 | 說明 |
| ------- | ------- | ---- |
| 表單驗證提示 | `severity="error"` | 欄位驗證失敗時的即時反饋 |
| 欄位說明 | `severity="info"` | 額外說明或提示，顯示關閉按鈕 |
| 警告訊息 | `severity="warning"` | 操作前的警告，無關閉按鈕 |
| 多個訊息 | `InlineMessageGroup` | 將多個訊息組織在一起顯示 |

### 常見錯誤

1. **使用 ReactNode 而非 string**
   - ❌ 錯誤：`<InlineMessage severity="error" content={<span>Error</span>} />`
   - ✅ 正確：`<InlineMessage severity="error" content="Error message" />`

2. **僅靠文字傳達嚴重程度**
   - ❌ 錯誤：`<InlineMessage severity="info" content="Error: Field required" />`（訊息說錯誤，但 severity 是 info）
   - ✅ 正確：`<InlineMessage severity="error" content="This field is required" />`

3. **在 warning/error 上新增 onClose**
   - ❌ 錯誤：`<InlineMessage severity="error" onClose={handleClose} />`（使用者可能誤認為問題已解決）
   - ✅ 正確：只在 `severity="info"` 時提供 onClose

4. **訊息過長或複雜**
   - ❌ 錯誤：`<InlineMessage content="This is a very long message explaining everything..." />`
   - ✅ 正確：保持簡潔：`<InlineMessage content="Email is required" />`

5. **位置不當**
   - ❌ 錯誤：訊息放在頁面其他位置，與相關欄位相隔很遠
   - ✅ 正確：放在相關欄位下方或旁邊

### 實作建議

1. **保持內容簡潔**：訊息應清晰且簡短
2. **選擇正確的嚴重程度**：根據訊息類型選擇合適的 severity
3. **位置靠近相關內容**：放在相關欄位或內容附近
4. **無障礙支援**：組件已內含 `role="status"` 和 `aria-live="polite"`
5. **僅支援字串內容**：content 只支援 string，不支援 ReactNode
