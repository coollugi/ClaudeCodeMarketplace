# Mezzanine-UI Component Reference

Complete component API reference documentation.

> Baseline: `@mezzanine-ui/react` `1.5.1` · `@mezzanine-ui/core` `1.2.1` · `@mezzanine-ui/system` / `@mezzanine-ui/icons` `1.0.2`. Last verified: 2026-09-12.

## Table of Contents

- [General Components](#general-components)
- [Navigation Components](#navigation-components)
- [Data Display Components](#data-display-components)
- [Data Entry Components](#data-entry-components)
- [Feedback Components](#feedback-components)
- [Other Components](#other-components)
- [Utility Components](#utility-components)
- [Internal Components](#internal-components)
- [Hooks](#hooks)

---

## General Components

### Button

Button component supporting multiple variants and sizes.

```tsx
import { Button, ButtonGroup } from '@mezzanine-ui/react';
import { PlusIcon, ChevronDownIcon } from '@mezzanine-ui/icons';

// Basic variants
<Button variant="base-primary">Primary</Button>
<Button variant="base-secondary">Secondary</Button>
<Button variant="base-tertiary">Tertiary</Button>
<Button variant="base-ghost">Ghost</Button>
<Button variant="base-dashed">Dashed</Button>
<Button variant="base-text-link">Text Link</Button>

// Destructive actions
<Button variant="destructive-primary">Delete</Button>
<Button variant="destructive-secondary">Cancel</Button>

// Sizes
<Button size="main">Main Size</Button>
<Button size="sub">Sub Size</Button>
<Button size="minor">Minor Size</Button>

// With icons
<Button icon={PlusIcon} iconType="leading">Add</Button>
<Button icon={ChevronDownIcon} iconType="trailing">Expand</Button>
<Button icon={PlusIcon} iconType="icon-only">Add</Button>

// States
<Button disabled>Disabled</Button>
<Button loading>Loading</Button>

// Button group
<ButtonGroup>
  <Button>Left</Button>
  <Button>Center</Button>
  <Button>Right</Button>
</ButtonGroup>
```

**Props**

| Prop    | Type                                        | Default          | Description      |
| ------- | ------------------------------------------- | ---------------- | ---------------- |
| variant | `ButtonVariant`                             | `'base-primary'` | Button variant   |
| size    | `'main' \| 'sub' \| 'minor'`               | `'main'`         | Button size      |
| icon    | `IconDefinition`                            | -                | Icon             |
| iconType| `'leading' \| 'trailing' \| 'icon-only'`   | -                | Icon position    |
| disabled| `boolean`                                   | `false`          | Whether disabled |
| loading | `boolean`                                   | `false`          | Whether loading  |
| component| `ElementType`                              | `'button'`       | Render element   |

**ButtonVariant Types**
- `base-primary`, `base-secondary`, `base-tertiary`, `base-ghost`, `base-dashed`, `base-text-link`
- `destructive-primary`, `destructive-secondary`, `destructive-ghost`, `destructive-text-link`
- `inverse`, `inverse-ghost`

---

### Icon

Icon component.

```tsx
import { Icon } from '@mezzanine-ui/react';
import { PlusIcon, SearchIcon, SpinnerIcon } from '@mezzanine-ui/icons';

<Icon icon={PlusIcon} />
<Icon icon={SearchIcon} size={24} />
<Icon icon={SpinnerIcon} spin />
```

**Icon Categories**

| Category     | Example Icons                                                                                                                     |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------- |
| `arrow/`     | `ChevronDownIcon`, `ChevronUpIcon`, `CaretDownIcon`, `CaretRightIcon`, `LongTailArrowRightIcon`                                   |
| `controls/`  | `PlusIcon`, `MinusIcon`, `CloseIcon`, `TrashIcon`, `SettingIcon`, `EyeIcon`, `EyeInvisibleIcon`, `FilterIcon`, `LockIcon`, `UnlockIcon` |
| `system/`    | `SearchIcon`, `MenuIcon`, `HomeIcon`, `UserIcon`, `CalendarIcon`, `NotificationIcon`, `SpinnerIcon`                                |
| `content/`   | `EditIcon`, `CopyIcon`, `DownloadIcon`, `UploadIcon`                                                                              |
| `alert/`     | `CheckedFilledIcon`, `ErrorFilledIcon`, `WarningFilledIcon`, `InfoFilledIcon`, `DangerousFilledIcon`, `QuestionFilledIcon`          |
| `stepper/`   | `Item0Icon` ~ `Item9Icon`                                                                                                         |

---

### Typography

Text typography component.

```tsx
import { Typography } from '@mezzanine-ui/react';

// Headings
<Typography variant="h1">Heading 1 (24px)</Typography>
<Typography variant="h2">Heading 2 (18px)</Typography>
<Typography variant="h3">Heading 3 (16px)</Typography>

// Body
<Typography variant="body">Body (14px)</Typography>
<Typography variant="body-highlight">Highlighted Body</Typography>
<Typography variant="body-mono">Monospace Body</Typography>

// Caption
<Typography variant="caption">Caption (12px)</Typography>
<Typography variant="caption-highlight">Highlighted Caption</Typography>
<Typography variant="annotation">Annotation (10px)</Typography>

// Functional
<Typography variant="button">Button Text</Typography>
<Typography variant="input">Input Text</Typography>
<Typography variant="label-primary">Primary Label</Typography>
<Typography variant="label-secondary">Secondary Label</Typography>

// Colors
<Typography color="text-neutral-solid">Solid Text</Typography>
<Typography color="text-brand">Brand Text</Typography>
<Typography color="text-error">Error Text</Typography>
```

**TypographySemanticType** (20 types)
- Headings: `h1`, `h2`, `h3`
- Body: `body`, `body-highlight`, `body-mono`, `body-mono-highlight`
- Links: `text-link-body`, `text-link-caption`
- Captions: `caption`, `caption-highlight`, `annotation`, `annotation-highlight`
- Functional: `button`, `button-highlight`, `input`, `input-mono`, `label-primary`, `label-primary-highlight`, `label-secondary`

---

### Separator

Separator component.

```tsx
import { Separator } from '@mezzanine-ui/react';

<Separator />
```

---

### Cropper

Image cropping component.

```tsx
import { Cropper } from '@mezzanine-ui/react';

<Cropper src="/image.jpg" aspectRatio={16 / 9} />
```

---

## Navigation Components

### Navigation

Side navigation component.

```tsx
import {
  Navigation,
  NavigationHeader,
  NavigationOption,
  NavigationOptionCategory,
  NavigationFooter,
  NavigationUserMenu,
  NavigationIconButton,
} from '@mezzanine-ui/react';
import { HomeIcon, SettingIcon } from '@mezzanine-ui/icons';

<Navigation>
  <NavigationHeader>
    <Logo />
  </NavigationHeader>

  <NavigationOptionCategory title="Main Menu">
    <NavigationOption icon={HomeIcon} title="Home" />
    <NavigationOption icon={SettingIcon} title="Settings" />
  </NavigationOptionCategory>

  <NavigationFooter>
    <NavigationUserMenu imgSrc="/avatar.png">
      John Doe
    </NavigationUserMenu>
  </NavigationFooter>
</Navigation>
```

**Notable Props (v1.0.0)**

| Prop                   | Type      | Default | Description                              |
| ---------------------- | --------- | ------- | ---------------------------------------- |
| `exactActivatedMatch`  | `boolean` | `false` | Strict pathname matching for active state |
| `collapseToggleLabel`  | `string`  | -       | **New in 1.5.0.** Accessible/translatable label for the collapse-toggle control, part of the 1.5.0 a11y pass |

> **v1.5.0 a11y fixes**: the invalid `menuitem` role is dropped from navigation options and option categories (groups/leaves are now labelled correctly instead), so every navigation control announces itself to assistive tech.

---

### Tab

Tab component.

```tsx
import { Tab, TabItem } from '@mezzanine-ui/react';

<Tab activeKey={activeKey} onChange={(key) => setActiveKey(key)}>
  <TabItem key="1">Tab 1</TabItem>
  <TabItem key="2">Tab 2</TabItem>
</Tab>
```

**Notable Props (v1.0.0)**

| Prop    | Type                    | Default | Description                         |
| ------- | ----------------------- | ------- | ----------------------------------- |
| `size`  | `'main' \| 'sub'`       | `'main'`| Tab size                            |
| `error` | `boolean`               | `false` | Show error state                    |

---

### Stepper

Step indicator.

```tsx
import { Stepper, Step, useStepper } from '@mezzanine-ui/react';

const stepper = useStepper({ steps: 3 });

<Stepper {...stepper}>
  <Step title="Step 1" description="Description text" />
  <Step title="Step 2" />
  <Step title="Step 3" />
</Stepper>
```

---

### Breadcrumb

Breadcrumb navigation.

```tsx
import { Breadcrumb } from '@mezzanine-ui/react';

<Breadcrumb items={[
  { text: 'Home', href: '/' },
  { text: 'List', href: '/list' },
  { text: 'Detail' },
]} />
```

---

### Drawer

Drawer component.

```tsx
import { Drawer } from '@mezzanine-ui/react';

<Drawer
  open={open}
  onClose={() => setOpen(false)}
  isHeaderDisplay
  headerTitle="Drawer Title"
>
  Drawer content
</Drawer>
```

---

### PageHeader

Page header component.

```tsx
import { PageHeader } from '@mezzanine-ui/react';

<PageHeader title="Page Title" />
```

---

### PageFooter

Page footer component.

```tsx
import { PageFooter } from '@mezzanine-ui/react';

<PageFooter>Footer content</PageFooter>
```

> **v1.5.0 a11y fix**: no longer renders unnamed empty buttons.

---

## Data Display Components

### Table

Table component supporting virtualization, drag-and-drop, fixed columns, and more.

```tsx
import { Table, useTableDataSource, useTableRowSelection } from '@mezzanine-ui/react';

const columns = [
  { title: 'Name', dataIndex: 'name' },
  { title: 'Age', dataIndex: 'age' },
];

const data = [
  { id: '1', name: 'John Doe', age: 32 },
  { id: '2', name: 'Jane Smith', age: 28 },
];

<Table columns={columns} dataSource={data} />
```

**Notable Props (v1.0.0)**

| Prop       | Type                                                                  | Default | Description                                          |
| ---------- | --------------------------------------------------------------------- | ------- | ---------------------------------------------------- |
| `rowState` | `TableRowState \| ((rowData: T) => TableRowState \| undefined)` | -       | Row-level semantic styling: `'added'` \| `'deleted'` \| `'disabled'` |

> **v1.1.0 SSR fix**: Row height is now resolved via `useIsomorphicLayoutEffect` instead of `useMemo`, eliminating hydration mismatches in Next.js / Remix apps.
>
> **v1.4.4 fix**: `loading` rows no longer feed fabricated placeholder records into consumer callbacks (`column.render` / `actions.render` / `rowState` / `getCheckboxProps` / `rowExpandable` / `expandedRowRender` / `isRowDisabled`) — `record` is now optional in those callback signatures while loading.
>
> **v1.5.0 a11y fix**: icon-only / dropdown row-action buttons now have accessible names, and the row-action menu (via `Dropdown`'s new `shift`, see [Dropdown](#dropdown)) stays inside the viewport instead of being clipped in the last column or after horizontal scroll.

---

### Card

Card component. v2 provides multiple card variants.

```tsx
import {
  BaseCard,
  SingleThumbnailCard,
  FourThumbnailCard,
  QuickActionCard,
  CardGroup,
  // Skeleton sub-components
  BaseCardSkeleton,
  SingleThumbnailCardSkeleton,
  FourThumbnailCardSkeleton,
  QuickActionCardSkeleton,
  Thumbnail,
} from '@mezzanine-ui/react';

// Base card
<BaseCard title="Title" description="Description text" />

// Single thumbnail card
<SingleThumbnailCard
  title="Title"
  description="Description"
  thumbnail={{ src: '/image.jpg', alt: 'Image' }}
/>

// Four thumbnail card
<FourThumbnailCard
  title="Title"
  thumbnails={[
    { src: '/img1.jpg', alt: 'Image 1' },
    { src: '/img2.jpg', alt: 'Image 2' },
    { src: '/img3.jpg', alt: 'Image 3' },
    { src: '/img4.jpg', alt: 'Image 4' },
  ]}
/>

// Quick action card
<QuickActionCard title="Add" icon={PlusIcon} onClick={handleClick} />

// Card group
<CardGroup>
  <BaseCard title="Card 1" />
  <BaseCard title="Card 2" />
</CardGroup>
```

---

### Tag

Tag component.

```tsx
import { Tag, TagGroup } from '@mezzanine-ui/react';

<Tag>Default</Tag>
<Tag color="success">Success</Tag>
<Tag closable onClose={() => {}}>Closable</Tag>
```

---

### Badge

Badge component.

```tsx
import { Badge, BadgeContainer } from '@mezzanine-ui/react';

<BadgeContainer>
  <Badge count={5} />
  <Icon icon={NotificationIcon} />
</BadgeContainer>
```

---

### Accordion

Accordion component for expandable/collapsible content.

```tsx
import {
  Accordion,
  AccordionTitle,
  AccordionContent,
  AccordionActions,
  AccordionGroup,
} from '@mezzanine-ui/react';

// Basic usage
<Accordion>
  <AccordionTitle>Title</AccordionTitle>
  <AccordionContent>Content</AccordionContent>
</Accordion>

// With action buttons
<Accordion>
  <AccordionTitle>Title</AccordionTitle>
  <AccordionContent>Content</AccordionContent>
  <AccordionActions>
    <Button variant="base-text-link">Action</Button>
  </AccordionActions>
</Accordion>

// Group (accordion mode)
<AccordionGroup>
  <Accordion>
    <AccordionTitle>Item 1</AccordionTitle>
    <AccordionContent>Content 1</AccordionContent>
  </Accordion>
  <Accordion>
    <AccordionTitle>Item 2</AccordionTitle>
    <AccordionContent>Content 2</AccordionContent>
  </Accordion>
</AccordionGroup>

// Exclusive mode — only one accordion open at a time
<AccordionGroup exclusive>
  <Accordion title="Item 1">Content 1</Accordion>
  <Accordion title="Item 2">Content 2</Accordion>
</AccordionGroup>
```

---

### Empty

Empty state component.

```tsx
import { Empty } from '@mezzanine-ui/react';

<Empty title="No data available" />
```

---

### Tooltip

Tooltip component.

```tsx
import { Tooltip, Button } from '@mezzanine-ui/react';

<Tooltip title="Tooltip text">
  {(tooltipProps) => <Button {...tooltipProps}>Hover me</Button>}
</Tooltip>
```

**Notable Props (v1.0.0)**

| Prop                 | Type                         | Default | Description                           |
| -------------------- | ---------------------------- | ------- | ------------------------------------- |
| `offsetMainAxis`     | `number`                     | -       | Offset distance along main axis       |

> **v1.5.0 a11y overhaul**: content is now reachable by keyboard and assistive tech, not just mouse hover. The render-prop payload gains `onFocus` / `onBlur`, and the content node emits `role="tooltip"` with a stable `useId` wired to the trigger's `aria-describedby`. Opens only on `:focus-visible` (keyboard focus) — not on the mousedown-focus browsers give a `<button>` — so clicking an icon-only trigger no longer leaves the tooltip stuck open.

---

### Pagination

Pagination component.

```tsx
import { Pagination, PaginationJumper, PaginationPageSize, usePagination } from '@mezzanine-ui/react';

const pagination = usePagination({
  total: 100,
  pageSize: 10,
  current: 1,
});

<Pagination {...pagination} />
```

---

### Description

Description list component displaying information as key-value pairs.

```tsx
import {
  Description,
  DescriptionGroup,
  DescriptionContent,
} from '@mezzanine-ui/react';

<DescriptionGroup>
  <Description title="Name">
    <DescriptionContent>John Doe</DescriptionContent>
  </Description>
  <Description title="Email">
    <DescriptionContent>user@example.com</DescriptionContent>
  </Description>
</DescriptionGroup>
```

---

### Section

Section component for grouping content with a title.

```tsx
import { Section } from '@mezzanine-ui/react';

<Section title="Section Title">
  Section content
</Section>
```

---

### SectionGroup

Groups multiple Section components with consistent spacing.

```tsx
import { SectionGroup, Section } from '@mezzanine-ui/react';

// ContentHeader has never been exported from the main entry (always sub-path only) — pass title directly to Section or compose a custom header element
<SectionGroup direction="vertical">
  <Section title="Section 1">Content 1</Section>
  <Section title="Section 2">Content 2</Section>
</SectionGroup>
```

> **Note (corrected)**: `ContentHeader` has **never** been exported from the main entry — it is not a removal, it has always been sub-path only (verified across every tag from `0.0.1` through `1.5.1`). Import it via the `@mezzanine-ui/react/ContentHeader` sub-path; `Section` / `PageHeader` require it internally.

---

### ContentHeader *(sub-path only — 從未在主入口匯出)*

**Not removed, not deprecated.** `ContentHeader` source still exists (`src/ContentHeader/`) and has never had an `@deprecated` marker — it simply was never re-exported from the main `@mezzanine-ui/react` entry, from `0.0.1` all the way to `1.5.1`. Import via `@mezzanine-ui/react/ContentHeader` sub-path. `Section` / `PageHeader` still require it internally as a child.

> **v1.5.0 a11y fix**: the back-button label is now translatable.

---

### OverflowCounterTag

Overflow counter tag for displaying the number of overflowed items.

```tsx
import { OverflowCounterTag } from '@mezzanine-ui/react';

<OverflowCounterTag count={3} />
```

---

### OverflowTooltip

Internal overflow tooltip component used with Select in multi-select mode. Only `OverflowCounterTag` is exported from the main entry.

```tsx
import { OverflowCounterTag } from '@mezzanine-ui/react';

// OverflowTooltip is internal; use OverflowCounterTag instead
<OverflowCounterTag count={3} />
```

---

## Data Entry Components

### Input

Input field component.

```tsx
import { Input } from '@mezzanine-ui/react';

<Input placeholder="Enter text" />
```

**Notable Props (v1.0.0)**

| Prop                       | Type      | Default | Description                                                       |
| -------------------------- | --------- | ------- | ----------------------------------------------------------------- |
| `hideSuffixWhenClearable`  | `boolean` | `false` | When true, clear icon overlays the suffix position when clearable |

**Breaking Change (v1.0.0)**: The `variant="currency"` has been renamed to `variant="measure"`. Update any Input components using the currency variant.

---

### TextField

Text field component wrapping Input with additional features like prefix/suffix icons.

```tsx
import { TextField } from '@mezzanine-ui/react';
import { SearchIcon } from '@mezzanine-ui/icons';

<TextField prefix={<SearchIcon />} placeholder="Search" />
```

> **v1.5.0 a11y fix**: keeps native ARIA input semantics on the underlying control instead of overriding them.

---

### Toggle

Toggle component (new in v1.0.0). Replaces deprecated Switch component.

```tsx
import { Toggle } from '@mezzanine-ui/react';

<Toggle checked={enabled} onChange={setEnabled} />
```

---

### ⚠️ Switch *(已移除 @ 1.0.0-canary.3)*

**Genuinely removed** — the only component in this list that actually is. It left in two stages: the source directory (`src/Switch/`) was deleted at `1.0.0-canary.3` and replaced by `Toggle`, after which `Switch` survived only as an alias re-export in `src/index.ts`; `1.0.0` dropped that alias too. There was never a formal `@deprecated` notice at either step. Use `Toggle` instead — see the "元件移除／未匯出狀況" table in `../SKILL.md` (a previous version of this doc incorrectly dated this to v1.4.1).

```tsx
// ❌ No longer resolves — the alias was dropped in 1.0.0
import { Switch } from '@mezzanine-ui/react';
<Switch checked={enabled} onChange={setEnabled} />

// ✅ Use Toggle
import { Toggle } from '@mezzanine-ui/react';
<Toggle checked={enabled} onChange={setEnabled} />
```

> The hook `useSwitchControlValue` is unrelated and still ships — it is still exported from the main entry in 1.5.1. Its name is not evidence that the component exists.

---

### Select

Dropdown select component using the `options` prop to define choices (`DropdownOption[]` format).

```tsx
import { Select } from '@mezzanine-ui/react';
import type { SelectValue } from '@mezzanine-ui/react';

const options = [
  { id: '1', name: 'Option 1' },
  { id: '2', name: 'Option 2' },
];

const [value, setValue] = useState<SelectValue | null>(null);

<Select placeholder="Please select" value={value} onChange={setValue} options={options} />
```

**Notable Props (v1.0.0)**

| Prop               | Type      | Default | Description                                               |
| ------------------ | --------- | ------- | --------------------------------------------------------- |
| `isForceClearable` | `boolean` | `false` | Force clear button display in multi-select mode (on SelectTrigger) |

**v1.4.0**: New opt-in `flip?: boolean` prop (default `false`), forwarded to the underlying `Dropdown`. When enabled, the menu flips above the input near the bottom of the viewport while keeping its width and horizontal alignment with the anchor.

---

### Checkbox

Checkbox component supporting single and group modes.

```tsx
import { Checkbox, CheckboxGroup, CheckAll } from '@mezzanine-ui/react';
import type { CheckAllProps } from '@mezzanine-ui/react';

<Checkbox checked={checked} onChange={setChecked}>Option</Checkbox>
```

**Notable Props (v1.0.0)**

| Prop        | Type                                        | Default | Description                |
| ----------- | ------------------------------------------- | ------- | -------------------------- |
| `severity`  | `'info' \| 'warning' \| 'error'`           | `'info'`| Checkbox error state       |

---

### Radio

Radio button component supporting normal and segment modes.

```tsx
import { Radio, RadioGroup } from '@mezzanine-ui/react';

<RadioGroup value={value} onChange={setValue}>
  <Radio value="1">Option 1</Radio>
  <Radio value="2">Option 2</Radio>
</RadioGroup>
```

---

### AutoComplete

Autocomplete component supporting single and multiple selection modes.

```tsx
import { AutoComplete } from '@mezzanine-ui/react';

const options = [
  { id: '1', name: 'Option 1' },
  { id: '2', name: 'Option 2' },
];

// Single select
<AutoComplete
  options={options}
  value={value}
  onChange={setValue}
  placeholder="Type to search"
/>

// Multiple select
<AutoComplete
  mode="multiple"
  options={options}
  value={values}
  onChange={setValues}
/>
```

**Notable Props (v1.0.0)**

| Prop                      | Type      | Default | Description                                    |
| ------------------------- | --------- | ------- | ---------------------------------------------- |
| `overflowStrategy`        | `string`  | -       | Dropdown overflow handling strategy             |
| `stepByStepBulkCreate`    | `boolean` | `false` | Enable step-by-step bulk creation mode         |

**v1.0.0 Enhancement**: `searchTextControlRef` now exposes a `reset()` method for clearing the search text programmatically.

---

### Cascader

Hierarchical dropdown selector for multi-level option trees. Users drill down through nested columns; the selected value is an ordered array of `CascaderOption` objects from root to leaf. Supports controlled/uncontrolled modes, keyboard navigation, clearable state, and two sizes (`main` / `sub`).

See [Cascader component reference](./components/Cascader.md) for full API, props tables, size variants, keyboard interactions, and `CascaderPanel` advanced usage.

```tsx
import { Cascader } from '@mezzanine-ui/react';
import type { CascaderOption } from '@mezzanine-ui/react';

const options: CascaderOption[] = [
  {
    id: 'north',
    name: '北部',
    children: [
      { id: 'taipei', name: '台北市' },
      { id: 'newtaipei', name: '新北市' },
    ],
  },
];

<Cascader
  fullWidth
  options={options}
  placeholder="選擇地區 / 縣市"
  value={value}
  onChange={setValue}
/>
```

---

### Textarea

Multi-line text input component.

```tsx
import { Textarea } from '@mezzanine-ui/react';

<Textarea placeholder="Enter text" rows={4} />
```

---

### Slider

Slider component supporting single value and range modes.

```tsx
import { Slider, useSlider } from '@mezzanine-ui/react';

// Single value
<Slider value={50} onChange={setValue} min={0} max={100} />

// Range
<Slider value={[20, 80]} onChange={setRange} min={0} max={100} />
```

**Notable Props (v1.0.0)**

| Prop                  | Type       | Default | Description                      |
| --------------------- | ---------- | ------- | -------------------------------- |
| `onIconLeadingClick`  | `function` | -       | Icon click handler for leading   |
| `onIconTrailingClick` | `function` | -       | Icon click handler for trailing  |

---

### SelectionCard

Selection card component.

```tsx
import { SelectionCard } from '@mezzanine-ui/react';

<SelectionCard text="Option 1" selector="radio" name="option" value="1" />
```

---

### DatePicker

Date picker.

```tsx
import { DatePicker } from '@mezzanine-ui/react';

<DatePicker value={date} onChange={setDate} />
```

---

### DateRangePicker

Date range picker for selecting a start and end date.

```tsx
import { DateRangePicker } from '@mezzanine-ui/react';

<DateRangePicker value={dateRange} onChange={setDateRange} />
```

---

### DateTimePicker

Date-time picker combining date and time selection.

```tsx
import { DateTimePicker } from '@mezzanine-ui/react';

<DateTimePicker value={dateTime} onChange={setDateTime} />
```

---

### DateTimeRangePicker

Date-time range picker.

```tsx
import { DateTimeRangePicker } from '@mezzanine-ui/react';

<DateTimeRangePicker value={value} onChange={setValue} />
```

---

### MultipleDatePicker

Multiple date picker.

```tsx
import { MultipleDatePicker, MultipleDatePickerTrigger, useMultipleDatePickerValue } from '@mezzanine-ui/react';

const pickerValue = useMultipleDatePickerValue({ defaultValue: [] });

<MultipleDatePicker {...pickerValue} />
```

---

### TimePicker

Time picker.

```tsx
import { TimePicker } from '@mezzanine-ui/react';

<TimePicker value={time} onChange={setTime} />
```

---

### TimeRangePicker

Time range picker for selecting start and end times.

```tsx
import { TimeRangePicker, useTimeRangePickerValue } from '@mezzanine-ui/react';

const rangeValue = useTimeRangePickerValue({ defaultValue: [null, null] });
<TimeRangePicker {...rangeValue} />
```

---

### FilterArea

Filter area component.

```tsx
import { FilterArea, FilterLine, Filter } from '@mezzanine-ui/react';

<FilterArea>
  <FilterLine>
    <Filter label="Status">
      <Select options={statusOptions} value={status} onChange={setStatus} />
    </Filter>
  </FilterLine>
</FilterArea>
```

---

### Upload

Upload component.

```tsx
import { Upload, UploadItem, UploadPictureCard, Uploader } from '@mezzanine-ui/react';

<Upload>
  <Uploader onUpload={handleUpload} />
  <UploadItem file={file} onRemove={handleRemove} />
</Upload>

<UploadPictureCard onUpload={handleUpload} files={files} />
```

---

### Form / FormGroup

Form component.

```tsx
import { FormField, FormLabel, FormHintText } from '@mezzanine-ui/react';
import { FormGroup } from '@mezzanine-ui/react/Form'; // FormGroup is only exported from sub-path

<FormField>
  <FormLabel required>Name</FormLabel>
  <Input placeholder="Enter name" />
  <FormHintText>Hint text</FormHintText>
</FormField>

// FormGroup groups multiple fields
<FormGroup title="Basic Information">
  <FormField name="name" label="Name" layout="vertical" required>
    <Input placeholder="Enter name" />
  </FormField>
</FormGroup>
```

---

## Feedback Components

### Modal

Dialog component.

```tsx
import { Modal, ModalHeader, ModalFooter, ModalBodyForVerification, Button } from '@mezzanine-ui/react';

<Modal open={open} onClose={handleClose}>
  <ModalHeader>Dialog Title</ModalHeader>
  Dialog content
  <ModalFooter>
    <Button variant="base-secondary" onClick={handleClose}>Cancel</Button>
    <Button variant="base-primary" onClick={handleConfirm}>Confirm</Button>
  </ModalFooter>
</Modal>
```

> **v1.5.0**: implements the dialog focus model behind `role="dialog"` via the new `useFocusTrap` hook (see [Hooks](#hooks) below) — moves focus into the dialog on open, cycles `Tab` / `Shift+Tab` within it, restores focus to the previously focused element on close, and is aware of nested dialogs. The dialog is also now announced as modal (`aria-modal`). Same model applies to `MediaPreviewModal`. No prop-level API change.

---

### Message

Message notification component for brief feedback messages.

```tsx
import { Message } from '@mezzanine-ui/react';

Message.success('Success message');
Message.error('Error message');
Message.warning('Warning message');
```

---

### NotificationCenter

Notification center component for persistent notifications with title and description.

```tsx
import { NotificationCenter } from '@mezzanine-ui/react';

NotificationCenter.error({ title: 'Error', description: 'Operation failed' });
```

---

### AlertBanner

Alert banner component.

```tsx
import { AlertBanner } from '@mezzanine-ui/react';

<AlertBanner severity="success" message="Success message" />
<AlertBanner severity="warning" message="System announcement" />
<AlertBanner severity="error" closable onClose={() => {}} message="Error message" />
```

---

### InlineMessage

Inline message component for form-level error hints or descriptions.

```tsx
import { InlineMessage, InlineMessageGroup } from '@mezzanine-ui/react';

<InlineMessage severity="error" content="Invalid field format" />

<InlineMessageGroup
  items={[
    { severity: 'error', message: 'Name is required' },
    { severity: 'warning', message: 'Password strength is insufficient' },
  ]}
/>
```

> **v1.5.0 a11y fix**: caller-provided DOM props are now spread onto the root element.

---

### Progress

Progress bar component.

```tsx
import { Progress } from '@mezzanine-ui/react';

<Progress percent={70} />
```

---

### Skeleton

Skeleton loading placeholder component.

```tsx
import { Skeleton } from '@mezzanine-ui/react';

<Skeleton />
```

---

### Spin

Spin loading indicator component.

```tsx
import { Spin } from '@mezzanine-ui/react';

<Spin />
```

---

### ResultState

Result state component for displaying operation result pages.

```tsx
import { ResultState } from '@mezzanine-ui/react';

<ResultState
  type="success"
  title="Operation Successful"
  description="Your request has been processed"
  actions={{
    secondaryButton: { children: 'Return to Home', onClick: handleGoHome },
  }}
/>
```

---

## Layout Components

### Layout

Full-page layout component providing main content area and a resizable side panel.

```tsx
import { Layout } from '@mezzanine-ui/react';

<Layout>
  <Layout.Main>Main content</Layout.Main>
  <Layout.SidePanel open={sidePanelOpen}>
    Side panel content
  </Layout.SidePanel>
</Layout>
```

---

## Other Components

### Backdrop

Backdrop overlay component.

```tsx
import { Backdrop } from '@mezzanine-ui/react';

<Backdrop open={open} onClick={handleClose} />
```

---

### FloatingButton

Floating action button component.

```tsx
import { FloatingButton } from '@mezzanine-ui/react';

<FloatingButton onClick={handleClick} />
```

---

### Anchor

Anchor navigation component.

```tsx
import { Anchor, AnchorGroup } from '@mezzanine-ui/react';

<AnchorGroup>
  <Anchor href="#section-1">Section 1</Anchor>
  <Anchor href="#section-2">Section 2</Anchor>
</AnchorGroup>
```

---

## Utility Components

### Transition Series

Transition animation components.

```tsx
import {
  Transition,
  Collapse,
  Fade,
  Rotate,
  Scale,
  Slide,
  Translate,
} from '@mezzanine-ui/react';

<Fade in={visible}><div>Fade in/out content</div></Fade>
<Collapse in={expanded}><div>Collapsible content</div></Collapse>
<Slide in={visible} direction="up"><div>Slide content</div></Slide>
<Scale in={visible}><div>Scale content</div></Scale>
<Rotate in={visible}><div>Rotate content</div></Rotate>
<Translate in={visible} from="bottom"><div>Translate content</div></Translate>
```

---

### Popper

Positioning component for managing floating element placement.

```tsx
import { Popper } from '@mezzanine-ui/react';

<Popper
  open={open}
  anchorRef={anchorRef}
  placement="bottom-start"
  onPlacementChange={(resolved) => console.log(resolved)}
>
  Floating content
</Popper>
```

> **v1.4.0**: New `onPlacementChange` callback — fires with the placement resolved by floating-ui, including middleware-driven flips (e.g. `flip()`).

---

### Portal

Portal component that renders children outside the DOM tree.

```tsx
import { Portal } from '@mezzanine-ui/react';

<Portal>
  <div>Content rendered to body</div>
</Portal>
```

---

### Calendar / RangeCalendar

Calendar component, the underlying component for date pickers.

```tsx
import {
  Calendar,
  RangeCalendar,
  CalendarConfigProvider,
  useCalendarControls,
  useCalendarModeStack,
} from '@mezzanine-ui/react';

<Calendar value={date} onChange={setDate} />
<RangeCalendar value={dateRange} onChange={setDateRange} />
```

> **v1.5.0**: `RangeCalendarProps` gains `previewValue` — `RangeCalendar` now reads the committed range (not the hover-polluted internal calendar value) to decide whether a click starts or closes a range, fixing `DateRangePicker` hover previews that used to wipe out an already-selected start date. The disabled-date scan used for range validation was also moved into `RangeCalendar`, runs only when a `disabledDate` predicate is supplied, and is capped by an internal step limit (`maxRangeScanSteps` in `useRangeScan.ts` — **not a public prop**) to avoid multi-second freezes on very large or mistyped ranges.

---

### TimePanel

Time panel component, the underlying component for time pickers.

```tsx
import { TimePanel, TimePanelColumn } from '@mezzanine-ui/react';

<TimePanel value={time} onChange={setTime} />
```

---

### Notifier

Notifier utility component.

```tsx
import { createNotifier } from '@mezzanine-ui/react';
import type { Notifier } from '@mezzanine-ui/react';
```

---

## Internal Components

> The following are internal components, exported only for advanced customization.

### ClearActions *(sub-path only — 從未在主入口匯出)*

**Not removed, not deprecated.** `ClearActions` source still exists (`src/ClearActions/`) and has never had an `@deprecated` marker — it simply was never re-exported from the main entry, from `0.0.1` through `1.5.1`. Import via `@mezzanine-ui/react/ClearActions` sub-path when needed.

---

### Scrollbar *(sub-path only — 從未在主入口匯出)*

**Not removed, not deprecated.** `Scrollbar` source still exists (`src/Scrollbar/`) and has never had an `@deprecated` marker — it simply was never re-exported from the main entry, from `0.0.1` through `1.5.1`. Import via `@mezzanine-ui/react/Scrollbar` sub-path, or use native scrolling / custom CSS scrollbar styles.

---

### Picker

Internal shared Picker base components and hooks, used by DatePicker, DateRangePicker, TimePicker, TimeRangePicker, DateTimePicker, etc.

```tsx
import {
  PickerTrigger,
  RangePickerTrigger,
  usePickerDocumentEventClose,
  usePickerValue,
  useTabKeyClose,
} from '@mezzanine-ui/react';
```

---

### Dropdown

Dropdown container component. Internal but available for advanced customization.

```tsx
import {
  Dropdown,
  DropdownAction,
  DropdownItem,
  DropdownItemCard,
  DropdownStatus,
} from '@mezzanine-ui/react';

<Dropdown open={open}>
  <DropdownItem value="option1">Option 1</DropdownItem>
  <DropdownItem value="option2">Option 2</DropdownItem>
  <DropdownAction onClick={handleAction}>Action</DropdownAction>
</Dropdown>

// v1.2.0+: opt-in viewport-aware flip (main-axis only, keeps sameWidth alignment)
<Dropdown flip sameWidth open={open}>
  <DropdownItem value="option1">Option 1</DropdownItem>
</Dropdown>

// v1.5.0+: opt-in viewport-aware shift (cross-axis only, for menus near a left/right edge)
<Dropdown flip shift open={open}>
  <DropdownItem value="option1">Option 1</DropdownItem>
</Dropdown>
```

> **v1.2.0**: New opt-in `flip?: boolean` prop (default `false`). **v1.4.0**: enter-transition direction now follows the placement floating-ui actually resolves to after a flip. **v1.5.0**: New opt-in `shift?: boolean` prop (default `false`) — floating-ui `shift` middleware, ordered after `flip`; slides the menu along the cross axis to stay inside the viewport (e.g. `Table`'s last-column row-action menu, which enables it internally).

---

## Hooks

### General Hooks

| Hook                         | Description                         |
| ---------------------------- | ----------------------------------- |
| `useClickAway`               | Detect clicks outside an element    |
| `useComposeRefs`             | Compose multiple refs               |
| `useDelayMouseEnterLeave`    | Delay mouse enter/leave events      |
| `useDocumentEscapeKeyDown`   | Handle ESC key press                |
| `useDocumentEvents`          | Listen to document events           |
| `useDocumentTabKeyDown`      | Handle Tab key press                |
| `useIsomorphicLayoutEffect`  | SSR-safe layout effect              |
| `useLastCallback`            | Latest callback reference           |
| `useLastValue`               | Latest value reference              |
| `usePreviousValue`           | Store previous value                |
| `useScrollLock`              | Lock scrolling                      |
| `useTopStack`                | Manage stack layers                 |
| `useWindowWidth`             | Get window width                    |

### Form Hooks

| Hook                           | Description                    |
| ------------------------------ | ------------------------------ |
| `useAutoCompleteValueControl`  | AutoComplete value management  |
| `useCheckboxControlValue`      | Checkbox value management      |
| `useControlValueState`         | Generic controlled value state |
| `useCustomControlValue`        | Custom control value management|
| `useInputControlValue`         | Input controlled value management |
| `useInputWithClearControlValue`| Input with clear value management |
| `useRadioControlValue`         | Radio value management         |
| `useSelectValueControl`        | Select value management        |
| `useSwitchControlValue`        | Switch value management        |

### Component Hooks

| Hook                           | Description                          |
| ------------------------------ | ------------------------------------ |
| `useCalendarContext`           | Calendar context access              |
| `useCalendarControlModifiers`  | Calendar control modifiers           |
| `useCalendarControls`          | Calendar control state management    |
| `useCalendarModeStack`         | Calendar mode stack management       |
| `useDateRangeCalendarControls` | DateRangePicker calendar controls    |
| `useDateRangePickerValue`      | DateRangePicker value management     |
| `useFocusTrap`                 | **New in 1.5.0.** Dialog focus-trap model — moves focus in on open, cycles Tab/Shift+Tab within the container, restores focus on close; used internally by `Modal` / `MediaPreviewModal` |
| `useModalContainer`            | Modal container management           |
| `useMultipleDatePickerValue`   | MultipleDatePicker value management  |
| `usePagination`                | Pagination state management          |
| `usePickerDocumentEventClose`  | Picker document event close          |
| `usePickerValue`               | Picker generic value management      |
| `useRangeCalendarControls`     | RangeCalendar control state management |
| `useSlider`                    | Slider state management              |
| `useStepper`                   | Stepper state management             |
| `useTabKeyClose`               | Picker Tab key close                 |
| `useTableContext`              | Table context access                 |
| `useTableDataContext`          | Table data context access            |
| `useTableDataSource`           | Table data source management         |
| `useTableRowSelection`         | Table row selection management       |
| `useTableSuperContext`         | Table super context access           |
| `useTimeRangePickerValue`      | TimeRangePicker value management     |
