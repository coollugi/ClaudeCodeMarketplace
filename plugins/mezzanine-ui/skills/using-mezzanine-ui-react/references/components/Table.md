# Table Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Table`
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Table)  · Verified 1.5.1 (2026-09-12)

High-performance data table component supporting virtual scrolling, column resizing, fixed columns, row selection, sorting, expandable rows, drag-and-drop reordering, pinning, toggleable columns, collectable columns, and more.

> **v1.1.0 SSR fix**: Row height is now read via `useIsomorphicLayoutEffect` instead of `useMemo`, so the first render is deterministic across server and client. Next.js / Remix consumers no longer see React hydration mismatch warnings caused by `getComputedStyle` returning `0` on the server. No public API change.

## Import

```tsx
import {
  Table,
  useTableDataSource,
  useTableRowSelection,
} from '@mezzanine-ui/react';
import type {
  TableProps,
  TableColumn,
  TableDataSource,
  TableRowSelection,
  TableExpandable,
  TableDraggable,
  TableToggleable,
  TableCollectable,
  TableActions,
  TableScroll,
} from '@mezzanine-ui/react';
```

> Note: The following types are re-exported from `@mezzanine-ui/core/table` and available from `@mezzanine-ui/react`:
> `getCellAlignClass`, `getRowKey`, `ColumnAlign`, `FixedType`, `HighlightMode`, `SortOrder`, `TableRowState`, `TableSize`, `TableBulkActions`, `TableColumnTitleMenu`, etc.
> `TABLE_ACTIONS_KEY` is only available from the `@mezzanine-ui/react/Table` sub-path.
> `TablePinnable` must be imported from `@mezzanine-ui/core/table` or `@mezzanine-ui/react/Table`.

---

## Table Props

`TableProps<T>` is a union type with multiple variants based on `resizable` and `scroll.virtualized` configuration:

- **resizable mode**: `columns` must use `TableColumnWithMinWidth<T>[]` (each column requires `minWidth`), `actions` must use `TableActionsWithMinWidth<T>`
- **non-resizable mode**: Uses standard `TableColumn<T>[]` and `TableActions<T>`
- **virtualized mode**: Cannot be used together with `draggable`
- **draggable and pinnable are mutually exclusive**: Cannot be enabled simultaneously

### Base Props (TableBaseProps)

| Property                | Type                                        | Default  | Description                |
| ----------------------- | ------------------------------------------- | -------- | -------------------------- |
| `actions`               | `TableActions<T>` / `TableActionsWithMinWidth<T>` | -  | Actions column config      |
| `columns`               | `TableColumn<T>[]` / `TableColumnWithMinWidth<T>[]` | - | Required, column definitions |
| `dataSource`            | `T[]`                                       | -        | Required, data source      |
| `draggable`             | `TableDraggable<T>`                         | -        | Drag config (mutually exclusive with pinnable) |
| `emptyProps`            | `EmptyProps & { height?: number \| string }`| -        | Empty state config         |
| `expandable`            | `TableExpandable<T>`                        | -        | Expandable row config      |
| `fullWidth`             | `boolean`                                   | `false`  | Whether full width         |
| `highlight`             | `HighlightMode`                             | `'row'`  | Hover highlight mode       |
| `loading`               | `boolean`                                   | `false`  | Loading state              |
| `loadingRowsCount`      | `number`                                    | `10`     | Skeleton rows when loading |
| `minHeight`             | `number \| string`                          | -        | Minimum height             |
| `nested`                | `boolean`                                   | `false`  | Whether nested table       |
| `pagination`            | `TablePaginationProps`                      | -        | Pagination config (same as PaginationProps) |
| `pinnable`              | `TablePinnable<T>`                          | -        | Pin config (mutually exclusive with draggable) |
| `resizable`             | `boolean`                                   | `false`  | Whether columns are resizable |
| `rowHeightPreset`       | `'base' \| 'condensed' \| 'detailed' \| 'roomy'` | `'base'` | Row height preset    |
| `rowSelection`          | `TableRowSelection<T>`                      | -        | Row selection config       |
| `rowState`              | `TableRowState \| ((rowData: T) => TableRowState \| undefined)` | -  | Row-level semantic styling |
| `scroll`                | `TableScroll`                               | -        | Scroll config              |
| `showHeader`            | `boolean`                                   | `true`   | Whether to show header     |
| `size`                  | `'main' \| 'sub'`                           | `'main'` | Table size                 |
| `sticky`                | `boolean`                                   | `true`   | Whether header is sticky   |
| `toggleable`            | `TableToggleable<T>`                        | -        | Toggle column config       |
| `collectable`           | `TableCollectable<T>`                       | -        | Collect column config      |
| `transitionState`       | `TableTransitionState`                      | -        | Transition animation state |
| `zebraStriping`         | `boolean`                                   | -        | Zebra striping             |
| `separatorAtRowIndexes` | `number[]`                                  | -        | Separator row indexes      |

