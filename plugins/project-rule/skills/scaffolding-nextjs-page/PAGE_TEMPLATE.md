# Page Component and Table Template

## Page Layout Contract (read before writing page.tsx)

Mezzanine's `PageHeader` / `PageFooter` ship their **own** horizontal padding (`--mzn-spacing-padding-horizontal-spacious`, 16px) while `Layout.Main` ships none. Every page therefore uses the same three-layer structure — written out explicitly in each page, no wrapper component:

1. `.page` root — **zero** horizontal padding, only `display: flex` + `row-gap`
2. `PageHeader` / `PageFooter` — direct children of `.page`, flush to the edges
3. `.content` — the only element carrying `padding-inline`, matching PageHeader's value

Putting padding on `.page`, or nesting `PageHeader` / `PageFooter` inside `.content`, is the single most common layout bug — the header double-indents and the footer's `border-top` stops short on both sides.

> Full rationale, padding table and anti-patterns: `using-mezzanine-ui-react` skill → **Page Layout Skeleton (必讀 — 版面 padding 契約)**.

## Page Component Template

```tsx
'use client';

import { useCallback, useState, type ReactNode } from 'react';
import Button from '@mezzanine-ui/react/Button';
import Message from '@mezzanine-ui/react/Message';
import PageHeader from '@mezzanine-ui/react/PageHeader';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';
import { PlusIcon } from '@mezzanine-ui/icons';
import {
  useGet{Entities}Query,
  useCreate{Entity}Mutation,
  useUpdate{Entity}Mutation,
  useDelete{Entity}Mutation,
} from '@/graphql/generated/graphql';
import type { Get{Entities}Query } from '@/graphql/generated/graphql';
import styles from './page.module.scss';
import { {Entity}Table } from './_components/{Entity}Table';
import { {Entity}FormModal } from './_components/{Entity}FormModal';
import { Delete{Entity}Dialog } from './_components/Delete{Entity}Dialog';

const PAGE_SIZE = 15;

type {Entity} = Get{Entities}Query['{entities}'][number];
// Or use NonNullable:
// type {Entity} = NonNullable<Get{Entities}Query['{entities}']>[number];

export default function {Entities}Page(): ReactNode {
  // --- Query & Mutation hooks ---
  const { data, loading, refetch } = useGet{Entities}Query({
    variables: { offset: 0, limit: PAGE_SIZE },
    notifyOnNetworkStatusChange: true,
  });

  const [create{Entity}, { loading: creating }] = useCreate{Entity}Mutation();
  const [update{Entity}, { loading: updating }] = useUpdate{Entity}Mutation();
  const [delete{Entity}, { loading: deleting }] = useDelete{Entity}Mutation();

  // --- UI State ---
  const [page, setPage] = useState(1);
  const [formModalOpen, setFormModalOpen] = useState(false);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [selected{Entity}, setSelected{Entity}] = useState<{Entity} | null>(null);

  // --- Handlers ---
  const handleOpenCreate = useCallback((): void => {
    setSelected{Entity}(null);
    setFormModalOpen(true);
  }, []);

  const handleOpenEdit = useCallback(({entity}: {Entity}): void => {
    setSelected{Entity}({entity});
    setFormModalOpen(true);
  }, []);

  const handleOpenDelete = useCallback(({entity}: {Entity}): void => {
    setSelected{Entity}({entity});
    setDeleteDialogOpen(true);
  }, []);

  const handleCloseFormModal = useCallback((): void => {
    setFormModalOpen(false);
    setSelected{Entity}(null);
  }, []);

  const handleCloseDeleteDialog = useCallback((): void => {
    setDeleteDialogOpen(false);
    setSelected{Entity}(null);
  }, []);

  const handleSubmitForm = useCallback(
    async (formData: {Entity}FormData): Promise<void> => {
      try {
        if (selected{Entity}) {
          await update{Entity}({
            variables: { id: selected{Entity}.id, ...formData },
          });
          Message.success('{entityLabel} updated successfully');
        } else {
          await create{Entity}({
            variables: formData,
          });
          Message.success('{entityLabel} created successfully');
        }
        await refetch();
        handleCloseFormModal();
      } catch {
        Message.error(selected{Entity} ? 'Update failed, please try again' : 'Creation failed, please try again');
      }
    },
    [selected{Entity}, create{Entity}, update{Entity}, refetch, handleCloseFormModal],
  );

  const handleConfirmDelete = useCallback(async (): Promise<void> => {
    if (!selected{Entity}) return;
    try {
      await delete{Entity}({
        variables: { id: selected{Entity}.id },
      });
      Message.success('{entityLabel} deleted successfully');
      await refetch();
      handleCloseDeleteDialog();
    } catch {
      Message.error('Deletion failed, please try again');
    }
  }, [selected{Entity}, delete{Entity}, refetch, handleCloseDeleteDialog]);

  const handlePageChange = useCallback((newPage: number): void => {
    setPage(newPage);
  }, []);

  // --- Data destructuring ---
  const items = data?.{entities}?.items ?? [];
  const total = data?.{entities}?.total ?? 0;

  return (
    // Layer 1: page root — no horizontal padding, only vertical rhythm
    <div className={styles.page}>
      {/* Layer 2a: PageHeader is a direct child, flush to the edges */}
      <PageHeader>
        <ContentHeader title="{pageTitle}">
          <Button icon={PlusIcon} iconType="leading" onClick={handleOpenCreate}>
            Create {entityLabel}
          </Button>
        </ContentHeader>
      </PageHeader>

      {/* Layer 2b: the only element carrying the horizontal gutter */}
      <main className={styles.content}>
        <{Entity}Table
          items={items}
          loading={loading}
          currentPage={page}
          pageSize={PAGE_SIZE}
          total={total}
          onPageChange={handlePageChange}
          onEdit={handleOpenEdit}
          onDelete={handleOpenDelete}
        />
      </main>

      <{Entity}FormModal
        open={formModalOpen}
        {entity}={selected{Entity}}
        loading={creating || updating}
        onClose={handleCloseFormModal}
        onSubmit={handleSubmitForm}
      />

      <Delete{Entity}Dialog
        open={deleteDialogOpen}
        {entity}={selected{Entity}}
        loading={deleting}
        onClose={handleCloseDeleteDialog}
        onConfirm={handleConfirmDelete}
      />
    </div>
  );
}
```

