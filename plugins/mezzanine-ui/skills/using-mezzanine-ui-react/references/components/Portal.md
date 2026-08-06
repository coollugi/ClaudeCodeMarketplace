# Portal Component

> **Category**: Utility
>
> **Storybook**: `Utility/Portal`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Portal) · Verified 1.4.1 (2026-07-01)

A portal component that renders children to a different location in the DOM. Used by Modal, Drawer, Tooltip, and other components that need to escape the parent DOM structure.

## Import

```tsx
import { Portal } from '@mezzanine-ui/react';
import type { PortalProps } from '@mezzanine-ui/react';

// Portal initialization (call at app startup)
import { initializePortals } from '@mezzanine-ui/react/Portal';

// Other sub-path exports
// import { getContainer, getRootElement, resetPortals, PortalLayer } from '@mezzanine-ui/react/Portal';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/others-portal--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Portal Props

| Property        | Type                                     | Default     | Description        |
| --------------- | ---------------------------------------- | ----------- | ------------------ |
| `children`      | `ReactNode`                              | -           | Child content      |
| `container`     | `HTMLElement \| RefObject<HTMLElement \| null> \| RefObject<HTMLElement> \| null` | - | Target container |
| `disablePortal` | `boolean`                                | `false`     | Disable Portal     |
| `layer`         | `'default' \| 'alert'`                   | `'default'` | Portal layer       |

---

## PortalLayer

| Layer     | Description                                                              |
| --------- | ------------------------------------------------------------------------ |
| `default` | Default layer, renders to `#mzn-portal-container` (className: `mzn-portal-default`) |
| `alert`   | Alert layer, renders to `#mzn-alert-container` (className: `mzn-portal-alert`)      |

---

## Usage Examples

### Basic Usage

```tsx
import { Portal } from '@mezzanine-ui/react';

<Portal>
  <div>This content renders to the Portal container</div>
</Portal>
```

### Using Alert Layer

```tsx
<Portal layer="alert">
  <div>This content renders to the alert container (higher z-index)</div>
</Portal>
```

### Specify Target Container (HTMLElement)

```tsx
function CustomContainer() {
  const [container, setContainer] = useState<HTMLElement | null>(null);

  useEffect(() => {
    setContainer(document.getElementById('my-container'));
  }, []);

  return (
    <Portal container={container}>
      <div>Renders to custom container</div>
    </Portal>
  );
}
```

### Specify Target Container (RefObject)

```tsx
function RefContainer() {
  const containerRef = useRef<HTMLDivElement>(null);

  return (
    <>
      <div ref={containerRef} id="target-container" />
      <Portal container={containerRef}>
        <div>Renders to the ref-pointed container</div>
      </Portal>
    </>
  );
}
```

### Disable Portal

```tsx
<Portal disablePortal>
  <div>Renders in place, Portal not used</div>
</Portal>
```

### Usage in Modal

```tsx
// Modal component internally uses Portal
function Modal({ open, children }) {
  if (!open) return null;

  return (
    <Portal>
      <div className="modal-backdrop">
        <div className="modal-content">
          {children}
        </div>
      </div>
    </Portal>
  );
}
```

---

## Portal Containers

Mezzanine-UI automatically creates two Portal containers as **children** of `rootElement` (default: `document.body`):

```html
<body> <!-- rootElement (default: document.body) -->
  <div id="root"><!-- Application --></div>
  <!-- Portal containers below, children of rootElement -->
  <div id="mzn-portal-container" class="mzn-portal-default"><!-- default layer --></div>
  <div id="mzn-alert-container" class="mzn-portal-alert"><!-- alert layer --></div>
</body>
```

---

## Server-Side Rendering (SSR)

In SSR environments, since `window` doesn't exist, Portal returns `null`:

```tsx
// Server-side does not render Portal content
if (typeof window === 'undefined') return null;
```

---

## Relationship with Other Components

The following components use Portal internally:
- **Modal** - Dialog
- **Drawer** - Drawer
- **Backdrop** - Backdrop overlay
- **Popper** - Positioned popup layer
- **Tooltip** - Tooltip
- **Message** - Message notification
- **NotificationCenter** - Notification center

---

## Figma Mapping

Portal is a purely functional component with no corresponding visual element in Figma.

---

## Scenario-Oriented Best Practices

### 場景推薦

| 使用場景 | 建議做法 | 原因 |
| -------- | -------- | ---- |
| Modal、Drawer、Tooltip 等內部使用 | 使用預設 Portal 層級 | 高階元件已配置正確的 Portal 和 z-index 層級 |
| 全局告警或最高優先級彈窗 | 使用 `layer="alert"` | Alert 層級 z-index 最高，確保顯示在所有內容上方 |
| 渲染到指定容器 | 使用 `container` prop 搭配 RefObject | 精確控制 Portal 目標位置 |
| 測試或調試 Portal 行為 | 使用 `disablePortal={true}` | 禁用 Portal 在原位置渲染，便於檢查 DOM 層級 |
| 伺服器端渲染環境 | 注意 Portal 伺服器端返回 null | 客戶端必須完成初始化，避免水合不匹配 |

### 常見錯誤

- **直接在應用程式中使用 Portal**：Portal 是低階工具，應使用 Modal、Drawer、Tooltip 等高階元件
- **在多個 Portal 中都使用預設容器導致 z-index 競爭**：改用 `layer="alert"` 或自訂容器區分優先級
- **SSR 環境中期望 Portal 內容在伺服器端渲染**：Portal 檢查 `typeof window === 'undefined'` 後返回 null，必須等待客戶端初始化
- **將 Portal 嵌套在具有特殊定位的容器內**：嵌套容器的 `position` 和 `z-index` 可能影響 Portal 的定位和層級

## Best Practices

1. **Use higher-level components**: Generally don't use Portal directly; use Modal, Drawer, etc.
2. **Layer selection**: Use `layer="alert"` for content requiring the highest z-index (e.g., global alerts)
3. **Custom container**: Use the `container` prop when a specific DOM location is needed
4. **Disable Portal**: Use `disablePortal` for testing or special layout needs
5. **SSR note**: Portal doesn't render on the server; be aware of hydration issues
