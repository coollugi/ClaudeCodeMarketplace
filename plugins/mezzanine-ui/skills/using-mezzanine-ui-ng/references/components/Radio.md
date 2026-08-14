# Radio

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/radio) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-radio--docs

A single-select radio button component supporting `radio` (standard) and `segment` (segmented control) types. Can be used standalone or within `MznRadioGroup`. The group provides a shared DI context and exposes `ControlValueAccessor` for `string` values.

`MznRadioGroup` can render radio buttons from a declarative `options` array or accept projected `mznRadio` children. Both approaches can be mixed.

> **別名（重要）** — `type="segment"` 的 `MznRadioGroup` 就是一般所稱的
> **Segmented Control / 分段控制項 / 分段切換 / Toggle Button Group / mat-button-toggle-group (Angular Material) / Segmented (Ant Design)**
> （Figma 元件名為 `Segmented Control` / `Segmented Control Set`）。
> 互斥的**檢視切換、排序切換、篩選切換**一律用它，
> **不要用多顆 `mznButton` 的 variant 差異模擬選中狀態**。

> **Aliases** — Radio · Radio Button · 單選 · Segmented Control · 分段控制項 · 分段切換 · 檢視切換 · 排序切換 · Toggle Button Group · mat-button-toggle-group · Segmented (AntD) · Figma `Segmented Control`
> **Not for** — 多選（用 [`MznCheckbox`](Checkbox.md) / `MznCheckboxGroup`）；卡片式選取（用 [`MznSelectionCard`](SelectionCard.md)）

