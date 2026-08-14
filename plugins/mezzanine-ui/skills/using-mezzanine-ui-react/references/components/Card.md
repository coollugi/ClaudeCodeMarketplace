# Card Component

> **Category**: Data Display
>
> **Storybook**: `Data Display/Card`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Card) · Verified 1.4.1 (2026-07-01)

The Card system provides a set of structured card components for displaying different types of content. The v2 version splits cards into multiple specialized sub-components, each with clear use cases and type definitions. All card components support polymorphic rendering and can render as `div`, `a`, or custom components (e.g., Next.js `Link`).

> **Aliases** — Card · Tile · 卡片 · 商品卡 · 圖文卡 · Figma `Card / *`
> **Not for** — 頁面級的內容區塊（用 [`Section`](Section.md)）；可選取的卡片（用 [`SelectionCard`](SelectionCard.md)）

---

## Import

```tsx
import {
  BaseCard,
  BaseCardSkeleton,
  CardGroup,
  FourThumbnailCard,
  FourThumbnailCardSkeleton,
  QuickActionCard,
  QuickActionCardSkeleton,
  SingleThumbnailCard,
  SingleThumbnailCardSkeleton,
  Thumbnail,
} from '@mezzanine-ui/react';

// Note: ThumbnailCardInfo component is not exported from main entry '@mezzanine-ui/react', only its type ThumbnailCardInfoProps is exported.
// To use the component directly, import from the Card sub-path:
// import { ThumbnailCardInfo } from '@mezzanine-ui/react/Card';

import type {
  BaseCardComponent,
  BaseCardActionVariant,
  BaseCardType,
  BaseCardProps,
  BaseCardPropsCommon,
  BaseCardDefaultProps,
  BaseCardActionProps,
  BaseCardOverflowProps,
  BaseCardToggleProps,
  BaseCardComponentProps,
  BaseCardSkeletonProps,
  CardGroupProps,
  CardGroupLoadingType,
  FourThumbnailCardComponent,
  FourThumbnailCardType,
  FourThumbnailCardProps,
  FourThumbnailCardPropsCommon,
  FourThumbnailCardDefaultProps,
  FourThumbnailCardActionProps,
  FourThumbnailCardOverflowProps,
  FourThumbnailCardComponentProps,
  FourThumbnailCardSkeletonProps,
  QuickActionCardComponent,
  QuickActionCardMode,
  QuickActionCardProps,
  QuickActionCardPropsCommon,
  QuickActionCardWithIconProps,
  QuickActionCardWithTitleProps,
  QuickActionCardComponentProps,
  QuickActionCardSkeletonProps,
  SingleThumbnailCardComponent,
  SingleThumbnailCardType,
  SingleThumbnailCardProps,
  SingleThumbnailCardPropsCommon,
  SingleThumbnailCardDefaultProps,
  SingleThumbnailCardActionProps,
  SingleThumbnailCardOverflowProps,
  SingleThumbnailCardComponentProps,
  SingleThumbnailCardSkeletonProps,
  ThumbnailComponent,
  ThumbnailPropsBase,
  ThumbnailComponentProps,
  ThumbnailCardInfoProps,
} from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/data-display-card-basecard--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Polymorphic Rendering (Generic Export)

Card components exported from `@mezzanine-ui/react` main entry are actually Generic versions that support polymorphic rendering with generic parameters:

```tsx
// Main entry exports the Generic version (BaseCardGeneric as BaseCard)
import { BaseCard } from '@mezzanine-ui/react';

// Use with generic parameters directly
<BaseCard<'a'> component="a" href="/link" title="Link Card" type="default">
  Content
