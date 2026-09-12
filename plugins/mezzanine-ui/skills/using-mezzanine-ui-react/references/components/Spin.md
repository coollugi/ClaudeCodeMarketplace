# Spin Component

> **Category**: Feedback
>
> **Storybook**: `Feedback/Spin`
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Spin) · Verified 1.5.1 (2026-09-12)

Spinning loading component for indicating content is loading.

## Import

```tsx
import { Spin } from '@mezzanine-ui/react';
import type { SpinProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-spin--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Spin Props

> Extends `NativeElementPropsWithoutKeyAndRef<'div'>`.

| Property               | Type                  | Default  | Description                |
| ---------------------- | --------------------- | -------- | -------------------------- |
| `children`             | `ReactNode`           | -        | Wrapped content            |
| `color`                | `string`              | -        | Custom CSS color for spinner arc |
| `description`          | `string`              | -        | Loading description text   |
| `descriptionClassName` | `string`              | -        | Description className      |
| `size`                 | `GeneralSize`          | `'main'` | Size (`'main' \| 'sub' \| 'minor'`) |
| `stretch`              | `boolean`             | `false`  | Whether to stretch to fill container |
| `loading`              | `boolean`             | `false`  | Whether loading            |
| `trackColor`           | `string`              | -        | Custom CSS color for track ring background |
| `backdropProps`        | `Omit<BackdropProps, 'container' \| 'open'>` | - | Backdrop props (nested mode) |

---

## Usage Examples

### Standalone Usage

```tsx
import { Spin } from '@mezzanine-ui/react';

// Basic usage
<Spin loading />

// With description
<Spin loading description="Loading..." />

// Different sizes
<Spin loading size="main" />
<Spin loading size="sub" />
<Spin loading size="minor" />
```

### Stretch to Fill Container

```tsx
<div style={{ height: 200 }}>
  <Spin loading stretch />
</div>
```

### Wrapping Content (Nested Mode)

When Spin wraps child elements, it automatically uses a semi-transparent overlay to cover the content.

```tsx
function LoadingCard() {
  const [loading, setLoading] = useState(true);

  return (
    <Spin loading={loading} description="Loading...">
      <Card
        title="Card Title"
        description="Card content..."
      />
    </Spin>
  );
}
```

### Table Loading

```tsx
function DataTable() {
  const [loading, setLoading] = useState(false);
  const [data, setData] = useState([]);

  const fetchData = async () => {
    setLoading(true);
    const result = await api.getData();
    setData(result);
    setLoading(false);
  };

  return (
    <Spin loading={loading}>
      <Table dataSource={data} columns={columns} />
    </Spin>
  );
}
```

### Custom Color

```tsx
// Custom spinner arc color
<Spin
  loading
  color="#1890ff"
/>

// Custom track and arc colors
<Spin
  loading
  color="#1890ff"
  trackColor="#f0f0f0"
/>

// Using CSS variables
<div style={{ '--mzn-spin--color': '#ff4d4f', '--mzn-spin--track-color': '#ffccc7' }}>
  <Spin loading />
</div>
```

### Full Page Loading

```tsx
function PageLoading() {
  return (
    <div style={{ position: 'fixed', inset: 0 }}>
      <Spin
        loading
        stretch
        description="Loading page..."
      />
    </div>
  );
}
```

### Delayed Display

Avoid flickering by not showing Spin for short loading times.

```tsx
function DelayedSpin({ loading, delay = 300, children }) {
  const [show, setShow] = useState(false);

  useEffect(() => {
    let timer: NodeJS.Timeout;

    if (loading) {
      timer = setTimeout(() => setShow(true), delay);
    } else {
      setShow(false);
    }

    return () => clearTimeout(timer);
  }, [loading, delay]);

  return (
    <Spin loading={show}>
      {children}
    </Spin>
  );
}
```

### Conditional Loading

```tsx
function ConditionalLoading() {
  const [loading, setLoading] = useState(false);

  return (
    <>
      <Button onClick={() => setLoading(!loading)}>
        Toggle Loading State
      </Button>

      <Spin loading={loading}>
        <div className="content">
          This is the content area
        </div>
      </Spin>
    </>
  );
}
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-spin--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Migration Guide (Upgrading to 1.0.0)

### Breaking Changes

The spinner animation system has been significantly refactored from Icon-based to CSS-based:

- **Removed**: `iconProps` prop - The spinner is no longer an Icon component
- **Added**: `color` prop - Set custom spinner arc color via `--mzn-spin--color` CSS variable
- **Added**: `trackColor` prop - Set custom track ring background color via `--mzn-spin--track-color` CSS variable

**Before (pre-1.0.0)**:
```tsx
<Spin loading iconProps={{ color: 'primary', size: 32 }} />
```

**After (1.0.0)**:
```tsx
<Spin loading color="#1890ff" trackColor="#f0f0f0" />
```

The spinner now uses a Fluent 2-style spinning arc animation with CSS-based ring/tail elements for better performance and customization.

---

## Two Modes

### Standalone Mode

Without wrapping children, displays only the spinning icon and description.

```tsx
<Spin loading description="Loading" />
```

### Nested Mode

Wrapping children with a semi-transparent overlay when loading.

```tsx
<Spin loading>
  <Content />
</Spin>
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-spin--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Figma Mapping

| Figma Variant              | React Props                              |
| -------------------------- | ---------------------------------------- |
| `Spin / Main`              | `size="main"`                            |
| `Spin / Sub`               | `size="sub"`                             |
| `Spin / Minor`             | `size="minor"`                           |
| `Spin / With Description`  | `description="..."`                      |
| `Spin / Nested`            | Wrapping children                        |

---

## Best Practices

1. **Use loading prop**: Control display state via `loading`
2. **Provide description text**: Long loading times should include a description
3. **Avoid flickering**: Consider delayed display for short loading times
4. **Nested mode**: Recommend nested mode for data block loading
5. **Stretch to fill**: Use `stretch` when the container needs a fixed height
