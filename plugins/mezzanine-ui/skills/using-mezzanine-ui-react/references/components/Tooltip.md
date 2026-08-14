# Tooltip Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Tooltip`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Tooltip) · Verified 1.4.1 (2026-07-01)

Tooltip component for displaying additional information on mouse hover. Extends `PopperProps` (excluding `arrow`, `children`, `disablePortal`, `title`).

> **Aliases** — Tooltip · Hint · 提示泡泡 · 滑過說明
> **Not for** — 文字溢出才顯示完整內容（用 [`OverflowTooltip`](OverflowTooltip.md)）；需要互動內容的浮層（用 [`Popper`](Popper.md) / [`Dropdown`](Dropdown.md)）

## Import

```tsx
import { Tooltip, useDelayMouseEnterLeave } from '@mezzanine-ui/react';
import type { TooltipProps, UseDelayMouseEnterLeave, DelayMouseEnterLeave } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-tooltip--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Tooltip Props

Extends `PopperProps` (excluding `arrow`, `children`, `disablePortal`, `title`).

| Property          | Type                                                                                                           | Default | Description                    |
| ----------------- | -------------------------------------------------------------------------------------------------------------- | ------ | ------------------------------ |
| `anchor`          | `Element \| RefObject`                                                                                         | -      | Anchor element (alternative to children) |
| `arrow`           | `boolean`                                                                                                      | `true` | Whether to show arrow          |
| `children`        | `(opt: { onMouseEnter: MouseEventHandler; onMouseLeave: MouseEventHandler; ref: RefCallback<HTMLElement> }) => ReactElement` | - | Trigger element render function |
| `className`       | `string`                                                                                                       | -      | Custom style class             |
| `container`       | `Element \| RefObject<Element \| null> \| null`                                                                | -      | Portal container element (from `PortalProps`) |
| `controllerRef`   | `Ref<PopperController>`                                                                                        | -      | Ref to access the underlying `useFloating` result |
| `disablePortal`   | `boolean`                                                                                                      | `true` | Whether to disable Portal      |
| `mouseLeaveDelay` | `number`                                                                                                       | `0.1`  | Mouse leave delay (seconds)    |
| `offsetMainAxis`  | `number`                                                                                                       | -      | Tooltip distance to anchor on main axis (px, overrides default) |
| `onMouseEnter`    | `(event: MouseEvent) => void`                                                                                  | -      | Mouse enter callback           |
| `onMouseLeave`    | `(event: MouseEvent) => void`                                                                                  | -      | Mouse leave callback           |
| `onPlacementChange` | `(placement: PopperPlacement) => void`                                                                       | -      | Fired when the resolved placement changes (e.g. after a `flip` middleware adjustment) |
| `open`            | `boolean`                                                                                                      | `false`| Controlled open state (auto-triggers on hover when not set) |
| `options`         | `PopperOptions`                                                                                                | `{}`   | Popper configuration           |
| `ref`             | `RefObject<HTMLElement>`                                                                                       | -      | Tooltip root element ref       |
| `title`           | `ReactNode`                                                                                                    | -      | Tooltip content                |

> `children` must be a render function that receives `{ ref, onMouseEnter, onMouseLeave }` parameters. Tooltip visibility depends on the `open` prop or (internal `visible` state and `title` exists).

---

## Placement Options

Set position via `options.placement`:

| Placement       | Description    |
| --------------- | -------------- |
| `top`           | Top            |
| `top-start`     | Top left       |
| `top-end`       | Top right      |
| `bottom`        | Bottom         |
| `bottom-start`  | Bottom left    |
| `bottom-end`    | Bottom right   |
| `left`          | Left           |
| `left-start`    | Left top       |
| `left-end`      | Left bottom    |
| `right`         | Right          |
| `right-start`   | Right top      |
| `right-end`     | Right bottom   |

---

## Usage Examples

### Basic Usage

```tsx
import { Tooltip, Button } from '@mezzanine-ui/react';

<Tooltip title="This is tooltip text">
  {({ ref, onMouseEnter, onMouseLeave }) => (
    <Button
      ref={ref}
      onMouseEnter={onMouseEnter}
      onMouseLeave={onMouseLeave}
    >
      Hover me
    </Button>
  )}
