# Slider Component

> **Category**: Data Entry
>
> **Storybook**: `Data Entry/Slider`
>
> **Source Verification**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Slider) · Verified 1.5.1 (2026-09-12)

Slider component for selecting values within a numeric range. Supports single value and range modes.

## Import

```tsx
import { Slider, useSlider } from '@mezzanine-ui/react';

import type {
  // Slider component Props
  SliderProps,
  SliderBaseProps,
  SliderComponentProps,
  SingleSliderProps,
  RangeSliderProps,
  // Value types (from @mezzanine-ui/core/slider)
  SliderValue,
  SingleSliderValue,
  RangeSliderValue,
  SliderRect,
  // Hook related types
  UseSliderProps,
  UseSliderResult,
  UseSliderCommonProps,
  UseSingleSliderProps,
  UseRangeSliderProps,
} from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-entry-slider--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## SliderBaseProps

Extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'defaultChecked' | 'defaultValue' | 'onChange'>` — native `<div>` element attributes, excluding `defaultChecked`, `defaultValue`, and `onChange` (Slider defines its own `onChange` with the slider-specific signature shown below).

| Property     | Type                   | Default | Description          |
| ------------ | ---------------------- | ------- | -------------------- |
| `disabled`   | `boolean`              | `-`     | Whether disabled (no destructuring default in source — falsy/undefined behaves as not disabled) |
| `innerRef`   | `Ref<HTMLDivElement>`  | -       | Inner div element ref |
| `max`        | `number`               | `100`   | Maximum value        |
| `min`        | `number`               | `0`     | Minimum value        |
| `step`       | `number`               | `1`     | Step value           |
| `withTick`   | `number \| number[]`   | -       | Tick marks           |

> **Note**: `SliderProps` is the publicly exported type and does not include `innerRef` (`Omit<SliderComponentProps, 'innerRef'>`).

---

## Type Definitions

```tsx
// Value types (from @mezzanine-ui/core/slider)
type SingleSliderValue = number;
type RangeSliderValue = [number, number];
type SliderValue = SingleSliderValue | RangeSliderValue;
type SliderRect = Pick<DOMRect, 'left' | 'width'>;
```

---

## Mode Differentiation

Slider automatically determines the mode based on the `value` type:

### Single Value Mode (SingleSliderProps)

```tsx
// SliderAddonProps = SliderBaseProps & (SliderWithInputProps | SliderWithIconProps | SliderWithoutAddonsProps)
interface SingleSliderProps extends SliderAddonProps {
  value: SingleSliderValue;       // number
  onChange?: (value: SingleSliderValue) => void;
}
```

### Range Mode (RangeSliderProps)

```tsx
interface RangeSliderProps extends SliderAddonProps {
  value: RangeSliderValue;        // [number, number]
  onChange?: (value: RangeSliderValue) => void;
}
```

### SliderComponentProps and SliderProps

```tsx
type SliderComponentProps = SingleSliderProps | RangeSliderProps;
type SliderProps = Omit<SliderComponentProps, 'innerRef'>;
```

---

## Addon Props (Mutually Exclusive)

Slider addons are implemented as a union type, choose one of three:

### SliderWithInputProps

| Property     | Type   | Description          |
| ------------ | ------ | -------------------- |
| `withInput`  | `true` | Show numeric input   |

### SliderWithIconProps

| Property             | Type                 | Description                               |
| -------------------- | -------------------- | ----------------------------------------- |
| `prefixIcon`         | `IconDefinition`     | Prefix icon                               |
| `suffixIcon`         | `IconDefinition`     | Suffix icon                               |
| `onPrefixIconClick`  | `() => void`         | Custom handler for prefix icon click (overrides default decrement) |
| `onSuffixIconClick`  | `() => void`         | Custom handler for suffix icon click (overrides default increment) |

### SliderWithoutAddonsProps

No addons.

> **Mutual exclusion**: `withInput` and `prefixIcon`/`suffixIcon` cannot be used together.

---

## Usage Examples

### Basic Single Slider

```tsx
import { Slider } from '@mezzanine-ui/react';
import { useState } from 'react';

function SingleSlider() {
  const [value, setValue] = useState(30);

  return (
    <Slider
      value={value}
      onChange={setValue}
    />
  );
}
```

### Range Slider

```tsx
function RangeSlider() {
  const [value, setValue] = useState<[number, number]>([20, 80]);

  return (
    <Slider
      value={value}
      onChange={setValue}
    />
  );
}
```

### Custom Range

```tsx
<Slider
  value={value}
  onChange={setValue}
  min={0}
  max={1000}
  step={10}
/>
```

### With Tick Marks

