# Backdrop Component

> **Category**: Others
>
> **Storybook**: `Others/Backdrop`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Backdrop) · Verified 1.4.1 (2026-07-01)

Backdrop overlay component for creating backgrounds for modals, drawers, and other overlay layers.

## Import

```tsx
import { Backdrop } from '@mezzanine-ui/react';
import type { BackdropProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/others-backdrop--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Backdrop Props

| Property                        | Type                 | Default | Description                        |
| ------------------------------- | -------------------- | ------- | ---------------------------------- |
| `children`                      | `ReactNode`          | -       | Child content                      |
| `container`                     | `HTMLElement \| RefObject<HTMLElement> \| RefObject<HTMLElement \| null> \| null` | - | Portal container |
| `disableCloseOnBackdropClick`   | `boolean`            | `false` | Disable close on backdrop click    |
| `disablePortal`                 | `boolean`            | `false` | Disable Portal                     |
| `disableScrollLock`             | `boolean`            | `false` | Disable scroll lock                |
| `onBackdropClick`               | `MouseEventHandler`  | -       | Backdrop click callback            |
| `onClose`                       | `VoidFunction`       | -       | Close callback                     |
| `open`                          | `boolean`            | `false` | Whether open                       |
| `variant`                       | `BackdropVariant`    | `'dark'`| Backdrop variant                   |

---

## BackdropVariant Type

```tsx
type BackdropVariant = 'dark' | 'light';
```

---

## Usage Examples

### Basic Usage

```tsx
import { Backdrop } from '@mezzanine-ui/react';
import { useState } from 'react';

function BasicExample() {
  const [open, setOpen] = useState(false);

  return (
    <>
      <Button onClick={() => setOpen(true)}>Open Backdrop</Button>
      <Backdrop
        open={open}
        onClose={() => setOpen(false)}
      >
        <div>Content</div>
      </Backdrop>
    </>
  );
}
```

### Disable Close on Backdrop Click

```tsx
<Backdrop
  open={open}
  onClose={handleClose}
  disableCloseOnBackdropClick
>
  <div>Must use button to close</div>
</Backdrop>
```

### Custom Backdrop Click Handler

```tsx
<Backdrop
  open={open}
  onClose={handleClose}
  onBackdropClick={(event) => {
    console.log('Backdrop clicked');
  }}
>
  <div>Content</div>
</Backdrop>
```

### Disable Scroll Lock

```tsx
<Backdrop
  open={open}
  onClose={handleClose}
  disableScrollLock
>
  <div>Page can still scroll while backdrop is open</div>
</Backdrop>
```

### Custom Container

```tsx
const containerRef = useRef<HTMLDivElement>(null);

<div ref={containerRef} style={{ position: 'relative' }}>
  <Backdrop
    open={open}
    onClose={handleClose}
    container={containerRef.current}
  >
    <div>Rendered into custom container</div>
  </Backdrop>
</div>
```

### Disable Portal

```tsx
<Backdrop
  open={open}
  onClose={handleClose}
  disablePortal
>
  <div>Rendered in place without Portal</div>
</Backdrop>
```

---

## Internal Behavior

1. **Scroll lock**: Body scroll is locked by default when open
2. **Portal**: Renders to Portal container by default
3. **Fade animation**: Uses Fade transition effect
4. **Positioning**: Uses absolute positioning with custom container or disablePortal

---

## Figma Mapping

| Figma Variant           | React Props                    |
| ----------------------- | ------------------------------ |
| `Backdrop / Dark`       | `variant="dark"` (default)     |
| `Backdrop / Light`      | `variant="light"`              |

---

## Best Practices

### 場景推薦

| 使用情境 | 推薦用法 | 原因 |
| ------- | ------- | ---- |
| 配合 Modal 使用 | `<Modal><Backdrop>` (內置) | Modal 內含，毋需手動 |
| 配合 Drawer 使用 | `<Drawer><Backdrop>` (內置) | Drawer 內含，毋需手動 |
| 獨立背景層 | `<Backdrop open={true} />` | 自訂疊層場景 |
| 允許背景點擊關閉 | `disableCloseOnBackdropClick={false}` (預設) | 常見 UX |
| 禁止背景點擊關閉 | `disableCloseOnBackdropClick={true}` | 強制用戶完成操作 |
| 深色背景 | `variant="dark"` (預設) | 標準用途 |
| 淺色背景 | `variant="light"` | 高對比度需求 |
| 允許背景滾動 | `disableScrollLock={true}` | 特殊場景 |
| 自訂容器 | `container={containerRef}` | 限制背景範圍 |

### 常見錯誤

#### ❌ 手動包裝 Modal 或 Drawer
```tsx
// 不必要：Modal 內已含 Backdrop
<Backdrop open={isOpen}>
  <Modal open={isOpen}>
    Content
  </Modal>
