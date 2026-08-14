# Tag

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/tag) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/data-display-tag--docs

標籤元件，用於分類、篩選或標記內容。支援五種模式：`static`（純標籤）、`counter`（帶計數徽章）、`dismissable`（可關閉）、`addable`（可點擊新增）及 `overflow-counter`（溢出計數）。`MznTagGroup` 可包裹多個標籤，並支援 `fade` 過場動畫。

> **Aliases** — mat-chip (Angular Material) · Chip (MUI) · Tag (Ant Design) · Label · Pill · 標籤 · 分類標籤 · Figma `Tag / *`
> **Not for** — 狀態呈現（已核准 / 失敗 / 停用）。`MznTag` **沒有語意顏色**，狀態請用 [`MznBadge variant="dot-*"`](Badge.md)，見下一節。

---

## Tag 沒有語意顏色（重要）

`Tag` 只有**單一配色** —— `background/brand-faint` 底 + `text/brand-solid` 字（來源：`packages/core/src/tag/_tag-styles.scss`）。它**沒有** `color` / `severity` / `status` input，也沒有對應的 CSS variable。

**這是刻意的，不是缺漏**：`Tag` 表達「這是什麼」（分類），不表達「它現在怎麼樣」（狀態）。

| 你要表達的               | directive                       | 範例                         |
| ------------------------ | ------------------------------- | ---------------------------- |
| 分類、標籤、可篩選的屬性 | `MznTag`                        | 「測試單據」「會簽」「FVPL」 |
| 狀態、結果、進度         | `MznBadge variant="dot-*"`      | 「已核准」「失敗」「送審中」 |

判斷句：**「這個標籤在說『它是什麼』，還是『它現在怎麼樣』？」**

```html
<!-- ❌ 不要用 class / ::ng-deep 覆寫 Tag 的底色來製造狀態色 -->
<span mznTag label="已核准" class="status-positive"></span>

<!-- ✅ 狀態用 Badge，五階語意色、零覆寫 -->
<span mznBadge variant="dot-success" text="已核准"></span>
```

> ⚠️ 覆寫 `Tag` 底色會在專案裡長出一套與設計系統平行的私有色階，違反「樣式僅可透過 design tokens 調整」。
> **需要 class 或 `::ng-deep` 覆寫 `background` / `color` / `border` 才能達成設計 = 選錯元件的訊號。**

### 「只改 CSS 變數」也不行（常見的漂亮繞法）

有一種看起來很守規矩的做法：不直接寫 `background`，而是在 class 裡把 `Tag` 內部用到的語意 token 指到別的 token。

```scss
/* ❌ 這仍然是覆寫元件外觀，而且更難察覺 */
.status-approved {
  --mzn-color-background-brand-faint: var(--mzn-color-background-success-faint);
  --mzn-color-text-brand-solid: var(--mzn-color-text-success);
}
```

它「只用了 design tokens」，但做的事情是**讓一個宣稱自己是 brand 色的元件謊稱自己是 success 色**。後果與直接寫死顏色相同，還多了兩個問題：

1. 語意錯位 —— 該節點的 `--mzn-color-background-brand-faint` 已不再是 brand 色，任何巢狀在裡面、也用到這個 token 的元素會一起被污染。
2. 升級即碎 —— 一旦 `Tag` 改用別的 token，這套覆寫會靜默失效，沒有任何型別或編譯錯誤會提醒你。

**判準**：design tokens 是拿來用在**你自己的版面元素**上的，不是拿來**重新定義元件內部語意**的。元件的語意色只能透過元件自己的 input 選 —— `MznTag` 沒有那個 input，就是它不負責語意。

另：分類標籤需要「白底 + 灰框」的描邊外觀時，用 `readOnly` input（`background-color: unset` + `border: 1px solid border/neutral-light`），**不要自己刻 border**。

---

## Import

```ts
import { MznTag, MznTagGroup } from '@mezzanine-ui/ng/tag';
import type { TagType, TagSize } from '@mezzanine-ui/core/tag';
// TagType: 'static' | 'counter' | 'dismissable' | 'addable' | 'overflow-counter'
// TagSize: 'main' | 'sub'
```

## Selector

`<span mznTag type="static" label="標籤文字">` — attribute-directive component，建議 host element 為 `<span>`

`<div mznTagGroup>` — 標籤群組容器

## Inputs — MznTag