---

## TableColumn Definition

```tsx
interface TableColumnBase<T> {
  key: string;                                  // Required, unique identifier
  title?: ReactNode;                            // Column title
  dataIndex?: string;                           // Data property name
  render?: (record: T, index: number) => ReactNode;  // Custom render
  align?: ColumnAlign;                          // 'start' | 'center' | 'end'
  width?: number;                               // Column width (px)
  minWidth?: number;                            // Minimum column width
  maxWidth?: number;                            // Maximum column width
  fixed?: FixedType;                            // boolean | 'start' | 'end'
  ellipsis?: boolean;                           // Text ellipsis (default true)
  sortOrder?: SortOrder;                        // 'ascend' | 'descend' | null
  onSort?: (key: string, order: SortOrder) => void;  // Sort callback
  titleHelp?: ReactNode;                        // Title help tooltip
  titleMenu?: TableColumnTitleMenu;             // Title dropdown menu
  className?: string;                           // Custom style class
  headerClassName?: string;                     // Header style class
  bodyClassName?: string;                       // Body style class
}
```

> `TableColumn<T>` is a union type requiring either `dataIndex` or `render` (at least one). `TableColumnWithMinWidth<T>` additionally requires `minWidth` (for `resizable` mode).

### TableColumnTitleMenu

```tsx
interface TableColumnTitleMenu {
  options: DropdownOption[];
  onSelect?: (option: DropdownOption) => void;
  maxHeight?: number | string;
  placement?: Placement;
}
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-table--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## TableDataSource Requirements

Data source must include a `key` or `id` property as a unique identifier.

```tsx
interface TableDataSourceWithKey {
  key: string;
  [key: string]: unknown;
}

interface TableDataSourceWithId {
  id: string;
  [key: string]: unknown;
}

type TableDataSource = TableDataSourceWithKey | TableDataSourceWithId;
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-table--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Row Selection (rowSelection)

```tsx
type TableRowSelection<T> = TableRowSelectionCheckbox<T> | TableRowSelectionRadio<T>;
```

### Checkbox Mode

```tsx
interface TableRowSelectionCheckbox<T> {
  mode: 'checkbox';
  selectedRowKeys: string[];
  onChange: (selectedRowKeys: string[], selectedRow: T | null, selectedRows: T[]) => void;
  fixed?: boolean;
  isSelectionDisabled?: (record: T) => boolean;
  getCheckboxProps?: (record: T) => { indeterminate?: boolean; selected?: boolean };
  hideSelectAll?: boolean;
  onSelectAll?: (type: 'all' | 'none') => void;
  preserveSelectedRowKeys?: boolean;
  bulkActions?: TableBulkActions<T>;
}
```

### Radio Mode

```tsx
interface TableRowSelectionRadio<T> {
  mode: 'radio';
  selectedRowKey: string | undefined;
  onChange: (selectedRowKey: string | undefined, selectedRow: T | null) => void;
  fixed?: boolean;
  isSelectionDisabled?: (record: T) => boolean;
}
```

### TableBulkActions

```tsx
interface TableBulkActions<T> {
  mainActions: [TableBulkGeneralAction<T>, ...TableBulkGeneralAction<T>[]];  // At least one
  destructiveAction?: TableBulkGeneralAction<T>;
  overflowAction?: TableBulkOverflowAction<T>;
  renderSelectionSummary?: (count: number, selectedRowKeys: string[], selectedRows: T[]) => string;
}
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-table--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Expandable Rows (expandable)

```tsx
interface TableExpandable<T> {
  expandedRowRender: (record: T) => ReactNode;   // Required
  expandedRowKeys?: string[];
  fixed?: boolean;
  onExpand?: (expanded: boolean, record: T) => void;
  onExpandedRowsChange?: (expandedRowKeys: string[]) => void;
  rowExpandable?: (record: T) => boolean;
}
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-table--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Actions Column (actions)

