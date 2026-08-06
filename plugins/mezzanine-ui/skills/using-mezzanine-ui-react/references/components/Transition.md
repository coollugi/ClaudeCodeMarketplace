# Transition Component

> **Category**: Utility / Motion
>
> **Storybook**: `Utility/Transition`
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Transition)  · Verified 1.4.1 (2026-07-01)

Transition animation component group, based on `react-transition-group`. Provides the base `Transition` component and various preset animation effects: `Collapse`, `Fade`, `Rotate`, `Scale`, `Slide`, `Translate`.

## Import

```tsx
import {
  Transition,
  Collapse,
  Fade,
  Rotate,
  Scale,
  Slide,
  Translate,
} from '@mezzanine-ui/react';
import type {
  TransitionProps,
  CollapseProps,
  FadeProps,
  RotateProps,
  ScaleProps,
  SlideProps,
  TranslateProps,
  TranslateFrom,
} from '@mezzanine-ui/react';

// The following types are not exported from the main entry, import from subpath
import type {
  TransitionDuration,
  TransitionEasing,
  TransitionDelay,
  TransitionMode,
  TransitionState,
  TransitionImplementationProps,
  TransitionImplementationChildProps,
} from '@mezzanine-ui/react/Transition';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/motion-transition--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Props / Sub-components

### Transition (Base Component)

Low-level transition control component wrapping `react-transition-group/Transition`. Usually not used directly; instead used indirectly through preset animation components like `Fade`, `Scale`, etc.

| Property         | Type                                | Default  | Description                             |
| ---------------- | ----------------------------------- | -------- | --------------------------------------- |
| `in`             | `boolean`                           | `false`  | Whether in entered state (triggers enter/exit) |
| `appear`         | `boolean`                           | `true`   | Whether to animate on initial mount     |
| `duration`       | `TransitionDuration`                | -        | Animation duration (milliseconds)       |
| `keepMount`      | `boolean`                           | `false`  | Whether to keep mounted in DOM after exit |
| `lazyMount`      | `boolean`                           | `true`   | Mount only on first enter               |
| `nodeRef`        | `RefObject<HTMLElement \| null>`   | **required** | DOM element ref                      |
| `children`       | `TransitionChildren`                | -        | Child content (can be a render function) |
| `addEndListener` | `(node: HTMLElement, next: VoidFunction) => void` | - | Custom transition end handler     |
| `onEnter`        | `TransitionEnterHandler`            | -        | Before enter callback                   |
| `onEntering`     | `TransitionEnterHandler`            | -        | Entering callback                       |
| `onEntered`      | `TransitionEnterHandler`            | -        | Enter complete callback                 |
| `onExit`         | `TransitionExitHandler`             | -        | Before exit callback                    |
| `onExiting`      | `TransitionExitHandler`             | -        | Exiting callback                        |
| `onExited`       | `TransitionExitHandler`             | -        | Exit complete callback                  |

---

### TransitionImplementationProps (Shared Props Base)

Most preset animation components inherit this interface (excluding `addEndListener`, `children`, `nodeRef`) and additionally provide:

| Property   | Type               | Default | Description          |
| ---------- | ------------------ | ------- | -------------------- |
| `children` | `ReactElement`     | -       | Child element to apply animation to |
| `delay`    | `TransitionDelay`  | `0`     | Animation delay (milliseconds) |
| `easing`   | `TransitionEasing` | -       | Easing function      |

---

### Fade

Controls fade in/out effect via `opacity`.

`FadeProps = TransitionImplementationProps`

| Property   | Type                 | Default                                       | Description  |
| ---------- | -------------------- | --------------------------------------------- | ------------ |
| `in`       | `boolean`            | `false`                                       | Whether visible |
| `duration` | `TransitionDuration` | `{ enter: MOTION_DURATION.moderate, exit: MOTION_DURATION.moderate }` | Duration |
| `easing`   | `TransitionEasing`   | `{ enter: MOTION_EASING.entrance, exit: MOTION_EASING.exit }` | Easing function |
| `delay`    | `TransitionDelay`    | `0`                                           | Delay        |

---

### Collapse

Implements collapse/expand effect via height animation. Supports `'auto'` for auto-calculated duration.

> **Note**: This component is currently marked as `@deprecated` (designers have not defined the official specification yet), but it is still used internally in components like `Accordion`.

Extends `TransitionImplementationProps` and `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'children'>`.

| Property          | Type                 | Default                                       | Description                        |
| ----------------- | -------------------- | --------------------------------------------- | ---------------------------------- |
| `in`              | `boolean`            | `false`                                       | Whether expanded                   |
| `collapsedHeight` | `string \| number`  | `0`                                           | Height when collapsed (e.g. `'40px'`) |
| `duration`        | `TransitionDuration` | `'auto'`                                      | Duration (`'auto'` calculates based on height) |
| `easing`          | `TransitionEasing`   | `{ enter: MOTION_EASING.entrance, exit: MOTION_EASING.exit }` | Easing function |
| `style`           | `CSSProperties`      | -                                             | Container style                    |

---

### Rotate

Implements rotation effect via CSS `transform: rotate()`. Unlike other transition components, **it does not unmount elements**, only toggles the rotation angle. Commonly used for arrow indicators (e.g. expand/collapse icons in Accordion, Select).

| Property          | Type          | Default                   | Description                              |
| ----------------- | ------------- | ------------------------- | ---------------------------------------- |
| `children`        | `ReactElement`| -                         | Child element to rotate                  |
| `in`              | `boolean`     | `false`                   | Whether in rotated state                 |
| `degrees`         | `number`      | `180`                     | Rotation angle (degrees)                 |
| `duration`        | `number`      | `MOTION_DURATION.fast`    | Transition duration (ms, default ~150ms) |
| `easing`          | `string`      | `MOTION_EASING.standard`  | Easing function                          |
| `transformOrigin` | `string`      | `'center'`                | Rotation origin                          |

---

### Scale

Implements scale fade-in effect via `opacity` and `transform: scale()`.

Extends `TransitionImplementationProps`.

| Property          | Type                 | Default                                       | Description          |
| ----------------- | -------------------- | --------------------------------------------- | -------------------- |
| `in`              | `boolean`            | -                                             | Whether visible      |
| `duration`        | `TransitionDuration` | `{ enter: MOTION_DURATION.moderate, exit: MOTION_DURATION.moderate }` | Duration |
| `easing`          | `TransitionEasing`   | `{ enter: MOTION_EASING.entrance, exit: MOTION_EASING.exit }` | Easing function |
| `transformOrigin` | `string`             | `'center'`                                    | Scale origin         |

> On enter, scales from `scale(0.95)` up to `scale(1)`; on exit, scales from `scale(1)` down to `scale(0.95)`.

---

### Slide

Implements slide in/out effect via `transform: translate3d()` (100% displacement).

Extends `TransitionImplementationProps`.

| Property   | Type                 | Default                                       | Description                              |
| ---------- | -------------------- | --------------------------------------------- | ---------------------------------------- |
| `in`       | `boolean`            | `false`                                       | Whether visible                          |
| `from`     | `SlideFrom`          | `'right'`                                     | Slide direction: `'right'` / `'top'`     |
| `duration` | `TransitionDuration` | `{ enter: MOTION_DURATION.slow, exit: MOTION_DURATION.slow }` | Duration |
| `easing`   | `TransitionEasing`   | `{ enter: MOTION_EASING.standard, exit: MOTION_EASING.standard }` | Easing function |

> `SlideFrom = 'right' | 'top'`

---

### Translate

Implements subtle displacement fade-in effect via `opacity` and `transform: translate3d()` (4px displacement). Commonly used for Dropdown popup animations.

Extends `TransitionImplementationProps`.

| Property   | Type                 | Default                                       | Description                                             |
| ---------- | -------------------- | --------------------------------------------- | ------------------------------------------------------- |
| `in`       | `boolean`            | `false`                                       | Whether visible                                         |
| `from`     | `TranslateFrom`      | `'top'`                                       | Enter direction: `'top'` / `'bottom'` / `'left'` / `'right'` |
| `duration` | `TransitionDuration` | `{ enter: MOTION_DURATION.moderate, exit: MOTION_DURATION.moderate }` | Duration |
| `easing`   | `TransitionEasing`   | `{ enter: MOTION_EASING.standard, exit: MOTION_EASING.standard }` | Easing function |

> `TranslateFrom = 'top' | 'bottom' | 'left' | 'right'`

---

## Type Definitions

```ts
type TransitionMode = 'enter' | 'exit';

