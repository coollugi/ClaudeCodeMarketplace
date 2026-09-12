# Tag Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Tag`
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Tag)  · Verified 1.5.1 (2026-09-12)

Tag component for labeling, categorizing, or filtering content. Supports multiple types with different host elements (`<span>` or `<button>`).

> **Aliases** — Chip (MUI) · Tag (Ant Design) · Label · Pill · 標籤 · 分類標籤 · Figma `Tag / *`
> **Not for** — 狀態呈現（已核准 / 失敗 / 停用）。`Tag` **沒有語意顏色**，狀態請用 [`Badge variant="dot-*"`](Badge.md)，見下一節。

## Import

```tsx
import { Tag, TagGroup } from '@mezzanine-ui/react';
import type { TagProps, TagGroupProps, TagSize } from '@mezzanine-ui/react';
```

> `TagSize` is re-exported from `@mezzanine-ui/core/tag`.

---

## Tag 沒有語意顏色（重要）

`Tag` 只有**單一配色** —— `background/brand-faint` 底 + `text/brand-solid` 字（來源：`packages/core/src/tag/_tag-styles.scss`）。它**沒有** `color` / `severity` / `status` prop，也沒有對應的 CSS variable。

**這是刻意的，不是缺漏**：`Tag` 表達「這是什麼」（分類），不表達「它現在怎麼樣」（狀態）。

| 你要表達的               | 元件                    | 範例                             |
| ------------------------ | ----------------------- | -------------------------------- |
| 分類、標籤、可篩選的屬性 | `Tag`                   | 「測試單據」「會簽」「FVPL」     |
| 狀態、結果、進度         | `Badge variant="dot-*"` | 「已核准」「失敗」「送審中」     |

判斷句：**「這個標籤在說『它是什麼』，還是『它現在怎麼樣』？」**

```tsx
// ❌ 不要用 className 覆寫 Tag 的底色來製造狀態色
<Tag label="已核准" className={styles.statusPositive} />

// ✅ 狀態用 Badge，五階語意色、零覆寫
<Badge variant="dot-success" text="已核准" />
```

> ⚠️ 覆寫 `Tag` 底色會在專案裡長出一套與設計系統平行的私有色階，違反「樣式僅可透過 design tokens 調整」。
> **需要 `className` 覆寫 `background` / `color` / `border` 才能達成設計 = 選錯元件的訊號。**

### 「只改 CSS 變數」也不行（常見的漂亮繞法）

有一種看起來很守規矩的做法：不直接寫 `background`，而是在 class 裡把 `Tag` 內部用到的語意 token 指到別的 token。

```scss
/* ❌ 這仍然是覆寫元件外觀，而且更難察覺 */
.statusApproved {
  --mzn-color-background-brand-faint: var(--mzn-color-background-success-faint);
  --mzn-color-text-brand-solid: var(--mzn-color-text-success);
}
```

它「只用了 design tokens」，但做的事情是**讓一個宣稱自己是 brand 色的元件謊稱自己是 success 色**。後果與直接寫死顏色相同，還多了兩個問題：

1. 語意錯位 —— DOM 上該節點的 `--mzn-color-background-brand-faint` 已不再是 brand 色，任何巢狀在裡面、也用到這個 token 的元素會一起被污染。
2. 升級即碎 —— 一旦 `Tag` 改用別的 token（例如換成 `background/neutral-faint`），這套覆寫會靜默失效，沒有任何型別或編譯錯誤會提醒你。

**判準**：design tokens 是拿來用在**你自己的版面元素**上的（page body 的 `padding-inline`、自訂區塊的 `row-gap`），不是拿來**重新定義元件內部語意**的。元件的語意色只能透過元件自己的 prop 選 —— `Tag` 沒有那個 prop，就是它不負責語意。

另：分類標籤需要「白底 + 灰框」的描邊外觀時，用 `readOnly` prop（`background-color: unset` + `border: 1px solid border/neutral-light`），**不要自己刻 border**。