> **這個元件歸類在 Data Entry，但 `segment` 模式不限於表單。** 排序切換、檢視切換這類非表單的互斥切換也用它 —— 見下方 [Usage](#usage) 的排序切換範例。

## Import

```ts
import { MznRadio, MznRadioGroup, MZN_RADIO_GROUP } from '@mezzanine-ui/ng/radio';
import type {
  RadioWithInputConfig,
  RadioGroupOption,
  RadioGroupContextValue,
  RadioGroupOrientation,
} from '@mezzanine-ui/ng/radio';
import { RadioSize, RadioType } from '@mezzanine-ui/core/radio';
```

## Selector

`<div mznRadio value="..." ...>` — attribute-directive component (`value` is required)

`<div mznRadioGroup ...>` — attribute-directive component

## Inputs — MznRadio

| Input             | Type                     | Default    | Description                                               |
| ----------------- | ------------------------ | ---------- | --------------------------------------------------------- |
| `value`           | `string` (required)      | —          | The radio's string value                                  |
| `checked`         | `boolean`                | —          | Controlled checked state (standalone usage)               |
| `disabled`        | `boolean`                | `false`    | Disabled state                                            |
| `error`           | `boolean`                | `false`    | Error state styling                                       |
| `hint`            | `string`                 | —          | Secondary hint text (radio type only)                     |
| `icon`            | `IconDefinition`         | —          | Icon shown in the segment (segment type only)             |
| `name`            | `string`                 | —          | Input name attribute                                      |
| `size`            | `RadioSize`              | `'main'`   | `'main' \| 'minor'`                                       |
| `type`            | `RadioType`              | `'radio'`  | `'radio' \| 'segment'`                                    |
| `withInputConfig` | `RadioWithInputConfig`   | —          | Inline text input config shown alongside the radio button |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Inputs — MznRadioGroup

| Input         | Type                             | Default        | Description                                              |
| ------------- | -------------------------------- | -------------- | -------------------------------------------------------- |
| `options`     | `ReadonlyArray<RadioGroupOption>`| `[]`           | Declarative option list; renders before projected children |
| `disabled`    | `boolean`                        | `false`        | Disable all radios                                       |
| `orientation` | `RadioGroupOrientation`          | `'horizontal'` | `'horizontal' \| 'vertical'`                             |
| `name`        | `string`                         | `''`           | Input name propagated to all radios                      |
| `size`        | `InputCheckSize`                 | `'main'`       | Size propagated to all radios                            |
| `type`        | `RadioType`                      | `'radio'`      | Type propagated to all radios                            |

## Outputs

| Output        | Type                       | Component       | Description                                |
| ------------- | -------------------------- | --------------- | ------------------------------------------ |
| `valueChange` | `OutputEmitterRef<string>` | `MznRadioGroup` | Emitted when the selected value changes    |

## ControlValueAccessor

Both `MznRadio` (standalone) and `MznRadioGroup` implement `ControlValueAccessor`.

**Standalone radio** — binds `string` (the radio's own `value` when selected):

```html
<div mznRadio [formControl]="colorCtrl" value="red">Red</div>
<div mznRadio [(ngModel)]="selectedColor" value="blue">Blue</div>
```

**RadioGroup** — binds `string` (the `value` of the selected radio):

```html
<form [formGroup]="form">
  <div mznRadioGroup formControlName="color" name="color">
    <div mznRadio value="red">Red</div>
    <div mznRadio value="blue">Blue</div>
    <div mznRadio value="green">Green</div>
  </div>
</form>

<div mznRadioGroup [(ngModel)]="selectedColor" name="color">
  <div mznRadio value="red">Red</div>
  <div mznRadio value="blue">Blue</div>
</div>
```

`MznRadio.writeValue(string)` stores the group value in an internal signal and computes `resolvedChecked = group.value() === this.value()`. `MznRadioGroup.writeValue(string | null)` sets the internal value signal; `null` becomes `''`.

## Usage

```html
<!-- Segmented control group via options array -->
<div mznRadioGroup
  formControlName="plan"
  name="plan"
  type="segment"
  [options]="[
    { id: 'free', name: 'Free' },
    { id: 'pro', name: 'Pro' },
    { id: 'enterprise', name: 'Enterprise', disabled: true }
  ]">
</div>

<!-- Vertical radio group with hints -->
<div mznRadioGroup [(ngModel)]="shippingMethod" name="shipping" orientation="vertical">
  <div mznRadio value="standard" hint="3-5 business days">Standard</div>
  <div mznRadio value="express" hint="1-2 business days">Express</div>
  <div mznRadio value="overnight" hint="Next business day">Overnight</div>
</div>
```

```ts
import { MznRadio, MznRadioGroup } from '@mezzanine-ui/ng/radio';
import { ReactiveFormsModule, FormControl } from '@angular/forms';

@Component({
  imports: [MznRadio, MznRadioGroup, ReactiveFormsModule],
})
export class PlanSelectorComponent {
  readonly planCtrl = new FormControl('free');
}
```

### Segment 模式 — 非表單情境（排序切換 / 檢視切換）

`segment` 模式最常見的用途其實**不是表單欄位**，而是列表上方的排序、檢視、篩選切換。這種情境不需要 `mznFormField`，直接綁 signal 或 `ngModel` 即可。

```html
<!-- ✅ 這就是設計稿上的 Segmented Control -->
<div mznRadioGroup
  type="segment"
  size="sub"
  name="sort"
  [(ngModel)]="sort"
  [options]="[
    { id: 'sla', name: '時效由近到遠' },
    { id: 'amount', name: '金額由大到小' }
  ]">
</div>
```

```html
<!-- ❌ 反例：用兩顆 Button 的 variant 差異模擬選中狀態 -->
<!-- 語意不對（不是 radiogroup，鍵盤操作與 a11y 都不同）、視覺也不是設計稿上的 Segmented Control -->
@for (option of sorts; track option.id) {
  <button
    mznButton
    [variant]="sort() === option.id ? 'base-secondary' : 'base-tertiary'"
    (click)="sort.set(option.id)">
    {{ option.name }}
  </button>
}
```

## Notes

- When radios are inside a group, the group's `MZN_RADIO_GROUP` DI token provides shared state. The radio's `select(value)` call on change bubbles up through the group's CVA `onChange`. The injected value has the shape:

  ```ts
  interface RadioGroupContextValue {
    readonly disabled: Signal<boolean>;
    readonly name: Signal<string>;
    readonly size: Signal<InputCheckSize>;
    readonly type: Signal<RadioType>;
    readonly value: Signal<string>;
    readonly select: (val: string) => void;
  }
  ```
- For `segment` type, icons can be provided via the `icon` input (individual radio) or the `icon` field in `RadioGroupOption`.
- `withInputConfig` shows an adjacent `MznInput` (base variant) that auto-focuses when the radio is selected. This is a React parity feature for "Other: [input]" patterns.
- Unlike `MznCheckboxGroup` which binds `string[]`, `MznRadioGroup` binds a single `string` — reflecting radio's mutually exclusive selection.
- **不要用多顆 `mznButton` 模擬分段控制項**：設計稿上的 Segmented Control 一律是 `MznRadioGroup type="segment"`。用 `Button` 的 variant 差異模擬選中狀態，語意（不是 radiogroup）、鍵盤操作與視覺都不對。
