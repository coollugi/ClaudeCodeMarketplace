# Table

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/table) · Verified 1.0.0-rc.4 (2026-04-24)

Full-featured data table with sortable columns, sticky headers, pinnable columns, row selection (checkbox / radio), drag-and-drop row reordering, row expansion, collectable (star/pin) rows, toggle rows, bulk actions, pagination, and optional column resizing. Built on CDK DragDrop for row reordering.

## Import

```ts
// Components / directives / helpers
import {
  MznTable,
  MznTableCellRender,
  useTableDataSource,
  getRowKey,
} from '@mezzanine-ui/ng/table';

// DI tokens
import { MZN_TABLE_CONTEXT } from '@mezzanine-ui/ng/table';

// Context & cell-render types
import type {
  TableContextValue,
  MznTableCellRenderContext,
} from '@mezzanine-ui/ng/table';

// useTableDataSource option/return types
import type {
  UseTableDataSourceOptions,
  UseTableDataSourceReturn,
  UpdateDataSourceOptions,
} from '@mezzanine-ui/ng/table';

// Column / data-source / row config types
import type {
  TableColumn,
  TableDataSource,
  TableActions,
  TableActionItem,
  TableBulkActions,
  TableBulkGeneralAction,
  TableBulkOverflowAction,
  TableRowSelection,
  TableRowSelectionBase,
  TableRowSelectionCheckbox,
  TableRowSelectionRadio,
  TableSelectionMode,
  TableExpandable,
  TablePagination,
  TableDraggable,
  TableCollectable,
  TablePinnable,
  TableToggleable,
  TableScroll,
  TableEmptyProps,
  TableTransitionState,
  TableRowState,
} from '@mezzanine-ui/ng/table';

// Variant / alignment / mode types
import type {
  ColumnAlign,
  TableActionVariant,
  SortOrder,
  TableSize,
  HighlightMode,
  RowHeightPreset,
} from '@mezzanine-ui/ng/table';
```

### DI Tokens / Context

`MZN_TABLE_CONTEXT` is an `InjectionToken<TableContextValue>` exposed by `MznTable` to its descendants (custom cell renderers, action dropdowns, etc.). Advanced composition can inject it to read the current row set, selection state, or data-source signals without prop-drilling. `TableContextValue` describes the injected object's shape. Most consumers do not need to touch these directly — they exist for custom sub-components that extend the built-in table surface.

## Selector

`[mznTable]` — component applied to a container `<div>`.

## Inputs