</BaseCard>
```

Corresponding Generic export names (usually not needed directly):

| Main Entry Name       | Actual Generic Name            |
| --------------------- | ------------------------------ |
| `BaseCard`            | `BaseCardGeneric`              |
| `FourThumbnailCard`   | `FourThumbnailCardGeneric`     |
| `QuickActionCard`     | `QuickActionCardGeneric`       |
| `SingleThumbnailCard` | `SingleThumbnailCardGeneric`   |
| `Thumbnail`           | `ThumbnailGeneric`             |

---

## Sub-components

### BaseCard

A general-purpose card component with title, description, content area, and optional header actions. The `type` attribute switches between four header action modes: no action (`default`), action button (`action`), dropdown menu (`overflow`), and toggle switch (`toggle`).

- **Default element**: `div`
- **Polymorphic rendering**: `'div' | 'a' | JSXElementConstructor<any>`

#### BaseCard Common Props (BaseCardPropsCommon)

| Property      | Type        | Default | Description                             |
| ------------- | ----------- | ------- | --------------------------------------- |
| `className`   | `string`    | -       | Custom CSS class name                   |
| `children`    | `ReactNode` | -       | Card content area                       |
| `disabled`    | `boolean`   | `false` | Whether disabled                        |
| `readOnly`    | `boolean`   | `false` | Whether read-only (no interactivity)    |
| `title`       | `string`    | -       | Card header title                       |
| `description` | `string`    | -       | Card header description                 |
| `component`   | `C`         | `'div'` | Root element or custom component to render |

#### BaseCard type="default" Props

Does not render any header action element. This is the default type.

| Property | Type        | Default     | Description        |
| -------- | ----------- | ----------- | ------------------ |
| `type`   | `'default'` | `'default'` | Type discriminator |

#### BaseCard type="action" Props

Renders a text-link button in the header action area.

| Property        | Type                                             | Default            | Description                    |
| --------------- | ------------------------------------------------ | ------------------ | ------------------------------ |
| `type`          | `'action'`                                       | -                  | Type discriminator (required)  |
| `actionName`    | `string`                                         | -                  | Action button text label (required) |
| `actionVariant` | `'base-text-link' \| 'destructive-text-link'`    | `'base-text-link'` | Action button style variant    |
| `onActionClick` | `(event: MouseEvent<HTMLButtonElement>) => void`  | -                  | Action button click handler    |

#### BaseCard type="overflow" Props

Renders a three-dot icon dropdown menu in the header action area.

| Property         | Type                               | Default | Description                    |
| ---------------- | ---------------------------------- | ------- | ------------------------------ |
| `type`           | `'overflow'`                       | -       | Type discriminator (required)  |
| `options`        | `DropdownOption[]`                 | -       | Dropdown options (required)    |
| `onOptionSelect` | `(option: DropdownOption) => void` | -       | Option select callback         |

#### BaseCard type="toggle" Props

Renders a toggle switch in the header action area.

| Property               | Type                                  | Default | Description                       |
| ---------------------- | ------------------------------------- | ------- | --------------------------------- |
| `type`                 | `'toggle'`                            | -       | Type discriminator (required)     |
| `checked`              | `boolean`                             | -       | Controlled toggle state           |
| `defaultChecked`       | `boolean`                             | -       | Default toggle state (uncontrolled) |
| `onToggleChange`       | `ChangeEventHandler<HTMLInputElement>` | -       | Toggle state change callback      |
| `toggleSize`           | `ToggleSize`                          | -       | Toggle switch size                |
| `toggleLabel`          | `string`                              | -       | Toggle switch label text          |
| `toggleSupportingText` | `string`                              | -       | Toggle switch supporting text     |

---

### QuickActionCard

A compact quick action card displaying an icon with title and optional subtitle. At least one of `icon` or `title` must be provided. Supports horizontal and vertical layout modes.

- **Default element**: `button`
- **Polymorphic rendering**: `'button' | 'a' | JSXElementConstructor<any>`

#### QuickActionCard Props

| Property    | Type                          | Default        | Description                                |
| ----------- | ----------------------------- | -------------- | ------------------------------------------ |
| `className` | `string`                      | -              | Custom CSS class name                      |
| `component` | `C`                           | `'button'`     | Root element or custom component to render |
| `disabled`  | `boolean`                     | `false`        | Whether disabled                           |
| `readOnly`  | `boolean`                     | `false`        | Whether read-only                          |
| `icon`      | `IconDefinition`              | -              | Icon to display (required when no `title`) |
| `title`     | `string`                      | -              | Card title (required when no `icon`)       |
| `subtitle`  | `string`                      | -              | Card subtitle                              |
| `mode`      | `'horizontal' \| 'vertical'` | `'horizontal'` | Layout mode                                |

---

### SingleThumbnailCard

A single thumbnail card with one image, optional tag, personal action button (e.g., favorite), and info area. The `type` attribute switches between three info area action modes. Card width is determined by the image child element.

- **Default element**: `div`
- **Polymorphic rendering**: `'div' | 'a' | JSXElementConstructor<any>`
- **Children restriction**: Only accepts **one** image element as `children`

#### SingleThumbnailCard Common Props (SingleThumbnailCardPropsCommon)

| Property                       | Type                                                              | Default | Description                                      |
| ------------------------------ | ----------------------------------------------------------------- | ------- | ------------------------------------------------ |
| `className`                    | `string`                                                          | -       | Custom CSS class name                            |
| `children`                     | `ReactNode`                                                       | -       | Single image element (required)                  |
| `component`                    | `C`                                                               | `'div'` | Root element or custom component to render       |
| `filetype`                     | `string`                                                          | -       | File extension (e.g., `'pdf'`, `'jpg'`) for badge |
| `personalActionIcon`           | `IconDefinition`                                                  | -       | Personal action button icon (e.g., favorite)     |
| `personalActionActiveIcon`     | `IconDefinition`                                                  | -       | Active state icon for personal action            |
| `personalActionActive`         | `boolean`                                                         | `false` | Whether personal action is active                |
| `personalActionOnClick`        | `(event: MouseEvent<HTMLButtonElement>, active: boolean) => void` | -       | Personal action button click handler             |
| `subtitle`                     | `string`                                                          | -       | Info area subtitle                               |
| `tag`                          | `string`                                                          | -       | Tag displayed above the thumbnail                |
| `title`                        | `string`                                                          | -       | Info area title (required)                       |

#### SingleThumbnailCard type="default" Props

Does not render any info area action element. This is the default type.

| Property | Type        | Default     | Description        |
| -------- | ----------- | ----------- | ------------------ |
| `type`   | `'default'` | `'default'` | Type discriminator |

#### SingleThumbnailCard type="action" Props

Renders a text-link button in the info area.

| Property        | Type                                             | Default | Description                    |
| --------------- | ------------------------------------------------ | ------- | ------------------------------ |
| `type`          | `'action'`                                       | -       | Type discriminator (required)  |
| `actionName`    | `string`                                         | -       | Action button text label (required) |
| `onActionClick` | `(event: MouseEvent<HTMLButtonElement>) => void`  | -       | Action button click handler    |

#### SingleThumbnailCard type="overflow" Props

Renders a three-dot icon dropdown menu in the info area.

| Property         | Type                               | Default | Description                    |
| ---------------- | ---------------------------------- | ------- | ------------------------------ |
| `type`           | `'overflow'`                       | -       | Type discriminator (required)  |
| `options`        | `DropdownOption[]`                 | -       | Dropdown options (required)    |
| `onOptionSelect` | `(option: DropdownOption) => void` | -       | Option select callback         |

---

### FourThumbnailCard

A four-thumbnail card displaying up to four images in a 2x2 grid, with optional tag, personal action button, and info area. Children must be `Thumbnail` components; empty slots are auto-filled when fewer than four are provided.

- **Default element**: `div`
- **Polymorphic rendering**: `'div' | 'a' | JSXElementConstructor<any>`
- **Children restriction**: Only accepts 1-4 `Thumbnail` components as `children`

#### FourThumbnailCard Common Props (FourThumbnailCardPropsCommon)

| Property                       | Type                                                              | Default | Description                                      |
| ------------------------------ | ----------------------------------------------------------------- | ------- | ------------------------------------------------ |
| `className`                    | `string`                                                          | -       | Custom CSS class name                            |
| `children`                     | `ReactNode`                                                       | -       | 1-4 Thumbnail components (required)              |
| `component`                    | `C`                                                               | `'div'` | Root element or custom component to render       |
| `filetype`                     | `string`                                                          | -       | File extension (e.g., `'pdf'`, `'jpg'`) for badge |
| `personalActionIcon`           | `IconDefinition`                                                  | -       | Personal action button icon (e.g., favorite)     |
| `personalActionActiveIcon`     | `IconDefinition`                                                  | -       | Active state icon for personal action            |
| `personalActionActive`         | `boolean`                                                         | `false` | Whether personal action is active                |
| `personalActionOnClick`        | `(event: MouseEvent<HTMLButtonElement>, active: boolean) => void` | -       | Personal action button click handler             |
| `subtitle`                     | `string`                                                          | -       | Info area subtitle                               |
| `tag`                          | `string`                                                          | -       | Tag displayed above the thumbnail grid           |
| `title`                        | `string`                                                          | -       | Info area title (required)                       |

#### FourThumbnailCard type="default" Props

Does not render any info area action element. This is the default type.

| Property | Type        | Default     | Description        |
| -------- | ----------- | ----------- | ------------------ |
| `type`   | `'default'` | `'default'` | Type discriminator |

#### FourThumbnailCard type="action" Props

Renders a text-link button in the info area.

| Property        | Type                                             | Default | Description                    |
| --------------- | ------------------------------------------------ | ------- | ------------------------------ |
| `type`          | `'action'`                                       | -       | Type discriminator (required)  |
| `actionName`    | `string`                                         | -       | Action button text label (required) |
| `onActionClick` | `(event: MouseEvent<HTMLButtonElement>) => void`  | -       | Action button click handler    |

#### FourThumbnailCard type="overflow" Props

Renders a three-dot icon dropdown menu in the info area.

| Property         | Type                               | Default | Description                    |
| ---------------- | ---------------------------------- | ------- | ------------------------------ |
| `type`           | `'overflow'`                       | -       | Type discriminator (required)  |
| `options`        | `DropdownOption[]`                 | -       | Dropdown options (required)    |
| `onOptionSelect` | `(option: DropdownOption) => void` | -       | Option select callback         |

---

### Thumbnail

A thumbnail sub-component designed for `FourThumbnailCard` children. Wraps images and displays a title overlay on hover. Supports polymorphic rendering as links or buttons.

- **Default element**: `div`
- **Polymorphic rendering**: `'div' | 'a' | 'button' | JSXElementConstructor<any>`

#### Thumbnail Props (ThumbnailPropsBase)

| Property    | Type        | Default | Description                           |
| ----------- | ----------- | ------- | ------------------------------------- |
| `className` | `string`    | -       | Custom CSS class name                 |
| `children`  | `ReactNode` | -       | Image element (required)              |
| `component` | `C`         | `'div'` | Root element or custom component to render |
| `title`     | `string`    | -       | Title text displayed on hover overlay |

---

### ThumbnailCardInfo

A shared card info area component used internally by `SingleThumbnailCard` and `FourThumbnailCard`. Renders filetype badge, title, subtitle, and action button/dropdown. Typically not used directly.

> **Note**: `ThumbnailCardInfo` component is not exported from `@mezzanine-ui/react` main entry; only its type `ThumbnailCardInfoProps` is exported.

#### ThumbnailCardInfo Props

| Property         | Type                                             | Default     | Description                                    |
| ---------------- | ------------------------------------------------ | ----------- | ---------------------------------------------- |
| `className`      | `string`                                         | -           | Custom CSS class name                          |
| `disabled`       | `boolean`                                        | `false`     | Whether action is disabled                     |
| `filetype`       | `string`                                         | -           | File extension for colored file badge          |
| `subtitle`       | `string`                                         | -           | Subtitle text                                  |
| `title`          | `string`                                         | -           | Title text                                     |
| `type`           | `'default' \| 'action' \| 'overflow'`            | `'default'` | Action type                                    |
| `actionName`     | `string`                                         | -           | Action button text (for type="action")         |
| `onActionClick`  | `(event: MouseEvent<HTMLButtonElement>) => void`  | -           | Action button click handler (for type="action") |
| `options`        | `DropdownOption[]`                               | -           | Dropdown options (for type="overflow")         |
| `onOptionSelect` | `(option: DropdownOption) => void`               | -           | Option select callback (for type="overflow")   |

---

### CardGroup

A card group container that uses CSS Grid to arrange cards of the same type in horizontal rows with consistent spacing. Supports loading skeleton display. Only accepts `BaseCard`, `QuickActionCard`, `SingleThumbnailCard`, `FourThumbnailCard` as children.

#### CardGroup Props

| Property                        | Type                                                                     | Default | Description                                                       |
| ------------------------------- | ------------------------------------------------------------------------ | ------- | ----------------------------------------------------------------- |
| `className`                     | `string`                                                                 | -       | Custom CSS class name                                             |
| `children`                      | `ReactNode`                                                              | -       | Card components (only the four card types above)                  |
| `loading`                       | `boolean`                                                                | `false` | Whether to show loading skeleton                                  |
| `loadingCount`                  | `number`                                                                 | `3`     | Number of loading skeletons                                       |
| `loadingType`                   | `'base' \| 'four-thumbnail' \| 'quick-action' \| 'single-thumbnail'`    | -       | Loading skeleton card type (required when `loading` is `true`)    |
| `loadingThumbnailWidth`         | `number \| string`                                                       | -       | Thumbnail skeleton width (for `single-thumbnail` and `four-thumbnail` only) |
| `loadingThumbnailAspectRatio`   | `string`                                                                 | -       | Thumbnail skeleton aspect ratio (e.g., `'16/9'`, `'4/3'`)        |

---

## Skeleton Variants

Each card type has a corresponding skeleton component for loading state placeholders.

### BaseCardSkeleton

Skeleton placeholder simulating `BaseCard` layout.

| Property      | Type      | Default | Description                      |
| ------------- | --------- | ------- | -------------------------------- |
| `className`   | `string`  | -       | Custom CSS class name            |
| `showContent` | `boolean` | `true`  | Whether to show content skeleton |

### FourThumbnailCardSkeleton

Skeleton placeholder simulating `FourThumbnailCard` layout, rendering a 2x2 skeleton grid. Internally uses `'4/3'` aspect ratio.

| Property         | Type               | Default | Description               |
| ---------------- | ------------------ | ------- | ------------------------- |
| `className`      | `string`           | -       | Custom CSS class name     |
| `thumbnailWidth` | `number \| string` | `200`   | Thumbnail skeleton width  |

### QuickActionCardSkeleton

Skeleton placeholder simulating `QuickActionCard` layout.

| Property    | Type                          | Default        | Description           |
| ----------- | ----------------------------- | -------------- | --------------------- |
| `className` | `string`                      | -              | Custom CSS class name |
| `mode`      | `'horizontal' \| 'vertical'` | `'horizontal'` | Layout mode           |

### SingleThumbnailCardSkeleton

Skeleton placeholder simulating `SingleThumbnailCard` layout.

| Property               | Type               | Default                                      | Description                  |
| ---------------------- | ------------------ | -------------------------------------------- | ---------------------------- |
| `className`            | `string`           | -                                            | Custom CSS class name        |
| `thumbnailWidth`       | `number \| string` | `'var(--mzn-spacing-size-container-slim)'`   | Thumbnail skeleton width     |
| `thumbnailAspectRatio` | `string`           | `'16/9'`                                     | Thumbnail skeleton aspect ratio |

---

## Type Definitions

### BaseCard Related Types

```typescript
type BaseCardComponent = 'div' | 'a' | JSXElementConstructor<any>;

