# Toggle Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/Toggle`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Toggle) · Verified 1.4.1 (2026-07-01)

> Toggle is the successor of the removed Switch component (removed in 1.4.1). Migrate `Switch` usages to `Toggle` — public API is intentionally aligned (checked / defaultChecked / disabled / onChange), with new `label`, `supportingText`, and `size` additions.

A toggle switch component for turning a single option on or off. Supports controlled and uncontrolled modes with optional label and supporting text.

> **Aliases** — Switch (MUI・Ant Design・Bootstrap `form-switch`) · Slide Toggle · 開關 · 切換開關 · Figma `Toggle / *`
> **Not for** — 多選清單（用 [`Checkbox`](Checkbox.md) / `CheckboxGroup`）；互斥的多選一（用 [`RadioGroup type="segment"`](Radio.md)）。`Switch` 已不在公開 API，一律改用 `Toggle`。

## Import

```tsx
import { Toggle } from '@mezzanine-ui/react';
import type { ToggleProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-toggle--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Toggle Props

Extends `NativeElementPropsWithoutKeyAndRef<'div'>`.

| Property          | Type                      | Default | Description                              |
| ----------------- | ------------------------- | ------- | ---------------------------------------- |
| `checked`         | `boolean`                 | -       | Checked state (controlled mode)           |
| `defaultChecked`  | `boolean`                 | `-`     | Initial checked state (uncontrolled mode)|
| `disabled`        | `boolean`                 | `false` | Whether disabled                         |
| `inputProps`      | `Omit<NativeElementPropsWithoutKeyAndRef<'input'>, 'checked' \| 'defaultChecked' \| 'disabled' \| 'onChange' \| 'placeholder' \| 'type' \| 'value' \| 'aria-disabled' \| 'aria-checked'>` | - | Native input attributes (excluding controlled props) |
| `label`           | `string`                  | -       | Label text displayed beside toggle       |
| `onChange`        | `ChangeEventHandler<HTMLInputElement>` | - | Change event handler |
| `size`            | `'main' \| 'sub'`        | `'main'` | Toggle size                              |
| `supportingText`  | `string`                  | -       | Helper text displayed below label        |

---

## ToggleSize

```tsx
type ToggleSize = 'main' | 'sub';
```

| Size   | Description |
| ------ | ----------- |
| `main` | Main size   |
| `sub`  | Sub size    |

---

## Usage Examples

### Basic Toggle (Uncontrolled)

```tsx
import { Toggle } from '@mezzanine-ui/react';

<Toggle label="Enable notifications" />
```

### Controlled Toggle

```tsx
import { useState } from 'react';
import { Toggle } from '@mezzanine-ui/react';

function ControlledToggle() {
  const [enabled, setEnabled] = useState(false);

  return (
    <Toggle
      checked={enabled}
      onChange={(e) => setEnabled(e.target.checked)}
      label="Feature enabled"
    />
  );
}
```

### With Supporting Text

```tsx
<Toggle
  label="Auto-save"
  supportingText="Automatically save changes every minute"
/>
```

### Different Sizes

```tsx
<Toggle label="Main size" size="main" />
<Toggle label="Sub size" size="sub" />
```

### Disabled State

```tsx
<Toggle label="Read-only" disabled />
```

### With Default Checked

```tsx
<Toggle
  defaultChecked
  label="Dark mode"
/>
```

### Multiple Toggles in Form

```tsx
import { Toggle } from '@mezzanine-ui/react';

function PreferencesForm() {
  const [preferences, setPreferences] = useState({
    notifications: true,
    darkMode: false,
    autoSave: true,
  });

  const handleChange = (key) => (e) => {
    setPreferences((prev) => ({
      ...prev,
      [key]: e.target.checked,
    }));
  };

  return (
    <>
      <Toggle
        checked={preferences.notifications}
        onChange={handleChange('notifications')}
        label="Notifications"
        supportingText="Receive push notifications"
      />
      <Toggle
        checked={preferences.darkMode}
        onChange={handleChange('darkMode')}
        label="Dark Mode"
      />
      <Toggle
        checked={preferences.autoSave}
        onChange={handleChange('autoSave')}
        label="Auto-save"
        supportingText="Automatically save your work"
      />
    </>
  );
}
```

---

## Best Practices

### 場景推薦

| 使用情境 | 推薦用法 | 原因 |
| ------- | ------- | ---- |
| 單一開關 | `<Toggle label="..."/>` | 簡潔，直觀 |
| 搭配說明 | `<Toggle label="..." supportingText="..."/>` | 提供額外上下文 |
| 非受控 | `<Toggle defaultChecked label="..."/>` | 簡單狀態管理 |
| 受控表單 | `<Toggle checked={state} onChange={handler}/>` | 複雜表單場景 |
| 不同尺度 | `size="main" \| size="sub"` | 視覺層級區分 |
| 禁用狀態 | `disabled` | 表示不可用 |

### 常見錯誤

#### ❌ 混用 checked 與 defaultChecked
```tsx
// 錯誤：兩個屬性同時出現會導致混亂
<Toggle checked={true} defaultChecked={false} label="Conflicting" />
```

#### ✅ 正確做法：選擇一種模式
```tsx
// 非受控模式
<Toggle defaultChecked label="Simple" />

// 受控模式
<Toggle checked={enabled} onChange={setEnabled} label="Controlled" />
```

#### ❌ 缺少標籤或說明
```tsx
// 錯誤：使用者不知道開關代表什麼
<Toggle />
```

#### ✅ 正確做法：提供清晰標籤
```tsx
<Toggle label="Enable feature" supportingText="This feature is beta" />
```

#### ❌ 誤用於多選選項
```tsx
// 錯誤：使用 Toggle 作為多選方案
<Toggle label="Option 1" />
<Toggle label="Option 2" />
<Toggle label="Option 3" />
{/* 應該用 Checkbox 代替 */}
```

#### ✅ 正確做法：多選用 Checkbox
```tsx
import { Checkbox } from '@mezzanine-ui/react';

<Checkbox label="Option 1" />
<Checkbox label="Option 2" />
<Checkbox label="Option 3" />
```

### 核心要點

1. **單一選項開關**：Toggle 專門用於二元選擇，不是多選工具
2. **清晰標籤必須**：`label` 屬性讓使用者瞭解功能用途
3. **說明文字優化體驗**：`supportingText` 提供額外背景資訊
4. **受控 vs 非受控**：簡單開關用非受控，複雜表單用受控
5. **無障礙屬性**：自動管理 `aria-checked` 和 `aria-disabled`