> Modals and dialogs render through a portal, so their JSX position is irrelevant — keeping them as siblings of `<main>` avoids implying they are page content.

## SCSS Module Template

### page.module.scss

```scss
.page {
  display: flex;
  flex-direction: column;
  // ❌ never add padding / padding-inline here — PageHeader already ships 16px
  // horizontal padding, adding it again double-indents the header
  row-gap: var(--mzn-spacing-gap-calm);
  width: 100%;
  height: 100%;
}

.content {
  // ✅ the only element carrying the horizontal gutter — same token as PageHeader
  padding-inline: var(--mzn-spacing-padding-horizontal-spacious);
  padding-block-end: var(--mzn-spacing-padding-vertical-spacious);
  display: flex;
  flex-direction: column;
  row-gap: var(--mzn-spacing-gap-calm);
  flex: 1;
  min-height: 0;
  overflow-y: auto;
}
```

Filters, tabs and Sections are plain children of `.content` — they inherit the gutter and the `row-gap`, so no extra grid template or per-element padding is needed. If a `PageFooter` is used, put it **after** `</main>` as a sibling, never inside `.content`.

## Table Component Template

```tsx
'use client';

import { useMemo, type ReactNode } from 'react';
import dayjs from 'dayjs';
import Table from '@mezzanine-ui/react/Table';
import type { TableColumn } from '@mezzanine-ui/react/Table';
import { EditIcon, TrashIcon } from '@mezzanine-ui/icons';
import type { Get{Entities}Query } from '@/graphql/generated/graphql';
import styles from './{entity}-table.module.scss';

type {Entity} = Get{Entities}Query['{entities}'][number];

interface {Entity}TableData {
  readonly id: string;
  readonly name: string;
  readonly createdAt: string;
  // ... other fields
  readonly [key: string]: string;
}

interface {Entity}TableProps {
  readonly items: readonly {Entity}[];
  readonly loading: boolean;
  readonly currentPage: number;
  readonly pageSize: number;
  readonly total: number;
  readonly onPageChange: (page: number) => void;
  readonly onEdit: ({entity}: {Entity}) => void;
  readonly onDelete: ({entity}: {Entity}) => void;
}

export function {Entity}Table({
  items,
  loading,
  currentPage,
  pageSize,
  total,
  onPageChange,
  onEdit,
  onDelete,
}: {Entity}TableProps): ReactNode {
  const dataSource = useMemo<{Entity}TableData[]>(
    () =>
      items.map(item => ({
        id: item.id,
        name: item.name,
        createdAt: dayjs(item.createdAt as string).format('YYYY-MM-DD'),
        // ... other field transformations
      })),
    [items],
  );

  const columns: TableColumn<{Entity}TableData>[] = useMemo(
    () => [
      {
        key: 'name',
        dataIndex: 'name',
        title: 'Name',
        width: 300,
      },
      {
        key: 'createdAt',
        dataIndex: 'createdAt',
        title: 'Created At',
        width: 150,
      },
      // ... other columns
    ],
    [],
  );

  return (
    <div className={styles.tableWrapper}>
      <Table<{Entity}TableData>
        columns={columns}
        dataSource={dataSource}
        loading={loading}
        fullWidth
        highlight="row"
        emptyProps={{
          type: 'initial-data',
          title: 'No data',
          description: 'Click the button above to add data',
        }}
        actions={{
          title: 'Actions',
          width: 120,
          fixed: 'end',
          render: record => {
            const item = items.find(i => i.id === record.id);
            if (!item) return [];
            return [
              {
                name: 'Edit',
                icon: EditIcon,
                iconType: 'leading' as const,
                variant: 'base-secondary' as const,
                onClick: () => { onEdit(item); },
              },
              {
                name: 'Delete',
                icon: TrashIcon,
                iconType: 'leading' as const,
                variant: 'destructive-secondary' as const,
                onClick: () => { onDelete(item); },
              },
            ];
          },
        }}
        pagination={{
          current: currentPage,
          pageSize,
          total,
          onChange: onPageChange,
        }}
      />
    </div>
  );
}
```

### {entity}-table.module.scss

```scss
.tableWrapper {
  flex: 1;
  overflow: hidden;
}
```

## Key Patterns

### Data Transformation

The Table's `dataSource` MUST use `useMemo` to flatten raw GraphQL data into plain objects. Avoid complex computations inside `columns`.

### Enum Label Mapping

For enum fields, create a constant mapping:

```tsx
const STATUS_LABELS: Record<EntityStatus, string> = {
  [EntityStatus.Active]: 'Active',
  [EntityStatus.Inactive]: 'Inactive',
};
```

### Dynamic Table Loading

If SSR hydration issues occur, use `next/dynamic`:

```tsx
const Table = dynamic(() => import('@mezzanine-ui/react/Table'), {
  ssr: false,
});
```

### index.ts Re-export

Each component folder re-exports via `index.ts`:

```tsx
export { {Entity}Table } from './{Entity}Table';
```