type BaseCardActionVariant = 'base-text-link' | 'destructive-text-link';

type BaseCardType = 'default' | 'action' | 'overflow' | 'toggle';

// Union type, discriminated by type for different Props shapes
type BaseCardProps =
  | BaseCardDefaultProps
  | BaseCardActionProps
  | BaseCardOverflowProps
  | BaseCardToggleProps;

// Complete Props type with polymorphic rendering
type BaseCardComponentProps<C extends BaseCardComponent = 'div'> =
  ComponentOverridableForwardRefComponentPropsFactory<
    BaseCardComponent,
    C,
    BaseCardProps
  >;
```

### QuickActionCard Related Types

```typescript
type QuickActionCardComponent = 'button' | 'a' | JSXElementConstructor<any>;

type QuickActionCardMode = 'horizontal' | 'vertical';

// Union type, requires at least icon or title
type QuickActionCardProps =
  | QuickActionCardWithIconProps
  | QuickActionCardWithTitleProps;

type QuickActionCardComponentProps<C extends QuickActionCardComponent = 'button'> =
  ComponentOverridableForwardRefComponentPropsFactory<
    QuickActionCardComponent,
    C,
    QuickActionCardProps
  >;
```

### SingleThumbnailCard Related Types

```typescript
type SingleThumbnailCardComponent = 'div' | 'a' | JSXElementConstructor<any>;