```tsx
interface TableActionsBase<T> {
  align?: ColumnAlign;                           // Default 'end'
  render: (record: T, index: number) => TableActionItem<T>[];  // Required
  variant?: ButtonVariant;
  className?: string;
  headerClassName?: string;
  fixed?: FixedType;
  maxWidth?: number;
  minWidth?: number;
  title?: ReactNode;
  titleHelp?: ReactNode;
  titleMenu?: TableColumnTitleMenu;
  width?: number;
}

type TableActionItem<T> = TableActionItemButton<T> | TableActionItemDropdown<T>;
```

### TableActionItemButton

```tsx
interface TableActionItemButton<T> {
  type?: 'button';
  name?: string;
  icon?: IconDefinition;
  iconType?: ButtonIconType;
  onClick: (record: T, index: number) => void;
  disabled?: (record: T) => boolean;
  variant?: ButtonVariant;
}
```

### TableActionItemDropdown

```tsx
interface TableActionItemDropdown<T> {
  type: 'dropdown';
  name?: string;
  icon?: IconDefinition;                         // Default DotHorizontalIcon
  iconType?: ButtonIconType;
  options: DropdownOption[];
  onSelect: (option: DropdownOption, record: T, index: number) => void;
  disabled?: (record: T) => boolean;
  variant?: ButtonVariant;
  maxHeight?: number | string;
  placement?: Placement;                         // Default 'bottom-end'
}
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-table--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Scroll Config (scroll)

```tsx
interface TableScroll {
  virtualized?: boolean;                         // Default false
  y?: number | string;
}
```

> Cannot use `draggable` when `virtualized` is enabled.

---

## Drag and Drop (draggable)

```tsx
interface TableDraggable<T> {
  enabled: boolean;
  fixed?: boolean;
  onDragEnd?: (newDataSource: T[], options: {
    draggingId: string;
    fromIndex: number;
    toIndex: number;
  }) => void;
}
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-table--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Pinning (pinnable)

```tsx
interface TablePinnable<T> {
  enabled: boolean;
  fixed?: boolean;
  onPinChange: (record: T, pinned: boolean) => void;
  pinnedRowKeys: string[];
}
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-table--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Toggle Column (toggleable)

```tsx
interface TableToggleable<T> {
  enabled: boolean;
  fixed?: boolean;
  isRowDisabled?: (record: T) => boolean;
  onToggleChange: (record: T, toggled: boolean) => void;
  toggledRowKeys: string[];
  title?: ReactNode;
  titleHelp?: ReactNode;
  titleMenu?: TableColumnTitleMenu;
  minWidth?: number;
  align?: ColumnAlign;
}
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-table--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Collect Column (collectable)

```tsx
interface TableCollectable<T> {
  enabled: boolean;
  collectedRowKeys: string[];
  fixed?: boolean;
  isRowDisabled?: (record: T) => boolean;
  onCollectChange: (record: T, collected: boolean) => void;
  title?: ReactNode;
  titleHelp?: ReactNode;
  titleMenu?: TableColumnTitleMenu;
  minWidth?: number;
  align?: ColumnAlign;
}
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-table--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Row Height Presets

| Preset      | Main Size    | Sub Size  |
| ----------- | ------------ | --------- |
| `condensed` | Most compact | reduced   |
| `base`      | Standard     | minimal   |
| `detailed`  | Spacious     | tightened |
| `roomy`     | Most spacious| medium    |

---

## Highlight Modes

| Mode     | Description                |
| -------- | -------------------------- |
| `row`    | Highlight entire row (default) |
| `cell`   | Highlight single cell only |
| `column` | Highlight entire column    |
| `cross`  | Cross highlight            |

---

## Hooks

### useTableDataSource

Manages table data and transition animation state.

```tsx
const { dataSource, transitionState, updateDataSource } = useTableDataSource<T>(options);
```

#### UseTableDataSourceOptions

| Property            | Type     | Default | Description                    |
| ------------------- | -------- | ------- | ------------------------------ |
| `initialData`       | `T[]`    | `[]`    | Initial data source            |
| `highlightDuration` | `number` | `1000`  | Highlight animation duration (ms) |
| `fadeOutDuration`   | `number` | `200`   | Fade-out animation duration (ms) |

#### Return Value

| Property           | Type                                                         | Description          |
| ------------------ | ------------------------------------------------------------ | -------------------- |
| `dataSource`       | `T[]`                                                        | Current data source  |
| `transitionState`  | `TableTransitionState`                                       | Animation state      |
| `updateDataSource` | `(data: T[], options?: UpdateDataSourceOptions) => void`     | Update data method   |

#### UpdateDataSourceOptions

| Property      | Type       | Description                    |
| ------------- | ---------- | ------------------------------ |
| `addedKeys`   | `string[]` | Keys of added items (triggers animation) |
| `removedKeys` | `string[]` | Keys of removed items (triggers animation) |

#### TableTransitionState

| Property       | Type          | Description                |
| -------------- | ------------- | -------------------------- |
| `addingKeys`   | `Set<string>` | Keys in add animation      |
| `deletingKeys` | `Set<string>` | Keys in delete animation   |
| `fadingOutKeys`| `Set<string>` | Keys in fade-out animation |

---

### useTableRowSelection

For parent-child table row selection management, exported from the `@mezzanine-ui/react` main entry.

```tsx
import { useTableRowSelection } from '@mezzanine-ui/react';

