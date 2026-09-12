# Skeleton Component

> **Category**: Feedback
>
> **Storybook**: `Feedback/Skeleton`
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Skeleton) · Verified 1.5.1 (2026-09-12)

Skeleton screen component for providing placeholder effects while content is loading.

> **Aliases** — Skeleton Screen · Placeholder · Shimmer · Ghost Loading · 骨架屏 · 載入佔位
> **Not for** — 不知道版面結構的載入（用 [`Spin`](Spin.md)）；有百分比的進度（用 [`Progress`](Progress.md)）

## Import

```tsx
import { Skeleton } from '@mezzanine-ui/react';
import type { SkeletonProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-skeleton--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Skeleton Props

> Extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'children'>` — `children` is not supported.

| Property  | Type                     | Default | Description                          |
| --------- | ------------------------ | ------- | ------------------------------------ |
| `circle`  | `boolean`                | -       | Whether circular                     |
| `height`  | `number \| string`       | `100%`  | Height                               |
| `variant` | `TypographySemanticType` | -       | Typography type (auto-calculates height) |
| `width`   | `number \| string`       | `100%`  | Width                                |

---

## Skeleton Types

### Strip Skeleton

When `variant` is set and neither `height` nor `circle` is set, height is automatically calculated based on the typography type.

```tsx
// Auto-sets height based on Typography variant
<Skeleton variant="h1" />
<Skeleton variant="h2" />
<Skeleton variant="body" />
<Skeleton variant="caption" />
```

### Rectangle/Square Skeleton

Set `width` and `height` to create a custom-sized skeleton.

```tsx
<Skeleton width={200} height={100} />
<Skeleton width="100%" height={200} />
```

### Circle Skeleton

Set `circle` to create a circular skeleton.

```tsx
<Skeleton circle width={48} height={48} />
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-skeleton--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Usage Examples

### Text Skeleton

```tsx
import { Skeleton } from '@mezzanine-ui/react';

// Simulating a title
<Skeleton variant="h3" width="60%" />

// Simulating a paragraph
<Skeleton variant="body" width="100%" />
<Skeleton variant="body" width="100%" />
<Skeleton variant="body" width="80%" />
```

### Avatar Skeleton

```tsx
// Circular avatar
<Skeleton circle width={40} height={40} />

// Square avatar
<Skeleton width={40} height={40} />
```

### Image Skeleton

```tsx
<Skeleton width="100%" height={200} />
```

### Card Skeleton

```tsx
function CardSkeleton() {
  return (
    <div className="card">
      {/* Cover image */}
      <Skeleton width="100%" height={180} />

      <div className="card-content">
        {/* Title */}
        <Skeleton variant="h3" width="70%" />

        {/* Subtitle */}
        <Skeleton variant="caption" width="40%" />

        {/* Description */}
        <Skeleton variant="body" width="100%" />
        <Skeleton variant="body" width="90%" />
      </div>
    </div>
  );
}
```

### List Skeleton

```tsx
function ListSkeleton({ count = 5 }) {
  return (
    <>
      {Array.from({ length: count }).map((_, i) => (
        <div key={i} className="list-item">
          <Skeleton circle width={40} height={40} />
          <div className="list-content">
            <Skeleton variant="body" width="60%" />
            <Skeleton variant="caption" width="40%" />
          </div>
        </div>
      ))}
    </>
  );
}
```

### Table Skeleton

```tsx
function TableSkeleton({ rows = 5, cols = 4 }) {
  return (
    <table>
      <thead>
        <tr>
          {Array.from({ length: cols }).map((_, i) => (
            <th key={i}>
              <Skeleton variant="label-primary" />
            </th>
          ))}
        </tr>
      </thead>
      <tbody>
        {Array.from({ length: rows }).map((_, rowIndex) => (
          <tr key={rowIndex}>
            {Array.from({ length: cols }).map((_, colIndex) => (
              <td key={colIndex}>
                <Skeleton variant="body" width={`${60 + Math.random() * 30}%`} />
              </td>
            ))}
          </tr>
        ))}
      </tbody>
    </table>
  );
}
```

### Conditional Rendering

```tsx
function UserProfile({ loading, user }) {
  if (loading) {
    return (
      <div className="profile">
        <Skeleton circle width={80} height={80} />
        <Skeleton variant="h3" width={120} />
        <Skeleton variant="body" width={200} />
      </div>
    );
  }

  return (
    <div className="profile">
      <img src={user.avatar} alt={user.name} />
      <h4>{user.name}</h4>
      <p>{user.bio}</p>
    </div>
  );
}
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-skeleton--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Typography Variant Mapping

| Variant                  | Description        |
| ------------------------ | ------------------ |
| `h1`, `h2`, `h3`        | Heading levels     |
| `body`, `body-highlight` | Body text          |
| `body-mono`, `body-mono-highlight` | Monospace body |
| `text-link-body`, `text-link-caption` | Link text  |
| `caption`, `caption-highlight` | Caption text |
| `annotation`, `annotation-highlight` | Annotation |
| `button`, `button-highlight` | Button text    |
| `input`, `input-mono`, `input-highlight` | Input text |
| `label-primary`, `label-primary-highlight` | Primary label |
| `label-secondary`       | Secondary label    |

---

## Figma Mapping

| Figma Variant              | React Props                              |
| -------------------------- | ---------------------------------------- |
| `Skeleton / Text`          | `variant="body"`                         |
| `Skeleton / Heading`       | `variant="h3"`                           |
| `Skeleton / Rectangle`     | `width={...} height={...}`               |
| `Skeleton / Circle`        | `circle width={...} height={...}`        |

---

## Best Practices

1. **Mirror real layout**: Skeleton screens should reflect the actual content structure
2. **Use variant**: Text skeletons should use variant for auto-calculated height
3. **Avoid overuse**: Only use in main content areas
4. **Stay consistent**: Use the same skeleton structure for the same type of content
5. **Appropriate animation**: Skeletons have a default shimmer animation to indicate loading