type SingleThumbnailCardType = 'default' | 'action' | 'overflow';

type SingleThumbnailCardProps =
  | SingleThumbnailCardDefaultProps
  | SingleThumbnailCardActionProps
  | SingleThumbnailCardOverflowProps;

type SingleThumbnailCardComponentProps<C extends SingleThumbnailCardComponent = 'div'> =
  ComponentOverridableForwardRefComponentPropsFactory<
    SingleThumbnailCardComponent,
    C,
    SingleThumbnailCardProps
  >;
```

### FourThumbnailCard Related Types

```typescript
type FourThumbnailCardComponent = 'div' | 'a' | JSXElementConstructor<any>;

type FourThumbnailCardType = 'default' | 'action' | 'overflow';

type FourThumbnailCardProps =
  | FourThumbnailCardDefaultProps
  | FourThumbnailCardActionProps
  | FourThumbnailCardOverflowProps;

type FourThumbnailCardComponentProps<C extends FourThumbnailCardComponent = 'div'> =
  ComponentOverridableForwardRefComponentPropsFactory<
    FourThumbnailCardComponent,
    C,
    FourThumbnailCardProps
  >;
```

### Thumbnail Related Types

```typescript
type ThumbnailComponent = 'a' | 'button' | 'div' | JSXElementConstructor<any>;