const {
  parentSelectedKeys,
  parentOnChange,
  parentGetCheckboxProps,
  getChildOnChange,
  getChildSelectedRowKeys,
  totalSelectionCount,
} = useTableRowSelection<T>({ getSubData });
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-table--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

### Internal Hooks (usually not used directly)

The following hooks are used internally by Table and available via the `@mezzanine-ui/react/Table` sub-path, but not directly exported from the main entry:

| Hook                      | Purpose                  | Parameters                              |
| ------------------------- | ------------------------ | --------------------------------------- |
| `useTableSelection`       | Row selection state      | `UseTableSelectionOptions<T>`           |
| `useTableSorting`         | Column sorting logic     | `UseTableSortingOptions<T>`             |
| `useTableExpansion`       | Row expansion logic      | `UseTableExpansionOptions<T>`           |
| `useTableResizedColumns`  | Column resize state      | None                                    |
| `useTableScroll`          | Scroll state management  | `{ enabled: boolean }`                  |
| `useTableVirtualization`  | Virtual scrolling        | `UseTableVirtualizationOptions`         |
| `useTableFixedOffsets`    | Fixed column offsets     | `UseTableFixedOffsetsOptions`           |

---

## Sub-components

Table internally exports multiple sub-components, usually not needed directly:

`TableBody`, `TableCell`, `TableColGroup`, `TableHeader`, `TableRow`, `TablePagination`, `TableActionsCell`, `TableDragOrPinHandleCell`, `TableExpandCell`, `TableExpandedRow`, `TableResizeHandle`, `TableSelectionCell`, `TableToggleableCell`, `TableCollectableCell`

---

## Usage Examples

### Basic Table

```tsx
import { Table } from '@mezzanine-ui/react';

const columns = [
  { key: 'name', title: 'Name', dataIndex: 'name' },
  { key: 'age', title: 'Age', dataIndex: 'age' },
  { key: 'email', title: 'Email', dataIndex: 'email' },
];

const data = [
  { key: '1', name: 'John', age: 32, email: 'john@example.com' },
  { key: '2', name: 'Jane', age: 28, email: 'jane@example.com' },
];

<Table columns={columns} dataSource={data} />
```

### With Row Selection

```tsx
function SelectableTable() {
  const [selectedKeys, setSelectedKeys] = useState<string[]>([]);

  return (
    <Table
      columns={columns}
      dataSource={data}
      rowSelection={{
        mode: 'checkbox',
        selectedRowKeys: selectedKeys,
        onChange: (keys) => setSelectedKeys(keys),
      }}
    />
  );
}
```

### With Sorting

```tsx
function SortableTable() {
  const [sortOrder, setSortOrder] = useState<SortOrder>(null);

  const columns = [
    {
      key: 'name',
      title: 'Name',
      dataIndex: 'name',
      sortOrder,
      onSort: (key, order) => setSortOrder(order),
    },
  ];

  return <Table columns={columns} dataSource={sortedData} />;
}
```

### With Expandable Rows

```tsx
<Table
  columns={columns}
  dataSource={data}
  expandable={{
    expandedRowRender: (record) => <div>{record.description}</div>,
    rowExpandable: (record) => record.hasDetails,
  }}
/>
```

### With Actions Column

```tsx
<Table
  columns={columns}
  dataSource={data}
  actions={{
    title: 'Actions',
    width: 120,
    render: (record) => [
      {
        name: 'Edit',
        icon: EditIcon,
        onClick: () => handleEdit(record),
      },
      {
        type: 'dropdown',
        icon: DotHorizontalIcon,
        options: [
          { id: 'delete', name: 'Delete' },
        ],
        onSelect: (opt) => handleAction(opt, record),
      },
    ],
  }}
/>
```

