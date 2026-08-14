# Toggle

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/toggle) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-toggle--docs

A binary on/off toggle switch component (supersedes the React `Switch` component naming). Implements `ControlValueAccessor` to bind `boolean` values with Angular Forms. Supports an optional text label and supporting text.

> **Aliases** — mat-slide-toggle (Angular Material) · Switch (MUI・Ant Design) · 開關 · 切換開關 · Figma `Toggle / *`
> **Not for** — 多選清單（用 [`MznCheckbox`](Checkbox.md) / `MznCheckboxGroup`）；互斥的多選一（用 [`MznRadioGroup type="segment"`](Radio.md)）。`@mezzanine-ui/ng` 沒有 `MznSwitch`。

## Import

```ts
import { MznToggle } from '@mezzanine-ui/ng/toggle';
import { ToggleSize } from '@mezzanine-ui/core/toggle';
```

## Selector

`<div mznToggle ...>` — attribute-directive component

## Inputs

| Input            | Type         | Default  | Description                                    |
| ---------------- | ------------ | -------- | ---------------------------------------------- |
| `checked`        | `boolean`    | —        | Controlled checked state                       |
| `disabled`       | `boolean`    | `false`  | Disabled state                                 |
| `label`          | `string`     | —        | Primary label text shown to the right          |
| `size`           | `ToggleSize` | `'main'` | `'main' \| 'minor'`                            |
| `supportingText` | `string`     | —        | Secondary supporting text beneath the label    |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

`MznToggle` has no explicit output events. Value changes are communicated via `ControlValueAccessor`.

## ControlValueAccessor

`MznToggle` implements `ControlValueAccessor` via `provideValueAccessor(MznToggle)`. It binds to `boolean` values.

```html
<!-- formControlName -->
<form [formGroup]="form">
  <div mznToggle formControlName="notifications" label="Enable notifications"></div>
</form>

<!-- formControl -->
<div mznToggle [formControl]="darkModeCtrl" label="Dark mode"></div>

<!-- ngModel -->
<div mznToggle [(ngModel)]="isEnabled" label="Feature flag"></div>
```

`writeValue(boolean)` stores the value in `internalChecked` signal. `setDisabledState(boolean)` is implemented — it sets `internalDisabled` signal, so Angular forms can programmatically disable the toggle (e.g. `formControl.disable()`).

## Usage

```html
<!-- Settings form with toggles -->
<form [formGroup]="settingsForm">
  <div mznToggle
    formControlName="emailNotifications"
    label="Email Notifications"
    supportingText="Receive updates via email">
  </div>

  <div mznToggle
    formControlName="smsNotifications"
    label="SMS Notifications"
    [size]="'minor'">
  </div>
</form>

<!-- Disabled state managed by forms API -->
<div mznToggle
  [formControl]="featureCtrl"
  label="Beta Feature"
  supportingText="Available for premium users">
</div>
```

```ts
import { MznToggle } from '@mezzanine-ui/ng/toggle';
import { ReactiveFormsModule, FormGroup, FormControl } from '@angular/forms';

@Component({
  imports: [MznToggle, ReactiveFormsModule],
})
export class SettingsComponent {
  readonly settingsForm = new FormGroup({
    emailNotifications: new FormControl(true),
    smsNotifications: new FormControl(false),
  });

  readonly featureCtrl = new FormControl({ value: false, disabled: true });
}
```

## Notes

- `MznToggle` supersedes the `Switch` naming from earlier React versions. The Angular package uses `toggle` throughout.
- `setDisabledState` is fully implemented — calling `formControl.disable()` / `formControl.enable()` will correctly toggle the disabled state via `internalDisabled` signal.
- The `checked` input provides a controlled mode: if `[checked]` is bound, it overrides `internalChecked`. In most form scenarios, use CVA (`formControlName` / `[(ngModel)]`) instead of `[checked]`.
- Unlike `MznCheckbox`, the toggle has no group component — each toggle independently manages its boolean value.
- `size: 'minor'` renders a smaller knob and track suitable for compact layouts.