interface ThumbnailPropsBase {
  className?: string;
  children: ReactNode;
  title?: string;
}

type ThumbnailComponentProps<C extends ThumbnailComponent = 'div'> =
  ComponentOverridableForwardRefComponentPropsFactory<
    ThumbnailComponent,
    C,
    ThumbnailPropsBase
  >;
```

### CardGroup Related Types

```typescript
type CardGroupLoadingType =
  | 'base'
  | 'four-thumbnail'
  | 'quick-action'
  | 'single-thumbnail';
```

---

## Usage Examples

### BaseCard -- Four type Modes

```tsx
import { useState } from 'react';
import { BaseCard } from '@mezzanine-ui/react';

function BaseCardExamples(): React.ReactElement {
  const [checked, setChecked] = useState(false);

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 16, width: 320 }}>
      {/* type="default": Title and description only, no header action */}
      <BaseCard
        title="Default Card"
        description="No header action element"
        type="default"
      >
        Card content area
      </BaseCard>

      {/* type="action": Header with text-link button */}
      <BaseCard
        type="action"
        title="Action Card"
        description="Header contains an action button"
        actionName="Edit"
        onActionClick={() => alert('Edit clicked')}
      >
        Click the header "Edit" button to trigger action.
      </BaseCard>

      {/* type="overflow": Header with three-dot dropdown menu */}
      <BaseCard
        type="overflow"
        title="Overflow Card"
        description="Header contains an options menu"
        options={[
          { id: 'edit', name: 'Edit' },
          { id: 'delete', name: 'Delete', validate: 'danger' },
        ]}
        onOptionSelect={(option) => alert(`Selected: ${option.name}`)}
      >
        Click the three-dot icon for more options.
      </BaseCard>

      {/* type="toggle": Header with toggle switch */}
      <BaseCard
        type="toggle"
        title="Toggle Card"
        description="Header contains a toggle switch"
        checked={checked}
        onToggleChange={(e) => setChecked(e.target.checked)}
      >
        Toggle state: {checked ? 'On' : 'Off'}
      </BaseCard>
    </div>
  );
}
```

### BaseCard -- Polymorphic Rendering as Link

```tsx
import { BaseCard } from '@mezzanine-ui/react';

