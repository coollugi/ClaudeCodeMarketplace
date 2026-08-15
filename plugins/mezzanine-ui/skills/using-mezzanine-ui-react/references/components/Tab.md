# Tab Component

> **Category**: Navigation
>
> **Storybook**: `Navigation/Tab`
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Tab) · Verified 1.4.1 (2026-07-01)

Tab component for switching between different content views within the same area.

> **Aliases** — Tabs · TabBar · 頁籤 · 分頁標籤 · Figma `Tab / *`
> **Not for** — 互斥的檢視／排序切換（用 [`RadioGroup type="segment"`](Radio.md)）。另注意 `Tab` 只接受 `<TabItem>` children，其餘 JSX **靜默丟棄且不出 warning**。

## Import

```tsx
import { Tab, TabItem } from '@mezzanine-ui/react';
import type { TabProps, TabItemProps, TabsChild } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/navigation-tab--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Type Definition

```ts
type TabsChild = ReactElement<TabItemProps>;
```

---

## Children Validation (重要 — 靜默過濾)

`Tab` 在 runtime 透過 `Children.map` 檢查每個子元素的 `child.type !== TabItem`，**靜默丟棄非 `<TabItem>` 的元素**。**不會在 console 印出任何 warning**，這是常見的「JSX 寫了但畫面空白」陷阱。

```tsx
// ❌ 包一層 div：所有 TabItem 不渲染（無 warning）
<Tab>
  <div className={styles.wrapper}>
    <TabItem key="a">A</TabItem>
    <TabItem key="b">B</TabItem>
  </div>
</Tab>

// ❌ Fragment 中夾雜文字 / 自訂元件：非 TabItem 部分被丟棄
<Tab>
  <>
    <TabItem key="a">A</TabItem>
    <span>分隔</span>          {/* 靜默丟棄 */}
    <CustomItem />              {/* 靜默丟棄 */}
  </>
</Tab>

// ✅ 直接放 TabItem，可使用陣列 / 條件渲染 / map
<Tab>
  <TabItem key="a">A</TabItem>
  {showB && <TabItem key="b">B</TabItem>}
  {tabs.map((t) => (
    <TabItem key={t.id}>{t.label}</TabItem>
  ))}
</Tab>
```

> Tab 內容（每個分頁的 body）**不要**寫在 Tab 內部，請依照 controlled 模式於 Tab 之外依 `activeKey` 切換顯示。

---

## Tab Props

> Extends `NativeElementPropsWithoutKeyAndRef<'div'>` (excluding `onChange` and `children`).

| Property           | Type                                      | Default        | Description          |
| ------------------ | ----------------------------------------- | -------------- | -------------------- |
| `activeKey`        | `Key`                                     | -              | Controlled active tab |
| `children`         | `TabsChild \| TabsChild[]`               | **required**   | TabItem children     |
| `defaultActiveKey` | `Key`                                     | `0`            | Default active tab   |
| `direction`        | `'horizontal' \| 'vertical'`             | `'horizontal'` | Layout direction     |
| `onChange`         | `(activeKey: Key, index: number) => void` | -              | Change event         |
| `size`             | `'main' \| 'sub'`                         | `'main'`       | Tab group size (controls padding) |

---

## TabItem Props

> Extends `NativeElementPropsWithoutKeyAndRef<'button'>`.

| Property     | Type             | Default | Description                           |
| ------------ | ---------------- | ------- | ------------------------------------- |
| `active`     | `boolean`        | -       | Whether active (controlled by `<Tab>`) |
| `badgeCount` | `number`         | -       | Badge number on the tab               |
| `children`   | `ReactNode`      | -       | Tab content                           |
| `disabled`   | `boolean`        | `false` | Whether disabled                      |
| `error`      | `boolean`        | `false` | Error state variant (changes badge styling) |
| `icon`       | `IconDefinition` | -       | Tab icon                              |

---

## 版面 padding 契約 (重要 — size 決定是否貼邊)

`Tab` 的 `size` **預設為 `'main'`**，而 `size="main"` 在 core SCSS 帶有自己的 gutter：

```scss
.mzn-tab--horizontal.mzn-tab--main { padding: 16px 16px 0; }  // compact 12 / 14 / 0
.mzn-tab--vertical.mzn-tab--main   { padding: 0 0 0 16px; }   // compact left 14
```

橫向 Tab 的底線是 `::before { inset: 0; border-bottom: ... }`，**必須滿版**才不會被截斷。因此：

- **`size="main"`（頁面級分頁）** — 必須是 page container 的**直接子代**，與 `PageHeader` 同層貼齊版面。
- **`size="sub"`（Section 內的分頁）** — host 無 padding，只有 `__item` 有較緊湊的內距。透過 `Section` 的 `tab` prop 傳入時，Section 另有 `> .mzn-tab--horizontal.mzn-tab--main { padding: 0 }` 會把 main size 的 padding 歸零。
- 放進套了 `padding-inline` 的 body wrapper 時要改 `size="sub"`，否則是 16 + 16 的雙層內縮。

詳見 SKILL.md → **Page Layout Skeleton (必讀 — 版面 padding 契約)**。

## Usage Examples

### Basic Usage

```tsx
import { Tab, TabItem } from '@mezzanine-ui/react';

