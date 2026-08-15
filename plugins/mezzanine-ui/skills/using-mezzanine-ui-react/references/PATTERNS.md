# Mezzanine-UI Common Usage Patterns

Common UI pattern implementation examples.

> Baseline: `@mezzanine-ui/react` `1.4.1` · `@mezzanine-ui/core` `1.1.0` · `@mezzanine-ui/system` / `@mezzanine-ui/icons` `1.0.2`. Last verified: 2026-07-01.

## Table of Contents

- [Layout Patterns](#layout-patterns)
- [Form Patterns](#form-patterns)
- [Table Patterns](#table-patterns)
- [Dialog Patterns](#dialog-patterns)
- [Navigation Patterns](#navigation-patterns)
- [Positioning Patterns](#positioning-patterns)
- [Loading States](#loading-states)
- [Error Handling](#error-handling)
- [Notifications](#notifications)

---

## Layout Patterns

### Page Body Alignment with PageHeader (重要 — 容易忽略)

`PageHeader` 內建水平/垂直 padding（CSS 為 `padding: spacious spacious 0`，對應 `--mzn-spacing-padding-horizontal-spacious`，預設 16px / compact 14px）。因此頁面骨架要遵循以下四條規則，否則會出現「PageHeader 比下方內容還要內縮」或「下方內容貼齊邊緣但 PageHeader 多了 16px」這類視覺錯位：

1. **頁面最外層 container 不可加水平 padding** — 讓 `PageHeader` 自己貼齊版面邊緣，padding 由元件內建提供。
2. **`PageHeader` / `PageFooter` 直接掛在最外層 column** — `PageFooter` 同樣自帶 padding（`vertical-base horizontal-spacious`，預設 8px / 16px）並帶 `border-top` 與底色，必須滿版，不可放進有 padding 的 wrapper。
3. **下方主要內容必須包一層 wrapper，套用與 PageHeader 相同的水平 padding** — 通常是 `padding-inline: var(--mzn-spacing-padding-horizontal-spacious)`，讓內容文字左緣對齊 PageHeader 的標題文字。
4. **垂直間距靠 container 的 `row-gap`** — `PageHeader` 的 `padding-bottom` 刻意為 `0`，區塊分隔由 container 分配（建議 `var(--mzn-spacing-gap-calm)`）；不要對 `PageHeader` 補 `margin-bottom`。

> 內容若使用 `Section`：**外側 gutter 仍要靠 body wrapper 的 `padding-inline`**（`Section` 沒有 margin，直接掛在無 padding 的 page container 下會貼齊版面邊緣）；`Section` 自帶的 `vertical-spacious horizontal-spacious`（16px）是**卡片內側**的 padding，因此不要再對 `Section` 本身或它的直接子元素補 padding。最終對齊：卡片左緣 = PageHeader 標題文字左緣（16px），卡片內容再內縮 16px。

| 元件                     | 生效條件                                     | host padding                                                             | default       | compact       |
| ------------------------ | -------------------------------------------- | ------------------------------------------------------------------------ | ------------- | ------------- |
| `PageHeader`             | 無條件                                       | `vertical-spacious horizontal-spacious 0`                                | `16 / 16 / 0` | `12 / 14 / 0` |
| `PageFooter`             | 無條件                                       | `vertical-base horizontal-spacious`                                      | `8 / 16`      | `4 / 14`      |
| `FilterArea`             | `size="main"`（預設）                        | `padding-inline: horizontal-spacious` + `padding-top: vertical-spacious` | `16 / top 16` | `14 / top 12` |
| `Tab`                    | `size="main"`（預設）+ horizontal            | `vertical-spacious horizontal-spacious 0`                                | `16 / 16 / 0` | `12 / 14 / 0` |
| `Tab`                    | `size="main"` + vertical                     | `0 0 0 horizontal-spacious`                                              | `left 16`     | `left 14`     |
| `Section`                | 無條件（**卡片**，需外層 wrapper 給 gutter） | `vertical-spacious horizontal-spacious`                                  | `16 / 16`     | `12 / 14`     |
| `Layout` / `Layout.Main` | —                                            | 無                                                                       | —             | —             |

> **`size="main"` = 頁面級、自帶 gutter、必須貼邊；`size="sub"` = 放在 `Section` 內、無外距。** `FilterArea` 與 `Tab` 的預設值都是 `main`，把它們放進套了 `padding-inline` 的 body wrapper 而沒改成 `sub`，就是 16 + 16 的雙層內縮。`Section` 會自動把 `contentHeader` / `filterArea` 改寫成 `sub`，並把 main size 的 `Tab` padding 歸零。

```tsx
// ContentHeader 已於 1.4.1 從主入口移除，但 PageHeader / Section 仍要求其作為必要子元件，
// 需改由 sub-path 匯入（詳見 references/components/ContentHeader.md 的 REMOVED 說明）
import ContentHeader from '@mezzanine-ui/react/ContentHeader';

// ✅ 正確：外層無 padding，PageHeader 直接貼邊；內容用 wrapper 對齊
function ProductListPage() {
  return (
    <div className={styles.page}>
      <PageHeader>
        <Breadcrumb items={[{ name: 'Home', href: '/' }, { name: 'Products' }]} />
        <ContentHeader title="Product Management" description="管理所有商品">
          <Button>Add Product</Button>
        </ContentHeader>
      </PageHeader>

      <main className={styles.body}>
        <Table columns={columns} dataSource={data} />
        <Pagination {...pagination} />
      </main>

      {/* PageFooter 同樣自帶 padding，與 PageHeader 一樣掛在最外層貼齊版面 */}
      <PageFooter actions={{ primaryButton: { children: 'Save' } }} />
    </div>
  );
}
```

```scss
// page.module.scss
.page {
  // ❌ 不要在這裡加 padding-inline / padding-left / padding-right
  // PageHeader 已內建水平 padding，這裡加會導致 PageHeader 雙重內縮
  display: flex;
  flex-direction: column;
  // ✅ PageHeader 的 padding-bottom 為 0，區塊分隔由這裡的 row-gap 負責
  row-gap: var(--mzn-spacing-gap-calm);
  min-height: 100%;
}

.body {
  // ✅ 對齊 PageHeader 的水平 padding，讓表格 / 卡片左緣對齊標題文字
  padding-inline: var(--mzn-spacing-padding-horizontal-spacious);
  padding-block-end: var(--mzn-spacing-padding-vertical-spacious);
  display: flex;
  flex-direction: column;
  row-gap: var(--mzn-spacing-gap-calm);
  flex: 1;
}
```

```tsx
// ❌ 反例 1：外層加了 padding，讓 PageHeader 雙重內縮
<div style={{ padding: 24 }}>      {/* PageHeader 會被推進 24px + 內建 16px = 40px */}
  <PageHeader>...</PageHeader>
  <Table ... />
</div>

// ❌ 反例 2：外層拿掉 padding 了，但下方內容沒有 wrapper
<div className={styles.page}>
  <PageHeader>...</PageHeader>
  <Table ... />                    {/* 表格貼齊版面，比 PageHeader 標題左緣少 16px */}
</div>

// ❌ 反例 3：PageFooter 被塞進有 padding 的 body wrapper
<div className={styles.page}>
  <PageHeader>...</PageHeader>
  <div className={styles.body}>
    <Table ... />
    <PageFooter ... />             {/* border-top 沒有滿版，兩側各縮 16px */}
  </div>
</div>

// ❌ 反例 4：用 margin 補間距
<PageHeader style={{ marginBottom: 24 }}>...</PageHeader>  {/* 應改用 container row-gap */}
```

> **為什麼這個 pattern 容易被忽略**：`PageHeader` 的 padding 由元件內部 CSS 注入，從 React props / TypeScript 型別上看不出來。代理或開發者不檢查 SCSS 原始碼時，自然會在外層 container 套上一致的 padding，反而造成視覺錯位。**規則的心智模型**：水平 gutter 只有一個來源 — 頁面級元件自帶（`PageHeader` / `PageFooter` / `Section`），其餘內容由 body wrapper 補上同值 `padding-inline`。

### Full Page Layout + Right Panel

> `Layout` 只接受 `Navigation` / `Layout.LeftPanel` / `Layout.Main` / `Layout.RightPanel` 作為**直接子代**（多包一層 `<div>` 會被靜默丟棄）。`Layout.Main` **不提供任何 padding**，頁面骨架的 padding 契約完全由上一節的規則負責。

```tsx
import {
  Layout,
  Navigation,
  NavigationHeader,
  NavigationOption,
  NavigationOptionCategory,
  PageHeader,
  Breadcrumb,
  Button,
  Table,
} from '@mezzanine-ui/react';
import ContentHeader from '@mezzanine-ui/react/ContentHeader';
import { HomeIcon, SettingIcon } from '@mezzanine-ui/icons';
import { useState } from 'react';
import styles from './page.module.scss';

function AppWithRightPanel(): JSX.Element {
  const [rightPanelOpen, setRightPanelOpen] = useState(false);
  const [selectedItem, setSelectedItem] = useState<DataItem | null>(null);

  const handleItemClick = (item: DataItem): void => {
    setSelectedItem(item);
    setRightPanelOpen(true);
  };

  return (
    <Layout>
      <Navigation>
        <NavigationHeader title="Mezzanine" />
        <NavigationOptionCategory title="Main Menu">
          <NavigationOption icon={HomeIcon} title="Home" />
          <NavigationOption icon={SettingIcon} title="Settings" />
        </NavigationOptionCategory>
      </Navigation>

      <Layout.Main>
        {/* page container：無水平 padding，靠 row-gap 分隔區塊 */}
        <div className={styles.page}>
          <PageHeader>
            <Breadcrumb items={[{ name: 'Home', href: '/' }, { name: 'Items' }]} />
            <ContentHeader title="Item List">
              <Button>Add Item</Button>
            </ContentHeader>
          </PageHeader>

          {/* body wrapper：唯一負責水平 gutter 的地方 */}
          <main className={styles.body}>
            <Table
              columns={columns}
              dataSource={data}
              onRow={(record) => ({ onClick: () => handleItemClick(record) })}
            />
          </main>
        </div>
      </Layout.Main>

      <Layout.RightPanel open={rightPanelOpen} defaultWidth={400}>
        {selectedItem && (
          <div className={styles.panel}>
            <h2>{selectedItem.name}</h2>
            <p>{selectedItem.description}</p>
            <Button onClick={() => setRightPanelOpen(false)}>Close</Button>
          </div>
        )}
      </Layout.RightPanel>
    </Layout>
  );
}
```

---

## Form Patterns

### Basic Form

```tsx
import {
  FormField,
  Input,
  Select,
  Button,
} from '@mezzanine-ui/react';

const typeOptions = [
  { id: 'personal', name: 'Personal' },
  { id: 'business', name: 'Business' },
];

function BasicForm() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [type, setType] = useState<{ id: string; name: string } | null>(null);

  const handleSubmit = () => {
    // Handle submission
  };

  return (
    <form onSubmit={handleSubmit}>
      <FormField name="name" label="Name" required>
        <Input
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder="Enter name"
        />
      </FormField>

      <FormField name="email" label="Email" required hintText="We will not disclose your Email">
        <Input
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          placeholder="Enter Email"
        />
      </FormField>

      <FormField name="type" label="Type">
        <Select
          value={type}
          onChange={(value) => setType(value)}
          placeholder="Select type"
          options={typeOptions}
        />
      </FormField>

      <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end' }}>
        <Button variant="base-secondary" onClick={() => {}}>
          Cancel
        </Button>
        <Button variant="base-primary" onClick={handleSubmit}>
          Submit
        </Button>
      </div>
    </form>
  );
}
```

### Form Validation

```tsx
import {
  FormField,
  Input,
} from '@mezzanine-ui/react';
import type { SeverityWithInfo } from '@mezzanine-ui/system/severity';

function FormWithValidation() {
  const [email, setEmail] = useState('');
  const [error, setError] = useState('');

  const validateEmail = (value: string) => {
    if (!value) {
      setError('Email is required');
      return false;
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
      setError('Invalid Email format');
      return false;
    }
    setError('');
    return true;
  };

  const severity: SeverityWithInfo = error ? 'error' : 'info';

  return (
    <FormField name="email" label="Email" required severity={severity} hintText={error || undefined}>
      <Input
        value={email}
        onChange={(e) => {
          setEmail(e.target.value);
          validateEmail(e.target.value);
        }}
        placeholder="Enter Email"
      />
    </FormField>
  );
}
```

### Search Form

```tsx
import { Input, Button } from '@mezzanine-ui/react';

function SearchForm() {
  const [keyword, setKeyword] = useState('');

  const handleSearch = () => {
    // Execute search
  };

  return (
    <div style={{ display: 'flex', gap: 8 }}>
      <Input
        variant="search"
        value={keyword}
        onChange={(e) => setKeyword(e.target.value)}
        placeholder="Search..."
        clearable
      />
      <Button variant="base-primary" onClick={handleSearch}>
        Search
      </Button>
    </div>
  );
}
```

---

## Table Patterns

### Basic Data Table

```tsx
import { Table, Badge, Button, Modal } from '@mezzanine-ui/react';
import { useState } from 'react';

function DataTable() {
  const [deleteTarget, setDeleteTarget] = useState<DataItem | null>(null);

  const handleDeleteConfirm = () => {
    if (deleteTarget) {
      handleDelete(deleteTarget.id);
      setDeleteTarget(null);
    }
  };

  const columns = [
    {
      title: 'Name',
      dataIndex: 'name',
    },
    {
      title: 'Status',
      dataIndex: 'status',
      // 狀態欄用 Badge 的 dot-* + text，不是 Tag —— Tag 沒有語意色，
      // 且表格狀態欄用圓點才不會與同列的 text-link 操作按鈕混淆。
      // 見 references/components/Badge.md → 表格狀態欄用 dot-*
      render: (record: DataItem) => (
        <Badge
          variant={record.status === 'active' ? 'dot-success' : 'dot-inactive'}
          text={record.status === 'active' ? 'Active' : 'Inactive'}
        />
      ),
    },
    {
      title: 'Created At',
      dataIndex: 'createdAt',
      render: (date: string) => new Date(date).toLocaleDateString(),
    },
    {
      title: 'Actions',
      render: (_: unknown, record: DataItem) => (
        <div style={{ display: 'flex', gap: 8 }}>
          <Button
            variant="base-text-link"
            size="minor"
            onClick={() => handleEdit(record)}
          >
            Edit
          </Button>
          <Button
            variant="destructive-text-link"
            size="minor"
            onClick={() => setDeleteTarget(record)}
          >
            Delete
          </Button>
        </div>
      ),
    },
  ];

  const data = [
    { id: '1', name: 'Item 1', status: 'active', createdAt: '2024-01-01' },
    { id: '2', name: 'Item 2', status: 'inactive', createdAt: '2024-01-02' },
  ];

  return (
    <>
      <Table columns={columns} dataSource={data} />
      <Modal
        open={!!deleteTarget}
        onClose={() => setDeleteTarget(null)}
        size="narrow"
        modalType="standard"
        showModalHeader
        title="Confirm Deletion"
        showModalFooter
        confirmText="Delete"
        onConfirm={handleDeleteConfirm}
        cancelText="Cancel"
        onCancel={() => setDeleteTarget(null)}
      >
        Are you sure you want to delete "{deleteTarget?.name}"?
      </Modal>
    </>
  );
}
```

### Selectable Table

```tsx
import { Table, Button } from '@mezzanine-ui/react';
import type { TableRowSelection } from '@mezzanine-ui/react';

function SelectableTable() {
  const [selectedKeys, setSelectedKeys] = useState<string[]>([]);

  const rowSelection: TableRowSelection = {
    selectedRowKeys: selectedKeys,
    onChange: (keys) => setSelectedKeys(keys as string[]),
  };

  const handleBatchDelete = () => {
    // Batch delete selected items
  };

  return (
    <div>
      {selectedKeys.length > 0 && (
        <div style={{ marginBottom: 16 }}>
          <span>{selectedKeys.length} items selected</span>
          <Button
            variant="destructive-secondary"
            size="sub"
            onClick={handleBatchDelete}
          >
            Batch Delete
          </Button>
        </div>
      )}
      <Table
        columns={columns}
        dataSource={data}
        rowSelection={rowSelection}
      />
    </div>
  );
}
```

### Table with Pagination

```tsx
import { Table, Pagination, usePagination } from '@mezzanine-ui/react';

function PaginatedTable() {
  const [data, setData] = useState([]);
  const [total, setTotal] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);

  const pagination = usePagination({
    total,
    pageSize: 10,
    current: currentPage,
    onChange: (page) => {
      setCurrentPage(page);
      fetchData(page, 10);
    },
  });

  useEffect(() => {
    fetchData(1, 10);
  }, []);

  return (
    <div>
      <Table columns={columns} dataSource={data} />
      <div style={{ marginTop: 16, display: 'flex', justifyContent: 'flex-end' }}>
        <Pagination {...pagination} />
      </div>
    </div>
  );
}
```

---

## Dialog Patterns

### Confirmation Dialog

```tsx
import { Modal } from '@mezzanine-ui/react';

function ConfirmModal({ open, onClose, onConfirm }) {
  return (
    <Modal
      open={open}
      onClose={onClose}
      size="narrow"
      modalType="standard"
      showModalHeader
      title="Confirm Deletion"
      showModalFooter
      confirmText="Delete"
      onConfirm={onConfirm}
      cancelText="Cancel"
      onCancel={onClose}
    >
      Are you sure you want to delete this item? This action cannot be undone.
    </Modal>
  );
}
```

### Form Dialog

```tsx
import {
  Modal,
  FormField,
  Input,
} from '@mezzanine-ui/react';

function FormModal({ open, onClose, onSubmit }) {
  const [name, setName] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async () => {
    setLoading(true);
    try {
      await onSubmit({ name });
      onClose();
    } finally {
      setLoading(false);
    }
  };

  return (
    <Modal
      open={open}
      onClose={onClose}
      modalType="standard"
      showModalHeader
      title="Add Item"
      showModalFooter
      confirmText="Confirm"
      onConfirm={handleSubmit}
      cancelText="Cancel"
      onCancel={onClose}
      loading={loading}
    >
      <FormField name="name" label="Name" required>
        <Input
          value={name}
          onChange={(e) => setName(e.target.value)}
          placeholder="Enter name"
        />
      </FormField>
    </Modal>
  );
}
```

### Drawer Detail

```tsx
import {
  Drawer,
  DrawerHeader,
  DrawerBody,
  DrawerFooter,
  Button,
  Description,
  DescriptionGroup,
  DescriptionContent,
} from '@mezzanine-ui/react';

function DetailDrawer({ open, onClose, data }) {
  return (
    <Drawer open={open} onClose={onClose}>
      <DrawerHeader title="Item Details" />
      <DrawerBody>
        <DescriptionGroup>
          <Description title="Name">
            <DescriptionContent>{data?.name}</DescriptionContent>
          </Description>
          <Description title="Status">
            <DescriptionContent>{data?.status}</DescriptionContent>
          </Description>
          <Description title="Created At">
            <DescriptionContent>{data?.createdAt}</DescriptionContent>
          </Description>
        </DescriptionGroup>
      </DrawerBody>
      <DrawerFooter>
        <Button variant="base-secondary" onClick={onClose}>
          Cancel
        </Button>
        <Button variant="base-primary" onClick={() => handleEdit(data)}>
          Edit
        </Button>
      </DrawerFooter>
    </Drawer>
  );
}
```

---

## Navigation Patterns

### Side Navigation

```tsx
import {
  Navigation,
  NavigationHeader,
  NavigationOption,
  NavigationOptionCategory,
  NavigationFooter,
  NavigationUserMenu,
} from '@mezzanine-ui/react';
import { HomeIcon, SettingIcon, FileIcon } from '@mezzanine-ui/icons';

function SideNavigation() {
  const [activeKey, setActiveKey] = useState('home');

  return (
    <Navigation>
      <NavigationHeader>
        <img src="/logo.svg" alt="Logo" />
      </NavigationHeader>

      <NavigationOptionCategory title="Main Menu">
        <NavigationOption
          icon={HomeIcon}
          title="Home"
          active={activeKey === 'home'}
          onTriggerClick={() => setActiveKey('home')}
        />
        <NavigationOption
          icon={FileIcon}
          title="Documents"
          active={activeKey === 'documents'}
          onTriggerClick={() => setActiveKey('documents')}
        />
      </NavigationOptionCategory>

      <NavigationOptionCategory title="Settings">
        <NavigationOption
          icon={SettingIcon}
          title="System Settings"
          active={activeKey === 'settings'}
          onTriggerClick={() => setActiveKey('settings')}
        />
      </NavigationOptionCategory>

      <NavigationFooter>
        <NavigationUserMenu imgSrc="/avatar.png" />
      </NavigationFooter>
    </Navigation>
  );
}
```

### Tab Navigation

```tsx
import { Tab, TabItem } from '@mezzanine-ui/react';
import { Key } from 'react';

function TabNavigation() {
  const [activeKey, setActiveKey] = useState<Key>('overview');

  return (
    <div>
      <Tab activeKey={activeKey} onChange={(key) => setActiveKey(key)}>
        <TabItem key="overview">Overview</TabItem>
        <TabItem key="details">Details</TabItem>
        <TabItem key="history">History</TabItem>
      </Tab>

      {activeKey === 'overview' && <OverviewContent />}
      {activeKey === 'details' && <DetailsContent />}
      {activeKey === 'history' && <HistoryContent />}
    </div>
  );
}
```

---

## Positioning Patterns

### Viewport-aware Flip + Placement Tracking (Dropdown / Select / Popper, v1.2.0 – v1.4.0)

`Dropdown`（v1.2.0+）與 `Select`（v1.4.0+，內部轉發至 `Dropdown`）都提供 opt-in `flip?: boolean` prop（預設 `false`）。啟用後選單在視窗邊緣空間不足時會沿主軸自動翻轉方向，且進場動畫會跟隨翻轉後的實際方向播放。`Popper` 則新增 `onPlacementChange` callback，可用來讀取 floating-ui 解析後的最終 placement（含 middleware 翻轉結果）。

```tsx
import { Select, Dropdown, Popper } from '@mezzanine-ui/react';
import { useState } from 'react';
import type { PopperPlacement } from '@mezzanine-ui/react';

// Select 靠近視窗底部時自動往上翻轉
function BottomAwareSelect() {
  return (
    <Select
      flip
      placeholder="Select type"
      options={typeOptions}
      value={value}
      onChange={setValue}
    />
  );
}

// Dropdown 直接使用 flip，維持 sameWidth 對齊
function FlippableDropdown() {
  return (
    <Dropdown flip sameWidth open={open}>
      {/* DropdownItem ... */}
    </Dropdown>
  );
}

// Popper 監聽翻轉後的實際 placement，動態調整進場動畫方向
function PlacementAwarePopper() {
  const [placement, setPlacement] = useState<PopperPlacement>('bottom-start');

  return (
    <Popper
      open={open}
      anchorRef={anchorRef}
      placement="bottom-start"
      onPlacementChange={setPlacement}
    >
      <div data-enter-from={placement.startsWith('top') ? 'bottom' : 'top'}>
        Floating content
      </div>
    </Popper>
  );
}
```

> `flip` 預設關閉以維持既有版位行為，僅在會出現在視窗邊緣（如表格分頁大小選單、底部工具列的 Select）的呼叫端才建議開啟。

---

## Loading States

### Page Loading

```tsx
import { Spin, Skeleton } from '@mezzanine-ui/react';

function PageLoading() {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState(null);

  if (loading) {
    return (
      <div style={{ padding: 24, textAlign: 'center' }}>
        <Spin loading description="Loading..." />
      </div>
    );
  }

  return <PageContent data={data} />;
}

// Or use Skeleton
function PageWithSkeleton() {
  const [loading, setLoading] = useState(true);

  if (loading) {
    return (
      <div style={{ padding: 24 }}>
        <Skeleton width={200} height={24} />
        <Skeleton width="100%" height={16} style={{ marginTop: 16 }} />
        <Skeleton width="100%" height={16} style={{ marginTop: 8 }} />
        <Skeleton width="80%" height={16} style={{ marginTop: 8 }} />
      </div>
    );
  }

  return <PageContent />;
}
```

### Button Loading

```tsx
import { Button } from '@mezzanine-ui/react';

function SubmitButton() {
  const [loading, setLoading] = useState(false);

  const handleClick = async () => {
    setLoading(true);
    try {
      await submitData();
    } finally {
      setLoading(false);
    }
  };

  return (
    <Button variant="base-primary" loading={loading} onClick={handleClick}>
      Submit
    </Button>
  );
}
```

---

## Error Handling

### Form Errors

```tsx
import { FormField, Input, InlineMessageGroup } from '@mezzanine-ui/react';

function FormWithErrors({ errors }) {
  const nameError = errors.find(e => e.field === 'name');

  return (
    <div>
      {errors.length > 0 && (
        <InlineMessageGroup
          items={errors.map(err => ({
            key: err.field,
            severity: 'error' as const,
            content: err.message,
          }))}
        />
      )}

      <FormField
        name="name"
        label="Name"
        required
        severity={nameError ? 'error' : 'info'}
        hintText={nameError?.message}
      >
        <Input placeholder="Enter name" />
      </FormField>
    </div>
  );
}
```

### Empty State

```tsx
import { Empty, Button } from '@mezzanine-ui/react';

function EmptyState() {
  return (
    <Empty
      title="No data available"
      type="initial-data"
    >
      <Button onClick={() => handleCreate()}>
        Create first entry
      </Button>
    </Empty>
  );
}
```

### Result State

```tsx
import { ResultState, Button } from '@mezzanine-ui/react';

function SuccessResult() {
  return (
    <ResultState
      type="success"
      title="Operation Successful"
      description="Your changes have been saved"
      actions={{
        secondaryButton: { children: 'Back to list', onClick: () => navigate('/list') },
        primaryButton: { children: 'Continue adding', onClick: () => reset() },
      }}
    />
  );
}

function ErrorResult() {
  return (
    <ResultState
      type="error"
      title="Operation Failed"
      description="An error occurred, please try again later"
      actions={{
        secondaryButton: { children: 'Retry', onClick: () => retry() },
      }}
    />
  );
}
```

---

## Notifications

### Message Alerts

```tsx
import { Message, Button } from '@mezzanine-ui/react';

function NotificationExample() {
  const handleSave = async () => {
    try {
      await saveData();
      Message.success('Saved successfully');
    } catch (error) {
      Message.error('Save failed, please try again later');
    }
  };

  return (
    <Button variant="base-primary" onClick={handleSave}>
      Save
    </Button>
  );
}
```

### Notification Center

```tsx
import { NotificationCenter, Button } from '@mezzanine-ui/react';

function NotificationExample() {
  const showNotification = () => {
    NotificationCenter.success({
      title: 'Operation Successful',
      description: 'Your changes have been saved',
      duration: 5000,
    });
  };

  const showError = () => {
    NotificationCenter.error({
      title: 'Operation Failed',
      description: 'An error occurred, please contact the administrator',
      duration: 0, // Does not auto-close
    });
  };

  return (
    <div>
      <Button onClick={showNotification}>Show success notification</Button>
      <Button onClick={showError}>Show error notification</Button>
    </div>
  );
}
```

### Alert Banner

```tsx
import { AlertBanner } from '@mezzanine-ui/react';

function PageWithBanner() {
  const [showBanner, setShowBanner] = useState(true);

  return (
    <div>
      {showBanner && (
        <AlertBanner
          severity="warning"
          message="System maintenance tonight at 22:00, estimated downtime: 2 hours."
          onClose={() => setShowBanner(false)}
        />
      )}
      <PageContent />
    </div>
  );
}
```