function BaseCardAsLink(): React.ReactElement {
  return (
    <BaseCard<'a'>
      component="a"
      href="https://example.com"
      target="_blank"
      title="Clickable Link Card"
      description="The entire card is a hyperlink"
      type="default"
    >
      Clicking this card will open the link in a new tab.
    </BaseCard>
  );
}
```

### QuickActionCard -- Horizontal and Vertical Modes

```tsx
import { QuickActionCard, CardGroup } from '@mezzanine-ui/react';
import { CalendarIcon, FileIcon, UserIcon } from '@mezzanine-ui/icons';

function QuickActionCardExamples(): React.ReactElement {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 24 }}>
      {/* Horizontal mode (default) */}
      <CardGroup>
        <QuickActionCard
          icon={CalendarIcon}
          title="Calendar"
          subtitle="View schedule"
        />
        <QuickActionCard
          icon={FileIcon}
          title="Documents"
          subtitle="Browse files"
        />
        <QuickActionCard
          icon={UserIcon}
          title="Contacts"
          subtitle="Manage contacts"
        />
      </CardGroup>

      {/* Vertical mode */}
      <div style={{ display: 'flex', gap: 16 }}>
        <QuickActionCard
          icon={CalendarIcon}
          mode="vertical"
          title="Calendar"
          subtitle="View schedule"
        />
        <QuickActionCard
          icon={FileIcon}
          mode="vertical"
          title="Files"
          subtitle="Browse files"
        />
      </div>

      {/* As link */}
      <QuickActionCard<'a'>
        component="a"
        href="https://example.com"
        target="_blank"
        icon={FileIcon}
        title="External Link"
        subtitle="Opens in new tab"
      />
    </div>
  );
}
```

### SingleThumbnailCard -- Thumbnail Card with Favorite

```tsx
import { useState } from 'react';
import { SingleThumbnailCard, CardGroup } from '@mezzanine-ui/react';
import { StarOutlineIcon, StarFilledIcon } from '@mezzanine-ui/icons';

