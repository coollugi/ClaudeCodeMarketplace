# Typography Component

> **Category**: Foundation
>
> **Storybook**: `Foundation/Typography`
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Typography) · Verified 1.4.1 (2026-07-01)

Typography component for consistent text styling.

## Import

```tsx
import { Typography } from '@mezzanine-ui/react';
import type {
  TypographyProps,
  TypographyComponent,
  TypographySemanticType,
  TypographyColor,
  TypographyAlign,
  TypographyDisplay,
} from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/foundation-typography--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Typography Props

`TypographyProps<C>` is a generic type that extends `TypographyPropsBase` plus native properties of element `C`.

| Property    | Type                     | Default  | Description              |
| ----------- | ------------------------ | -------- | ------------------------ |
| `variant`   | `TypographySemanticType` | `'body'` | Text style type          |
| `color`     | `TypographyColor`        | -        | Text color               |
| `align`     | `TypographyAlign`        | -        | Text alignment           |
| `display`   | `TypographyDisplay`      | -        | CSS display property     |
| `ellipsis`  | `boolean`                | `false`  | Whether to show ellipsis |
| `noWrap`    | `boolean`                | `false`  | Whether to prevent wrapping |
| `component` | `TypographyComponent`    | Auto-inferred | Custom rendered element |

---

## TypographyComponent Type

```ts
type TypographyComponent =
  | `h${1 | 2 | 3 | 4 | 5 | 6}`
  | 'p'
  | 'span'
  | 'label'
  | 'div'
  | 'caption'
  | 'a'
  | JSXElementConstructor<any>;
```

---

## TypographySemanticType (21 types total)

### Headings

| Type | Font Size | Font Weight | Description |
| ---- | --------- | ----------- | ----------- |
| `h1` | 24px      | 600         | Heading 1   |
| `h2` | 18px      | 600         | Heading 2   |
| `h3` | 16px      | 600         | Heading 3   |

### Body

| Type                  | Font Size | Font Weight | Description            |
| --------------------- | --------- | ----------- | ---------------------- |
| `body`                | 14px      | 400         | Body text              |
| `body-highlight`      | 14px      | 500         | Emphasized body text   |
| `body-mono`           | 14px      | 400         | Monospace body text    |
| `body-mono-highlight` | 14px      | 500         | Emphasized monospace body |

### Link

| Type                | Font Size | Font Weight | Description  |
| ------------------- | --------- | ----------- | ------------ |
| `text-link-body`    | 14px      | 400         | Body link    |
| `text-link-caption` | 12px      | 400         | Caption link |

### Caption

| Type                   | Font Size | Font Weight | Description          |
| ---------------------- | --------- | ----------- | -------------------- |
| `caption`              | 12px      | 400         | Caption text         |
| `caption-highlight`    | 12px      | 600         | Emphasized caption   |
| `annotation`           | 10px      | 400         | Annotation           |
| `annotation-highlight` | 10px      | 500         | Emphasized annotation |

### Functional

| Type                       | Font Size | Font Weight | Description            |
| -------------------------- | --------- | ----------- | ---------------------- |
| `button`                   | 14px      | 400         | Button text            |
| `button-highlight`         | 14px      | 500         | Emphasized button text |
| `input`                    | 14px      | 400         | Input text             |
| `input-mono`               | 14px      | 400         | Monospace input        |
| `input-highlight`          | 14px      | 500         | Emphasized input text  |
| `label-primary`            | 14px      | 400         | Primary label          |
| `label-primary-highlight`  | 14px      | 500         | Emphasized primary label |
| `label-secondary`          | 12px      | 400         | Secondary label        |

---

## TypographyColor

```ts
type TypographyColor = 'inherit' | `text-${TextTone}`;
```

Semantic text colors based on the design token system. `TextTone` comes from `@mezzanine-ui/system/palette`.

### Neutral

| Color                | Description        |
| -------------------- | ------------------ |
| `inherit`            | Inherit from parent |
| `text-fixed-light`   | Fixed light        |
| `text-neutral-faint` | Faint text         |
| `text-neutral-light` | Light text         |
| `text-neutral`       | Standard text      |
| `text-neutral-strong`| Strong text        |
| `text-neutral-solid` | Solid text         |

### Brand

| Color                | Description        |
| -------------------- | ------------------ |
| `text-brand`         | Brand text         |
| `text-brand-strong`  | Brand strong       |
| `text-brand-solid`   | Brand solid        |

### Semantic

| Color                  | Description      |
| ---------------------- | ---------------- |
| `text-error`           | Error text       |
| `text-error-strong`    | Error strong     |
| `text-error-solid`     | Error solid      |
| `text-warning`         | Warning text     |
| `text-warning-strong`  | Warning strong   |
| `text-success`         | Success text     |
| `text-info`            | Info text        |
| `text-info-strong`     | Info strong      |

---

## TypographyAlign

| Align     | Description    |
| --------- | -------------- |
| `left`    | Left aligned   |
| `center`  | Center aligned |
| `right`   | Right aligned  |
| `justify` | Justified      |

---

## TypographyDisplay

| Display        | Description  |
| -------------- | ------------ |
| `block`        | Block        |
| `inline-block` | Inline block |
| `flex`         | Flex         |
| `inline-flex`  | Inline flex  |

---

## Usage Examples

### Headings

```tsx
import { Typography } from '@mezzanine-ui/react';

