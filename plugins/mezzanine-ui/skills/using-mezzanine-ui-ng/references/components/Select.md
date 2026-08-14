# Select

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/select) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-select--docs

A dropdown selector component that opens a floating list panel on trigger click. Supports single and multiple selection modes. In `multiple` mode, if any option has `children` (nested options), the component auto-switches to tree mode and renders a checkbox-based tree. Uses `ClickAwayService` to close on outside clicks and `MznInputTriggerPopper` for floating panel positioning. Implements `ControlValueAccessor`.

> **Aliases** — Select · Combobox · mat-select (Angular Material) · 下拉選單 · 下拉選擇
> **Not for** — 觸發動作的選單（用 [`MznDropdown`](Dropdown.md)）；邊打字邊過濾（用 [`MznAutocomplete`](Autocomplete.md)）；有階層的選項（用 [`MznCascader`](Cascader.md)）

## Import

```ts
import { MznSelect, MznSelectTrigger, MznSelectTriggerTags } from '@mezzanine-ui/ng/select';
import type { SelectTriggerTagValue } from '@mezzanine-ui/ng/select';
import type { DropdownOption } from '@mezzanine-ui/core/dropdown';
import { SelectInputSize, SelectMode } from '@mezzanine-ui/core/select';
```

## Selector

`<div mznSelect ...>` — attribute-directive component

## Inputs

| Input               | Type                          | Default      | Description                                                       |
| ------------------- | ----------------------------- | ------------ | ----------------------------------------------------------------- |
| `options`           | `ReadonlyArray<DropdownOption>` | `[]`        | Selectable options; `DropdownOption = { id: string, name: string, children?: DropdownOption[], disabled?: boolean }` |
| `mode`              | `SelectMode`                  | `'single'`   | `'single' \| 'multiple'`                                          |
| `placeholder`       | `string`                      | `''`         | Placeholder text when no value selected                           |
| `disabled`          | `boolean`                     | `false`      | Disabled state                                                    |
| `error`             | `boolean`                     | `false`      | Error state styling                                               |
| `fullWidth`         | `boolean`                     | `false`      | Stretch to container width                                        |
| `readOnly`          | `boolean`                     | `false`      | Read-only state                                                   |
| `size`              | `SelectInputSize`             | `'main'`     | `'main' \| 'sub'`                                                 |
| `clearable`         | `boolean`                     | `false`      | Show clear button when a value is selected                        |
| `menuMaxHeight`     | `number`                      | —            | Maximum height of the dropdown list (px)                          |
| `loading`           | `boolean`                     | `false`      | Loading state                                                     |
| `loadingPosition`   | `'full' \| 'bottom'`          | `'bottom'`   | Where to show the loading indicator                               |
| `loadingText`       | `string`                      | `'Loading...'` | Loading text                                                    |
| `globalPortal`      | `boolean`                     | `true`       | Render panel in a body-level portal                               |
| `dropdownZIndex`    | `number`                      | —            | Custom z-index for the dropdown panel                             |
| `prefix`            | `string`                      | —            | Prefix text in the trigger                                        |
| `suffixActionIcon`  | `IconDefinition`              | `ChevronDownIcon` | Suffix icon in trigger                                       |
| `required`          | `boolean`                     | `false`      | Required field marker                                             |
| `overflowStrategy`  | `'counter' \| 'wrap'`         | `'counter'`  | Multiple mode tag overflow strategy                               |
| `type`              | `DropdownType`                | `'default'`  | `'default' \| 'tree'` — overridden automatically in multiple mode with children |
| `className`         | `string`                      | —            | Extra host CSS class                                              |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output            | Type                                              | Description                                          |
| ----------------- | ------------------------------------------------- | ---------------------------------------------------- |
| `selectionChange` | `OutputEmitterRef<DropdownOption>`                | Emitted when an option is selected/deselected        |
| `onScroll`        | `OutputEmitterRef<{ scrollTop, maxScrollTop }>`   | Scroll events on the dropdown list                   |
| `onReachBottom`   | `OutputEmitterRef<void>`                          | Scroll reaches bottom (infinite scroll hook)         |
| `onLeaveBottom`   | `OutputEmitterRef<void>`                          | Scroll leaves bottom                                 |

## ControlValueAccessor

`MznSelect` implements `ControlValueAccessor`. In `single` mode it binds `string`; in `multiple` mode it binds `string[]`.

```html
<!-- Single select with formControlName -->
<form [formGroup]="form">
  <div mznSelect formControlName="country" [options]="countries" placeholder="Select country"></div>
</form>

<!-- Multiple select with formControl -->
<div mznSelect
  mode="multiple"
  [formControl]="tagsCtrl"
  [options]="tagOptions"
  placeholder="Select tags"
  [clearable]="true">
</div>

<!-- ngModel -->
<div mznSelect [(ngModel)]="selectedId" [options]="items" placeholder="Select item"></div>
```

`writeValue(ReadonlyArray<string> | string | null)` normalises the input: a plain `string` becomes `[string]` internally; `null`/`undefined` becomes `[]`. In `single` mode, `onChange` emits the selected `id` as a plain `string`; in `multiple` mode it emits `string[]`.

## Usage