function SingleThumbnailCardExample(): React.ReactElement {
  const [isFavorite, setIsFavorite] = useState(false);

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 24 }}>
      {/* Full feature example */}
      <SingleThumbnailCard
        type="action"
        title="quarterly-report-q4.pdf"
        subtitle="Updated: 2024/01/15 - 2.4 MB"
        filetype="pdf"
        tag="Important"
        actionName="View Details"
        onActionClick={() => alert('View Details')}
        personalActionIcon={StarOutlineIcon}
        personalActionActiveIcon={StarFilledIcon}
        personalActionActive={isFavorite}
        personalActionOnClick={() => setIsFavorite(!isFavorite)}
      >
        <img
          alt="Document thumbnail"
          src="https://picsum.photos/320/180"
          style={{ display: 'block', width: '100%', aspectRatio: '16/9', objectFit: 'cover' }}
        />
      </SingleThumbnailCard>

      {/* In CardGroup */}
      <CardGroup>
        <SingleThumbnailCard filetype="jpg" subtitle="1920x1080" title="landscape.jpg">
          <img
            alt="Landscape"
            src="https://picsum.photos/seed/1/320/180"
            style={{ display: 'block', width: '100%', aspectRatio: '16/9', objectFit: 'cover' }}
          />
        </SingleThumbnailCard>
        <SingleThumbnailCard filetype="png" subtitle="800x600" title="portrait.png">
          <img
            alt="Portrait"
            src="https://picsum.photos/seed/2/320/180"
            style={{ display: 'block', width: '100%', aspectRatio: '16/9', objectFit: 'cover' }}
          />
        </SingleThumbnailCard>
      </CardGroup>
    </div>
  );
}
```

### FourThumbnailCard -- Four-Grid Thumbnails with Clickable Thumbnails

```tsx
import { useState } from 'react';
import { FourThumbnailCard, Thumbnail, CardGroup } from '@mezzanine-ui/react';
import { StarOutlineIcon, StarFilledIcon } from '@mezzanine-ui/icons';