function BasicTab() {
  return (
    <Tab>
      <TabItem key="tab1">Tab 1</TabItem>
      <TabItem key="tab2">Tab 2</TabItem>
      <TabItem key="tab3">Tab 3</TabItem>
    </Tab>
  );
}
```

### Controlled Mode

```tsx
function ControlledTab() {
  const [activeKey, setActiveKey] = useState<Key>('tab1');

  return (
    <>
      <Tab activeKey={activeKey} onChange={(key) => setActiveKey(key)}>
        <TabItem key="tab1">Tab 1</TabItem>
        <TabItem key="tab2">Tab 2</TabItem>
        <TabItem key="tab3">Tab 3</TabItem>
      </Tab>
      <div>
        {activeKey === 'tab1' && <div>Content 1</div>}
        {activeKey === 'tab2' && <div>Content 2</div>}
        {activeKey === 'tab3' && <div>Content 3</div>}
      </div>
    </>
  );
}
```

### Vertical Layout

```tsx
<Tab direction="vertical">
  <TabItem key="overview">Overview</TabItem>
  <TabItem key="details">Details</TabItem>
  <TabItem key="settings">Settings</TabItem>
</Tab>
```

### Default Selected

```tsx
<Tab defaultActiveKey="tab2">
  <TabItem key="tab1">Tab 1</TabItem>
  <TabItem key="tab2">Tab 2 (default)</TabItem>
  <TabItem key="tab3">Tab 3</TabItem>
</Tab>
```

### With Icons and Badges

```tsx
import { Tab, TabItem } from '@mezzanine-ui/react';
import { HomeIcon, UserIcon, SettingIcon } from '@mezzanine-ui/icons';

<Tab>
  <TabItem key="home" icon={HomeIcon}>Home</TabItem>
  <TabItem key="users" icon={UserIcon} badgeCount={5}>Users</TabItem>
  <TabItem key="settings" icon={SettingIcon}>Settings</TabItem>
</Tab>
```

### Tab Group Sizes

```tsx
// Main size (default) - larger padding
<Tab size="main">
  <TabItem key="tab1">Main Tab</TabItem>
  <TabItem key="tab2">Another Tab</TabItem>
</Tab>

// Sub size - compact padding
<Tab size="sub">
  <TabItem key="tab1">Compact Tab</TabItem>
  <TabItem key="tab2">Another Tab</TabItem>
</Tab>
```

### Error State on Tab Item

```tsx
// Error badge displays with alert variant (instead of default brand color)
<Tab>
  <TabItem key="form" icon={FormIcon}>Form</TabItem>
  <TabItem key="review" icon={ReviewIcon} badgeCount={3} error>
    Review
  </TabItem>
  <TabItem key="submit" icon={SendIcon}>Submit</TabItem>
</Tab>

// When error is true, badge variant changes to 'count-alert' to indicate issues
```

### Disabled Tab

```tsx
<Tab>
  <TabItem key="tab1">Available Tab</TabItem>
  <TabItem key="tab2" disabled>Disabled Tab</TabItem>
  <TabItem key="tab3">Available Tab</TabItem>
</Tab>
```

### With Content Panels

```tsx
function TabWithContent() {
  const [activeKey, setActiveKey] = useState<Key>('profile');

  return (
    <div>
      <Tab activeKey={activeKey} onChange={(key) => setActiveKey(key)}>
        <TabItem key="profile">Profile</TabItem>
        <TabItem key="account">Account Settings</TabItem>
        <TabItem key="notifications">Notifications</TabItem>
      </Tab>

      <div style={{ padding: '16px' }}>
        {activeKey === 'profile' && <ProfileContent />}
        {activeKey === 'account' && <AccountContent />}
        {activeKey === 'notifications' && <NotificationsContent />}
      </div>
    </div>
  );
}
```

### Dynamic Tabs

```tsx
function DynamicTabs() {
  const [tabs, setTabs] = useState([
    { key: '1', label: 'Tab 1' },
    { key: '2', label: 'Tab 2' },
  ]);

  const addTab = () => {
    const newKey = String(tabs.length + 1);
    setTabs([...tabs, { key: newKey, label: `Tab ${newKey}` }]);
  };

  return (
    <>
      <Tab>
        {tabs.map((tab) => (
          <TabItem key={tab.key}>{tab.label}</TabItem>
        ))}
      </Tab>
      <Button onClick={addTab}>Add Tab</Button>
    </>
  );
}
```

---

## Figma Mapping

| Figma Variant             | React Props                              |
| ------------------------- | ---------------------------------------- |
| `Tab / Main`              | `<Tab size="main">`                      |
| `Tab / Sub`               | `<Tab size="sub">`                       |
| `Tab / Horizontal`        | `<Tab direction="horizontal">`           |
| `Tab / Vertical`          | `<Tab direction="vertical">`             |
| `TabItem / Active`        | Determined by `activeKey`                |
| `TabItem / Disabled`      | `<TabItem disabled>`                     |
| `TabItem / Error`         | `<TabItem error>`                        |

---

## Best Practices

1. **Meaningful keys**: Use descriptive key values
2. **Limit tab count**: Recommend 2-7 tabs
3. **Concise tab text**: Keep tab text short
4. **Pair with content panels**: Tab only handles switching; content must be implemented separately
5. **Vertical for sidebars**: Side settings panels suit `direction="vertical"`