</Tooltip>
```

### Different Positions

```tsx
<Tooltip title="Top tooltip" options={{ placement: 'top' }}>
  {(props) => <Button {...props}>Top</Button>}
</Tooltip>

<Tooltip title="Bottom tooltip" options={{ placement: 'bottom' }}>
  {(props) => <Button {...props}>Bottom</Button>}
</Tooltip>

<Tooltip title="Left tooltip" options={{ placement: 'left' }}>
  {(props) => <Button {...props}>Left</Button>}
</Tooltip>

<Tooltip title="Right tooltip" options={{ placement: 'right' }}>
  {(props) => <Button {...props}>Right</Button>}
</Tooltip>
```

### Without Arrow

```tsx
<Tooltip title="Tooltip without arrow" arrow={false}>
  {(props) => <Button {...props}>No arrow</Button>}
</Tooltip>
```

### Long Content

```tsx
<Tooltip
  title={
    <div>
      <div>Multi-line tooltip text</div>
      <div>Second line content</div>
    </div>
  }
>
  {(props) => <span {...props}>Hover to see long content</span>}
</Tooltip>
```

### Controlled Mode

```tsx
function ControlledTooltip() {
  const [open, setOpen] = useState(false);

  return (
    <Tooltip title="Controlled tooltip" open={open}>
      {(props) => (
        <Button
          {...props}
          onClick={() => setOpen(!open)}
        >
          Click to toggle
        </Button>
      )}
    </Tooltip>
  );
}
```

### Custom Delay

```tsx
<Tooltip title="Delayed close" mouseLeaveDelay={0.5}>
  {(props) => <Button {...props}>Delay 0.5s</Button>}
</Tooltip>
```

### With Icon

```tsx
import { Icon } from '@mezzanine-ui/react';
import { QuestionFilledIcon } from '@mezzanine-ui/icons';

<Tooltip title="Help text">
  {(props) => (
    <Icon {...props} icon={QuestionFilledIcon} />
  )}
</Tooltip>
```

### Using anchor Prop

```tsx
function AnchorTooltip() {
  const buttonRef = useRef<HTMLButtonElement>(null);
  const [open, setOpen] = useState(false);

  return (
    <>
      <Button
        ref={buttonRef}
        onMouseEnter={() => setOpen(true)}
        onMouseLeave={() => setOpen(false)}
      >
        Using anchor
      </Button>
      <Tooltip
        anchor={buttonRef}
        title="Tooltip using anchor"
        open={open}
      >
        {() => null}
      </Tooltip>
    </>
  );
}
```

### Custom Offset from Anchor

```tsx
<Tooltip title="Tooltip with custom offset" offsetMainAxis={16}>
  {({ ref, onMouseEnter, onMouseLeave }) => (
    <Button
      ref={ref}
      onMouseEnter={onMouseEnter}
      onMouseLeave={onMouseLeave}
    >
      Hover with 16px offset
    </Button>
  )}
</Tooltip>
```

---

## Figma Mapping

| Figma Variant          | React Props                          |
| ---------------------- | ------------------------------------ |
| `Tooltip / Top`        | `options={{ placement: 'top' }}`     |
| `Tooltip / Bottom`     | `options={{ placement: 'bottom' }}`  |
| `Tooltip / Left`       | `options={{ placement: 'left' }}`    |
| `Tooltip / Right`      | `options={{ placement: 'right' }}`   |
| `Tooltip / With Arrow` | `arrow={true}`                       |
| `Tooltip / No Arrow`   | `arrow={false}`                      |

---

## Best Practices

1. **Keep content concise**: Tooltip content should be brief and clear
2. **Use render function**: children must be a render function
3. **Pass events**: Ensure `ref`, `onMouseEnter`, `onMouseLeave` are passed to the child element
4. **Appropriate delay**: Adjust `mouseLeaveDelay` based on UX requirements
5. **Avoid overuse**: Important information should not only be placed in Tooltips
6. **forwardRef support**: Component uses `forwardRef<HTMLDivElement>`, the root element can be accessed via ref
