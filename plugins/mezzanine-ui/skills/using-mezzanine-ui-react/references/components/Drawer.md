# Drawer Component

> **Category**: Navigation
>
> **Storybook**: `Navigation/Drawer`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Drawer) · Verified 1.5.1 (2026-09-12)

A drawer component that slides out from the edge of the page, used to display detailed information or forms.

## Import

```tsx
import { Drawer } from '@mezzanine-ui/react';
import type { DrawerProps, DrawerPlacement } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-drawer--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Drawer Props

> Extends `NativeElementPropsWithoutKeyAndRef<'div'>` and partial `BackdropProps`.

### Core Props

| Property                        | Type               | Default      | Description                                                                                        |
| ------------------------------- | ------------------ | ------------ | -------------------------------------------------------------------------------------------------- |
| `open`                          | `boolean`          | -            | Whether the drawer is open                                                                         |
| `onClose`                       | `VoidFunction`     | -            | Close event handler                                                                                |
| `children`                      | `ReactNode`        | -            | Content                                                                                            |
| `size`                          | `DrawerSize`       | `'medium'`   | Width size                                                                                         |
| `container`                     | `Element`          | -            | Portal container                                                                                   |
| `disablePortal`                 | `boolean`          | -            | Disable Portal                                                                                     |
| `disableCloseOnBackdropClick`   | `boolean`          | `false`      | Disable close on backdrop click                                                                    |
| `disableCloseOnEscapeKeyDown`   | `boolean`          | `false`      | Disable closing when Escape key is pressed                                                         |
| `contentKey`                    | `string \| number` | -            | Forces remount when data changes, prevents stale DOM state                                         |
| `onBackdropClick`               | `() => void`       | -            | Backdrop click event handler                                                                       |

### Header Props

| Property            | Type      | Default | Description                              |
| ------------------- | --------- | ------- | ---------------------------------------- |
| `isHeaderDisplay`   | `boolean` | -       | Controls whether to display the header area |
| `headerTitle`       | `string`  | -       | Title text displayed in the drawer header |

### Bottom Action Props

The bottom action area supports three button slots: primary, secondary, and ghost. Each slot shares the same pattern of props.

| Property                          | Type              | Default            | Description                                      |
| --------------------------------- | ----------------- | ------------------ | ------------------------------------------------ |
| `isBottomDisplay`                 | `boolean`         | -                  | Controls whether to display the bottom action area |
| `bottomPrimaryActionText`         | `string`          | -                  | Text for the primary action button               |
| `bottomPrimaryActionVariant`      | `ButtonVariant`   | `'base-primary'`   | Variant for the primary action button            |
| `bottomPrimaryActionIcon`         | `IconDefinition`  | -                  | Icon for the primary action button               |
| `bottomPrimaryActionIconType`     | `ButtonIconType`  | -                  | Icon type for the primary action button          |
| `bottomPrimaryActionLoading`      | `boolean`         | -                  | Loading state for the primary action button      |
| `bottomPrimaryActionDisabled`     | `boolean`         | -                  | Disabled state for the primary action button     |
| `bottomPrimaryActionSize`         | `ButtonSize`      | -                  | Size for the primary action button               |
| `bottomOnPrimaryActionClick`      | `VoidFunction`    | -                  | Click handler for the primary action button      |
| `bottomSecondaryActionText`       | `string`          | -                  | Text for the secondary action button             |
| `bottomSecondaryActionVariant`    | `ButtonVariant`   | `'base-secondary'` | Variant for the secondary action button          |
| `bottomSecondaryActionIcon`       | `IconDefinition`  | -                  | Icon for the secondary action button             |
| `bottomSecondaryActionIconType`   | `ButtonIconType`  | -                  | Icon type for the secondary action button        |
| `bottomSecondaryActionLoading`    | `boolean`         | -                  | Loading state for the secondary action button    |
| `bottomSecondaryActionDisabled`   | `boolean`         | -                  | Disabled state for the secondary action button   |
| `bottomSecondaryActionSize`       | `ButtonSize`      | -                  | Size for the secondary action button             |
| `bottomOnSecondaryActionClick`    | `VoidFunction`    | -                  | Click handler for the secondary action button    |
| `bottomGhostActionText`           | `string`          | -                  | Text for the ghost action button                 |
| `bottomGhostActionVariant`        | `ButtonVariant`   | `'base-ghost'`     | Variant for the ghost action button              |
| `bottomGhostActionIcon`           | `IconDefinition`  | -                  | Icon for the ghost action button                 |
| `bottomGhostActionIconType`       | `ButtonIconType`  | -                  | Icon type for the ghost action button            |
| `bottomGhostActionLoading`        | `boolean`         | -                  | Loading state for the ghost action button        |
| `bottomGhostActionDisabled`       | `boolean`         | -                  | Disabled state for the ghost action button       |
| `bottomGhostActionSize`           | `ButtonSize`      | -                  | Size for the ghost action button                 |
| `bottomOnGhostActionClick`        | `VoidFunction`    | -                  | Click handler for the ghost action button        |

### Filter Area Props

| Property                        | Type                                    | Default | Description                                                                        |
| ------------------------------- | --------------------------------------- | ------- | ---------------------------------------------------------------------------------- |
| `filterAreaShow`                | `boolean`                               | `false` | Controls whether to display the filter area                                        |
| `filterAreaAllRadioLabel`       | `string`                                | -       | Label of the "All" radio in filter area                                            |
| `filterAreaReadRadioLabel`      | `string`                                | -       | Label of the "Read" radio in filter area                                           |
| `filterAreaUnreadRadioLabel`    | `string`                                | -       | Label of the "Unread" radio in filter area                                         |
| `filterAreaDefaultValue`        | `string`                                | -       | Default value of the radio group in filter area                                    |
| `filterAreaValue`               | `string`                                | -       | Controlled value of the radio group in filter area                                 |
| `filterAreaOnRadioChange`       | `ChangeEventHandler<HTMLInputElement>`  | -       | Callback when the radio group value changes in filter area                         |
| `filterAreaShowUnreadButton`    | `boolean`                               | `false` | Controls whether to display the unread button in filter area                       |
| `filterAreaCustomButtonLabel`   | `string`                                | `'全部已讀'` | Label of the custom button in filter area                                      |
| `filterAreaOnCustomButtonClick` | `VoidFunction`                          | -       | Callback when the custom button is clicked in filter area                          |
| `filterAreaIsEmpty`             | `boolean`                               | `false` | Whether the filter area content is empty (for disabling custom button)             |
| `filterAreaOptions`             | `DropdownOption[]`                      | `[]`    | Options for the filter bar dropdown; replaces the right-side button with a Dropdown |
| `filterAreaOnSelect`            | `(option: DropdownOption) => void`      | -       | Callback when a filter bar dropdown option is selected                             |

---

## Type Definitions

```ts
type DrawerSize = 'narrow' | 'medium' | 'wide';
// Note: DrawerSize must be imported from @mezzanine-ui/core/drawer

