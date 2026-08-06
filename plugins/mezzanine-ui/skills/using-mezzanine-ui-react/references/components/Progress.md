# Progress Component

> **Category**: Feedback
>
> **Storybook**: `Feedback/Progress`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Progress) · Verified 1.4.1 (2026-07-01)

A progress bar component for displaying operation completion progress.

## Import

```tsx
import { Progress } from '@mezzanine-ui/react';
import type { ProgressProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-progress--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Progress Props

> Extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'title' | 'children'>` — `title` and `children` are not supported.

| Property       | Type                                                           | Default      | Description                      |
| -------------- | -------------------------------------------------------------- | ------------ | -------------------------------- |
| `icons`        | `{ error?: IconDefinition; success?: IconDefinition }`         | -            | Custom icons for error/success states |
| `percent`      | `number`                                                       | `0`          | Progress percentage (0-100)      |
| `percentProps` | `Omit<TypographyProps, 'className' \| 'children'>`             | -            | Percentage text props            |
| `status`       | `ProgressStatus`                                               | Auto-detect  | Force set status; auto-detects from percent if omitted |
| `tick`         | `number`                                                       | `0`          | Tick mark position (0-100)       |
| `type`         | `ProgressType`                                                 | `'progress'` | Display type                     |

---

## ProgressType

| Type       | Description             | Right Side Display       |
| ---------- | ----------------------- | ------------------------ |
| `progress` | Progress bar only       | No additional display    |
| `percent`  | Progress bar + percent  | Shows `XX%` number       |
| `icon`     | Progress bar + icon     | Shows icon on success/error |

---

## ProgressStatus

| Status    | Description              | Auto-detect Condition    |
| --------- | ------------------------ | ------------------------ |
| `enabled` | In progress (default green) | `percent < 100`       |
| `success` | Success (green + icon)   | `percent >= 100`         |
| `error`   | Error (red + icon)       | Must be set manually     |

---

## Usage Examples

### Basic Progress Bar

```tsx
import { Progress } from '@mezzanine-ui/react';

<Progress percent={30} />
<Progress percent={60} />
<Progress percent={100} />
```

### Show Percentage

```tsx
<Progress percent={45} type="percent" />
// Shows "45%"
```

### With Status Icon

```tsx
// In progress
<Progress percent={60} type="icon" />

// Success
<Progress percent={100} type="icon" status="success" />

// Error
<Progress percent={60} type="icon" status="error" />
```

### With Tick Mark

```tsx
// Show tick at 75% position
<Progress percent={50} tick={75} />
```

### Custom Icons

```tsx
import { CheckedFilledIcon, DangerousFilledIcon } from '@mezzanine-ui/icons';

<Progress
  percent={100}
  type="icon"
  status="success"
  icons={{
    success: CheckedFilledIcon,
    error: DangerousFilledIcon,
  }}
/>
```

### Dynamic Update

```tsx
function UploadProgress() {
  const [percent, setPercent] = useState(0);
  const [status, setStatus] = useState<'enabled' | 'success' | 'error'>('enabled');

  const handleUpload = async () => {
    setStatus('enabled');

    for (let i = 0; i <= 100; i += 10) {
      await delay(100);
      setPercent(i);
    }

    setStatus('success');
  };

  return (
    <>
      <Progress percent={percent} type="icon" status={status} />
      <Button onClick={handleUpload}>Start Upload</Button>
    </>
  );
}
```

### Error State

```tsx
function DownloadProgress() {
  const [percent, setPercent] = useState(60);
  const [status, setStatus] = useState<'enabled' | 'error'>('error');

  return (
    <Progress
      percent={percent}
      type="icon"
      status={status}
    />
  );
}
```

---

## Figma Mapping

| Figma Variant                | React Props                              |
| ---------------------------- | ---------------------------------------- |
| `Progress / Default`         | `type="progress"`                        |
| `Progress / With Percent`    | `type="percent"`                         |
| `Progress / With Icon`       | `type="icon"`                            |
| `Progress / Success`         | `status="success"`                       |
| `Progress / Error`           | `status="error"`                         |
| `Progress / With Tick`       | `tick={75}`                              |

---

## Scenario-Oriented Best Practices

### 場景推薦

| 使用場景 | 建議做法 | 原因 |
| -------- | -------- | ---- |
| 檔案上傳進度 | 使用 `type="icon"` 搭配動態 `percent` | 上傳完成時自動轉為成功狀態，視覺反饋清晰 |
| 下載進度顯示 | 使用 `type="percent"` 顯示百分比數值 | 用戶關心具體數字，便於預估剩餘時間 |
| 任務完成狀態指示 | 使用 `type="icon"` 配合 `status="error"` | 失敗狀態需手動設置，以區別正常進度 |
| 處理流程多個里程碑 | 使用 `tick` 標記重要節點 | 視覺化顯示流程階段，提示用戶當前位置 |
| 自訂成功/失敗圖示 | 透過 `icons` prop 傳入自訂 IconDefinition | 配合品牌或特定設計風格 |

### 常見錯誤

- **期望 error 狀態自動檢測**：Error 無法自動檢測，必須明確 `status="error"`。Success 在 `percent >= 100` 時自動轉換，Error 不會
- **在 `percent < 100` 時設置 `status="success"`**：可行但不符合直覺。應等待 `percent >= 100` 利用自動檢測
- **使用 `type="percent"` 卻自訂了 `renderValue`**：Type 控制顯示內容類型，自訂 `renderValue` 時應改用 `percentProps`
- **tick 值超過 100 或為負數**：Tick 應在 0-100 範圍內，超出範圍會導致視覺位置不正確

## Best Practices

1. **Choose appropriate type**: Use `progress` for simple scenarios, `percent` when numbers are needed
2. **Auto status detection**: When `status` is not specified, it is automatically determined by percent
3. **Error state must be set manually**: Error state requires explicit `status="error"`
4. **Smooth animation**: CSS provides automatic transition animation when percent updates
5. **Tick marks**: Use `tick` to mark targets or milestones
