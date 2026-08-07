# Figma to Code Mapping

Maps Figma design file components to React code.

> Baseline: `@mezzanine-ui/react` `1.4.2` · `@mezzanine-ui/core` `1.1.0` · `@mezzanine-ui/system` / `@mezzanine-ui/icons` `1.0.2`. Last verified: 2026-08-07.

## Table of Contents

- [Figma File Info](#figma-file-info)
- [Figma REST API](#figma-rest-api)
- [Icon Mapping](#icon-mapping)
- [UI Component Mapping](#ui-component-mapping)
- [Design Token Mapping](#design-token-mapping)

---

## Figma File Info

| File           | File Key                   | Purpose                        |
| -------------- | -------------------------- | ------------------------------ |
| Component file | `gjGdP49GQZzOeQf0bNOFlt`  | Component definitions & variants |
| Document file  | `VgnrTeu6oOSE0giftMw1Oy`  | Design specs & documentation   |

---

## Figma REST API

### Getting Node ID from Figma URL

Figma URL format: `https://figma.com/design/:fileKey/:fileName?node-id=1-2`

- Extract `node-id` parameter from URL (e.g., `1-2`)
- Replace `-` with `:` to get nodeId (e.g., `1:2`)

### Common API Queries

```bash
# Get file structure
curl -s -H "X-Figma-Token: $MEZZANINE_FIGMA_TOKEN" \
  "https://api.figma.com/v1/files/gjGdP49GQZzOeQf0bNOFlt"

# Get all components
curl -s -H "X-Figma-Token: $MEZZANINE_FIGMA_TOKEN" \
  "https://api.figma.com/v1/files/gjGdP49GQZzOeQf0bNOFlt/components"

# Get specific node
curl -s -H "X-Figma-Token: $MEZZANINE_FIGMA_TOKEN" \
  "https://api.figma.com/v1/files/gjGdP49GQZzOeQf0bNOFlt/nodes?ids=<node-id>"

# Get design variables
curl -s -H "X-Figma-Token: $MEZZANINE_FIGMA_TOKEN" \
  "https://api.figma.com/v1/files/VgnrTeu6oOSE0giftMw1Oy/variables/local"

# Get component screenshots
curl -s -H "X-Figma-Token: $MEZZANINE_FIGMA_TOKEN" \
  "https://api.figma.com/v1/images/gjGdP49GQZzOeQf0bNOFlt?ids=<node-id>&format=png"
```

---

## Icon Mapping

### Alert Icons

| Figma Node                                    | React Component           |
| --------------------------------------------- | ------------------------- |
| `Icons / Alert / Checked-Filled`              | `CheckedFilledIcon`       |
| `Icons / Alert / Checked-Outline`             | `CheckedOutlineIcon`      |
| `Icons / Alert / Error-Filled`                | `ErrorFilledIcon`         |
| `Icons / Alert / Error-Outline`               | `ErrorOutlineIcon`        |
| `Icons / Alert / Warning-Filled`              | `WarningFilledIcon`       |
| `Icons / Alert / Warning-Outline`             | `WarningOutlineIcon`      |
| `Icons / Alert / Info-Filled`                 | `InfoFilledIcon`          |
| `Icons / Alert / Info-Outline`                | `InfoOutlineIcon`         |
| `Icons / Alert / Dangerous-Filled`            | `DangerousFilledIcon`     |
| `Icons / Alert / Dangerous-Outline`           | `DangerousOutlineIcon`    |
| `Icons / Alert / Question-Filled`             | `QuestionFilledIcon`      |
| `Icons / Alert / Question-Outline`            | `QuestionOutlineIcon`     |

### Arrow Icons

| Figma Node                               | React Component            |
| ---------------------------------------- | -------------------------- |
| `Icons / Arrow / Chevron Down`           | `ChevronDownIcon`          |
| `Icons / Arrow / Chevron Up`             | `ChevronUpIcon`            |
| `Icons / Arrow / Chevron Left`           | `ChevronLeftIcon`          |
| `Icons / Arrow / Chevron Right`          | `ChevronRightIcon`         |
| `Icons / Arrow / Caret Down`             | `CaretDownIcon`            |
| `Icons / Arrow / Caret Up`               | `CaretUpIcon`              |
| `Icons / Arrow / Caret Right`            | `CaretRightIcon`           |
| `Icons / Arrow / Long Tail Arrow Right`  | `LongTailArrowRightIcon`   |

### Controls Icons

| Figma Node                        | React Component      |
| --------------------------------- | -------------------- |
| `Icons / Controls / Close`        | `CloseIcon`          |
| `Icons / Controls / Plus`         | `PlusIcon`           |
| `Icons / Controls / Minus`        | `MinusIcon`          |
| `Icons / Controls / Trash`        | `TrashIcon`          |
| `Icons / Controls / Setting`      | `SettingIcon`        |
| `Icons / Controls / Filter`       | `FilterIcon`         |
| `Icons / Controls / Eye`          | `EyeIcon`            |
| `Icons / Controls / Eye-Invisible`| `EyeInvisibleIcon`   |
| `Icons / Controls / Lock`         | `LockIcon`           |
| `Icons / Controls / Unlock`       | `UnlockIcon`         |

### Content Icons

| Figma Node                        | React Component      |
| --------------------------------- | -------------------- |
| `Icons / Content / Edit`          | `EditIcon`           |
| `Icons / Content / Copy`          | `CopyIcon`           |
| `Icons / Content / Download`      | `DownloadIcon`       |
| `Icons / Content / Upload`        | `UploadIcon`         |

### System Icons

| Figma Node                        | React Component      |
| --------------------------------- | -------------------- |
| `Icons / System / Search`         | `SearchIcon`         |
| `Icons / System / Menu`           | `MenuIcon`           |
| `Icons / System / Home`           | `HomeIcon`           |
| `Icons / System / User`           | `UserIcon`           |
| `Icons / System / Calendar`       | `CalendarIcon`       |
| `Icons / System / Notification`   | `NotificationIcon`   |
| `Icons / System / Spinner`        | `SpinnerIcon`        |

> **Note**: Only a representative subset is listed here. See ICONS.md for the complete icon list (127 icons).

### Stepper Icons

| Figma Node                   | React Component               |
| ---------------------------- | ----------------------------- |
| `Icons / Stepper / 0`       | `Item0Icon`                   |
| `Icons / Stepper / 1`       | `Item1Icon`                   |
| `Icons / Stepper / 2` ~ `9` | `Item2Icon` ~ `Item9Icon`     |

---

## UI Component Mapping

### Deprecation Notice

The following components have been removed in v1.4.1 (deprecated since v1.1.0) and are no longer available from the main entry:

- **ClearActions**: Removed. Implement close/clear buttons using a composition pattern.
- **ContentHeader**: Removed. Use `PageHeader` + `Section` or custom header elements instead.
- **Scrollbar**: Removed. Native browser scrolling is now the standard.
- **Switch**: Removed. Use **Toggle** component instead.

---

### Button

v2 uses a new variant naming system:

| Figma Variant                          | React Props                                              |
| -------------------------------------- | -------------------------------------------------------- |
| `Size=Main, Variant=Primary`          | `<Button size="main" variant="base-primary">`            |
| `Size=Main, Variant=Secondary`        | `<Button size="main" variant="base-secondary">`          |
| `Size=Main, Variant=Tertiary`         | `<Button size="main" variant="base-tertiary">`           |
| `Size=Main, Variant=Ghost`            | `<Button size="main" variant="base-ghost">`              |
| `Size=Main, Variant=Dashed`           | `<Button size="main" variant="base-dashed">`             |
| `Size=Main, Variant=Text-Link`        | `<Button size="main" variant="base-text-link">`          |
| `Size=Sub`                             | `<Button size="sub">`                                    |
| `Size=Minor`                           | `<Button size="minor">`                                  |
| `Variant=Destructive-Primary`         | `<Button variant="destructive-primary">`                 |
| `Variant=Destructive-Secondary`       | `<Button variant="destructive-secondary">`               |
| `Variant=Destructive-Ghost`           | `<Button variant="destructive-ghost">`                   |
| `State=Disabled`                       | `<Button disabled>`                                      |
| `State=Loading`                        | `<Button loading>`                                       |
| `Icon=Leading`                         | `<Button icon={PlusIcon} iconType="leading">`            |
| `Icon=Trailing`                        | `<Button icon={ChevronDownIcon} iconType="trailing">`    |
| `Icon=Only`                            | `<Button icon={PlusIcon} iconType="icon-only">`          |

**Size Mapping**

| Figma Size | v2 size prop     |
| ---------- | ---------------- |
| Main       | `size="main"`    |
| Sub        | `size="sub"`     |
| Minor      | `size="minor"`   |

**Variant Mapping**

| Figma Variant Type        | v2 variant prop                       |
| ------------------------- | ------------------------------------- |
| Primary                   | `variant="base-primary"`              |
| Secondary                 | `variant="base-secondary"`            |
| Tertiary                  | `variant="base-tertiary"`             |
| Ghost                     | `variant="base-ghost"`                |
| Dashed                    | `variant="base-dashed"`               |
| Text-Link                 | `variant="base-text-link"`            |
| Destructive Primary       | `variant="destructive-primary"`       |
| Destructive Secondary     | `variant="destructive-secondary"`     |
| Destructive Ghost         | `variant="destructive-ghost"`         |
| Destructive Text-Link     | `variant="destructive-text-link"`     |
| Inverse                   | `variant="inverse"`                   |
| Inverse Ghost             | `variant="inverse-ghost"`             |

### Input / TextField

| Figma Variant              | React Props                              |
| -------------------------- | ---------------------------------------- |
| `Input / Size=Main`       | `<Input size="main">`                    |
| `Input / Size=Sub`        | `<Input size="sub">`                     |
| `TextField / Prefix`      | `<TextField prefix={<SearchIcon />}>`    |
| `TextField / Suffix`      | `<TextField suffix={<CloseIcon />}>`     |
| `TextField / Error`       | `<TextField error>`                      |

### Select

| Figma Variant              | React Props                              |
| -------------------------- | ---------------------------------------- |
| `Select / Size=Main`      | `<Select size="main">`                   |
| `Select / Size=Sub`       | `<Select size="sub">`                    |
| `Select / Multiple`       | `<Select mode="multiple">`               |

### Checkbox / Radio

| Figma Variant                  | React Props                              |
| ------------------------------ | ---------------------------------------- |
| `Checkbox / Unchecked`         | `<Checkbox>`                             |
| `Checkbox / Checked`           | `<Checkbox checked>`                     |
| `Checkbox / Indeterminate`     | `<Checkbox indeterminate>`               |
| `Checkbox / Disabled`          | `<Checkbox disabled>`                    |
| `Radio / Unchecked`            | `<Radio>`                                |
| `Radio / Checked`              | `<Radio checked>`                        |
| `RadioGroup`                   | `<RadioGroup>`                           |

### Switch *(已移除 v1.4.1)*

⚠️ Switch component has been removed in v1.4.1 (deprecated since v1.1.0). Use Toggle instead.

| Figma Variant              | React Props                              |
| -------------------------- | ---------------------------------------- |
| `Switch / Off`             | ~~`<Switch checked={false}>`~~ Use Toggle |
| `Switch / On`              | ~~`<Switch checked>`~~ Use Toggle         |
| `Switch / Disabled`        | ~~`<Switch disabled>`~~ Use Toggle        |

### Toggle

| Figma Variant              | React Props                              |
| -------------------------- | ---------------------------------------- |
| `Toggle / Off`             | `<Toggle checked={false}>`               |
| `Toggle / On`              | `<Toggle checked>`                       |
| `Toggle / Disabled`        | `<Toggle disabled>`                      |

### DatePicker

| Figma Variant              | React Props                              |
| -------------------------- | ---------------------------------------- |
| `DatePicker / Date`        | `<DatePicker>`                           |
| `DatePicker / DateTime`    | `<DateTimePicker>`                       |
| `DatePicker / Range`       | `<DateRangePicker>`                      |

### Table

| Figma Variant              | React Props                                              |
| -------------------------- | -------------------------------------------------------- |
| `Table / Basic`            | `<Table>`                                                |
| `Table / Selection`        | Use `useTableRowSelection` hook                          |
| `Table / Fixed Column`     | `column.fixed: 'left' \| 'right'`                       |
| `Table / Virtual`          | `<Table scroll={{ virtualized: true, y: 420 }}>`         |

### Modal

| Figma Variant              | React Props                                              |
| -------------------------- | -------------------------------------------------------- |
| `Modal / Basic`            | `<Modal>`                                                |
| `Modal / With Header`      | `<Modal><ModalHeader>...</ModalHeader></Modal>`          |
| `Modal / With Footer`      | `<Modal><ModalFooter>...</ModalFooter></Modal>`          |

### Drawer

| Figma Variant              | React Props                                              |
| -------------------------- | -------------------------------------------------------- |
| `Drawer / Right`           | `<Drawer><DrawerHeader title="Title" /><DrawerBody>...</DrawerBody></Drawer>` |
| `Drawer / Left`            | `<Drawer><DrawerHeader title="Title" /><DrawerBody>...</DrawerBody></Drawer>` |
| `Drawer / Top`             | `<Drawer><DrawerHeader title="Title" /><DrawerBody>...</DrawerBody></Drawer>` |
| `Drawer / Bottom`          | `<Drawer><DrawerHeader title="Title" /><DrawerBody>...</DrawerBody></Drawer>` |

### Navigation

| Figma Variant              | React Component                  |
| -------------------------- | -------------------------------- |
| `Navigation / Header`      | `<NavigationHeader>`             |
| `Navigation / Option`      | `<NavigationOption>`             |
| `Navigation / Category`    | `<NavigationOptionCategory>`     |
| `Navigation / Footer`      | `<NavigationFooter>`             |
| `Navigation / UserMenu`    | `<NavigationUserMenu>`           |

### Tabs

| Figma Variant              | React Props                      |
| -------------------------- | -------------------------------- |
| `Tabs / Horizontal`        | `<Tab>`                          |
| `Tab / Item`               | `<TabItem>`                      |

### Empty State

| Figma Variant                  | React Props                              |
| ------------------------------ | ---------------------------------------- |
| `Empty / Default`              | `<Empty>`                                |
| `Empty / With Description`     | `<Empty title="Description text">`       |

### AlertBanner

| Figma Variant                   | React Props                        |
| ------------------------------- | ---------------------------------- |
| `AlertBanner / Warning`         | `<AlertBanner severity="warning">` |
| `AlertBanner / Error`           | `<AlertBanner severity="error">`   |
| `AlertBanner / Info`            | `<AlertBanner severity="info">`    |
| `AlertBanner / With Close`      | `<AlertBanner closable>`           |

### Tag

| Figma Variant              | React Props                                                      |
| -------------------------- | ---------------------------------------------------------------- |
| `Tag / Static`             | `<Tag type="static" label="Label">`                              |
| `Tag / Counter`            | `<Tag type="counter" label="Label" count={3}>`                   |
| `Tag / Overflow Counter`   | `<Tag type="overflow-counter" count={5}>`                        |
| `Tag / Dismissable`        | `<Tag type="dismissable" label="Label" onClose={handler}>`       |
| `Tag / Addable`            | `<Tag type="addable" label="Label">`                             |

### Badge

| Figma Variant              | React Props                              |
| -------------------------- | ---------------------------------------- |
| `Badge / Count`            | `<Badge variant="count-alert" count={5}>`|
| `Badge / Dot`              | `<Badge variant="dot-success">`          |

### Tooltip

| Figma Variant              | React Props                              |
| -------------------------- | ---------------------------------------- |
| `Tooltip / Top`            | `<Tooltip placement="top">`              |
| `Tooltip / Bottom`         | `<Tooltip placement="bottom">`           |
| `Tooltip / Left`           | `<Tooltip placement="left">`             |
| `Tooltip / Right`          | `<Tooltip placement="right">`            |

### Progress / Skeleton / Spin

| Figma Variant              | React Component              |
| -------------------------- | ---------------------------- |
| `Progress / Line`          | `<Progress>`                 |
| `Skeleton`                 | `<Skeleton>`                 |
| `Spin`                     | `<Spin>`                     |

---

## Design Token Mapping

v2 uses a **Primitives + Semantic** two-layer architecture.

### Primitives Colors

Base color values for defining raw colors.

| Figma Variable         | CSS Variable Format                           | Example                               |
| ---------------------- | --------------------------------------------- | ------------------------------------- |
| `Brand/{scale}`        | `--mzn-color-primitive-brand-{scale}`         | `--mzn-color-primitive-brand-500`     |
| `Red/{scale}`          | `--mzn-color-primitive-red-{scale}`           | `--mzn-color-primitive-red-500`       |
| `Yellow/{scale}`       | `--mzn-color-primitive-yellow-{scale}`        | `--mzn-color-primitive-yellow-500`    |
| `Green/{scale}`        | `--mzn-color-primitive-green-{scale}`         | `--mzn-color-primitive-green-500`     |
| `Blue/{scale}`         | `--mzn-color-primitive-blue-{scale}`          | `--mzn-color-primitive-blue-500`      |
| `Gray/{scale}`         | `--mzn-color-primitive-gray-{scale}`          | `--mzn-color-primitive-gray-500`      |

**Scale**: 25, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950

### Semantic Colors

Named by usage context, automatically supporting light/dark mode switching.

**Background Colors** (33 types)

| Figma Variable                   | CSS Variable                                |
| -------------------------------- | ------------------------------------------- |
| `Background/Base`                | `--mzn-color-background-base`               |
| `Background/Menu`                | `--mzn-color-background-menu`               |
| `Background/Inverse`             | `--mzn-color-background-inverse`            |
| `Background/Fixed-Dark`          | `--mzn-color-background-fixed-dark`         |
| `Background/Neutral-Ghost`       | `--mzn-color-background-neutral-ghost`      |
| `Background/Neutral-Faint`       | `--mzn-color-background-neutral-faint`      |
| `Background/Neutral-Subtle`      | `--mzn-color-background-neutral-subtle`     |
| `Background/Neutral`             | `--mzn-color-background-neutral`            |
| `Background/Neutral-Strong`      | `--mzn-color-background-neutral-strong`     |
| `Background/Neutral-Solid`       | `--mzn-color-background-neutral-solid`      |
| `Background/Brand-Ghost`         | `--mzn-color-background-brand-ghost`        |
| `Background/Brand-Faint`         | `--mzn-color-background-brand-faint`        |
| `Background/Brand-Subtle`        | `--mzn-color-background-brand-subtle`       |
| `Background/Brand-Light`         | `--mzn-color-background-brand-light`        |
| `Background/Brand`               | `--mzn-color-background-brand`              |
| `Background/Brand-Strong`        | `--mzn-color-background-brand-strong`       |
| `Background/Brand-Solid`         | `--mzn-color-background-brand-solid`        |
| `Background/Error-Ghost`         | `--mzn-color-background-error-ghost`        |
| `Background/Error-Faint`         | `--mzn-color-background-error-faint`        |
| `Background/Error-Subtle`        | `--mzn-color-background-error-subtle`       |
| `Background/Error-Light`         | `--mzn-color-background-error-light`        |
| `Background/Error`               | `--mzn-color-background-error`              |
| `Background/Error-Strong`        | `--mzn-color-background-error-strong`       |
| `Background/Error-Solid`         | `--mzn-color-background-error-solid`        |
| `Background/Warning-Ghost`       | `--mzn-color-background-warning-ghost`      |
| `Background/Warning-Faint`       | `--mzn-color-background-warning-faint`      |
| `Background/Warning`             | `--mzn-color-background-warning`            |
| `Background/Success-Ghost`       | `--mzn-color-background-success-ghost`      |
| `Background/Success-Faint`       | `--mzn-color-background-success-faint`      |
| `Background/Success`             | `--mzn-color-background-success`            |
| `Background/Info-Ghost`          | `--mzn-color-background-info-ghost`         |
| `Background/Info-Faint`          | `--mzn-color-background-info-faint`         |
| `Background/Info`                | `--mzn-color-background-info`               |

**Text Colors** (17 types)

| Figma Variable             | CSS Variable                            |
| -------------------------- | --------------------------------------- |
| `Text/Fixed-Light`         | `--mzn-color-text-fixed-light`          |
| `Text/Neutral-Faint`       | `--mzn-color-text-neutral-faint`        |
| `Text/Neutral-Light`       | `--mzn-color-text-neutral-light`        |
| `Text/Neutral`             | `--mzn-color-text-neutral`              |
| `Text/Neutral-Strong`      | `--mzn-color-text-neutral-strong`       |
| `Text/Neutral-Solid`       | `--mzn-color-text-neutral-solid`        |
| `Text/Brand`               | `--mzn-color-text-brand`                |
| `Text/Brand-Strong`        | `--mzn-color-text-brand-strong`         |
| `Text/Brand-Solid`         | `--mzn-color-text-brand-solid`          |
| `Text/Error`               | `--mzn-color-text-error`                |
| `Text/Error-Strong`        | `--mzn-color-text-error-strong`         |
| `Text/Error-Solid`         | `--mzn-color-text-error-solid`          |
| `Text/Warning`             | `--mzn-color-text-warning`              |
| `Text/Warning-Strong`      | `--mzn-color-text-warning-strong`       |
| `Text/Success`             | `--mzn-color-text-success`              |
| `Text/Info`                | `--mzn-color-text-info`                 |
| `Text/Info-Strong`         | `--mzn-color-text-info-strong`          |

**Border Colors** (11 types)

| Figma Variable                  | CSS Variable                                 |
| ------------------------------- | -------------------------------------------- |
| `Border/Fixed-Light`            | `--mzn-color-border-fixed-light`             |
| `Border/Fixed-Light-Alpha`      | `--mzn-color-border-fixed-light-alpha`       |
| `Border/Neutral-Faint`          | `--mzn-color-border-neutral-faint`           |
| `Border/Neutral-Light`          | `--mzn-color-border-neutral-light`           |
| `Border/Neutral`                | `--mzn-color-border-neutral`                 |
| `Border/Neutral-Strong`         | `--mzn-color-border-neutral-strong`          |
| `Border/Brand`                  | `--mzn-color-border-brand`                   |
| `Border/Error-Subtle`           | `--mzn-color-border-error-subtle`            |
| `Border/Error`                  | `--mzn-color-border-error`                   |
| `Border/Warning-Subtle`         | `--mzn-color-border-warning-subtle`          |
| `Border/Warning`                | `--mzn-color-border-warning`                 |

**Icon Colors** (19 types)

| Figma Variable              | CSS Variable                             |
| --------------------------- | ---------------------------------------- |
| `Icon/Fixed-Light`          | `--mzn-color-icon-fixed-light`           |
| `Icon/Neutral-Faint`        | `--mzn-color-icon-neutral-faint`         |
| `Icon/Neutral-Light`        | `--mzn-color-icon-neutral-light`         |
| `Icon/Neutral`              | `--mzn-color-icon-neutral`               |
| `Icon/Neutral-Strong`       | `--mzn-color-icon-neutral-strong`        |
| `Icon/Neutral-Bold`         | `--mzn-color-icon-neutral-bold`          |
| `Icon/Neutral-Solid`        | `--mzn-color-icon-neutral-solid`         |
| `Icon/Brand`                | `--mzn-color-icon-brand`                 |
| `Icon/Brand-Strong`         | `--mzn-color-icon-brand-strong`          |
| `Icon/Brand-Solid`          | `--mzn-color-icon-brand-solid`           |
| `Icon/Error`                | `--mzn-color-icon-error`                 |
| `Icon/Error-Strong`         | `--mzn-color-icon-error-strong`          |
| `Icon/Error-Solid`          | `--mzn-color-icon-error-solid`           |
| `Icon/Warning`              | `--mzn-color-icon-warning`               |
| `Icon/Warning-Strong`       | `--mzn-color-icon-warning-strong`        |
| `Icon/Success`              | `--mzn-color-icon-success`               |
| `Icon/Success-Strong`       | `--mzn-color-icon-success-strong`        |
| `Icon/Info`                 | `--mzn-color-icon-info`                  |
| `Icon/Info-Strong`          | `--mzn-color-icon-info-strong`           |

### Semantic Spacing

| Figma Variable                            | CSS Variable Format                               |
| ----------------------------------------- | ------------------------------------------------- |
| `Spacing/Gap/{tone}`                      | `--mzn-spacing-gap-{tone}`                        |
| `Spacing/Padding/Horizontal/{tone}`       | `--mzn-spacing-padding-horizontal-{tone}`         |
| `Spacing/Padding/Vertical/{tone}`         | `--mzn-spacing-padding-vertical-{tone}`           |
| `Spacing/Size/Element/{tone}`             | `--mzn-spacing-size-element-{tone}`               |
| `Spacing/Size/Container/{tone}`           | `--mzn-spacing-size-container-{tone}`             |

**Gap Tones** (15): `none`, `micro`, `tiny`, `tight`, `compact`, `base`, `base-fixed`, `comfortable`, `roomy`, `spacious`, `relaxed`, `airy`, `generous`, `breath`, `wide`

**Padding Horizontal Tones** (18): `none`, `micro`, `tiny`, `tiny-fixed`, `tight`, `tight-fixed`, `base`, `base-fixed`, `calm`, `comfort`, `comfort-fixed`, `roomy`, `spacious`, `relaxed`, `airy`, `breath`, `wide`, `max`

**Padding Vertical Tones** (11): `none`, `micro`, `tiny`, `tight`, `base`, `calm`, `comfort`, `roomy`, `spacious`, `generous`, `relaxed`

**Size Element Tones** (18): `hairline`, `tiny`, `tight`, `compact`, `slim`, `narrow`, `base`, `base-fixed`, `gentle`, `relaxed`, `airy`, `roomy`, `loose`, `extra-wide`, `extra-wide-condense`, `expansive`, `extra`, `max`

**Size Container Tones** (12): `collapsed`, `tiny`, `tight`, `slim`, `narrow`, `compact`, `standard`, `balanced`, `broad`, `wide`, `expanded`, `max`

### Typography (20 types)

| Figma Style                           | CSS Variable                                  | Font Size | Font Weight    |
| ------------------------------------- | --------------------------------------------- | --------- | -------------- |
| `Typography/H1`                       | `--mzn-typography-h1-*`                       | 24px      | 600 (semibold) |
| `Typography/H2`                       | `--mzn-typography-h2-*`                       | 18px      | 600 (semibold) |
| `Typography/H3`                       | `--mzn-typography-h3-*`                       | 16px      | 600 (semibold) |
| `Typography/Body`                     | `--mzn-typography-body-*`                     | 14px      | 400 (regular)  |
| `Typography/Body-Highlight`           | `--mzn-typography-body-highlight-*`           | 14px      | 500 (medium)   |
| `Typography/Body-Mono`                | `--mzn-typography-body-mono-*`                | 14px      | 400 (regular)  |
| `Typography/Body-Mono-Highlight`      | `--mzn-typography-body-mono-highlight-*`      | 14px      | 500 (medium)   |
| `Typography/Text-Link-Body`           | `--mzn-typography-text-link-body-*`           | 14px      | 400 (regular)  |
| `Typography/Text-Link-Caption`        | `--mzn-typography-text-link-caption-*`        | 12px      | 400 (regular)  |
| `Typography/Caption`                  | `--mzn-typography-caption-*`                  | 12px      | 400 (regular)  |
| `Typography/Caption-Highlight`        | `--mzn-typography-caption-highlight-*`        | 12px      | 600 (semibold) |
| `Typography/Annotation`               | `--mzn-typography-annotation-*`               | 10px      | 400 (regular)  |
| `Typography/Annotation-Highlight`     | `--mzn-typography-annotation-highlight-*`     | 10px      | 600 (semibold) |
| `Typography/Button`                   | `--mzn-typography-button-*`                   | 14px      | 400 (regular)  |
| `Typography/Button-Highlight`         | `--mzn-typography-button-highlight-*`         | 14px      | 500 (medium)   |
| `Typography/Input`                    | `--mzn-typography-input-*`                    | 14px      | 400 (regular)  |
| `Typography/Input-Mono`               | `--mzn-typography-input-mono-*`               | 14px      | 400 (regular)  |
| `Typography/Label-Primary`            | `--mzn-typography-label-primary-*`            | 14px      | 400 (regular)  |
| `Typography/Label-Primary-Highlight`  | `--mzn-typography-label-primary-highlight-*`  | 14px      | 500 (medium)   |
| `Typography/Label-Secondary`          | `--mzn-typography-label-secondary-*`          | 12px      | 400 (regular)  |

### Border Radius

| Figma Variable    | CSS Variable          | Value  |
| ----------------- | --------------------- | ------ |
| `Radius/None`     | `--mzn-radius-none`   | 0      |
| `Radius/XS`       | `--mzn-radius-xs`     | 2px    |
| `Radius/SM`       | `--mzn-radius-sm`     | 4px    |
| `Radius/Base`     | `--mzn-radius-base`   | 6px    |
| `Radius/MD`       | `--mzn-radius-md`     | 8px    |
| `Radius/LG`       | `--mzn-radius-lg`     | 12px   |
| `Radius/XL`       | `--mzn-radius-xl`     | 16px   |
| `Radius/Full`     | `--mzn-radius-full`   | 9999px |

### Theme and Density

**Theme Switching**

| Figma Mode | HTML Attribute                          |
| ---------- | --------------------------------------- |
| Light      | `<html data-theme="light">` or default |
| Dark       | `<html data-theme="dark">`             |

**Density Switching**

| Figma Mode | HTML Attribute                           |
| ---------- | ---------------------------------------- |
| Default    | Default                                  |
| Compact    | `<html data-density="compact">`          |