---

## Tag Types

| Type               | Host Element | Description            | Characteristics        |
| ------------------ | ------------ | ---------------------- | ---------------------- |
| `static`           | `<span>`     | Static tag (default)   | Display only           |
| `counter`          | `<span>`     | Counter tag            | With number badge      |
| `dismissable`      | `<span>`     | Dismissable tag        | With close button      |
| `addable`          | `<button>`   | Addable tag            | With plus icon, clickable |
| `overflow-counter` | `<button>`   | Overflow counter       | Shows +N format        |

---

## TagProps (Union Type)

```tsx
type TagProps =
  | TagPropsStatic
  | TagPropsCounter
  | TagPropsOverflowCounter
  | TagPropsDismissable
  | TagPropsAddable;
```

### Common Props for All Types

| Property    | Type      | Default  | Description  |
| ----------- | --------- | -------- | ------------ |
| `className` | `string`  | -        | Custom class |
| `size`      | `TagSize` | `'main'` | Size         |

---

## Type-specific Props

### Static Tag (TagPropsStatic)

Extends `<span>` native attributes (excluding `onClick`, `type`).

```tsx
interface TagPropsStatic {
  type?: 'static';
  label: string;                                 // Required
  readOnly?: boolean;
  // The following are never: active, count, disabled, onClose, onClick
}
```

### Counter Tag (TagPropsCounter)

Extends `<span>` native attributes (excluding `onClick`, `type`).

```tsx
interface TagPropsCounter {
  type: 'counter';                               // Required
  label: string;                                 // Required
  count: number;                                 // Required
  // The following are never: active, disabled, onClose, onClick, readOnly
}
```

### Dismissable Tag (TagPropsDismissable)

Extends `<span>` native attributes (excluding `onClick`, `type`).

```tsx
interface TagPropsDismissable {
  type: 'dismissable';                           // Required
  label: string;                                 // Required
  active?: boolean;
  disabled?: boolean;
  onClose: MouseEventHandler<HTMLButtonElement>;  // Required
  // The following are never: count, onClick, readOnly
}
```

### Addable Tag (TagPropsAddable)

Extends `<button>` native attributes (excluding `onClick`, `type`).

```tsx
interface TagPropsAddable {
  type: 'addable';                               // Required
  label: string;                                 // Required
  active?: boolean;
  disabled?: boolean;
  onClick?: MouseEventHandler<HTMLButtonElement>;
  // The following are never: count, onClose, readOnly
}
```

### Overflow Counter Tag (TagPropsOverflowCounter)

Extends `<button>` native attributes (excluding `onClick`, `type`).

```tsx
interface TagPropsOverflowCounter {
  type: 'overflow-counter';                      // Required
  count: number;                                 // Required
  disabled?: boolean;
  onClick?: MouseEventHandler<HTMLButtonElement>;
  readOnly?: boolean;
  // The following are never: active, label, onClose
}
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-tag--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Usage Examples

### Static Tag

```tsx
import { Tag } from '@mezzanine-ui/react';

