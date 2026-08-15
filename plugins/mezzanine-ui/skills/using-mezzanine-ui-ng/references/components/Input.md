# Input

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/input) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-input--docs

A multi-variant text input component supporting base, affix, search, password, measure, number, action, and select variants. The `search` variant includes a search icon prefix and a clearable button by default; `password` offers a visibility toggle and optional strength indicator; `measure` adds spinner up/down buttons; `action` and `select` variants attach external action or dropdown buttons. Implements `ControlValueAccessor` for full Angular Forms integration.

## Import

```ts
import { MznInput } from '@mezzanine-ui/ng/input';
import type { InputVariant } from '@mezzanine-ui/ng/input';
// Dropdown options type:
import type { DropdownOption } from '@mezzanine-ui/core/dropdown';
```

## Selector

`<div mznInput ...>` — attribute-directive component

> ⚠️ **必須掛在容器元素上，不能掛原生 `<input>` / `<textarea>`（`1.0.0-rc.7` 起會 throw）**
>
> `MznInput` 內部會自己渲染一個 `<input>`。把 directive 掛在原生表單元素上會讓 host 與內部的
> `ControlValueAccessor` 脫鉤，導致 `ngModel` / `formControl` **靜默失效**——值綁不上、也不報錯。
>
> rc.7 起元件會在初始化時直接拋出明確錯誤，把這個原本無聲的失敗變成一眼可見的問題：
>
> ```
> [mznInput] must be applied to a container element (e.g. <div mznInput>) —
> the component renders its own <input> internally. Detected host: <input>.
> ```
>
> ```html
> <!-- ❌ rc.7 起會 throw；rc.6 以前是靜默失效 -->
> <input mznInput [(ngModel)]="keyword" />
>
> <!-- ✅ -->
> <div mznInput [(ngModel)]="keyword"></div>
> ```
>
> 核對自 `packages/ng/input/input.component.ts:290-300`。

## Inputs

| Input                         | Type                                                    | Default        | Description                                                           |
| ----------------------------- | ------------------------------------------------------- | -------------- | --------------------------------------------------------------------- |
| `variant`                     | `InputVariant`                                          | `'base'`       | `'base' \| 'affix' \| 'action' \| 'measure' \| 'number' \| 'password' \| 'search' \| 'select'` |
| `value`                       | `string`                                                | —              | Controlled value (alias for `externalValue`)                          |
| `defaultValue`                | `string`                                                | —              | Initial uncontrolled value (set once on init)                         |
| `disabled`                    | `boolean`                                               | `false`        | Disables the input                                                    |
| `error`                       | `boolean`                                               | `false`        | Error state styling                                                   |
| `fullWidth`                   | `boolean`                                               | `true`         | Stretch to container width                                            |
| `readonly`                    | `boolean`                                               | `false`        | Read-only state (alias: `readonlyState`)                              |
| `placeholder`                 | `string`                                                | —              | Placeholder text                                                      |
| `size`                        | `'main' \| 'sub'`                                       | `'main'`       | Input height size                                                     |
| `active`                      | `boolean`                                               | `false`        | Force active/focused styling                                          |
| `clearable`                   | `boolean`                                               | auto           | Show clear button; `search` variant defaults to `true`               |
| `typing`                      | `boolean`                                               | —              | Override auto typing-state detection                                  |
| `inputId`                     | `string`                                                | —              | Native `<input id>`                                                   |
| `inputName`                   | `string`                                                | —              | Native `<input name>`                                                 |
| `inputType`                   | `string`                                                | —              | Native `<input type>` override                                        |
| `prefixIcon`                  | `IconDefinition`                                        | —              | Prefix icon (affix variant)                                           |
| `prefixText`                  | `string`                                                | —              | Prefix text (affix variant)                                           |
| `suffixText`                  | `string`                                                | —              | Suffix text (affix / measure variant)                                 |
| `min`                         | `number`                                                | —              | Min value (measure / number variant)                                  |
| `max`                         | `number`                                                | —              | Max value (measure / number variant)                                  |
| `step`                        | `number`                                                | —              | Step value (measure / number variant)                                 |
| `showSpinner`                 | `boolean`                                               | `false`        | Show spinner buttons (measure variant)                                |
| `formatter`                   | `(value: string) => string`                             | —              | Custom display formatter                                              |
| `parser`                      | `(value: string) => string`                             | —              | Custom value parser                                                   |
| `showPasswordStrengthIndicator` | `boolean`                                             | `false`        | Show password strength indicator (password variant)                   |
| `passwordStrengthIndicator`   | `{ strength?, strengthText?, strengthTextPrefix?, hintTexts? }` | — | Strength indicator config (password variant)             |
| `actionButton`                | `{ position?, icon?, label?, disabled?, onClick? }`     | —              | Action button config (action variant); `position` must be `'prefix'` or `'suffix'` — when omitted the button is not rendered |
| `selectButton`                | `{ position?, disabled?, value? }`                      | —              | Select button config (select variant); listen to `(selectOptionSelected)` output for selection events |
| `selectOptions`               | `ReadonlyArray<DropdownOption>`                         | —              | Dropdown options (select variant)                                     |
| `dropdownWidth`               | `number \| string`                                      | `120`          | Dropdown width (select variant)                                       |
| `dropdownMaxHeight`           | `number \| string`                                      | `114`          | Dropdown max height (select variant)                                  |
| `dropdownPlacement`           | `Placement`                                             | `'bottom-start'` | Dropdown placement (select variant)                                 |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output                  | Type                        | Description                                       |
| ----------------------- | --------------------------- | ------------------------------------------------- |
| `valueChange`           | `OutputEmitterRef<string>`  | Emitted on every input change                     |
| `spinUp`                | `OutputEmitterRef<void>`    | Emitted when spinner up is clicked (measure)      |
| `spinDown`              | `OutputEmitterRef<void>`    | Emitted when spinner down is clicked (measure)    |
| `selectOptionSelected`  | `OutputEmitterRef<DropdownOption>` | Emitted when a dropdown option is selected (select) |

