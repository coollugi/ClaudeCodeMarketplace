# Tag Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Tag`
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Tag)  · Verified 1.4.1 (2026-07-01)

Tag component for labeling, categorizing, or filtering content. Supports multiple types with different host elements (`<span>` or `<button>`).

## Import

```tsx
import { Tag, TagGroup } from '@mezzanine-ui/react';
import type { TagProps, TagGroupProps, TagSize } from '@mezzanine-ui/react';
```

> `TagSize` is re-exported from `@mezzanine-ui/core/tag`.

---

## Tag Types

| Type               | Host Element | Description            | Characteristics        |
| ------------------ | ------------ | ---------------------- | ---------------------- |
| `static`           | `<span>`     | Static tag (default)   | Display only           |
| `counter`          | `<span>`     | Counter tag            | With number badge      |
| `dismissable`      | `<span>`     | Dismissable tag        | With close button      |
| `addable`          | `<button>`   | Addable tag            | With plus icon, clickable |
| `overflow-counter` | `<button>`   | Overflow counter       | Shows +N format        |

---

## TagProps (Union Type)

```tsx
type TagProps =
  | TagPropsStatic
  | TagPropsCounter
  | TagPropsOverflowCounter
  | TagPropsDismissable
  | TagPropsAddable;
```

### Common Props for All Types

| Property    | Type      | Default  | Description  |
| ----------- | --------- | -------- | ------------ |
| `className` | `string`  | -        | Custom class |
| `size`      | `TagSize` | `'main'` | Size         |

---

## Type-specific Props

### Static Tag (TagPropsStatic)

Extends `<span>` native attributes (excluding `onClick`, `type`).

```tsx
interface TagPropsStatic {
  type?: 'static';
  label: string;                                 // Required
  readOnly?: boolean;
  // The following are never: active, count, disabled, onClose, onClick
}
```

### Counter Tag (TagPropsCounter)

Extends `<span>` native attributes (excluding `onClick`, `type`).

```tsx
interface TagPropsCounter {
  type: 'counter';                               // Required
  label: string;                                 // Required
  count: number;                                 // Required
  // The following are never: active, disabled, onClose, onClick, readOnly
}
```

### Dismissable Tag (TagPropsDismissable)

Extends `<span>` native attributes (excluding `onClick`, `type`).

```tsx
interface TagPropsDismissable {
  type: 'dismissable';                           // Required
  label: string;                                 // Required
  active?: boolean;
  disabled?: boolean;
  onClose: MouseEventHandler<HTMLButtonElement>;  // Required
  // The following are never: count, onClick, readOnly
}
```

### Addable Tag (TagPropsAddable)

Extends `<button>` native attributes (excluding `onClick`, `type`).

```tsx
interface TagPropsAddable {
  type: 'addable';                               // Required
  label: string;                                 // Required
  active?: boolean;
  disabled?: boolean;
  onClick?: MouseEventHandler<HTMLButtonElement>;
  // The following are never: count, onClose, readOnly
}
```

### Overflow Counter Tag (TagPropsOverflowCounter)

Extends `<button>` native attributes (excluding `onClick`, `type`).

```tsx
interface TagPropsOverflowCounter {
  type: 'overflow-counter';                      // Required
  count: number;                                 // Required
  disabled?: boolean;
  onClick?: MouseEventHandler<HTMLButtonElement>;
  readOnly?: boolean;
  // The following are never: active, label, onClose
}
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-tag--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Usage Examples

### Static Tag

```tsx
import { Tag } from '@mezzanine-ui/react';

