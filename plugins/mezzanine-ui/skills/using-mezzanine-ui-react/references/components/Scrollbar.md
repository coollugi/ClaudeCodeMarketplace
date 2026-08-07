# Scrollbar Component

> ⚠️ **REMOVED from public API in 1.4.1** — This component is no longer exported from `@mezzanine-ui/react`, though the source still exists in the tree and remains used internally by Dropdown and Cascader.
> Use native browser scrolling or CSS custom scrollbar styles instead for new code.

> **Category**: Internal (removed)
>
> **Storybook**: `Internal/Scrollbar` (removed in 1.4.1)
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Scrollbar) · **Deprecated** in 1.4.1 (2026-07-01)

Custom scrollbar component providing consistent scrollbar styles across browsers. Based on OverlayScrollbars.

## Import

```tsx
// Internal component, not publicly exported from @mezzanine-ui/react
// Must be imported from sub-path
import Scrollbar from '@mezzanine-ui/react/Scrollbar';
import type { ScrollbarProps } from '@mezzanine-ui/react/Scrollbar';
```

> **Note**: Scrollbar is not exported from the `@mezzanine-ui/react` main entry. It is an internal component.

---

## Scrollbar Props

| Property          | Type                                          | Default | Description                |
| ----------------- | --------------------------------------------- | ------- | -------------------------- |
| `children`        | `ReactNode`                                   | -       | Content                    |
| `className`       | `string`                                      | -       | className                  |
| `defer`           | `boolean \| object`                           | `true`  | Deferred initialization    |
| `disabled`        | `boolean`                                     | `false` | Disable custom scrollbar   |
| `events`          | `OverlayScrollbarsComponentProps['events']`   | -       | Event handlers             |
| `maxHeight`       | `number \| string`                            | -       | Maximum height             |
| `maxWidth`        | `number \| string`                            | -       | Maximum width              |
| `onViewportReady` | `(viewport, instance?) => void`               | -       | Viewport ready callback    |
| `options`         | `PartialOptions`                              | -       | OverlayScrollbars options  |
| `style`           | `CSSProperties`                               | -       | Style                      |

---

## Default Options

The component uses the following default OverlayScrollbars options:

```tsx
{
  overflow: {
    x: 'scroll',
    y: 'scroll',
  },
  scrollbars: {
    autoHide: 'scroll',
    autoHideDelay: 600,
    clickScroll: true,
  },
}
```

> **Note**: `overflow` is a forced value and will be overridden back to `{ x: 'scroll', y: 'scroll' }` even if passed via `options`. `scrollbars` is an overridable default that can be customized via `options.scrollbars`.

---

## Usage Examples

### Basic Usage

```tsx
import Scrollbar from '@mezzanine-ui/react/Scrollbar';

<Scrollbar maxHeight={300}>
  <div style={{ height: 600 }}>
    Long content...
  </div>
</Scrollbar>
```

### Width Constraint

```tsx
<Scrollbar maxWidth={400} maxHeight={300}>
  <div style={{ width: 800, height: 600 }}>
    Extra wide and tall content...
  </div>
</Scrollbar>
```

### Disable Custom Scrollbar

```tsx
<Scrollbar disabled maxHeight={300}>
  <div style={{ height: 600 }}>
    Using native scrollbar...
  </div>
</Scrollbar>
```

### Get Viewport Reference

```tsx
function ScrollbarWithRef() {
  const handleViewportReady = (viewport: HTMLDivElement, instance) => {
    console.log('viewport element:', viewport);
    console.log('OverlayScrollbars instance:', instance);
  };

  return (
    <Scrollbar maxHeight={300} onViewportReady={handleViewportReady}>
      <div style={{ height: 600 }}>Content...</div>
    </Scrollbar>
  );
}
```

### Custom Options

```tsx
<Scrollbar
  maxHeight={300}
  options={{
    scrollbars: {
      autoHide: 'leave',
      autoHideDelay: 200,
    },
  }}
>
  <div style={{ height: 600 }}>Content...</div>
</Scrollbar>
```

### Usage in Modal

```tsx
<Modal open={open} onClose={handleClose}>
  <ModalHeader>Title</ModalHeader>
  <ModalBody>
    <Scrollbar maxHeight={400}>
      <div style={{ height: 800 }}>
        Long form or list content...
      </div>
    </Scrollbar>
  </ModalBody>
  <ModalFooter>
    <Button onClick={handleClose}>Close</Button>
  </ModalFooter>
</Modal>
```

---

## Event Handling

```tsx
<Scrollbar
  maxHeight={300}
  events={{
    initialized: (instance) => {
      console.log('Scrollbar initialized');
    },
    scroll: ({ target }) => {
      console.log('Scrolling:', target.scrollTop);
    },
  }}
>
  <div style={{ height: 600 }}>Content...</div>
</Scrollbar>
```

---

## Figma Mapping

| Figma Variant               | React Props                              |
| --------------------------- | ---------------------------------------- |
| `Scrollbar / Default`       | Default                                  |
| `Scrollbar / Horizontal`    | Content width exceeds container          |
| `Scrollbar / Vertical`      | Content height exceeds container         |
| `Scrollbar / Both`          | Content exceeds container in both axes   |

---

## Scenario-Oriented Best Practices

### 場景推薦

| 使用場景 | 建議做法 | 原因 |
| -------- | -------- | ---- |
| Modal 或 Drawer 內的長內容 | 在 ModalBody 內使用 `<Scrollbar />` | 提供一致的滾動條樣式體驗 |
| 受限高度容器內的大量列表 | 設置 `maxHeight` 和 `onViewportReady` | 可監聽視口就緒，配合無限滾動加載 |
| 禁用自訂滾動條使用原生 | 設置 `disabled={true}` | 某些特殊場景可能需要原生滾動條行為 |
| 提升初始渲染性能 | 保持預設 `defer={true}` | 延遲初始化 OverlayScrollbars，避免阻塞首屏 |

### 常見錯誤

- **未設置 maxHeight 或 maxWidth**：沒有尺寸限制無法產生滾動條，內容只會原樣展示
- **在沒有設置寬度限制的情況下期望水平滾動條出現**：必須同時設置 `maxWidth` 和寬度超過該值的內容
- **期望直接在公開 API 中導入 Scrollbar**：應從 sub-path 導入，且建議只在必要時使用
- **頻繁改變 options 配置**：OverlayScrollbars 初始化開銷較大，避免動態改變 options

## Best Practices

1. **Set dimensions**: Must set `maxHeight` or `maxWidth` to see scrollbars
2. **Deferred init**: Default `defer=true` improves initial render performance
3. **Disabled mode**: `disabled=true` renders as a plain div
4. **Click scroll**: Default `clickScroll` enabled, allows clicking the track to scroll directly
5. **Auto hide**: Scrollbar auto-hides 600ms after scrolling stops
6. **Internal component**: Scrollbar is not exported from main entry—import from sub-path only when necessary