// DrawerPlacement is exported but the Drawer component currently uses fixed right placement, does not use placement prop
type DrawerPlacement = 'top' | 'right' | 'bottom' | 'left';
```

### DrawerSize

| Size     | Description   |
| -------- | ------------- |
| `narrow` | Narrow drawer |
| `medium` | Medium drawer |
| `wide`   | Wide drawer   |

---

## Usage Examples

### Basic Usage

```tsx
import { Drawer, Button } from '@mezzanine-ui/react';
import { useState } from 'react';

function BasicDrawer() {
  const [open, setOpen] = useState(false);

  return (
    <>
      <Button onClick={() => setOpen(true)}>Open Drawer</Button>
      <Drawer open={open} onClose={() => setOpen(false)}>
        <p>Drawer content</p>
      </Drawer>
    </>
  );
}
```

### Different Sizes

```tsx
// Narrow
<Drawer size="narrow" open={open} onClose={onClose}>
  Narrow drawer content
</Drawer>

// Medium (default)
<Drawer size="medium" open={open} onClose={onClose}>
  Medium drawer content
</Drawer>

// Wide
<Drawer size="wide" open={open} onClose={onClose}>
  Wide drawer content
</Drawer>
```

### Prevent Backdrop Click Close

```tsx
<Drawer
  open={open}
  onClose={onClose}
  disableCloseOnBackdropClick
>
  <p>Content that cannot be dismissed by clicking backdrop</p>
</Drawer>
```

### With Header and Bottom Actions

```tsx
<Drawer
  open={open}
  onClose={onClose}
  isHeaderDisplay
  headerTitle="Edit Record"
  isBottomDisplay
  bottomPrimaryActionText="Save"
  bottomOnPrimaryActionClick={handleSave}
  bottomSecondaryActionText="Cancel"
  bottomOnSecondaryActionClick={onClose}
>
  <FormContent />
</Drawer>
```

### With Filter Area

```tsx
<Drawer
  open={open}
  onClose={onClose}
  isHeaderDisplay
  headerTitle="Notifications"
  filterAreaShow
  filterAreaAllRadioLabel="All"
  filterAreaReadRadioLabel="Read"
  filterAreaUnreadRadioLabel="Unread"
  filterAreaValue={filterValue}
  filterAreaOnRadioChange={(e) => setFilterValue(e.target.value)}
