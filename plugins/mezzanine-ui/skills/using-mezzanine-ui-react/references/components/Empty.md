# Empty Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Empty`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Empty) · Verified 1.4.1 (2026-07-01)

An empty state component for displaying placeholder screens when there is no data or in specific states.

## Import

```tsx
import { Empty } from '@mezzanine-ui/react';
import type { EmptyProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-empty--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Empty Props

`EmptyProps` uses intersection types to combine multiple interfaces. Available props depend on `size` and `type`.

Extends `Omit<NativeElementPropsWithoutKeyAndRef<'div'>, 'title'>`.

### Base Props (BaseEmptyProps)

| Property | Type     | Default | Description            |
| -------- | -------- | ------- | ---------------------- |
| `title`  | `string` | -       | Required, title text   |

### Preset Pictogram Props (PresetPictogramEmptyProps)

| Property    | Type                                                           | Default          | Description                       |
| ----------- | -------------------------------------------------------------- | ---------------- | --------------------------------- |
| `type`      | `'initial-data' \| 'result' \| 'system' \| 'notification'`    | `'initial-data'` | Preset pictogram type             |
| `pictogram` | `ReactNode`                                                    | -                | Custom pictogram (overrides default) |

### Custom Pictogram Props (CustomPictogramEmptyProps)

| Property    | Type        | Default | Description      |
| ----------- | ----------- | ------- | ---------------- |
| `type`      | `'custom'`  | -       | Custom type      |
| `pictogram` | `ReactNode` | -       | Custom pictogram |

### Main/Sub Size Props (MainOrSubEmptyProps)

| Property      | Type                                                                                                                                   | Default  | Description                             |
| ------------- | -------------------------------------------------------------------------------------------------------------------------------------- | -------- | --------------------------------------- |
| `actions`     | `ButtonProps \| { primaryButton?: ButtonProps; secondaryButton: ButtonProps }`                                                          | -        | Action button config (priority over children) |
| `children`    | `ReactElement<ButtonProps> \| [ReactElement<ButtonProps>] \| [ReactElement<ButtonProps>, ReactElement<ButtonProps>]`                     | -        | 1-2 Button elements (first is secondary) |
| `description` | `string`                                                                                                                               | -        | Description text                        |
| `size`        | `'main' \| 'sub'`                                                                                                                     | `'main'` | Size                                    |

### Minor Size Props (MinorEmptyProps)

| Property      | Type      | Default | Description                              |
| ------------- | --------- | ------- | ---------------------------------------- |
| `size`        | `'minor'` | -       | Required, smallest size                  |
| `actions`     | `never`   | -       | Not available (minor has no action btns) |
| `description` | `never`   | -       | Not available (minor has no description) |

---

## Empty Type

| Type            | Description      | Default Pictogram  |
| --------------- | ---------------- | ------------------ |
| `initial-data`  | Initial no data  | BoxIcon            |
| `result`        | No search result | FolderOpenIcon     |
| `system`        | System error     | SystemIcon         |
| `notification`  | No notifications | NotificationIcon   |
| `custom`        | Custom           | Uses pictogram     |

---

## Empty Size

| Size    | Description | Features                                                    |
| ------- | ----------- | ----------------------------------------------------------- |
| `main`  | Main        | Large icon, full content, supports actions/description/children |
| `sub`   | Sub         | Medium icon, full content, supports actions/description/children |
| `minor` | Minor       | Small icon, title only (no actions, description, or children) |

---

## Usage Examples

### Basic Usage

```tsx
import { Empty } from '@mezzanine-ui/react';

<Empty title="No data available" />
```

### With Description

```tsx
<Empty
  title="No data available"
  description="Please add data to get started"
/>
```

### Different Types

```tsx
// Initial no data
<Empty type="initial-data" title="No data yet" />

// No search results
<Empty type="result" title="No results found" />

// System error
<Empty type="system" title="An error occurred" />

// No notifications
<Empty type="notification" title="No new notifications" />
```

### With Action Buttons

```tsx
// Single button (pass ButtonProps directly)
<Empty
  title="No data available"
  actions={{ content: 'Add Data', onClick: handleAdd }}
/>

// Two buttons (object form: secondaryButton required, primaryButton optional)
<Empty
  title="No data available"
  actions={{
    secondaryButton: { content: 'Learn More', onClick: handleLearnMore },
    primaryButton: { content: 'Add Data', onClick: handleAdd },
  }}
/>
```

### Using Children Buttons

```tsx
import { Empty, Button } from '@mezzanine-ui/react';

{/* First Button is treated as secondary, second as primary */}
<Empty title="No data available">
  <Button onClick={handleLearnMore}>Learn More</Button>
  <Button onClick={handleAdd}>Add Data</Button>
</Empty>
```

### Different Sizes

```tsx
// Main (default)
<Empty size="main" title="Main Size" description="Full content" />

// Sub
<Empty size="sub" title="Sub Size" description="Full content" />

// Minor (does not support actions or description)
<Empty size="minor" title="Minor Size" />
```

### Custom Pictogram

```tsx
import { Empty } from '@mezzanine-ui/react';

