# ResultState Component

> **Category**: Feedback
>
> **Storybook**: `Feedback/ResultState`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/ResultState) · Verified 1.4.1 (2026-07-01)

Result state component for displaying operation results or status pages.

## Import

```tsx
import { ResultState } from '@mezzanine-ui/react';
import type { ResultStateProps, ResultStateActions } from '@mezzanine-ui/react';
// ResultStateType and ResultStateSize must be imported from core
// import type { ResultStateType, ResultStateSize } from '@mezzanine-ui/core/result-state';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-resultstate--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## ResultState Props

> Extends `NativeElementPropsWithoutKeyAndRef<'div'>`.

| Property      | Type                                  | Default        | Description          |
| ------------- | ------------------------------------- | -------------- | -------------------- |
| `actions`     | `ResultStateActions`                  | -              | Action button config |
| `children`    | `ReactElement<ButtonProps> \| [ReactElement<ButtonProps>] \| [ReactElement<ButtonProps>, ReactElement<ButtonProps>]` | - | Button elements (1 or 2) |
| `description` | `string`                              | -              | Description text     |
| `size`        | `ResultStateSize`                     | `'main'`       | Size                 |
| `title`       | `string`                              | **required**   | Title text           |
| `type`        | `ResultStateType`                     | `'information'`| State type           |

---

## ResultStateType

```tsx
type ResultStateType = 'information' | 'success' | 'help' | 'warning' | 'error' | 'failure';
```

Each type corresponds to a different icon and color:

| Type          | Icon               | Usage              |
| ------------- | ------------------ | ------------------ |
| `information` | InfoFilledIcon     | General info       |
| `success`     | CheckedFilledIcon  | Operation success  |
| `help`        | QuestionFilledIcon | Help/question      |
| `warning`     | WarningFilledIcon  | Warning            |
| `error`       | ErrorFilledIcon    | Error              |
| `failure`     | DangerousFilledIcon| Failure/danger     |

## ResultStateSize

```tsx
type ResultStateSize = 'main' | 'sub';
```

---

## ResultStateActions Type

```tsx
// Single button (secondary only)
type SingleButtonAction = {
  secondaryButton: ButtonProps;
  primaryButton?: never;
};

// Two buttons
type TwoButtonsAction = {
  secondaryButton: ButtonProps;
  primaryButton: ButtonProps;
};

type ResultStateActions = SingleButtonAction | TwoButtonsAction;
```

---

## Usage Examples

### Basic Usage

```tsx
import { ResultState } from '@mezzanine-ui/react';

<ResultState
  type="success"
  title="Operation Successful"
  description="Your operation has been completed successfully"
/>
```

### Different Types

```tsx
<ResultState type="information" title="Information" description="This is an informational message" />
<ResultState type="success" title="Success" description="Operation completed" />
<ResultState type="help" title="Need Help?" description="Please contact support" />
<ResultState type="warning" title="Warning" description="Please note the following" />
<ResultState type="error" title="Error" description="An error occurred" />
<ResultState type="failure" title="Failure" description="Operation failed" />
```

### With Action Buttons (using actions)

```tsx
<ResultState
  type="success"
  title="Submission Successful"
  description="Your form has been submitted successfully"
  actions={{
    secondaryButton: {
      children: 'Back to Home',
      onClick: () => router.push('/'),
    },
    primaryButton: {
      children: 'View Details',
      onClick: () => router.push('/detail'),
    },
  }}
/>
```

### With Action Buttons (using children)

```tsx
<ResultState
  type="error"
  title="An Error Occurred"
  description="Please try again later"
>
  <Button onClick={handleRetry}>Retry</Button>
  <Button onClick={handleContact}>Contact Support</Button>
</ResultState>
```

### Single Button

```tsx
<ResultState
  type="information"
  title="Confirm Action"
  description="Please confirm the following"
  actions={{
    secondaryButton: {
      children: 'Got It',
      onClick: handleClose,
    },
  }}
/>
```

### Small Size

```tsx
<ResultState
  size="sub"
  type="warning"
  title="Caution"
  description="This action cannot be undone"
/>
```

### 404 Page

```tsx
function NotFoundPage() {
  return (
    <ResultState
      type="error"
      title="Page Not Found"
      description="The page you visited may have been removed or does not exist"
      actions={{
        secondaryButton: {
          children: 'Back to Home',
          onClick: () => router.push('/'),
        },
      }}
    />
  );
}
```

### Operation Success Page

```tsx
function SubmitSuccessPage() {
  return (
    <ResultState
      type="success"
      title="Submission Successful!"
      description="We will process your request as soon as possible and respond within 1-3 business days."
      actions={{
        secondaryButton: {
          children: 'Back to List',
          onClick: () => router.push('/list'),
        },
        primaryButton: {
          children: 'Create Another',
          onClick: () => router.push('/new'),
        },
      }}
    />
  );
}
```

---

## Button Order

- When using children: the first Button is secondary, the second is primary
- When using actions: `secondaryButton` is on the left, `primaryButton` is on the right
- Maximum of two buttons

---

## Figma Mapping

| Figma Variant                 | React Props                              |
| ----------------------------- | ---------------------------------------- |
| `ResultState / Information`   | `type="information"` (default)           |
| `ResultState / Success`       | `type="success"`                         |
| `ResultState / Help`          | `type="help"`                            |
| `ResultState / Warning`       | `type="warning"`                         |
| `ResultState / Error`         | `type="error"`                           |
| `ResultState / Failure`       | `type="failure"`                         |
| `ResultState / Main`          | `size="main"` (default)                  |
| `ResultState / Sub`           | `size="sub"`                             |
| `ResultState / With Actions`  | `actions` or `children` has value        |

---

## Scenario-Oriented Best Practices

### 場景推薦

| 使用場景 | 建議做法 | 原因 |
| -------- | -------- | ---- |
| 操作成功提示 | `type="success"` + 返回和詳情兩個按鈕 | 明確反饋操作結果，提供後續導航選項 |
| 404 或資源不存在 | `type="error"` + 單一「返回首頁」按鈕 | 表達問題嚴重性，提供恢復路徑 |
| 廢棄功能或維護中 | `type="help"` + 聯絡支援按鈕 | 提示用戶尋求幫助 |
| 警告性操作確認 | `type="warning"` + 「取消」和「確認」按鈕 | 讓用戶在執行不可逆操作前重新確認 |
| 權限不足或無法執行 | `type="failure"` + 相關按鈕 | 與 error 區別，failure 表示非異常的失敗 |
| 在 Modal 內展示結果 | 使用 `size="sub"` 節省空間 | Modal 內容區域有限，小尺寸更合適 |

### 常見錯誤

- **混淆 error 和 failure**：Error 通常表示系統異常或意外，Failure 表示操作自然失敗（如驗證失敗）
- **使用超過兩個按鈕**：會導致用戶決策疲勞。若需多個操作，應改成導航頁面而非對話框
- **primaryButton 和 secondaryButton 顛倒位置**：Primary（右側）應該是推薦操作，Secondary（左側）是備選或返回
- **省略 description 或僅複述 title**：Description 應補充細節，幫助用戶理解發生了什麼和後續步驟
- **在過於複雜的工作流中使用 ResultState**：ResultState 最適合獨立結果頁面，不應嵌入多步驟流程中

## Best Practices

1. **Correct type**: Choose the appropriate type based on the result
2. **Clear description**: Description should concisely explain the state
3. **Button limit**: Maximum two buttons to avoid decision fatigue
4. **Secondary first**: Use `secondaryButton` for single-button scenarios
5. **Page-level usage**: Suitable as full-page content or Modal content
