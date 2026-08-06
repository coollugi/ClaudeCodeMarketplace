# SelectionCard Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/SelectionCard`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/SelectionCard) · Verified 1.4.1 (2026-07-01)

SelectionCard component providing selection items with images or icons. Supports single-select (radio) and multi-select (checkbox) modes.

## Import

```tsx
import { SelectionCard } from '@mezzanine-ui/react';

import type {
  SelectionCardProps,
  SelectionCardPropsBase,
} from '@mezzanine-ui/react';

// SelectionCardDirection, SelectionCardType can be imported from sub-path
import type { SelectionCardDirection, SelectionCardType } from '@mezzanine-ui/react/SelectionCard';
// SelectionCardImageObjectFit is only available from core (react/SelectionCard does not export this type)
import type { SelectionCardImageObjectFit } from '@mezzanine-ui/core/selection-card';
```

> **Note**: `SelectionCardDirection` and `SelectionCardType` are not exported from the `@mezzanine-ui/react` main entry; import from `@mezzanine-ui/react/SelectionCard` or `@mezzanine-ui/core/selection-card`.

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-selectioncard--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## SelectionCardPropsBase

Base props interface, extends `Omit<NativeElementPropsWithoutKeyAndRef<'label'>, 'onChange'>`.

| Property         | Type                                                                                  | Default        | Description      |
| ---------------- | ------------------------------------------------------------------------------------- | -------------- | ---------------- |
| `checked`        | `boolean`                                                                             | -              | Controlled checked state |
| `customIcon`     | `IconDefinition`                                                                      | -              | Custom icon      |
| `defaultChecked` | `boolean`                                                                             | `false`        | Default checked state |
| `direction`      | `SelectionCardDirection` (`'horizontal' \| 'vertical'`)                               | `'horizontal'` | Layout direction |
| `disabled`       | `boolean`                                                                             | `false`        | Whether disabled |
| `id`             | `string`                                                                              | -              | Input element id |
| `image`          | `string`                                                                              | -              | Image URL        |
| `imageObjectFit` | `SelectionCardImageObjectFit` (`'cover' \| 'contain' \| 'fill' \| 'none' \| 'scale-down'`) | `'cover'` | Image fit mode |
| `inputRef`       | `Ref<HTMLInputElement>`                                                               | -              | Ref for inner `<input>` element |
| `name`           | `string`                                                                              | -              | Input name attribute |
| `onChange`       | `ChangeEventHandler<HTMLInputElement>`                                                | -              | Input change callback |
| `readonly`       | `boolean`                                                                             | `false`        | Whether read-only |
| `selector`       | `SelectionCardType` (`'radio' \| 'checkbox'`)                                         | **required** (internal fallback `'radio'`) | Selector type — the TS interface marks this required (no `?`); the component's internal destructuring defaults to `'radio'` if omitted, but callers should always pass it explicitly |
| `supportingText` | `string`                                                                              | -              | Supporting (secondary) text |
| `supportingTextMaxWidth` | `CSSProperties['maxWidth']`                                                   | -              | Max width for supporting text |
| `text`           | `string`                                                                              | **required**   | Primary text     |
| `textMaxWidth`   | `CSSProperties['maxWidth']`                                                           | -              | Max width for primary text |
| `value`          | `string`                                                                              | -              | Input value attribute |

## SelectionCardProps

Extends `SelectionCardPropsBase` with additional:

| Property         | Type                                           | Default | Description      |
| ---------------- | ---------------------------------------------- | ------- | ---------------- |
| `onClick`        | `(event: MouseEvent<HTMLLabelElement>) => void` | -       | Label click callback |

---

## Type Definitions

```tsx
// Layout direction
type SelectionCardDirection = 'horizontal' | 'vertical';

// Selector type
type SelectionCardType = 'radio' | 'checkbox';

// Image fit mode
type SelectionCardImageObjectFit = 'cover' | 'contain' | 'fill' | 'none' | 'scale-down';
```

---

## Usage Examples

### Basic Usage

```tsx
import { SelectionCard } from '@mezzanine-ui/react';

<SelectionCard
  text="Option 1"
  selector="radio"
  name="option"
/>
```

### With Image

```tsx
<SelectionCard
  text="Product A"
  image="/images/product-a.jpg"
  selector="radio"
  name="product"
/>
```

### Custom Icon

```tsx
import { FolderIcon } from '@mezzanine-ui/icons';

<SelectionCard
  text="Folder"
  customIcon={FolderIcon}
  selector="radio"
  name="type"
/>
```

### Multi-select Mode

```tsx
<SelectionCard
  text="Feature A"
  selector="checkbox"
  name="features"
/>
```

### Vertical Layout

```tsx
<SelectionCard
  text="Vertical Option"
  direction="vertical"
  selector="radio"
  name="layout"
/>
```

### With Text Width Constraint

```tsx
<SelectionCard
  text="Long text option that might wrap"
  textMaxWidth="150px"
  selector="radio"
  name="option"
/>
```

### With onClick Callback

```tsx
function SelectionCardWithClick() {
  const [selected, setSelected] = useState(false);

  return (
    <SelectionCard
      text="Option A"
      checked={selected}
      onClick={() => setSelected((prev) => !prev)}
      selector="radio"
      name="option"
    />
  );
}
```

### Disabled State

```tsx
<SelectionCard
  text="Not selectable"
  disabled
  selector="radio"
  name="option"
/>
```

---

## Image Fit Modes

| Value        | Description                              |
| ------------ | ---------------------------------------- |
| `cover`      | Fill container, may crop (default)       |
| `contain`    | Show completely, may have whitespace     |
| `fill`       | Stretch to fill container                |
| `none`       | No adjustment, use original size         |
| `scale-down` | Scale down but don't scale up            |

---

## Accessibility

- `text` is required, used as the primary label
- Automatically sets `aria-labelledby`
- Disabled state sets `aria-disabled`

---

## Figma Mapping

| Figma Variant                      | React Props                              |
| ---------------------------------- | ---------------------------------------- |
| `SelectionCard / Radio`            | `selector="radio"` (default)             |
| `SelectionCard / Checkbox`         | `selector="checkbox"`                    |
| `SelectionCard / Horizontal`       | `direction="horizontal"` (default)       |
| `SelectionCard / Vertical`         | `direction="vertical"`                   |
| `SelectionCard / With Image`       | `image` has value                        |
| `SelectionCard / With Icon`        | `customIcon` has value                   |
| `SelectionCard / Disabled`         | `disabled`                               |

---

## Best Practices

1. **Required text**: Primary text is required for labeling and accessibility
2. **Use with RadioGroup/CheckboxGroup**: Provide `name` when used in groups
3. **Use onClick for interactions**: Use the `onClick` prop to handle click events on the label element
4. **Visual consistency**: Keep the same `direction` and image/icon settings within a group