type TransitionDuration =
  | 'auto'
  | number
  | { [mode in TransitionMode]?: number };

type TransitionEasing =
  | string
  | { [mode in TransitionMode]?: string };

type TransitionDelay =
  | number
  | { [mode in TransitionMode]?: number };

type TransitionEnterHandler = (node: HTMLElement, isAppearing: boolean) => void;
type TransitionExitHandler = (node: HTMLElement) => void;

// react-transition-group transition states
type TransitionState =
  | 'entering'
  | 'entered'
  | 'exiting'
  | 'exited'
  | 'unmounted';

// SlideFrom is an internal type, not exported from the main entry. Use SlideProps['from'] instead
type SlideFrom = 'right' | 'top';
type TranslateFrom = 'top' | 'bottom' | 'left' | 'right';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/motion-transition--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Usage Examples

### Fade In/Out

```tsx
import { useState } from 'react';
import { Fade } from '@mezzanine-ui/react';

function FadeExample() {
  const [show, setShow] = useState(false);

  return (
    <>
      <button onClick={() => setShow((prev) => !prev)}>Toggle</button>
      <Fade in={show}>
        <div style={{ padding: 16, background: '#f0f0f0' }}>
          Fade in/out content
        </div>
      </Fade>
    </>
  );
}
```

### Collapse Expand