<Typography variant="h1">Heading 1 (24px)</Typography>
<Typography variant="h2">Heading 2 (18px)</Typography>
<Typography variant="h3">Heading 3 (16px)</Typography>
```

### Body Text

```tsx
<Typography variant="body">Regular body text</Typography>
<Typography variant="body-highlight">Emphasized body text</Typography>
<Typography variant="body-mono">Monospace body: 1234567890</Typography>
```

### Caption Text

```tsx
<Typography variant="caption">Caption text (12px)</Typography>
<Typography variant="caption-highlight">Emphasized caption</Typography>
<Typography variant="annotation">Annotation (10px)</Typography>
```

### Colors

```tsx
<Typography color="text-neutral-solid">Solid text</Typography>
<Typography color="text-brand">Brand text</Typography>
<Typography color="text-error">Error text</Typography>
<Typography color="text-success">Success text</Typography>
```

### Alignment

```tsx
<Typography align="left">Left aligned</Typography>
<Typography align="center">Center aligned</Typography>
<Typography align="right">Right aligned</Typography>
```

### Ellipsis

```tsx
<Typography ellipsis style={{ width: 200 }}>
  This is a long text that will show ellipsis when it exceeds the width...
</Typography>
```

### Custom Element

```tsx
// Default element is auto-inferred based on variant
<Typography variant="h1">Automatically uses <h1></Typography>
<Typography variant="body">Automatically uses <p></Typography>

// Manually specify element
<Typography variant="body" component="span">Uses <span></Typography>
<Typography variant="body" component="label">Uses <label></Typography>
```

---

## Auto Element Inference

| Variant                    | Default Element      |
| -------------------------- | -------------------- |
| `h1`, `h2`, `h3`          | `<h1>` ~ `<h3>`     |
| `body*`, `text-link-body`  | `<p>`                |
| Others                     | `<span>`             |

---

## Figma Mapping

| Figma Style                 | React Props                                     |
| --------------------------- | ----------------------------------------------- |
| `Typography/H1`             | `<Typography variant="h1">`                     |
| `Typography/H2`             | `<Typography variant="h2">`                     |
| `Typography/H3`             | `<Typography variant="h3">`                     |
| `Typography/Body`           | `<Typography variant="body">`                   |
| `Typography/Body-Highlight` | `<Typography variant="body-highlight">`         |
| `Typography/Caption`        | `<Typography variant="caption">`                |
| `Typography/Annotation`     | `<Typography variant="annotation">`             |

---

## Best Practices

1. **Use semantic types**: Choose the appropriate variant based on content
2. **Avoid manual font settings**: Use Typography to ensure consistency
3. **Use color tokens**: Use system colors via the `color` prop
4. **Use ellipsis for long text**: Handle overflow with `ellipsis`