## ControlValueAccessor

`MznInput` implements `ControlValueAccessor` via `provideValueAccessor(MznInput)`. It binds to `string` values.

```html
<!-- formControlName (ReactiveFormsModule) -->
<form [formGroup]="form">
  <div mznInput formControlName="username" placeholder="Username"></div>
</form>

<!-- formControl directive -->
<div mznInput [formControl]="usernameCtrl" placeholder="Username"></div>

<!-- ngModel (TemplateDrivenForms) -->
<div mznInput [(ngModel)]="username" placeholder="Username"></div>
```

`writeValue(value: string | null)` sets the internal signal; `null` is coerced to `''`. `setDisabledState` is implemented but delegates control to the `disabled` input — when forms call `setDisabledState`, the disabled state is reflected only when the `disabled` input is not bound externally.

## Usage

```html
<!-- Basic with error state from form control -->
<form [formGroup]="form">
  <div mznInput
    formControlName="email"
    placeholder="Email"
    [error]="form.get('email')?.invalid && !!form.get('email')?.touched">
  </div>
</form>

<!-- Password with strength indicator -->
<div mznInput
  variant="password"
  [formControl]="passwordCtrl"
  placeholder="Password"
  [showPasswordStrengthIndicator]="true"
  [passwordStrengthIndicator]="{ strength: 'medium', strengthTextPrefix: 'Strength: ' }">
</div>

<!-- Measure with spinner -->
<div mznInput
  variant="measure"
  [(ngModel)]="fontSize"
  suffixText="px"
  [showSpinner]="true"
  [min]="8"
  [max]="96"
  [step]="2">
</div>
```

```ts
import { MznInput } from '@mezzanine-ui/ng/input';
import { ReactiveFormsModule, FormControl, Validators } from '@angular/forms';

@Component({
  imports: [MznInput, ReactiveFormsModule],
})
export class SearchComponent {
  readonly emailCtrl = new FormControl('', [Validators.required, Validators.email]);
}
```

## Notes

- Unlike the React `<Input>` component which accepts `children` for complex compositions, the Angular version uses `variant` to select composition modes.
- The `value` input alias (`externalValue`) creates a controlled mode: if `[value]` is bound, the component always renders that value. Without `[value]`, CVA / uncontrolled mode applies.
- `measure` variant automatically formats numbers with commas for display but stores/emits the raw numeric string. The internal `parseNumberWithCommas` utility handles this.
- For `search` variant, `clearable` defaults to `true`; pass `[clearable]="false"` to disable the clear button.
- **`selectButton.onClick`** — although the field exists on the config type in source, it is not called by the component. Do not rely on it; use the `(selectOptionSelected)` output instead.
- **`actionButton.position`** — when `position` is omitted from the config object, `actionButtonPosition()` returns `null` and the action button is not rendered at all. There is no default side.