</Backdrop>
```

#### ✅ 正確做法：直接使用 Modal/Drawer
```tsx
<Modal open={isOpen}>
  Content  {/* Backdrop 已內置 */}
</Modal>
```

#### ❌ 禁用滾動鎖定導致背景滾動
```tsx
// 不好：背景在 Backdrop 打開時仍可滾動
<Backdrop open={true} disableScrollLock={true}>
  <ContentBox />
</Backdrop>
```

#### ✅ 正確做法：保留預設滾動鎖定
```tsx
<Backdrop open={true}>
  {/* disableScrollLock 預設 false，背景無法滾動 */}
  <ContentBox />
</Backdrop>
```

#### ❌ 硬禁止背景點擊關閉
```tsx
// 不夠人性化：完全無法逃脫
<Backdrop
  open={true}
  disableCloseOnBackdropClick={true}
  {/* 無其他關閉方式 */}
/>
```

#### ✅ 正確做法：提供明確關閉方式
```tsx
<Backdrop
  open={true}
  disableCloseOnBackdropClick={true}
  {/* 但提供按鈕/Esc 關閉 */}
>
  <Modal>
    <Button onClick={onClose}>關閉</Button>
  </Modal>
</Backdrop>
```

#### ❌ 巢狀 Backdrop 導致 z-index 衝突
```tsx
// 問題：多層 Portal 可能 z-index 混亂
<Backdrop open={open1}>
  <Backdrop open={open2}>
    Nested content
  </Backdrop>
</Backdrop>
```

#### ✅ 正確做法：用 Modal 或 Dialog 層級管理
```tsx
// Modal 自行管理 z-index
<Modal open={open1}>
  <Modal open={open2}>
    Nested modals with proper z-index
  </Modal>
</Modal>
```

#### ❌ 未設定自訂容器導致全屏覆蓋
```tsx
// 不夠靈活：Backdrop 總是全屏
<div className="container">
  <Backdrop open={true}>
    Content
  </Backdrop>
</div>
```

#### ✅ 正確做法：用 container 限制範圍
```tsx
const containerRef = useRef<HTMLDivElement>(null);

<div ref={containerRef} className="container" style={{ position: 'relative' }}>
  <Backdrop
    open={true}
    container={containerRef}  {/* 限制在容器內 */}
  >
    Content
  </Backdrop>
</div>
```

#### ❌ 忽視背景點擊事件
```tsx
// 不夠完整：無法對背景點擊做額外處理
<Backdrop open={true} onClose={handleClose} />
```

#### ✅ 正確做法：區分 onClose 和 onBackdropClick
```tsx
<Backdrop
  open={true}
  onClose={handleClose}  {/* 通用關閉邏輯 */}
  onBackdropClick={(e) => {
    console.log('背景被點擊');  {/* 特定背景動作 */}
  }}
/>
```

### 核心要點

1. **Modal/Drawer 內含**：毋需手動包裝，會自動包含 Backdrop
2. **滾動鎖定預設啟用**：防止背景在 Backdrop 開啟時滾動
3. **點擊關閉預設啟用**：提高 UX，但可透過 flag 禁用
4. **Portal 自動管理 z-index**：避免手動 z-index 衝突
5. **自訂容器限制範圍**：不一定要全屏，可限制在特定區域
6. **淡入淡出動畫**：內置 Fade 過渡，平滑視覺效果