```tsx
import { useState } from 'react';
import { Collapse } from '@mezzanine-ui/react';

function CollapseExample() {
  const [expanded, setExpanded] = useState(false);

  return (
    <>
      <button onClick={() => setExpanded((prev) => !prev)}>
        {expanded ? 'Collapse' : 'Expand'}
      </button>
      <Collapse in={expanded}>
        <div style={{ padding: 16 }}>
          Collapsible detailed content...
        </div>
      </Collapse>
    </>
  );
}
```

### Rotate Indicator

```tsx
import { useState } from 'react';
import { Rotate } from '@mezzanine-ui/react';
import { Icon } from '@mezzanine-ui/react';
import { ChevronDownIcon } from '@mezzanine-ui/icons';

function RotateExample() {
  const [open, setOpen] = useState(false);

  return (
    <button onClick={() => setOpen((prev) => !prev)}>
      <Rotate in={open} degrees={180}>
        <Icon icon={ChevronDownIcon} />
      </Rotate>
      Menu
    </button>
  );
}
```

### Scale Popup

```tsx
import { useState } from 'react';
import { Scale } from '@mezzanine-ui/react';

function ScaleExample() {
  const [visible, setVisible] = useState(false);

  return (
    <>
      <button onClick={() => setVisible((prev) => !prev)}>Toggle</button>
      <Scale in={visible} transformOrigin="top left">
        <div style={{ padding: 16, background: '#fff', boxShadow: '0 2px 8px rgba(0,0,0,0.15)' }}>
          Scale popup content
        </div>
      </Scale>
    </>
  );
}
```

### Slide In/Out

```tsx
import { useState } from 'react';
import { Slide } from '@mezzanine-ui/react';

function SlideExample() {
  const [show, setShow] = useState(false);

  return (
    <>
      <button onClick={() => setShow((prev) => !prev)}>Toggle</button>
      <Slide in={show} from="right">
        <div style={{ position: 'fixed', right: 0, top: 0, width: 300, height: '100vh', background: '#fff' }}>
          Panel sliding in from the right
        </div>
      </Slide>
    </>
  );
}
```

### Translate Fade-in

```tsx
import { useState } from 'react';
import { Translate } from '@mezzanine-ui/react';

function TranslateExample() {
  const [visible, setVisible] = useState(false);

  return (
    <div style={{ position: 'relative' }}>
      <button onClick={() => setVisible((prev) => !prev)}>Toggle</button>
      <Translate in={visible} from="bottom">
        <div style={{ padding: 16, background: '#fff', border: '1px solid #e0e0e0' }}>
          Content fading in from below
        </div>
      </Translate>
    </div>
  );
}
```

### Custom Duration and Easing

```tsx
import { Fade } from '@mezzanine-ui/react';

function CustomTimingExample() {
  return (
    <Fade
      in={show}
      duration={{ enter: 500, exit: 200 }}
      easing={{ enter: 'ease-out', exit: 'ease-in' }}
      delay={{ enter: 100, exit: 0 }}
    >
      <div>Content with custom timing and easing</div>
    </Fade>
  );
}
```

### Keep Mounted (keepMount)

```tsx
import { Fade } from '@mezzanine-ui/react';

function KeepMountExample() {
  return (
    <Fade in={show} keepMount>
      <div>Remains in DOM after exit (visibility: hidden)</div>
    </Fade>
  );
}
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/motion-transition--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Animation Component Usage in the Component Library

| Animation Component | Usage Scenario                                 |
| ------------------- | ---------------------------------------------- |
| `Fade`              | Accordion content, Modal overlay               |
| `Collapse`          | AccordionContent height collapse               |
| `Rotate`            | AccordionTitle arrow rotation, Select dropdown arrow |
| `Scale`             | Modal content popup                            |
| `Slide`             | Drawer panel slide-in                          |
| `Translate`         | Dropdown menu popup                            |

---

## Best Practices

1. **Choose appropriate animation**: Use `Scale`/`Fade` for Modal, `Slide` for Drawer, `Translate` for Dropdown, `Collapse` for collapsible areas.
2. **Appropriate duration**: Use `MOTION_DURATION` constants from `@mezzanine-ui/system/motion` (`fast`/`moderate`/`slow`).
3. **Lazy mounting**: Default `lazyMount=true` defers first render for performance optimization.
4. **Keep mounted**: Use `keepMount` when you need to preserve form state or avoid remounting.
5. **Rotate does not unmount elements**: Unlike other transition components, `Rotate` only toggles CSS transform and does not control mount/unmount.
6. **Slide vs Translate**: `Slide` is 100% displacement (entire element slides off screen), `Translate` is 4px micro-displacement with fade-in effect.
