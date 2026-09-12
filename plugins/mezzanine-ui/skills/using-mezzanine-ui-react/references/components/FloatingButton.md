# FloatingButton Component

> **Category**: Others
>
> **Storybook**: `Others/FloatingButton`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/FloatingButton) · Verified 1.5.1 (2026-09-12)

A floating action button component that stays fixed on the page. Internally uses the `Button` component with fixed `variant="base-primary"`, `size="main"`, and `tooltipPosition="left"`. Supports auto-hide when `open` state is active.

## Import

```tsx
import { FloatingButton } from '@mezzanine-ui/react';
import type { FloatingButtonProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/others-floating-button--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Props

`FloatingButtonProps` extends `ButtonProps` (excluding `variant`, `size`, `className`, `tooltipPosition`), with the following additional properties:

| Property           | Type             | Default | Description                                        |
| ------------------ | ---------------- | ------- | -------------------------------------------------- |
| `autoHideWhenOpen` | `boolean`        | `false` | Auto-hide floating button when `open` is `true`    |
| `className`        | `string`         | -       | Additional CSS class for root element              |
| `open`             | `boolean`        | `false` | Open state of the floating button                  |
| `children`         | `ReactNode`      | -       | Button content                                     |
| `disabled`         | `boolean`        | `false` | Whether disabled (inherited from ButtonProps)       |
| `loading`          | `boolean`        | `false` | Whether to show loading state (inherited from ButtonProps) |
| `icon`             | `IconDefinition` | -       | Button icon (inherited from ButtonProps)            |
| `iconType`         | `ButtonIconType` | -       | Icon type (inherited from ButtonProps)              |
| `disabledTooltip`  | `boolean`        | `false` | Disable icon-only mode tooltip (inherited from ButtonProps) |
| `onClick`          | `MouseEventHandler` | -    | Click event handler (inherited from native props)  |

> Note: `variant`, `size`, `tooltipPosition` are internally fixed to `'base-primary'`, `'main'`, `'left'` and cannot be overridden via props.

---

## Type Definitions

### ButtonIconType

```ts
type ButtonIconType = 'leading' | 'trailing' | 'icon-only';
```

---

## Usage Examples

### Basic Floating Button

```tsx
import { FloatingButton } from '@mezzanine-ui/react';
import { PlusIcon } from '@mezzanine-ui/icons';

function BasicFloatingButton() {
  return (
    <FloatingButton
      icon={PlusIcon}
      iconType="icon-only"
      onClick={() => console.log('Add')}
    >
      Add
    </FloatingButton>
  );
}
```

### Auto-hide with Open State

```tsx
import { useState } from 'react';
import { FloatingButton } from '@mezzanine-ui/react';
import { PlusIcon } from '@mezzanine-ui/icons';

function FloatingButtonWithPanel() {
  const [panelOpen, setPanelOpen] = useState(false);

  return (
    <>
      <FloatingButton
        icon={PlusIcon}
        iconType="icon-only"
        open={panelOpen}
        autoHideWhenOpen
        onClick={() => setPanelOpen(true)}
      >
        Add Item
      </FloatingButton>
      {panelOpen && (
        <div className="panel">
          <p>Panel content</p>
          <button onClick={() => setPanelOpen(false)}>Close</button>
        </div>
      )}
    </>
  );
}
```

### With Loading State

```tsx
import { useState } from 'react';
import { FloatingButton } from '@mezzanine-ui/react';
import { UploadIcon } from '@mezzanine-ui/icons';