### Virtual Scrolling

```tsx
<Table
  columns={columns}
  dataSource={largeData}
  scroll={{
    y: 400,
    virtualized: true,
  }}
/>
```

### Fixed Columns

```tsx
const columns = [
  { key: 'name', title: 'Name', dataIndex: 'name', fixed: 'start', width: 150 },
  { key: 'col1', title: 'Column 1', dataIndex: 'col1' },
  { key: 'col2', title: 'Column 2', dataIndex: 'col2' },
  { key: 'actions', title: 'Actions', fixed: 'end', width: 100 },
];
```

### Using useTableDataSource

```tsx
import { Table, useTableDataSource } from '@mezzanine-ui/react';

function AnimatedTable() {
  const { dataSource, transitionState, updateDataSource } = useTableDataSource({
    initialData: initialRows,
    highlightDuration: 1500,
  });

  const handleAdd = (newRow) => {
    updateDataSource([...dataSource, newRow], {
      addedKeys: [newRow.key],
    });
  };

  const handleRemove = (key: string) => {
    updateDataSource(
      dataSource.filter((row) => row.key !== key),
      { removedKeys: [key] },
    );
  };

  return (
    <Table
      columns={columns}
      dataSource={dataSource}
      transitionState={transitionState}
    />
  );
}
```

### With Row State

```tsx
<Table<DataType>
  columns={columns}
  dataSource={data}
  rowState={(record) => {
    if (record.age >= 42) return 'deleted';
    if (record.age >= 33) return 'disabled';
    if (record.age < 25) return 'added';

    return undefined;
  }}
/>
```

> `TableRowState` type: `'added' | 'deleted' | 'disabled'`. Applies semantic background color styling per row. Accepts a static state string or a function receiving the row data.

### With Bulk Actions

```tsx
<Table
  columns={columns}
  dataSource={data}
  rowSelection={{
    mode: 'checkbox',
    selectedRowKeys,
    onChange: (keys) => setSelectedRowKeys(keys),
    bulkActions: {
      mainActions: [
        { label: 'Export', onClick: (keys, rows) => handleExport(rows) },
      ],
      destructiveAction: {
        label: 'Batch Delete',
        onClick: (keys) => handleBatchDelete(keys),
      },
      renderSelectionSummary: (count) => `${count} selected`,
    },
  }}
/>
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-table--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Figma Mapping

| Figma Variant             | React Props                  |
| ------------------------- | ---------------------------- |
| `Table / Main`            | `<Table size="main">`        |
| `Table / Sub`             | `<Table size="sub">`         |
| `Table / With Selection`  | `<Table rowSelection={...}>` |
| `Table / With Expandable` | `<Table expandable={...}>`   |
| `Table / With Actions`    | `<Table actions={...}>`      |
| `Table / Loading`         | `<Table loading>`            |
| `Table / Zebra`           | `<Table zebraStriping>`      |

---

## Behavior Notes

- **Row-action accessible names (1.5.0+)**: for an action rendered `iconType="icon-only"`, `TableActionItemButton['name']` is used as the button's `aria-label` (icon-only buttons otherwise render with no visible text, so without this the button had no accessible name). For `TableActionItemDropdown`, `name` is always applied as the trigger button's `aria-label`, since the dropdown trigger is icon-only by default (`DotHorizontalIcon`).
- **Row-action dropdown menu stays inside the viewport (1.5.0+)**: the internal `Dropdown` used to render a `type: 'dropdown'` action item now sets `shift` in addition to the existing `flip`/`placement`. Row actions sit in the table's last column, so the menu routinely opens against the right edge of the viewport; `flip` only swaps sides along the main axis, so without `shift` the menu could still be clipped. No props changed — this is internal to `TableActionsCell`.

---

## Best Practices

1. **Provide unique key**: Each data record must have `key` or `id`
2. **Set column widths**: Explicitly set `width` or `minWidth` for stable layout
3. **Virtual scrolling for large datasets**: Enable `scroll.virtualized`
4. **Fix important columns**: Use `fixed` for key columns
5. **Use ellipsis appropriately**: Long text columns enable ellipsis with tooltip (default true)
6. **resizable mode requires minWidth**: All columns and actions need `minWidth`
7. **draggable and pinnable are mutually exclusive**: Cannot enable both simultaneously
8. **virtualized does not support draggable**: Drag-and-drop is not available in virtual scrolling mode
