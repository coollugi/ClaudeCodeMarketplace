# ClearActions Component

> **Note**: Not exported from the `@mezzanine-ui/react` main entrypoint — import it via sub-path (`@mezzanine-ui/react/ClearActions`). It ships as a real, functional component and is used internally by Modal, Drawer, Tag, TextField, and InlineMessage; it simply isn't re-exported from the package barrel, so application code must use the sub-path import shown below.

> **Category**: Internal (sub-path only)
>
> **Storybook**: `Internal/ClearActions`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/ClearActions) · Verified 1.5.1 (2026-09-12)

Clear/close button component providing a unified close button style. Used for close functionality in Modal, Drawer, Tag, and other components.

## Import

```tsx
// Internal component, not publicly exported from @mezzanine-ui/react
// Must be imported from sub-path
import ClearActions from '@mezzanine-ui/react/ClearActions';
import type { ClearActionsProps } from '@mezzanine-ui/react/ClearActions';
```

> **Note**: ClearActions is not exported from `@mezzanine-ui/react` main entry; it is an internal component.

---

## ClearActions Props

| Property  | Type                                      | Default      | Description       |
| --------- | ----------------------------------------- | ------------ | ----------------- |
| `className` | `string`                                 | -            | Custom CSS class name |
| `onClick` | `MouseEventHandler<HTMLButtonElement>`    | -            | Click callback    |
| `type`    | `'standard' \| 'embedded' \| 'clearable'` | `'standard'` | Usage context type |
| `variant` | `ClearActionsVariant`                     | -            | Visual variant (discriminated union, see below) |

> **Discriminated Union rules**:
> - `type='standard'` → `variant: 'base' | 'inverse'`
> - `type='embedded'` → `variant: 'contrast' | 'emphasis'`
> - `type='clearable'` → no `variant` prop

---

## ClearActions Type

| Type        | Description                                | Icon                |
| ----------- | ------------------------------------------ | ------------------- |
| `standard`  | Standard close button (Modal, Drawer)      | CloseIcon           |
| `embedded`  | Embedded close button (contrast background) | CloseIcon          |
| `clearable` | Clear button (Input clear functionality)   | DangerousFilledIcon |

---

## ClearActions Variant

### Standard Type Variants

| Variant   | Description          |
| --------- | -------------------- |
| `base`    | Base style (default) |
| `inverse` | Inverse color style  |

### Embedded Type Variants

| Variant    | Description              |
| ---------- | ------------------------ |
| `contrast` | Contrast style (default) |
| `emphasis` | Emphasis style           |

### Clearable Type Variants

Uses fixed `default` variant.

---

## Usage Examples

### Standard Type (Modal Close Button)

```tsx
<ClearActions
  type="standard"
  variant="base"
  onClick={handleClose}
/>
```

### Embedded Type (On Dark Background)

```tsx
<ClearActions
  type="embedded"
  variant="contrast"
  onClick={handleClose}
/>
```

### Clearable Type (Input Clear)

```tsx
<ClearActions
  type="clearable"
  onClick={handleClear}
/>
```

---

## Usage in Other Components

### Modal

```tsx
// Modal internally uses ClearActions
<ModalHeader>
  <Typography>Title</Typography>
  <ClearActions type="standard" onClick={onClose} />
</ModalHeader>
```

### TextField

```tsx
// TextField internally uses ClearActions
<TextField clearable onClear={handleClear}>
  {/* ClearActions type="clearable" is rendered automatically */}
</TextField>
```

### Tag (Dismissable)

```tsx
// Tag internally uses ClearActions
<Tag label="Tag" type="dismissable" onClose={handleClose}>
  {/* ClearActions is rendered automatically */}
</Tag>
```

---

## Accessibility

- Automatically sets `aria-label="Close"`
- Button type is `type="button"`

---

## Figma Mapping

| Figma Variant                   | React Props                  |
| ------------------------------- | ---------------------------- |
| `ClearActions / Standard`       | `type="standard"` (default)  |
| `ClearActions / Embedded`       | `type="embedded"`            |
| `ClearActions / Clearable`      | `type="clearable"`           |

---

## Best Practices

1. **Use higher-level components**: Generally do not use ClearActions directly; use Modal, Tag, and similar components instead
2. **Context selection**: Choose appropriate type based on usage context
3. **Contrast colors**: Use `embedded` type on dark backgrounds
4. **Clear functionality**: Use `clearable` type for input clear functionality
