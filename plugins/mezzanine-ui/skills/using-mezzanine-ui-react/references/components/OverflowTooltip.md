# OverflowTooltip Component

> **Category**: Data Display -- OverflowCounterTag is exported from the main entry; OverflowTooltip is an internal component
>
> **Storybook**: `Data Display/OverflowTooltip`
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/OverflowTooltip)  · Verified 1.5.1 (2026-09-12)

Overflow tag tooltip component for displaying truncated tag lists. Typically used with Select in multi-select mode.

## Import

```tsx
// Only OverflowCounterTag is exported from the main entry
import { OverflowCounterTag } from '@mezzanine-ui/react';
import type { OverflowCounterTagProps } from '@mezzanine-ui/react';

// OverflowTooltip itself is an internal component; must be imported from sub-path
// import OverflowTooltip from '@mezzanine-ui/react/OverflowTooltip';
```

> **Note**: Only `OverflowCounterTag` is exported from the `@mezzanine-ui/react` main entry. `OverflowTooltip` is an internal component.

---

## OverflowCounterTag Props

OverflowCounterTag is a composite component of OverflowTooltip and Tag. Clicking the counter tag expands the overflow tag list.

Extends `NativeElementPropsWithoutKeyAndRef<'span'>` and `Pick<OverflowTooltipProps, 'className' | 'onTagDismiss' | 'placement' | 'tags' | 'tagSize' | 'readOnly'>`.

| Property       | Type                      | Default | Description                  |
| -------------- | ------------------------- | ------- | ---------------------------- |
| `className`    | `string`                  | -       | Custom class name            |
| `disabled`     | `boolean`                 | -       | Whether disabled             |
| `onTagDismiss` | `(index: number) => void` | -       | Tag dismiss callback (required) |
| `placement`    | `Placement`               | -       | Popup placement              |
| `readOnly`     | `boolean`                 | -       | Whether read-only            |
| `tagSize`      | `TagProps['size']`        | -       | Tag size                     |
| `tags`         | `string[]`                | `[]`    | Tag list                     |

### OverflowCounterTag Usage Example

```tsx
import { OverflowCounterTag } from '@mezzanine-ui/react';

<OverflowCounterTag
  tags={['Tag 1', 'Tag 2', 'Tag 3']}
  onTagDismiss={(index) => handleRemove(index)}
  tagSize="main"
/>
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/internal-overflowtooltip--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## OverflowTooltip Props (Internal Component)

`OverflowTooltipProps` is an object type (not an interface inheritance).

| Property       | Type                       | Default       | Description          |
| -------------- | -------------------------- | ------------- | -------------------- |
| `anchor`       | `PopperProps['anchor']`    | **required**  | Anchor element       |
| `className`    | `string`                   | -             | className            |
| `onTagDismiss` | `(tagIndex: number) => void` | **required** | Tag dismiss callback |
| `open`         | `boolean`                  | **required**  | Whether open         |
| `placement`    | `Placement`                | `'top-start'` | Popup placement      |
| `readOnly`     | `boolean`                  | -             | Whether read-only    |
| `tagSize`      | `TagProps['size']`         | -             | Tag size             |
| `tags`         | `string[]`                 | **required**  | Tag list             |

---

## Usage Examples

### Basic Usage (OverflowTooltip Internal Component)

```tsx
// OverflowTooltip must be imported from sub-path (not exported from main entry)
import OverflowTooltip from '@mezzanine-ui/react/OverflowTooltip';
import { useRef, useState } from 'react';

function BasicExample() {
  const anchorRef = useRef<HTMLDivElement>(null);
  const [open, setOpen] = useState(false);
  const [tags, setTags] = useState(['Tag 1', 'Tag 2', 'Tag 3']);

  const handleTagDismiss = (index: number) => {
    setTags(prev => prev.filter((_, i) => i !== index));
  };

  return (
    <div>
      <div
        ref={anchorRef}
        onMouseEnter={() => setOpen(true)}
        onMouseLeave={() => setOpen(false)}
      >
        +{tags.length} more
      </div>
      <OverflowTooltip
        anchor={anchorRef}
        open={open}
        tags={tags}
        onTagDismiss={handleTagDismiss}
      />
    </div>
  );
}
```

### Read-Only Mode

```tsx
<OverflowTooltip
  anchor={anchorRef}
  open={open}
  tags={['Tag 1', 'Tag 2', 'Tag 3']}
  onTagDismiss={() => {}}
  readOnly
/>
```

### Custom Placement

```tsx
<OverflowTooltip
  anchor={anchorRef}
  open={open}
  tags={tags}
  onTagDismiss={handleTagDismiss}
  placement="bottom-start"
/>
```

### Small Size Tags

```tsx
<OverflowTooltip
  anchor={anchorRef}
  open={open}
  tags={tags}
  onTagDismiss={handleTagDismiss}
  tagSize="sub"
