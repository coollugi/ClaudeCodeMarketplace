# Autocomplete

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/autocomplete) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-entry-autocomplete--docs

A search-as-you-type dropdown component combining a text input with a floating dropdown. Wraps `MznDropdown` for list rendering, keyboard navigation, and click-away. Features: search debounce, async data loading, addable new options, bulk paste creation, multiple selection with tag display (counter/wrap overflow), and `inputPosition: 'inside' | 'outside'` modes.

Implements `ControlValueAccessor`. In `single` mode binds `string`; in `multiple` mode binds `string[]`.

## Import

```ts
import {
  MznAutocomplete,
  MznAutocompletePrefix,
  getFullParsedList,
} from '@mezzanine-ui/ng/autocomplete';
import type { DropdownOption } from '@mezzanine-ui/core/dropdown';
import { AutoCompleteMode, AutoCompleteInputSize } from '@mezzanine-ui/core/autocomplete';

// getFullParsedList signature:
// getFullParsedList(text: string, separators: ReadonlyArray<string>, trim: boolean): ReadonlyArray<string>
```

## Selector

`<div mznAutocomplete ...>` — attribute-directive component

`[mznAutocompletePrefix]` — directive for projecting prefix content into the trigger

## Inputs

| Input                       | Type                                              | Default             | Description                                                        |
| --------------------------- | ------------------------------------------------- | ------------------- | ------------------------------------------------------------------ |
| `options`                   | `ReadonlyArray<DropdownOption>`                   | `[]`                | Option list                                                        |
| `mode`                      | `AutoCompleteMode`                                | `'single'`          | `'single' \| 'multiple'`                                           |
| `placeholder`               | `string`                                          | `''`                | Placeholder text                                                   |
| `disabled`                  | `boolean`                                         | `false`             | Disabled state                                                     |
| `error`                     | `boolean`                                         | `false`             | Error state                                                        |
| `readOnly`                  | `boolean`                                         | `false`             | Read-only state                                                    |
| `required`                  | `boolean`                                         | `false`             | Required attribute on `<input>`                                    |
| `size`                      | `AutoCompleteInputSize`                           | `'main'`            | `'main' \| 'sub'`                                                  |
| `clearable`                 | `boolean`                                         | `false`             | Show clear button                                                  |
| `clearSearchText`           | `boolean`                                         | `true`              | Clear search text on blur/close                                    |
| `loading`                   | `boolean`                                         | `false`             | External loading state                                             |
| `loadingPosition`           | `'full' \| 'bottom'`                              | `'bottom'`          | Loading indicator position                                         |
| `loadingText`               | `string`                                          | `'載入中...'`         | Loading text                                                       |
| `asyncData`                 | `boolean`                                         | `false`             | Enable async mode: shows loading until `options` changes           |
| `searchDebounceTime`        | `number`                                          | `0`                 | Debounce delay for `searchChange` (ms)                             |
| `disabledOptionsFilter`     | `boolean`                                         | `false`             | Disable built-in substring filter; manage options externally       |
| `emptyText`                 | `string`                                          | `'沒有符合的項目'`      | Empty state message                                                |
| `menuMaxHeight`             | `number`                                          | —                   | Dropdown panel max height (px)                                     |
| `overflowStrategy`          | `'counter' \| 'wrap'`                             | `'wrap'`            | Tag overflow strategy (multiple mode)                              |
| `inputPosition`             | `'outside' \| 'inside'`                           | `'outside'`         | Outside: input in trigger area; inside: input in the panel         |
| `open`                      | `boolean`                                         | —                   | Controlled open state                                              |
| `active`                    | `boolean`                                         | `false`             | Force active styling                                               |
| `addable`                   | `boolean`                                         | `false`             | Enable creating new options                                        |
| `onInsert`                  | `(text: string, currentOptions: ReadonlyArray<DropdownOption>) => ReadonlyArray<DropdownOption>` | — | Callback input for adding new options; required when `addable` |
| `onRemoveCreated`           | `(cleanedOptions) => void`                        | —                   | Callback when unselected created options are cleaned up            |
| `createActionText`          | `(text: string) => string`                        | —                   | Custom create button text function                                 |
| `createActionTextTemplate`  | `string`                                          | `'建立 "{text}"'`    | Create button text template                                        |
| `createSeparators`          | `ReadonlyArray<string>`                           | `[',', '+', '\n']`  | Separators for bulk paste creation                                 |
| `stepByStepBulkCreate`      | `boolean`                                         | `false`             | Bulk paste creates items one at a time                             |
| `trimOnCreate`              | `boolean`                                         | `true`              | Trim whitespace when creating items                                |
| `id`                        | `string`                                          | —                   | Native `<input id>`                                                |
| `name`                      | `string`                                          | —                   | Native `<input name>`                                              |
| `dropdownZIndex`            | `number`                                          | —                   | Dropdown z-index                                                   |
| `caseSensitive`             | `boolean`                                         | `false`             | 選項比對是否區分大小寫（**`1.0.0-rc.10` 新增**，對應 React 1.4.2）|

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs

| Output              | Type                                       | Description                                               |
| ------------------- | ------------------------------------------ | --------------------------------------------------------- |
| `searchChange`      | `OutputEmitterRef<string>`                 | Debounced search text change                              |
| `searchTextChange`  | `OutputEmitterRef<string>`                 | Immediate (non-debounced) search text change              |
| `selectionChange`   | `OutputEmitterRef<DropdownOption>`         | Emitted on each selection toggle                          |
| `valueChange`       | `OutputEmitterRef<ReadonlyArray<string>>`  | Multiple mode value array change                          |
| `cleared`           | `OutputEmitterRef<void>`                   | Emitted when cleared                                      |
| `visibilityChange`  | `OutputEmitterRef<boolean>`                | Dropdown open/close                                       |
| `reachBottom`       | `OutputEmitterRef<void>`                   | Scroll reaches bottom                                     |
| `leaveBottom`       | `OutputEmitterRef<void>`                   | Scroll leaves bottom                                      |
| `inserted`          | `OutputEmitterRef<{ text, currentOptions }>` | New option insertion event                              |
| `removeCreated`     | `OutputEmitterRef<ReadonlyArray<DropdownOption>>` | Unselected created options removed                  |

## ControlValueAccessor

`MznAutocomplete` implements `ControlValueAccessor`. Single mode binds `string`; multiple mode binds `string[]`.

```html
<!-- Single mode with async data -->
<div mznAutocomplete
  formControlName="city"
  [options]="cityOptions"
  placeholder="Search city"
  [asyncData]="true"
  [searchDebounceTime]="300"
  (searchChange)="onSearchCity($event)">
</div>

<!-- Multiple mode -->
<div mznAutocomplete
  mode="multiple"
  [formControl]="tagsCtrl"
  [options]="tagOptions"
  placeholder="Add tags"
  [clearable]="true"
  overflowStrategy="wrap">
</div>

<!-- ngModel -->
<div mznAutocomplete [(ngModel)]="selectedUser" [options]="users" placeholder="Select user"></div>
```

`writeValue` accepts `string | string[] | null`. A plain `string` is normalised to `[string]`. `null`/`undefined` clears the selection. In `single` mode, the component also sets `searchText` to the selected option's name on `writeValue`.

## Usage

```html
<!-- Prefix icon with outside input mode -->
<div mznAutocomplete
  formControlName="product"
  [options]="filteredProducts"
  [disabledOptionsFilter]="true"
  (searchChange)="filterProducts($event)"
  placeholder="Search products">
  <i mznIcon mznAutocompletePrefix [icon]="searchIcon"></i>
</div>

<!-- Addable with inside input mode -->
<div mznAutocomplete
  mode="multiple"
  [(ngModel)]="selectedLabels"
  [options]="labels"
  [addable]="true"
  [onInsert]="handleInsert"
  inputPosition="inside"
  placeholder="Select or create labels">
</div>
```

```ts
import { MznAutocomplete, MznAutocompletePrefix } from '@mezzanine-ui/ng/autocomplete';
import type { DropdownOption } from '@mezzanine-ui/core/dropdown';

@Component({
  imports: [MznAutocomplete, MznAutocompletePrefix, ReactiveFormsModule],
})
export class ProductSearchComponent {
  filteredProducts: ReadonlyArray<DropdownOption> = [];

  filterProducts(text: string): void {
    this.filteredProducts = this.allProducts.filter(p =>
      p.name.toLowerCase().includes(text.toLowerCase())
    );
  }

  readonly handleInsert = (
    text: string,
    current: ReadonlyArray<DropdownOption>,
  ): ReadonlyArray<DropdownOption> => {
    const newOption: DropdownOption = { id: `new-${Date.now()}`, name: text };
    return [...current, newOption];
  };
}
```

## Public Methods

Imperative methods exposed on the `MznAutocomplete` component class. Access via `@ViewChild` or `viewChild`.

| Method                          | Signature                          | Description                                                              |
| ------------------------------- | ---------------------------------- | ------------------------------------------------------------------------ |
| `resetSearchText()`             | `(): void`                         | Clears search text, insert text, and internal selected value; emits `onChange` with empty value |
| `setSearchTextValue(text)`      | `(text: string): void`             | Programmatically sets the search text signal and syncs the native `<input>` element |

```ts
// Access via viewChild
private readonly autocomplete = viewChild(MznAutocomplete);

clearSearch(): void {
  this.autocomplete()?.resetSearchText();
}

prefillSearch(text: string): void {
  this.autocomplete()?.setSearchTextValue(text);
}
```

## Notes

- Set `[disabledOptionsFilter]="true"` when filtering externally (e.g. server-side). Otherwise, the component applies its own substring filter to `options`.
- `asyncData: true` shows a loading indicator from the moment the user types until `options` changes — no need to manually manage `loading` state.
- In `inputPosition: 'inside'` mode, the search input is rendered inside the dropdown panel. The trigger area is a minimal button. This is useful for modal-style pickers.
- `addable` requires `[onInsert]` callback input. The output `inserted` fires as a secondary signal; prefer `[onInsert]` for synchronous creation.
- Unlike the React version where `onChange` is passed as a prop, Angular uses CVA — bind `formControlName` or `[(ngModel)]` on the host element to receive the selected value.