```html
<!-- With error state and clear button -->
<div mznFormField name="role" label="Role" [severity]="form.get('role')?.invalid ? 'error' : 'info'">
  <div mznSelect
    formControlName="role"
    [options]="roleOptions"
    placeholder="Select role"
    [clearable]="true"
    [fullWidth]="true"
    [error]="form.get('role')?.invalid && !!form.get('role')?.touched">
  </div>
</div>

<!-- Tree-mode multiple select (auto-enabled when options have children) -->
<div mznSelect
  mode="multiple"
  [(ngModel)]="selectedLeafIds"
  [options]="treeOptions"
  placeholder="Select categories"
  overflowStrategy="wrap">
</div>
```

```ts
import { MznSelect } from '@mezzanine-ui/ng/select';
import type { DropdownOption } from '@mezzanine-ui/core/dropdown';
import { ReactiveFormsModule, FormControl } from '@angular/forms';

@Component({
  imports: [MznSelect, ReactiveFormsModule],
})
export class FilterComponent {
  readonly roleOptions: ReadonlyArray<DropdownOption> = [
    { id: 'admin', name: 'Admin' },
    { id: 'editor', name: 'Editor' },
    { id: 'viewer', name: 'Viewer', disabled: true },
  ];

  readonly roleCtrl = new FormControl('');
}
```

## MznSelectTrigger

The clickable trigger area of a select. Renders prefix text, the display value (or placeholder), an optional clear button, and a suffix action icon. Normally composed inside `MznSelect` automatically, but can be used standalone.

**Selector**: `[mznSelectTrigger]`

| Input              | Type                          | Default            | Description                                               |
| ------------------ | ----------------------------- | ------------------ | --------------------------------------------------------- |
| `active`           | `boolean`                     | `false`            | Active (open) state; rotates the suffix icon              |
| `clearable`        | `boolean`                     | `false`            | Show clear button when `hasValue` is true                 |
| `disabled`         | `boolean`                     | `false`            | Disabled state; blocks click events                       |
| `displayText`      | `string`                      | `''`               | Display text for single-mode value                        |
| `error`            | `boolean`                     | `false`            | Error state styling                                       |
| `hasValue`         | `boolean`                     | `false`            | Controls display text vs. placeholder visibility          |
| `mode`             | `SelectMode`                  | `'single'`         | `'single' \| 'multiple'`; affects CSS class              |
| `placeholder`      | `string`                      | `''`               | Placeholder text when no value is selected                |
| `prefix`           | `string \| undefined`         | —                  | Prefix text shown before the value                        |
| `readOnly`         | `boolean`                     | `false`            | Read-only state; blocks click events                      |
| `size`             | `SelectInputSize`             | `'main'`           | `'main' \| 'sub'`                                         |
| `suffixActionIcon` | `typeof ChevronDownIcon`      | `ChevronDownIcon`  | Custom suffix icon                                        |

| Output           | Type                        | Description                                       |
| ---------------- | --------------------------- | ------------------------------------------------- |
| `cleared`        | `OutputEmitterRef<MouseEvent>` | Emitted when clear button is clicked           |
| `triggerClicked` | `OutputEmitterRef<void>`    | Emitted when trigger is clicked (not when disabled/readOnly) |

## MznSelectTriggerTags

Renders multiple-selection values as dismissable tags inside the trigger area. Supports two overflow strategies.

**Selector**: `[mznSelectTriggerTags]`

**Type**: `SelectTriggerTagValue = { id: string; name: string }`

| Input              | Type                                   | Default     | Description                                                      |
| ------------------ | -------------------------------------- | ----------- | ---------------------------------------------------------------- |
| `disabled`         | `boolean`                              | `false`     | Passed to each tag; disables close button                        |
| `overflowStrategy` | `'counter' \| 'wrap'`                  | `'counter'` | `counter`: single-row with `+N` overflow; `wrap`: multi-row     |
| `readOnly`         | `boolean`                              | `false`     | Renders static (non-dismissable) tags                            |
| `size`             | `TagSize`                              | `'main'`    | Tag size (`TagSize`, not `SelectInputSize`)                      |
| `value`            | `ReadonlyArray<SelectTriggerTagValue>` | `[]`        | Selected items to render as tags                                 |

| Output      | Type                                    | Description                              |
| ----------- | --------------------------------------- | ---------------------------------------- |
| `tagClosed` | `OutputEmitterRef<SelectTriggerTagValue>` | Emitted with the removed item when a tag's close button is clicked |

> `counter` strategy uses `ResizeObserver` + `afterRenderEffect` to dynamically calculate how many tags fit in the available width, replacing overflow with a `+N` counter tag.

## Notes

- Tree mode is **auto-detected**: if `mode === 'multiple'` and any option has `children`, the component sets `resolvedType = 'tree'` regardless of the `type` input.
- In tree mode, clicking a parent node toggles/collapses it; clicking a leaf selects it. Checking a parent's checkbox selects all its leaf descendants.
- `globalPortal: true` (default) renders the dropdown panel outside the component's DOM subtree using a portal, which avoids `overflow: hidden` clipping from ancestor containers.
- The CVA `onChange` emits a plain `string` (not `string[]`) in single mode for React-parity. This means `formControl.value` is `string | string[]` depending on `mode`. Type your `FormControl` accordingly.
- When the clear button is clicked, `selectionChange` emits a synthetic `DropdownOption` with `{ id: '', name: '' }`. Consumers guarding on `event.id` must handle the empty-string case.
