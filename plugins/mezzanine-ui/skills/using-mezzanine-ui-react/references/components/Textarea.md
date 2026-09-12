# Textarea Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/Textarea`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Textarea) | Verified 1.5.1 (2026-09-12)

Multi-line text input component for entering longer text content.

## Import

```tsx
import { Textarea } from '@mezzanine-ui/react';
import type { TextareaProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-textarea--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Textarea Props

> `ref` (forwardRef) points to the outer `HTMLDivElement` (TextField container). For the native textarea ref, use `textareaRef`.

| Property            | Type                                              | Default     | Description                      |
| ------------------- | ------------------------------------------------- | ----------- | -------------------------------- |
| `className`         | `string`                                          | -           | Applied to the outer `TextField` wrapper (not the `<textarea>` itself) — distinct from `textareaClassName` below |
| `resize`            | `'none' \| 'both' \| 'horizontal' \| 'vertical'` | `'none'`    | Resize behavior                  |
| `textareaClassName` | `string`                                          | -           | Textarea element className       |
| `textareaRef`       | `Ref<HTMLTextAreaElement>`                         | -           | Textarea element ref             |
| `type`              | `'default' \| 'warning' \| 'error'`               | `'default'` | Visual state type                |
| `disabled`          | `boolean`                                         | -           | Whether disabled (only when `type="default"`) |
| `readOnly`          | `boolean`                                         | -           | Whether read-only (only when `type="default"`) |
| `rows`              | `number`                                          | -           | Native rows attribute            |
| `placeholder`       | `string`                                          | -           | Placeholder text                 |
| `value`             | `string`                                          | -           | Controlled value                 |
| `onChange`          | `ChangeEventHandler`                               | -           | Change event                     |

### Discriminated Union

`TextareaProps` uses `type` as the discriminant field:

```tsx
// type="default" (default): can set disabled / readOnly
{ type?: 'default'; disabled?: boolean; readOnly?: boolean }

// type="warning" | "error": disabled / readOnly not available
{ type: 'warning' | 'error'; disabled?: never; readOnly?: never }
```

> Design purpose: warning/error states should not simultaneously have disabled or readOnly set; this combination is forbidden at the type level.

---

## Usage Examples

### Basic Usage

```tsx
import { Textarea } from '@mezzanine-ui/react';

<Textarea placeholder="Enter content..." />
```

### Controlled Mode

```tsx
function ControlledTextarea() {
  const [value, setValue] = useState('');

  return (
    <Textarea
      value={value}
      onChange={(e) => setValue(e.target.value)}
      placeholder="Enter content..."
    />
  );
}
```

### Specifying Rows

```tsx
<Textarea rows={5} placeholder="5 rows height" />
<Textarea rows={10} placeholder="10 rows height" />
```

### Resizable

```tsx
// Vertical resize
<Textarea resize="vertical" rows={4} />

// Horizontal resize
<Textarea resize="horizontal" rows={4} />

// Free resize
<Textarea resize="both" rows={4} />

// No resize (default)
<Textarea resize="none" rows={4} />
```

### State Types

```tsx
// Default
<Textarea type="default" placeholder="Default state" />

// Warning
<Textarea type="warning" placeholder="Warning state" />

// Error
<Textarea type="error" placeholder="Error state" />
```

### Disabled and Read-only

```tsx
// Disabled
<Textarea disabled placeholder="Disabled state" />

// Read-only
<Textarea readOnly value="Read-only content, cannot edit" />
```

### With FormField

```tsx
import { FormField, Textarea } from '@mezzanine-ui/react';

<FormField
  name="description"
  label="Description"
  layout="vertical"
  required
>
  <Textarea
    rows={4}
    placeholder="Enter description..."
  />
</FormField>
```

### With Character Limit

```tsx
function LimitedTextarea({ maxLength = 200 }) {
  const [value, setValue] = useState('');

  return (
    <div>
      <Textarea
        value={value}
        onChange={(e) => setValue(e.target.value.slice(0, maxLength))}
        rows={4}
        placeholder="Enter content..."
      />
      <span>{value.length} / {maxLength}</span>
    </div>
  );
}
```

### Auto Height

```tsx
function AutoHeightTextarea() {
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  const handleChange = (e: ChangeEvent<HTMLTextAreaElement>) => {
    const textarea = e.target;
    textarea.style.height = 'auto';
    textarea.style.height = `${textarea.scrollHeight}px`;
  };

  return (
    <Textarea
      textareaRef={textareaRef}
      onChange={handleChange}
      placeholder="Auto-adjusting height..."
      rows={2}
    />
  );
}
```

### Form Validation

```tsx
function ValidatedTextarea() {
  const [value, setValue] = useState('');
  const [error, setError] = useState('');

  const validate = (val: string) => {
    if (!val.trim()) {
      setError('This field is required');
      return false;
    }
    if (val.length < 10) {
      setError('At least 10 characters required');
      return false;
    }
    setError('');
    return true;
  };

  return (
    <FormField
      name="content"
      label="Content"
      layout="vertical"
      severity={error ? 'error' : 'info'}
      hintText={error}
    >
      <Textarea
        value={value}
        onChange={(e) => {
          setValue(e.target.value);
          validate(e.target.value);
        }}
        type={error ? 'error' : 'default'}
        rows={4}
      />
    </FormField>
  );
}
```

---

## Figma Mapping

| Figma Variant               | React Props                              |
| --------------------------- | ---------------------------------------- |
| `Textarea / Default`        | `type="default"`                         |
| `Textarea / Warning`        | `type="warning"`                         |
| `Textarea / Error`          | `type="error"`                           |
| `Textarea / Disabled`       | `disabled`                               |
| `Textarea / ReadOnly`       | `readOnly`                               |
| `Textarea / Resizable`      | `resize="vertical"`                      |

---

## Internal Implementation Notes

- Internally uses `TextField` as the container (outer wrapper)
- Uses `useComposeRefs` to merge user's `textareaRef` with internal ref
- Shows a resize icon when `resize !== 'none'`

---

## Best Practices

1. **Set appropriate rows**: Set `rows` based on expected content volume
2. **Provide placeholder**: Explain the input format or examples
3. **State correspondence**: Keep consistent with FormField's severity
4. **Consider resizing**: Enable `resize="vertical"` for long text input
5. **Character limit**: Provide visual count when limits are needed