<Tag type="static" label="Tag" />
<Tag label="Default is also static" />
```

### Counter Tag

```tsx
<Tag type="counter" label="Notifications" count={5} />
<Tag type="counter" label="Messages" count={99} />
```

### Dismissable Tag

```tsx
function DismissableTags() {
  const [tags, setTags] = useState(['React', 'Vue', 'Angular']);

  const handleClose = (tagToRemove: string) => {
    setTags(tags.filter((tag) => tag !== tagToRemove));
  };

  return (
    <>
      {tags.map((tag) => (
        <Tag
          key={tag}
          type="dismissable"
          label={tag}
          onClose={() => handleClose(tag)}
        />
      ))}
    </>
  );
}
```

### Addable Tag

```tsx
function AddableTags() {
  const [tags, setTags] = useState(['Tag 1', 'Tag 2']);

  const handleAdd = () => {
    const newTag = `Tag ${tags.length + 1}`;
    setTags([...tags, newTag]);
  };

  return (
    <>
      {tags.map((tag) => (
        <Tag key={tag} label={tag} />
      ))}
      <Tag type="addable" label="Add" onClick={handleAdd} />
    </>
  );
}
```

### Overflow Counter

```tsx
function OverflowTags() {
  const tags = ['Tag 1', 'Tag 2', 'Tag 3', 'Tag 4', 'Tag 5'];
  const visibleCount = 3;

  return (
    <>
      {tags.slice(0, visibleCount).map((tag) => (
        <Tag key={tag} label={tag} />
      ))}
      {tags.length > visibleCount && (
        <Tag
          type="overflow-counter"
          count={tags.length - visibleCount}
          onClick={() => console.log('Expand all tags')}
        />
      )}
    </>
  );
}
```

### Different Sizes

```tsx
<Tag size="main" label="Main Size" />
<Tag size="sub" label="Sub Size" />
<Tag size="minor" label="Minor Size" />
```

### Disabled State

```tsx
<Tag type="dismissable" label="Disabled" disabled onClose={() => {}} />
<Tag type="addable" label="Add" disabled />
<Tag type="overflow-counter" count={5} disabled />
```

### Active State

```tsx
<Tag type="dismissable" label="Selected" active onClose={() => {}} />
<Tag type="addable" label="Add" active />
```

### Using TagGroup

```tsx
import { Tag, TagGroup } from '@mezzanine-ui/react';

<TagGroup>
  <Tag label="React" />
  <Tag label="TypeScript" />
  <Tag label="Node.js" />
</TagGroup>

// With fade transition
<TagGroup transition="fade">
  <Tag label="React" />
  <Tag label="TypeScript" />
</TagGroup>
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-tag--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## TagGroup Props

Extends `<div>` native attributes (excluding `children`, `key`, `ref`).

| Property     | Type                               | Default  | Description                                     |
| ------------ | ---------------------------------- | -------- | ----------------------------------------------- |
| `children`   | `TagGroupChild \| TagGroupChild[]` | -        | Required, accepts `Tag` or `OverflowCounterTag` (also imported from `@mezzanine-ui/react`) elements |
| `transition` | `'fade' \| 'none'`                 | `'none'` | Transition animation type                       |

---

## Figma Mapping

| Figma Variant            | React Props                     |
| ------------------------ | ------------------------------- |
| `Tag / Static`           | `<Tag type="static">`           |
| `Tag / Counter`          | `<Tag type="counter">`          |
| `Tag / Dismissable`      | `<Tag type="dismissable">`      |
| `Tag / Addable`          | `<Tag type="addable">`          |
| `Tag / Overflow Counter` | `<Tag type="overflow-counter">` |
| `Tag / Main`             | `<Tag size="main">`             |
| `Tag / Sub`              | `<Tag size="sub">`              |
| `Tag / Minor`            | `<Tag size="minor">`            |
| `Tag / Active`           | `<Tag active>`                  |
| `Tag / Disabled`         | `<Tag disabled>`                |

---

## Best Practices

1. **Choose appropriate type**: Select the corresponding type based on functional requirements
2. **Control tag count**: Use `overflow-counter` to handle too many tags
3. **Provide removal feedback**: `dismissable` must handle the `onClose` event (required)
4. **Uniform size**: Keep the same `size` for tags in the same area
5. **Clear active state**: Use `active` for filter tags to indicate selection
6. **Respect never constraints**: Each type has strict prop restrictions; do not mix props that don't belong to that type