function FloatingButtonWithLoading() {
  const [loading, setLoading] = useState(false);

  const handleClick = async (): Promise<void> => {
    setLoading(true);

    try {
      await uploadData();
    } finally {
      setLoading(false);
    }
  };

  return (
    <FloatingButton
      icon={UploadIcon}
      iconType="icon-only"
      loading={loading}
      onClick={handleClick}
    >
      Upload
    </FloatingButton>
  );
}
```

---

## Best Practices

### 場景推薦

| 使用場景 | 推薦設定 | 說明 |
|---------|--------|------|
| 建立新項目 | `iconType="icon-only"`, PlusIcon | 常見的主操作 |
| 回到頂部 | `iconType="icon-only"`, ArrowUpIcon | 長頁面導航 |
| 開啟聯絡表單 | `autoHideWhenOpen=true` | 開啟時隱藏按鈕 |
| 上傳檔案 | `iconType="icon-only"`, UploadIcon | 非同步上傳操作 |
| 使用者反饋 | `iconType="icon-only"`, MessageIcon | 應用內反饋入口 |

### 常見錯誤

1. **未使用 icon-only 模式導致不必要的文字**
   ```tsx
   // ❌ 錯誤：浮動按鈕顯示過多文字
   <FloatingButton onClick={handleCreate}>
     Add New Item
   </FloatingButton>

   // ✅ 正確：使用 icon-only，文字作為 tooltip
   <FloatingButton
     icon={PlusIcon}
     iconType="icon-only"
     onClick={handleCreate}
   >
     Add New Item
   </FloatingButton>
   ```

2. **開啟面板時忘記隱藏按鈕**
   ```tsx
   // ❌ 錯誤：面板開啟時按鈕仍可見，可能遮擋內容
   const [panelOpen, setPanelOpen] = useState(false);
   <FloatingButton
     icon={PlusIcon}
     iconType="icon-only"
     onClick={() => setPanelOpen(true)}
   />

   // ✅ 正確：使用 autoHideWhenOpen
   <FloatingButton
     icon={PlusIcon}
     iconType="icon-only"
     open={panelOpen}
     autoHideWhenOpen
     onClick={() => setPanelOpen(true)}
   />
   ```

3. **頁面上多個浮動按鈕導致混亂**
   ```tsx
   // ❌ 錯誤：多個浮動按鈕製造視覺雜亂
   <FloatingButton icon={PlusIcon} iconType="icon-only" />
   <FloatingButton icon={EditIcon} iconType="icon-only" />
   <FloatingButton icon={ShareIcon} iconType="icon-only" />

   // ✅ 正確：只有一個主操作浮動按鈕
   <FloatingButton
     icon={PlusIcon}
     iconType="icon-only"
     onClick={handlePrimaryAction}
   />
   ```

4. **非同步操作時未設定 loading 狀態**
   ```tsx
   // ❌ 錯誤：上傳時無視覺反饋
   const handleUpload = async () => {
     await uploadFile();
   };
   <FloatingButton
     icon={UploadIcon}
     iconType="icon-only"
     onClick={handleUpload}
   />

   // ✅ 正確：顯示 loading 狀態
   const [loading, setLoading] = useState(false);
   const handleUpload = async () => {
     setLoading(true);
     try {
       await uploadFile();
     } finally {
       setLoading(false);
     }
   };
   <FloatingButton
     icon={UploadIcon}
     iconType="icon-only"
     loading={loading}
     onClick={handleUpload}
   />
   ```

5. **可存取性不足**
   ```tsx
   // ❌ 錯誤：無障礙屬性不足
   <FloatingButton icon={PlusIcon} iconType="icon-only" />

   // ✅ 正確：提供清晰的無障礙文本
   <FloatingButton
     icon={PlusIcon}
     iconType="icon-only"
     aria-label="Create new item"
   >
     Create new item
   </FloatingButton>
   ```

### 核心原則

1. **使用 icon-only 模式**: 浮動按鈕通常呈現為圖示。設定 `iconType="icon-only"`，將語義化的 `children` 作為 tooltip 文本。
2. **自動隱藏**: 當浮動按鈕開啟面板或側邊欄時，使用 `autoHideWhenOpen` 防止按鈕遮擋內容。
3. **避免多個浮動按鈕**: 一個頁面只應有一個浮動按鈕，代表主要操作。
4. **固定位置**: FloatingButton 位置由 CSS 類控制，通常固定在屏幕右下角。
5. **非同步操作反饋**: 為長時間操作設定 `loading` 狀態以提供視覺反饋。
6. **可存取性**: 提供 aria-label 和語義化的 children 文本。
7. **圖示選擇**: 選擇清晰、易識別的圖示代表主要操作。