<Tag type="static" label="Tag" />
<Tag label="Default is also static" />
```

### Counter Tag

```tsx
<Tag type="counter" label="Notifications" count={5} />
<Tag type="counter" label="Messages" count={99} />
```

### Dismissable Tag

```tsx
function DismissableTags() {
  const [tags, setTags] = useState(['React', 'Vue', 'Angular']);

  const handleClose = (tagToRemove: string) => {
    setTags(tags.filter((tag) => tag !== tagToRemove));
  };

  return (
    <>
      {tags.map((tag) => (
        <Tag
          key={tag}
          type="dismissable"
          label={tag}
          onClose={() => handleClose(tag)}
        />
      ))}
    </>
  );
}
```

### Addable Tag

```tsx
function AddableTags() {
  const [tags, setTags] = useState(['Tag 1', 'Tag 2']);

  const handleAdd = () => {
    const newTag = `Tag ${tags.length + 1}`;
    setTags([...tags, newTag]);
  };

  return (
    <>
      {tags.map((tag) => (
        <Tag key={tag} label={tag} />
      ))}
      <Tag type="addable" label="Add" onClick={handleAdd} />
    </>
  );
}
```

### Overflow Counter

```tsx
function OverflowTags() {
  const tags = ['Tag 1', 'Tag 2', 'Tag 3', 'Tag 4', 'Tag 5'];
  const visibleCount = 3;

  return (
    <>
      {tags.slice(0, visibleCount).map((tag) => (
        <Tag key={tag} label={tag} />
      ))}
      {tags.length > visibleCount && (
        <Tag
          type="overflow-counter"
          count={tags.length - visibleCount}
          onClick={() => console.log('Expand all tags')}
        />
      )}
    </>
  );
}
```

### Different Sizes

```tsx
<Tag size="main" label="Main Size" />
<Tag size="sub" label="Sub Size" />
<Tag size="minor" label="Minor Size" />
```

### Disabled State

```tsx
<Tag type="dismissable" label="Disabled" disabled onClose={() => {}} />
<Tag type="addable" label="Add" disabled />
<Tag type="overflow-counter" count={5} disabled />
```

### Active State

```tsx
<Tag type="dismissable" label="Selected" active onClose={() => {}} />
<Tag type="addable" label="Add" active />
```

### Using TagGroup

```tsx
import { Tag, TagGroup } from '@mezzanine-ui/react';

<TagGroup>
  <Tag label="React" />
  <Tag label="TypeScript" />
  <Tag label="Node.js" />
</TagGroup>

// With fade transition
<TagGroup transition="fade">
  <Tag label="React" />
  <Tag label="TypeScript" />
</TagGroup>
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-tag--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## TagGroup Props

Extends `<div>` native attributes (excluding `children`, `key`, `ref`).

| Property     | Type                               | Default  | Description                                     |
| ------------ | ---------------------------------- | -------- | ----------------------------------------------- |
| `children`   | `TagGroupChild \| TagGroupChild[]` | -        | Required, accepts `Tag` or `OverflowCounterTag` (also imported from `@mezzanine-ui/react`) elements |
| `transition` | `'fade' \| 'none'`                 | `'none'` | Transition animation type                       |

---

## Figma Mapping

| Figma Variant            | React Props                     |
| ------------------------ | ------------------------------- |
| `Tag / Static`           | `<Tag type="static">`           |
| `Tag / Counter`          | `<Tag type="counter">`          |
| `Tag / Dismissable`      | `<Tag type="dismissable">`      |
| `Tag / Addable`          | `<Tag type="addable">`          |
| `Tag / Overflow Counter` | `<Tag type="overflow-counter">` |
| `Tag / Main`             | `<Tag size="main">`             |
| `Tag / Sub`              | `<Tag size="sub">`              |
| `Tag / Minor`            | `<Tag size="minor">`            |
| `Tag / Active`           | `<Tag active>`                  |
| `Tag / Disabled`         | `<Tag disabled>`                |

---

## Best Practices

1. **Choose appropriate type**: Select the corresponding type based on functional requirements
2. **Control tag count**: Use `overflow-counter` to handle too many tags
3. **Provide removal feedback**: `dismissable` must handle the `onClose` event (required)
4. **Uniform size**: Keep the same `size` for tags in the same area
5. **Clear active state**: Use `active` for filter tags to indicate selection
6. **Respect never constraints**: Each type has strict prop restrictions; do not mix props that don't belong to that type
7. **分類，不是狀態**：`Tag` 沒有語意色。要表達狀態改用 `Badge variant="dot-*"`，不要覆寫底色（見上方〈Tag 沒有語意顏色〉）
8. **描邊外觀用 `readOnly`**：不要自刻 border 模擬白底灰框