/>
```

### With Multi-Select

```tsx
function MultiSelectWithOverflow() {
  const [selectedValues, setSelectedValues] = useState(['a', 'b', 'c', 'd', 'e']);
  const [tooltipOpen, setTooltipOpen] = useState(false);
  const overflowRef = useRef<HTMLSpanElement>(null);

  const displayedTags = selectedValues.slice(0, 2);
  const overflowTags = selectedValues.slice(2);

  return (
    <div>
      {displayedTags.map(tag => (
        <Tag key={tag} label={tag} type="dismissable" onClose={() => handleRemove(tag)} />
      ))}
      {overflowTags.length > 0 && (
        <span
          ref={overflowRef}
          onMouseEnter={() => setTooltipOpen(true)}
          onMouseLeave={() => setTooltipOpen(false)}
        >
          +{overflowTags.length}
        </span>
      )}
      <OverflowTooltip
        anchor={overflowRef}
        open={tooltipOpen}
        tags={overflowTags}
        onTagDismiss={(index) => handleRemove(overflowTags[index])}
      />
    </div>
  );
}
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/internal-overflowtooltip--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Tag Behavior

- **readOnly=false** (default): Tags are displayed as dismissable; clicking X triggers `onTagDismiss`
- **readOnly=true**: Tags are displayed as static; cannot be dismissed

---

## Figma Mapping

| Figma Variant                    | React Props                              |
| -------------------------------- | ---------------------------------------- |
| `OverflowTooltip / Default`      | Default                                  |
| `OverflowTooltip / ReadOnly`     | `readOnly`                               |
| `OverflowTooltip / Top`          | `placement="top-start"` (default)        |
| `OverflowTooltip / Bottom`       | `placement="bottom-start"`               |

---

## Best Practices (最佳實踐)

### 場景推薦 (Scenario Recommendations)

| 場景 | 推薦做法 | 相關 Props |
| --- | --- | --- |
| 多選框溢出標籤 | 使用 `OverflowCounterTag` 而非直接使用 `OverflowTooltip` | `OverflowCounterTag` |
| 懸停顯示溢出 | 監聽 `onMouseEnter`/`onMouseLeave` 控制 `open` | `open` |
| 標籤可刪除 | 保持 `readOnly={false}` (預設) 並處理 `onTagDismiss` | `onTagDismiss` |
| 標籤唯讀展示 | 設定 `readOnly={true}` 隱藏刪除圖標 | `readOnly` |
| 空間受限 | 根據可用空間選擇 `placement` (bottom-start 等) | `placement` |
| 小螢幕適配 | 使用 `tagSize="sub"` 減少寬度佔用 | `tagSize` |

### 常見錯誤 (Common Mistakes)

1. **直接使用 OverflowTooltip**
   - ❌ 誤：在應該使用 `OverflowCounterTag` 的場景直接使用 `OverflowTooltip`
   - ✅ 正確：優先使用 `OverflowCounterTag`，內部已包裝 `OverflowTooltip`
   - 影響：減少重複邏輯，提升代碼簡潔度

2. **狀態同步不佳**
   - ❌ 誤：`onTagDismiss` 未更新外部標籤狀態
   - ✅ 正確：在 `onTagDismiss` 中更新 `tags` 陣列
   - 範例：`onTagDismiss={(index) => setTags(tags.filter((_, i) => i !== index))}`

3. **Placement 選擇不當**
   - ❌ 誤：不考慮視窗邊界，總是使用 `top-start`
   - ✅ 正確：根據 anchor 位置選擇合適的 `placement`
   - 影響：避免工具提示被視窗邊界裁剪

4. **忘記提供 anchor ref**
   - ❌ 誤：不提供 `anchor` prop 或提供 null
   - ✅ 正確：使用 `useRef` 關聯觸發元素
   - 範例：`<OverflowTooltip anchor={anchorRef.current} />`

5. **讀寫模式混亂**
   - ❌ 誤：在讀寫模式下不提供 `onTagDismiss` 實現
   - ✅ 正確：可編輯時提供回調，唯讀時設 `readOnly={true}`
   - 範例：預覽模式 `readOnly={true}`，編輯模式 `readOnly={false}`

### 核心建議 (Core Recommendations)

1. **使用 OverflowCounterTag**：大多數場景優先使用 `OverflowCounterTag` 組件
2. **懸停觸發**：通常使用 `mouseEnter`/`mouseLeave` 控制開關
3. **狀態同步**：`onTagDismiss` 應同步外部狀態
4. **合適的位置**：根據可用空間選擇 `placement`
5. **讀寫區分**：唯讀展示使用 `readOnly={true}`，編輯場景使用 `readOnly={false}`