| Input               | Type                                                                              | Default      | Description                                                              |
| ------------------- | --------------------------------------------------------------------------------- | ------------ | ------------------------------------------------------------------------ |
| `columns`           | `readonly TableColumn[]` **(required)**                                           | —            | Column definitions (see Column Definition section)                       |
| `dataSource`        | `readonly TableDataSource[]`                                                      | `[]`         | Row data; each record should have `key` or `id`                          |
| `size`              | `TableSize`                                                                       | `'main'`     | `'main' \| 'sub'`                                                        |
| `loading`           | `boolean`                                                                         | `false`      | Show skeleton rows while loading                                         |
| `loadingRowsCount`  | `number`                                                                          | `10`         | Number of skeleton rows shown while `loading=true`                       |
| `sticky`            | `boolean`                                                                         | `true`       | Sticky header                                                            |
| `resizable`         | `boolean`                                                                         | `false`      | Enable column resize handles                                             |
| `nested`            | `boolean`                                                                         | `false`      | Disable internal scrollbar (for nested tables)                           |
| `fullWidth`         | `boolean`                                                                         | `false`      | Set `table` element to `width: 100%`                                     |
| `highlight`         | `HighlightMode`                                                                   | `'row'`      | Hover highlight: `'cell' \| 'column' \| 'row' \| 'cross'`               |
| `showHeader`        | `boolean`                                                                         | `true`       | Show/hide `<thead>`                                                      |
| `zebraStriping`     | `boolean`                                                                         | `false`      | Alternating row background color                                         |
| `emptyText`         | `string`                                                                          | `'No data'`  | Text shown when `dataSource` is empty and `emptyProps` is unset          |
| `minHeight`         | `number \| string \| undefined`                                                   | —            | Minimum height of the table body                                         |
| `separatorAtRowIndexes` | `readonly number[] \| undefined`                                              | —            | Insert a visual separator line above these row indexes                   |
| `transitionState`   | `TableTransitionState \| undefined`                                               | —            | Add/remove row animation state (from `useTableDataSource`)               |
| `selectedRowKeys`   | `readonly string[]`                                                               | `[]`         | Pre-selected row keys (used without `rowSelection` for display only)     |
| `actions`           | `TableActions \| undefined`                                                       | —            | Action column config (button/dropdown per row)                           |
| `collectable`       | `TableCollectable \| undefined`                                                   | —            | Star/pin column config                                                   |
| `draggable`         | `TableDraggable \| undefined`                                                     | —            | Drag-and-drop row reordering config                                      |
| `emptyProps`        | `TableEmptyProps \| undefined`                                                    | —            | Empty state component config; takes priority over `emptyText`            |
| `expandable`        | `TableExpandable \| boolean`                                                      | `false`      | Expandable row config (or `true` for default toggle)                     |
| `pagination`        | `TablePagination \| undefined`                                                    | —            | Integrated pagination config                                             |
| `pinnable`          | `TablePinnable \| undefined`                                                      | —            | Pin-to-top column config                                                 |
| `rowHeightPreset`   | `RowHeightPreset`                                                                 | `'base'`     | `'base' \| 'condensed' \| 'detailed' \| 'roomy'`                        |
| `rowSelection`      | `TableRowSelection \| boolean`                                                    | `false`      | Checkbox or radio row selection config; `false` disables selection       |
| `rowState`          | `((record: TableDataSource) => TableRowState \| undefined) \| undefined`          | —            | Per-row state: `'added' \| 'deleted' \| 'disabled'`                     |
| `scroll`            | `TableScroll \| undefined`                                                        | —            | Set max-height for vertical scrolling (only `y` is supported)            |
| `toggleable`        | `TableToggleable \| undefined`                                                    | —            | Toggle-per-row column config                                             |

> Inputs declared with signal API (`input()`, `input.required()`) accept both static and reactive values.

## ControlValueAccessor

No.

## Column Definition

Declare an array of `TableColumn` objects and pass to `[columns]`:

```ts
import type { TableColumn, SortOrder } from '@mezzanine-ui/ng/table';

readonly columns: readonly TableColumn[] = [
  {
    key: 'name',
    title: '姓名',
    dataIndex: 'name',
    width: 200,
    sortOrder: undefined,       // undefined = not sortable
    fixed: 'start',
  },
  {
    key: 'email',
    title: '電子郵件',
    dataIndex: 'email',
    ellipsis: true,             // default true
  },
  {
    key: 'status',
    title: '狀態',
    dataIndex: 'status',
    align: 'center',
    width: 100,
  },
  {
    key: 'createdAt',
    title: '建立日期',
    dataIndex: 'createdAt',
    sortOrder: 'descend',       // 'ascend' | 'descend' | null
    onSort: (key, order) => this.onSort(key, order),
  },
];
```

### Key `TableColumn` fields

| Field        | Type                         | Notes                                           |
| ------------ | ---------------------------- | ----------------------------------------------- |
| `key`        | `string` (required)          | Unique column identifier                        |
| `dataIndex`  | `string \| undefined`        | Maps to `record[dataIndex]` for auto-rendering  |
| `title`      | `string \| undefined`        | Column header text                              |
| `width`      | `number \| string`           | Fixed width in px or CSS string                 |
| `minWidth`   | `number`                     | Required when `resizable` is enabled            |
| `maxWidth`   | `number`                     | Max drag width when resizable                   |
| `fixed`      | `'start' \| 'end'`           | Pin column left or right                        |
| `align`      | `ColumnAlign`                | `'start' \| 'center' \| 'end'`                 |
| `ellipsis`   | `boolean`                    | Truncate overflow text (default `true`)         |
| `sortOrder`  | `SortOrder`                  | `'ascend' \| 'descend' \| null \| undefined`   |
| `onSort`     | `(key, order) => void`       | Sort callback                                   |
| `titleHelp`  | `string`                     | Tooltip shown next to header text               |
| `titleMenu`  | `{ options: DropdownOption[]; ... }` *(inline)* | Dropdown menu in header cell (shape is internal; not separately exported) |