>
  <NotificationList filter={filterValue} />
</Drawer>
```

### Using ContentKey for Data Changes

```tsx
function DataDrawer() {
  const [open, setOpen] = useState(false);
  const [selectedId, setSelectedId] = useState<string | null>(null);

  return (
    <>
      <Drawer open={open} onClose={() => setOpen(false)} contentKey={selectedId}>
        {selectedId && <DataContent id={selectedId} />}
      </Drawer>
    </>
  );
}
```

### Drawer with Portal Container

```tsx
<Drawer
  open={open}
  onClose={onClose}
  container={document.getElementById('drawer-root')}
>
  <p>Rendered into custom container</p>
</Drawer>
```

---

## Figma Mapping

| Figma Variant                    | React Props                              |
| -------------------------------- | ---------------------------------------- |
| `Drawer / Narrow`                | `size="narrow"`                          |
| `Drawer / Medium`                | `size="medium"`                          |
| `Drawer / Wide`                  | `size="wide"`                            |
| `Drawer / With Header`           | `isHeaderDisplay`                        |
| `Drawer / With Bottom Actions`   | `isBottomDisplay`                        |
| `Drawer / Full`                  | `isHeaderDisplay isBottomDisplay`        |

---

## Best Practices

| 使用場景 | 推薦設定 | 說明 |
|---------|--------|------|
| 詳情檢視 | `size="medium"` | 檢視額外詳細資訊 |
| 表單編輯 | `size="wide"` | 寬抽屜容納完整表單 |
| 快速設定 | `size="narrow"` | 簡單設定使用窄抽屜 |
| 重要表單 | `disableCloseOnBackdropClick` | 防止意外關閉 |
| 列表操作 | `size="medium"`, 滾動內容 | 呈現清單或多筆項目 |

### 常見錯誤

1. **尺寸選擇不當導致佈局混亂**
   ```tsx
   // ❌ 錯誤：複雜表單用窄抽屜
   <Drawer size="narrow" isBottomDisplay>
     <ComplexForm />
   </Drawer>

   // ✅ 正確：根據內容複雜度選擇尺寸
   <Drawer size="wide" isBottomDisplay>
     <ComplexForm />
   </Drawer>
   ```

2. **未提供關閉方式**
   ```tsx
   // ❌ 錯誤：使用者無法關閉
   <Drawer open={open}>
     Content only
   </Drawer>

   // ✅ 正確：提供 onClose 方式
   <Drawer open={open} onClose={onClose}>
     Content
   </Drawer>
   ```

3. **使用 contentKey 不當**
   ```tsx
   // ❌ 錯誤：每次渲染都改變 contentKey
   <Drawer contentKey={Math.random()} open={open}>
     Content
   </Drawer>

   // ✅ 正確：只在數據變更時改變 contentKey
   <Drawer contentKey={dataId} open={open}>
     <DataContent id={dataId} />
   </Drawer>
   ```

4. **多層抽屜的管理**
   ```tsx
   // ❌ 錯誤：嵌套多個抽屜但無序處理
   <Drawer open={drawer1Open} onClose={() => setDrawer1Open(false)}>
     <Drawer open={drawer2Open} onClose={() => setDrawer2Open(false)}>
       Nested
     </Drawer>
   </Drawer>

   // ✅ 正確：使用堆疊結構，ESC 自動閉合頂層
   <Drawer open={drawer1Open} onClose={() => setDrawer1Open(false)}>
     <Button onClick={() => setDrawer2Open(true)}>Open Second</Button>
   </Drawer>
   <Drawer open={drawer2Open} onClose={() => setDrawer2Open(false)}>
     Content
   </Drawer>
   ```

### 核心原則

1. **選擇適當尺寸**: 根據內容量選擇 `size`
2. **提供關閉方式**: 確保用戶能夠關閉抽屜 (via `onClose`)
3. **使用內建按鈕**: 透過 `isBottomDisplay` 和 `bottomPrimaryAction*` / `bottomSecondaryAction*` / `bottomGhostAction*` props 使用內建底部操作按鈕
4. **重要操作禁用意外關閉**: 使用 `disableCloseOnBackdropClick` 防止關鍵操作被意外關閉
5. **堆疊處理**: 多個抽屜時，ESC 只關閉頂層；可用 `disableCloseOnEscapeKeyDown` 控制
6. **contentKey 管理**: 僅在內容數據確實改變時修改，避免頻繁重掛載
7. **無障礙設計**: 提供適當的焦點管理和鍵盤導航