| Input      | Type       | Default    | Description                                                                                              |
| ---------- | ---------- | ---------- | -------------------------------------------------------------------------------------------------------- |
| `type`     | `TagType`  | `'static'` | 標籤模式：`'static'` / `'counter'` / `'dismissable'` / `'addable'` / `'overflow-counter'`                |
| `label`    | `string`   | —          | 標籤顯示文字（`static`、`counter`、`dismissable`、`addable` 型）                                          |
| `size`     | `TagSize`  | `'main'`   | `'main' \| 'sub'` — 標籤尺寸                                                                             |
| `count`    | `number`   | —          | 計數器數字（`counter` 和 `overflow-counter` 型）                                                          |
| `disabled` | `boolean`  | `false`    | 是否禁用（`dismissable`、`addable`、`overflow-counter` 型）                                               |
| `active`   | `boolean`  | `false`    | 是否啟用中（套用 active 樣式）                                                                            |
| `readOnly` | `boolean`  | `false`    | 是否唯讀                                                                                                  |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs — MznTag

| Output     | Type                         | Description                                              |
| ---------- | ---------------------------- | -------------------------------------------------------- |
| `close`    | `OutputEmitterRef<MouseEvent>` | 關閉按鈕被點擊時觸發（`dismissable` 型）                |
| `tagClick` | `OutputEmitterRef<MouseEvent>` | 標籤被點擊時觸發（`addable` / `overflow-counter` 型）   |

## Inputs — MznTagGroup

| Input        | Type               | Default  | Description                             |
| ------------ | ------------------ | -------- | --------------------------------------- |
| `transition` | `'fade' \| 'none'` | `'none'` | 過場動畫；`'fade'` 在標籤增刪時以漸變呈現 |

## Usage

```html
<!-- 靜態標籤 -->
<span mznTag type="static" label="設計"></span>
<span mznTag type="static" label="前端" size="sub"></span>

<!-- 計數標籤 -->
<span mznTag type="counter" label="待處理" [count]="pendingCount()"></span>

<!-- 可關閉標籤 -->
<span mznTag type="dismissable" label="React" (close)="removeTag('React')"></span>

<!-- 可新增標籤 -->
<span mznTag type="addable" label="新增標籤" (tagClick)="openTagInput()"></span>

<!-- 溢出計數標籤 -->
<span mznTag type="overflow-counter" [count]="extraTagCount()" (tagClick)="showAllTags()"></span>

<!-- 標籤群組（帶 fade 動畫） -->
<div mznTagGroup transition="fade">
  @for (tag of tags(); track tag.id) {
    <span
      mznTag
      type="dismissable"
      [label]="tag.name"
      (close)="removeTag(tag.id)"
    ></span>
  }
  <span mznTag type="addable" label="新增" (tagClick)="openAddTag()"></span>
</div>
```

```ts
import { Component, signal } from '@angular/core';
import { MznTag, MznTagGroup } from '@mezzanine-ui/ng/tag';

interface TagItem {
  id: string;
  name: string;
}

@Component({
  selector: 'app-tag-editor',
  imports: [MznTag, MznTagGroup],
  template: `
    <div mznTagGroup transition="fade">
      @for (tag of tags(); track tag.id) {
        <span
          mznTag
          type="dismissable"
          [label]="tag.name"
          [disabled]="isReadOnly()"
          (close)="removeTag(tag.id)"
        ></span>
      }
      @if (!isReadOnly()) {
        <span mznTag type="addable" label="新增標籤" (tagClick)="addTag()"></span>
      }
    </div>
  `,
})
export class TagEditorComponent {
  readonly tags = signal<TagItem[]>([
    { id: '1', name: 'Angular' },
    { id: '2', name: 'TypeScript' },
  ]);
  readonly isReadOnly = signal(false);

  removeTag(id: string): void {
    this.tags.update((tags) => tags.filter((t) => t.id !== id));
  }

  addTag(): void { /* open dialog... */ }
}
```

## Notes

- `addable` 和 `overflow-counter` 型的 host element 為透明（`display: contents`），實際的標籤樣式套用在內部 `<button>` 上；這是為了讓 CSS selector（如 `:disabled`、hover）正確匹配。
- `close` output 僅在 `type="dismissable"` 時有效；`tagClick` output 僅在 `type="addable"` 或 `type="overflow-counter"` 時有效。
- `active` input 可用於表示「已選取」的篩選標籤（如篩選條件面板）。
- `MznTagGroup` 的 `transition="fade"` 僅控制標籤容器的動畫，標籤增刪的 CSS transition 由 SCSS 定義。