## TableScroll

Only `y` (max-height) is supported:

```ts
import type { TableScroll } from '@mezzanine-ui/ng/table';

readonly scroll: TableScroll = { y: 500 };
```

```html
<div mznTable [columns]="columns" [dataSource]="rows" [scroll]="{ y: 500 }"></div>
```

## Row Selection

Use the `mode` field (not `type`) to specify checkbox or radio:

```ts
import type { TableRowSelectionCheckbox } from '@mezzanine-ui/ng/table';

readonly rowSelection: TableRowSelectionCheckbox = {
  mode: 'checkbox',
  selectedRowKeys: this.selected,
  onChange: (keys) => { this.selected = [...keys]; },
};
```

```ts
import type { TableRowSelectionRadio } from '@mezzanine-ui/ng/table';

readonly rowSelection: TableRowSelectionRadio = {
  mode: 'radio',
  selectedRowKey: this.selectedKey,
  onChange: (key) => { this.selectedKey = key; },
};
```

## Custom Cell Rendering — MznTableCellRender

Use `MznTableCellRender` directive on a `<ng-template>` inside the table host. The directive's required input is `mznTableCellRender` (the column key it targets). The template context provides `$implicit` (row record) and `index` (row index):

```html
<div mznTable [columns]="cols" [dataSource]="rows">
  <ng-template mznTableCellRender="age" let-record let-i="index">
    <span mznTypography variant="body-mono">{{ record.age }}</span>
  </ng-template>
</div>
```

### Inputs — MznTableCellRender

**Selector**: `[mznTableCellRender]`（套用在 `<ng-template>` 上）

| Input                | Type                | Default | Description                                        |
| -------------------- | ------------------- | ------- | -------------------------------------------------- |
| `mznTableCellRender` | `string` (required) | —       | 目標欄位的 key；與 `columns` 中的 `key` 對應      |

### MznTableCellRenderContext

```ts
interface MznTableCellRenderContext<T extends TableDataSource = TableDataSource> {
  readonly $implicit: T;  // the row record
  readonly index: number; // the row index
}
```

## useTableDataSource

Angular function equivalent of the React `useTableDataSource` hook. Must be called inside an Angular injection context (component field initialiser or constructor).

```ts
import { useTableDataSource } from '@mezzanine-ui/ng/table';
import type {
  UseTableDataSourceOptions,
  UseTableDataSourceReturn,
  UpdateDataSourceOptions,
  TableTransitionState,
} from '@mezzanine-ui/ng/table';
```

### UseTableDataSourceOptions

| Field               | Type            | Default | Description                                      |
| ------------------- | --------------- | ------- | ------------------------------------------------ |
| `initialData`       | `readonly T[]`  | `[]`    | Starting data array                              |
| `highlightDuration` | `number`        | `700`   | ms for the add/delete highlight animation        |
| `fadeOutDuration`   | `number`        | `150`   | ms for the fade-out animation before row removal |

### UseTableDataSourceReturn

| Field               | Type                                                                               | Description                                              |
| ------------------- | ---------------------------------------------------------------------------------- | -------------------------------------------------------- |
| `dataSource`        | `Signal<readonly T[]>`                                                             | Bind to `[dataSource]` on the table                      |
| `transitionState`   | `Signal<TableTransitionState>`                                                     | Bind to `[transitionState]` on the table                 |
| `updateDataSource`  | `(data: readonly T[], options?: UpdateDataSourceOptions) => void`                  | Call to update data with optional add/remove animations  |

