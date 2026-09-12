# Tooltip Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Tooltip`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Tooltip) · Verified 1.5.1 (2026-09-12)

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
| `children`        | `(opt: { 'aria-describedby': string \| undefined; onBlur: FocusEventHandler; onFocus: FocusEventHandler; onMouseEnter: MouseEventHandler; onMouseLeave: MouseEventHandler; ref: RefCallback<HTMLElement> }) => ReactElement` | - | Trigger element render function. **Since 1.5.0** the payload also carries `onFocus`/`onBlur` and `'aria-describedby'` — see Accessibility section below |
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
| `options`         | `UseFloatingOptions`                                                                                           | `{}`   | 轉發給 `Popper` 的 floating-ui 設定（`packages/react/src/Popper/Popper.tsx:65`）。**沒有 `PopperOptions` 這個型別** |
| `ref`             | `RefObject<HTMLElement>`                                                                                       | -      | Tooltip root element ref       |
| `title`           | `ReactNode`                                                                                                    | -      | Tooltip content                |

> `children` must be a render function that receives `{ ref, onMouseEnter, onMouseLeave, onFocus, onBlur, 'aria-describedby' }` parameters — **spread the whole object onto the trigger element** rather than picking a subset, otherwise keyboard/assistive-tech users silently lose tooltip access. Tooltip visibility depends on the `open` prop or (internal `visible`/`focused` state and `title` exists).

---

## Accessibility (重要 — 1.5.0 起鍵盤與螢幕閱讀器可用)

Tooltip 在 1.5.0 做了一輪無障礙補強，讓內容不再只有滑鼠使用者拿得到：

- **render-prop payload 新增 `onFocus` / `onBlur`**：`focus` 開啟提示、`blur` 關閉提示，讓純鍵盤操作（Tab 到觸發元素）也能看到提示文字。
- **提示內容節點帶 `role="tooltip"`**，並以 `useId()` 產生穩定 `id`（可用 `id` prop 覆寫），透過 `aria-describedby` 掛回觸發元素——僅在提示顯示時才有值，關閉時為 `undefined`。
- **鍵盤 focus 觸發僅限 `:focus-visible`**：瀏覽器點擊 `<button>` 也會 focus 它，但那不是鍵盤導覽——若不收斂，滑鼠點一下就會跳出提示且黏著不放（要等失焦才收）。Tooltip 內部用 `element.matches(':focus-visible')` 判斷，只有這個判準為真時 `onFocus` 才真的開啟提示；不支援該 pseudo-class 的環境會退回「一律視為可見」，寧可多顯示也不讓鍵盤使用者拿不到。仍符合 WCAG 2.1 SC 1.4.13（該條款只要求 focus 觸發的內容可 dismiss / hover / persist，不要求滑鼠 focus 也要觸發）。
- **開啟中按 `Escape` 可關閉**（`useDocumentEscapeKeyDown`）：只影響 hover/focus 驅動的提示，不影響 `open` 受控模式（受控時仍完全由呼叫端決定）。目標元素重新進入（hover 或 focus）時會重置這個「已被 Escape 關閉」的狀態，讓提示可以再次出現。

這代表：一個只做 icon-only 按鈕的 `Button`，其 tooltip 文字現在同時對鍵盤與螢幕閱讀器存在，不再只服務滑鼠 hover。

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

// Spread the whole payload — this also wires onFocus/onBlur and
// aria-describedby, so the tooltip is reachable by keyboard/assistive tech,
// not just mouse hover.
<Tooltip title="This is tooltip text">
  {(tooltipProps) => (
    <Button {...tooltipProps}>
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
  {(tooltipProps) => (
    <Button {...tooltipProps}>
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
3. **Spread the full payload**: Pass the entire render-prop object (`ref`, `onMouseEnter`, `onMouseLeave`, `onFocus`, `onBlur`, `aria-describedby`) to the child element — picking only a subset silently breaks keyboard/screen-reader access
4. **Appropriate delay**: Adjust `mouseLeaveDelay` based on UX requirements
5. **Avoid overuse**: Important information should not only be placed in Tooltips
6. **forwardRef support**: Component uses `forwardRef<HTMLDivElement>`, the root element can be accessed via ref