<Empty
  type="custom"
  pictogram={<img src="/custom-empty.svg" alt="empty" />}
  title="Custom Empty State"
  description="Using a custom pictogram"
/>
```

### No Search Results

```tsx
function SearchResults({ results, keyword }) {
  if (results.length === 0) {
    return (
      <Empty
        type="result"
        title={`No results found for "${keyword}"`}
        description="Please try different keywords"
        actions={{ content: 'Clear Search', onClick: handleClear }}
      />
    );
  }

  return <ResultList results={results} />;
}
```

### List Empty State

```tsx
function DataList({ data, loading }) {
  if (loading) return <Spin loading />;

  if (data.length === 0) {
    return (
      <Empty
        type="initial-data"
        title="No data yet"
        description="Click the button below to add your first entry"
        actions={{ content: 'Add Data', onClick: handleAdd }}
      />
    );
  }

  return <List data={data} />;
}
```

### Table Empty State

```tsx
<Table
  dataSource={data}
  columns={columns}
  emptyDescription={
    <Empty
      size="sub"
      type="result"
      title="No matching data"
    />
  }
/>
```

---

## Figma Mapping

| Figma Variant                 | React Props                              |
| ----------------------------- | ---------------------------------------- |
| `Empty / Main`                | `size="main"`                            |
| `Empty / Sub`                 | `size="sub"`                             |
| `Empty / Minor`               | `size="minor"`                           |
| `Empty / Initial Data`        | `type="initial-data"`                    |
| `Empty / Result`              | `type="result"`                          |
| `Empty / System`              | `type="system"`                          |
| `Empty / Notification`        | `type="notification"`                    |
| `Empty / With Actions`        | `actions={...}`                          |

---

## Best Practices

### 場景推薦

| 使用場景 | 推薦設定 | 說明 |
|---------|--------|------|
| 初始化無數據 | `type="initial-data"`, `size="main"` | 首次進入應用或無任何記錄 |
| 搜尋無結果 | `type="result"`, `size="main"` | 搜尋或篩選結果為空 |
| 系統異常 | `type="system"`, `size="main"` | 服務異常或出現錯誤 |
| 無通知提示 | `type="notification"`, `size="sub"` | 通知中心空狀態 |
| 列表簡化 | `type="initial-data"`, `size="minor"` | 列表欄位或工具列空狀態 |

### 常見錯誤

1. **未指定 title 導致顯示不完整**
   ```tsx
   // ❌ 錯誤：缺少必要的 title
   <Empty type="initial-data" />

   // ✅ 正確：提供清晰的標題
   <Empty
     type="initial-data"
     title="No data available"
     description="Click the button below to add your first item"
   />
   ```

2. **尺寸選擇不當導致視覺失衡**
   ```tsx
   // ❌ 錯誤：在小元件中使用 main 尺寸
   <div style={{ width: '200px' }}>
     <Empty type="initial-data" size="main" title="Empty" />
   </div>

   // ✅ 正確：根據容器選擇合適尺寸
   <div style={{ width: '200px' }}>
     <Empty type="initial-data" size="minor" title="Empty" />
   </div>
   ```

3. **為 minor 尺寸設定不支援的屬性**
   ```tsx
   // ❌ 錯誤：minor 不支援 actions 和 description
   <Empty
     size="minor"
     title="Empty"
     description="This won't display"
     actions={{ content: 'Add' }}
   />

   // ✅ 正確：minor 只支援 title
   <Empty
     size="minor"
     title="Empty"
   />
   ```

4. **按鈕數量過多導致選擇困難**
   ```tsx
   // ❌ 錯誤：超過兩個按鈕
   <Empty
     title="No data"
     actions={{
       primaryButton: { content: 'Add' },
       secondaryButton: { content: 'Import' },
       // ... more buttons
     }}
   />

   // ✅ 正確：最多兩個按鈕
   <Empty
     title="No data"
     actions={{
       primaryButton: { content: 'Add New' },
       secondaryButton: { content: 'Import from File' },
     }}
   />
   ```

5. **混淆 actions 和 children 的優先級**
   ```tsx
   // ❌ 錯誤：同時設定 actions 和 children
   <Empty
     title="Empty"
     actions={{ content: 'Add' }}
   >
     <Button>This will be ignored</Button>
   </Empty>

   // ✅ 正確：優先使用 actions 配置
   <Empty
     title="Empty"
     actions={{
       primaryButton: { content: 'Add' },
       secondaryButton: { content: 'Learn More' },
     }}
   />
   ```

### 核心原則

1. **選擇適當類型**: 根據場景選擇匹配的類型
2. **提供操作**: 空狀態應暗示下一步行動
3. **文案簡潔**: 標題和描述應短小清晰
4. **尺寸適配**: 根據容器尺寸選擇合適大小
5. **限制按鈕**: 最多使用兩個按鈕，避免選擇過多
6. **引導用戶**: 提供清晰的指示幫助用戶採取行動
7. **型別一致**: 同一頁面的多個 Empty 應使用一致的邏輯