### UpdateDataSourceOptions

| Field         | Type                    | Description                                                        |
| ------------- | ----------------------- | ------------------------------------------------------------------ |
| `addedKeys`   | `readonly string[]`     | Keys of rows to animate as newly added (highlight effect)          |
| `removedKeys` | `readonly string[]`     | Keys of rows to animate as removed (highlight then fade-out)       |

```ts
class MyComponent {
  private readonly ds = useTableDataSource<Row>({ initialData: initialRows });

  readonly dataSource = this.ds.dataSource;
  readonly transitionState = this.ds.transitionState;

  onCreate(row: Row): void {
    this.ds.updateDataSource([row, ...this.dataSource()], { addedKeys: [row.key] });
  }

  onDelete(key: string): void {
    this.ds.updateDataSource(
      this.dataSource().filter((r) => r.key !== key),
      { removedKeys: [key] },
    );
  }
}
```

```html
<div mznTable
  [columns]="columns"
  [dataSource]="dataSource()"
  [transitionState]="transitionState()"
></div>
```

## Resizable Columns

Enable with `[resizable]="true"`. Each resizable column **must** specify `minWidth`.

```html
<div mznTable [columns]="columns" [dataSource]="rows" [resizable]="true"></div>
```

## Usage

```html
<!-- Basic table -->
<div mznTable [columns]="columns" [dataSource]="rows" [loading]="loading"></div>

<!-- With row selection and pagination -->
<div mznTable
  [columns]="columns"
  [dataSource]="rows"
  [rowSelection]="rowSelection"
  [pagination]="pagination"
></div>

<!-- With expandable rows -->
<ng-template #expandTpl let-record>
  <div class="p-4"><p>{{ record.detail }}</p></div>
</ng-template>

<div mznTable
  [columns]="columns"
  [dataSource]="rows"
  [expandable]="{ template: expandTpl, expandedRowKeys: openKeys, onExpand: onExpand }"
></div>

<!-- With action column -->
<div mznTable [columns]="columns" [dataSource]="rows" [actions]="actions"></div>
```

```ts
import { MznTable } from '@mezzanine-ui/ng/table';
import type {
  TableColumn,
  TableDataSource,
  TableRowSelectionCheckbox,
  TablePagination,
  TableActions,
  SortOrder,
} from '@mezzanine-ui/ng/table';

readonly columns: readonly TableColumn[] = [
  { key: 'name', title: '名稱', dataIndex: 'name', width: 200 },
  { key: 'email', title: '電子郵件', dataIndex: 'email' },
];

readonly rowSelection: TableRowSelectionCheckbox = {
  mode: 'checkbox',        // use mode, not type
  selectedRowKeys: this.selected,
  onChange: (keys) => { this.selected = [...keys]; },
};

readonly pagination: TablePagination = {
  total: 200,
  current: 1,
  pageSize: 20,
  onChange: (page) => { this.page = page; },
};

readonly actions: TableActions = {
  render: (record, index) => [
    { key: 'edit', label: '編輯', onClick: (r) => this.edit(r) },
    { key: 'delete', label: '刪除', variant: 'destructive-text-link', onClick: (r) => this.delete(r) },
  ],
};
```

## Notes

- `TableScroll` only has a `y` field (max-height). There is no `x` field — horizontal scrolling is not controlled via `scroll`.
- `HighlightMode` values are `'cell' | 'column' | 'row' | 'cross'`. There is no `'none'` mode.
- `rowSelection` uses `mode` field (not `type`) to distinguish `'checkbox'` from `'radio'`. The input type is `TableRowSelection | boolean` — `false` disables selection entirely.
- Data records should have `key` or `id` fields. `getRowKey(record)` is exported and returns `record.key ?? record.id ?? ''`.
- `TableExpandable.template` uses `$implicit` binding — declare `let-record` in your `ng-template`.
- `draggable.fixedRowKeys` pins specific rows to prevent reordering (e.g., totals rows).
- `actions.render` receives `(record, index)` and must return `readonly TableActionItem[]`.
