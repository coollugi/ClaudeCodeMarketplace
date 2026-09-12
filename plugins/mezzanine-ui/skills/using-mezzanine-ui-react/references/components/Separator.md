# Separator Component

> **Category**: Foundation
>
> **Storybook**: `Foundation/Separator`
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Separator) · Verified 1.5.1 (2026-09-12)

Separator component for visually dividing content sections. Supports horizontal and vertical orientations, rendering as an `<hr>` element.

## Import

```tsx
import { Separator } from '@mezzanine-ui/react';
import type { SeparatorProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/internal-separator--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Props

`SeparatorProps` extends native `<hr>` element attributes (excluding `key` and `ref`).

| Property      | Type                    | Default        | Description                          |
| ------------- | ----------------------- | -------------- | ------------------------------------ |
| `orientation` | `SeparatorOrientation`  | `'horizontal'` | Separator direction                  |
| `className`   | `string`                | -              | Additional CSS class                 |
| `style`       | `CSSProperties`         | -              | Inline style (inherited from `<hr>`) |

> In addition to the above, all native HTML attributes supported by `<hr>` can also be passed.

---

## Type Definition

### SeparatorOrientation

```ts
type SeparatorOrientation = 'horizontal' | 'vertical';
```

---

## Usage Examples

### Horizontal Separator (default)

```tsx
import { Separator } from '@mezzanine-ui/react';

function HorizontalExample() {
  return (
    <div>
      <p>Upper section</p>
      <Separator />
      <p>Lower section</p>
    </div>
  );
}
```

### Vertical Separator

```tsx
import { Separator } from '@mezzanine-ui/react';

function VerticalExample() {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
      <span>Item A</span>
      <Separator orientation="vertical" />
      <span>Item B</span>
      <Separator orientation="vertical" />
      <span>Item C</span>
    </div>
  );
}
```

### With Custom Style

```tsx
import { Separator } from '@mezzanine-ui/react';

function StyledSeparator() {
  return (
    <div>
      <h2>Title</h2>
      <Separator className="my-custom-separator" style={{ margin: '16px 0' }} />
      <p>Paragraph content</p>
    </div>
  );
}
```

### Toolbar Separator

```tsx
import { Separator, Button } from '@mezzanine-ui/react';

function Toolbar() {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
      <Button variant="base-primary">Save</Button>
      <Button variant="base-secondary">Export</Button>
      <Separator orientation="vertical" />
      <Button variant="base-secondary">Delete</Button>
    </div>
  );
}
```

---

## Accessibility

- Vertical separators automatically add the `aria-orientation="vertical"` attribute.
- Horizontal direction does not set `aria-orientation` additionally, as the default semantic of `<hr>` is horizontal separation.

---

## Best Practices

1. **Semantic usage**: Separator renders as an `<hr>` semantic tag, suitable for logical separation of content.
2. **Vertical with Flex**: When using vertical separators, the parent container must have `display: flex` and sufficient height.
3. **Spacing control**: Control separator margins via `style` or `className`.
4. **Avoid purely decorative usage**: For purely decorative lines, consider using CSS border instead of a semantic `<hr>`.