function FourThumbnailCardExample(): React.ReactElement {
  const [isFavorite, setIsFavorite] = useState(false);

  const createImage = (seed: number): React.ReactElement => (
    <img
      alt={`Thumbnail ${seed}`}
      src={`https://picsum.photos/seed/${seed}/160/120`}
      style={{ display: 'block', objectFit: 'cover', width: 160, height: 120 }}
    />
  );

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 24 }}>
      {/* Basic usage */}
      <FourThumbnailCard
        filetype="jpg"
        subtitle="4 photos"
        title="Vacation Album"
      >
        <Thumbnail title="Beach">{createImage(10)}</Thumbnail>
        <Thumbnail title="Mountain">{createImage(11)}</Thumbnail>
        <Thumbnail title="City">{createImage(12)}</Thumbnail>
        <Thumbnail title="Forest">{createImage(13)}</Thumbnail>
      </FourThumbnailCard>

      {/* Thumbnail as link */}
      <FourThumbnailCard
        type="action"
        title="Marketing Assets"
        subtitle="4 items"
        filetype="png"
        actionName="View All"
        onActionClick={() => alert('View All')}
        personalActionIcon={StarOutlineIcon}
        personalActionActiveIcon={StarFilledIcon}
        personalActionActive={isFavorite}
        personalActionOnClick={() => setIsFavorite(!isFavorite)}
        tag="Important"
      >
        <Thumbnail<'a'> component="a" href="/photo/1" title="Link 1">
          {createImage(20)}
        </Thumbnail>
        <Thumbnail<'a'> component="a" href="/photo/2" title="Link 2">
          {createImage(21)}
        </Thumbnail>
        <Thumbnail<'a'> component="a" href="/photo/3" title="Link 3">
          {createImage(22)}
        </Thumbnail>
        <Thumbnail<'a'> component="a" href="/photo/4" title="Link 4">
          {createImage(23)}
        </Thumbnail>
      </FourThumbnailCard>

      {/* Auto-fills empty slots when fewer than four */}
      <FourThumbnailCard subtitle="2 photos" title="Partial Fill">
        <Thumbnail title="Photo 1">{createImage(30)}</Thumbnail>
        <Thumbnail title="Photo 2">{createImage(31)}</Thumbnail>
      </FourThumbnailCard>
    </div>
  );
}
```

### CardGroup -- Loading Skeleton

```tsx
import { CardGroup } from '@mezzanine-ui/react';

function CardGroupLoadingExamples(): React.ReactElement {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 32 }}>
      {/* BaseCard skeleton */}
      <CardGroup loading loadingCount={3} loadingType="base" />

      {/* QuickActionCard skeleton */}
      <CardGroup loading loadingCount={4} loadingType="quick-action" />

      {/* SingleThumbnailCard skeleton (custom size) */}
      <CardGroup
        loading
        loadingCount={3}
        loadingType="single-thumbnail"
        loadingThumbnailWidth={360}
        loadingThumbnailAspectRatio="16/9"
      />

      {/* FourThumbnailCard skeleton */}
      <CardGroup
        loading
        loadingCount={3}
        loadingType="four-thumbnail"
        loadingThumbnailWidth={160}
      />
    </div>
  );
}
```

---

## Structure Overview

Component hierarchy of the Card system:

```
CardGroup (Container)
├── BaseCard
│   ├── Header
│   │   ├── Title + Description
│   │   └── Action Area (varies by type: Button / Dropdown / Toggle)
│   └── Content (children)
│
├── QuickActionCard
│   ├── Icon
│   └── Content (Title + Subtitle)
│
├── SingleThumbnailCard
│   ├── Thumbnail Area
│   │   ├── Tag (optional)
│   │   ├── Personal Action Button (optional)
│   │   ├── Image (children, single only)
│   │   └── Overlay
│   └── ThumbnailCardInfo
│       ├── Filetype Badge + Title + Subtitle
│       └── Action Area (varies by type: Button / Dropdown)
│
└── FourThumbnailCard
    ├── Thumbnail Grid (2x2)
    │   ├── Tag (optional)
    │   ├── Personal Action Button (optional)
    │   ├── Thumbnail x 1-4 (sub-components)
    │   │   ├── Image (children)
    │   │   └── Hover Overlay (Title)
    │   └── Empty Slots (auto-filled)
    └── ThumbnailCardInfo
        ├── Filetype Badge + Title + Subtitle
        └── Action Area (varies by type: Button / Dropdown)
```

---

## Best Practices

1. **Use discriminated union types**: Use the `type` attribute to let TypeScript auto-infer available Props, avoiding incompatible property combinations.
2. **Polymorphic rendering**: When the entire card should be clickable, use `component="a"` with generic parameters (e.g., `BaseCard<'a'>`) instead of wrapping in a link element.
3. **Children restrictions**: `SingleThumbnailCard` only accepts one child element; `FourThumbnailCard` children must be `Thumbnail` components.
4. **Skeleton loading**: Use `CardGroup`'s `loading` related props to manage loading state uniformly, rather than manually rendering individual Skeleton components.
5. **Personal action button**: Provide both `personalActionIcon` and `personalActionActiveIcon` to visually distinguish active/inactive states.
6. **Event bubbling**: Action buttons and Personal Action buttons have built-in `stopPropagation`, preventing navigation when the card is a link.
7. **Filetype badge**: The `filetype` property automatically categorizes by file extension and applies corresponding color styles.