```tsx
// Number: divide into N segments
<Slider
  value={value}
  onChange={setValue}
  withTick={4}
/>
// Shows ticks at 0, 25, 50, 75, 100

// Array: specify tick positions
<Slider
  value={value}
  onChange={setValue}
  withTick={[20, 50, 80]}
/>
// Shows ticks at positions 20, 50, 80
```

### With Input Field

```tsx
// Single value + input
<Slider
  value={value}
  onChange={setValue}
  withInput
/>

// Range + input
<Slider
  value={rangeValue}
  onChange={setRangeValue}
  withInput
/>
// Displays two input fields
```

### With Icons

```tsx
import { VolumeOffIcon, VolumeHighIcon } from '@mezzanine-ui/icons';

<Slider
  value={volume}
  onChange={setVolume}
  prefixIcon={VolumeOffIcon}
  suffixIcon={VolumeHighIcon}
/>
```

### Custom Icon Click Handlers

```tsx
import { MinusIcon, PlusIcon } from '@mezzanine-ui/icons';

<Slider
  value={quantity}
  onChange={setQuantity}
  min={1}
  max={10}
  prefixIcon={MinusIcon}
  suffixIcon={PlusIcon}
  onPrefixIconClick={() => {
    // Custom logic: emit event, trigger analytics, etc.
    console.log('Minus clicked');
  }}
  onSuffixIconClick={() => {
    // Custom logic instead of default increment
    console.log('Plus clicked');
  }}
/>

// Without custom handlers, defaults to step-based increment/decrement
```

### Disabled State

```tsx
<Slider
  value={50}
  disabled
/>
```

### Price Range Selector

```tsx
function PriceRangeSlider() {
  const [priceRange, setPriceRange] = useState<[number, number]>([100, 500]);

  return (
    <div>
      <label>Price Range: ${priceRange[0]} - ${priceRange[1]}</label>
      <Slider
        value={priceRange}
        onChange={setPriceRange}
        min={0}
        max={1000}
        step={10}
        withInput
      />
    </div>
  );
}
```

### Volume Control

```tsx
function VolumeControl() {
  const [volume, setVolume] = useState(50);

  return (
    <Slider
      value={volume}
      onChange={setVolume}
      min={0}
      max={100}
      prefixIcon={VolumeOffIcon}
      suffixIcon={VolumeHighIcon}
    />
  );
}
```

### Rating Slider

```tsx
function RatingSlider() {
  const [rating, setRating] = useState(3);

  return (
    <div>
      <Slider
        value={rating}
        onChange={setRating}
        min={1}
        max={5}
        step={1}
        withTick={[1, 2, 3, 4, 5]}
      />
      <span>Rating: {rating} / 5</span>
    </div>
  );
}
```

---

## useSlider Hook

Hook for custom Slider logic.

### UseSliderCommonProps

| Property | Type     | Description  |
| -------- | -------- | ------------ |
| `max`    | `number` | **Required** |
| `min`    | `number` | **Required** |
| `step`   | `number` | **Required** |

### UseSliderProps

```tsx
interface UseSliderProps extends UseSliderCommonProps {
  onChange?: UseSingleSliderProps['onChange'] | UseRangeSliderProps['onChange'];
  value: SingleSliderValue | RangeSliderValue;
}
```

### UseSliderResult

| Property                | Type                                              | Description                    |
| ----------------------- | ------------------------------------------------- | ------------------------------ |
| `activeHandleIndex`     | `number \| undefined`                             | Currently dragging handle index |
| `cssVars`               | `Record<string, CssVarInterpolation>`             | CSS variables                  |
| `handleClickTrackOrRail`| `((e: any) => void) \| undefined`                 | Track click handler (undefined when no onChange) |
| `handlePress`           | `(e: any, index?: number) => void`                | Handle press event handler     |
| `railRef`               | `RefObject<HTMLDivElement \| null>`                | Rail element ref               |

---

## Input Field Behavior

When `withInput` is true:
- Input value is applied on Enter or blur
- Pressing Escape reverts to the original value
- Values are automatically clamped within min/max range
- Range mode automatically sorts (smaller value first)

---

## Figma Mapping

| Figma Variant               | React Props                              |
| --------------------------- | ---------------------------------------- |
| `Slider / Single`           | `value={number}`                         |
| `Slider / Range`            | `value={[number, number]}`               |
| `Slider / With Input`       | `withInput`                              |
| `Slider / With Icons`       | `prefixIcon suffixIcon`                  |
| `Slider / With Ticks`       | `withTick`                               |
| `Slider / Disabled`         | `disabled`                               |

---

## Best Practices

1. **Controlled mode**: Slider is a fully controlled component; `value` must be provided
2. **Appropriate step**: Set a reasonable `step` based on the value range
3. **Tick marks**: Use `withTick` for reference on large value ranges
4. **Input field**: Use `withInput` for precise value requirements
5. **Range auto-sort**: Range mode automatically places the smaller value first
