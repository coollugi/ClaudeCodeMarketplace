# Mezzanine-UI Design Tokens

Foundation visual variable definitions for the design system. Mezzanine-UI uses a **Primitives + Semantic** two-layer architecture.

> Baseline: `@mezzanine-ui/react` `1.4.2` · `@mezzanine-ui/core` `1.1.0` · `@mezzanine-ui/system` / `@mezzanine-ui/icons` `1.0.2`. Last verified: 2026-08-07.
>
> Source: [GitHub](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/system/src)

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Primitives Color Palette](#primitives-color-palette)
- [Semantic Colors](#semantic-colors)
- [Spacing System](#spacing-system)
- [Typography System](#typography-system)
- [Border Radius](#border-radius)
- [Shadows](#shadows)
- [Sizes](#sizes)
- [Z-Index](#z-index)
- [Usage](#usage)

---

## Architecture Overview

v2 design tokens use a two-layer architecture:

1. **Primitives**: Raw value definitions (color values, spacing pixels, etc.)
2. **Semantic**: Named by usage context, referencing Primitives

> 💡 **Best Practice**: Always use Semantic tokens in applications for automatic theme switching support.

---

## Primitives Color Palette

Raw color values defined by category and scale.

### Color Categories

| Category     | Description    | Scale                                                        |
| ------------ | -------------- | ------------------------------------------------------------ |
| `brand`      | Brand color    | 25, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950   |
| `red`        | Error/Danger   | 25, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950   |
| `yellow`     | Warning        | 25, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950   |
| `green`      | Success        | 25, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950   |
| `blue`       | Info           | 25, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950   |
| `gray`       | Neutral gray   | 25, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950   |
| `white-base` | White series   | white, white-alpha-0~90                                      |
| `black-base` | Black series   | black, black-alpha-0~90                                      |
| `brand-base` | Brand opacity  | brand-alpha-10~90                                            |

### Brand Color

| Scale | Value     |
| ----- | --------- |
| 25    | `#FAFAFF` |
| 50    | `#F2F4FE` |
| 100   | `#E2E6FD` |
| 200   | `#C2CCFA` |
| 300   | `#9DAAF5` |
| 400   | `#7689EF` |
| 500   | `#5D74E9` |
| 600   | `#5265E1` |
| 700   | `#4353D6` |
| 800   | `#3340C2` |
| 900   | `#24318F` |
| 950   | `#1A2558` |

### Error Color (Red)

| Scale | Value     |
| ----- | --------- |
| 25    | `#FFFAFA` |
| 50    | `#FFF1F1` |
| 100   | `#FDDDDD` |
| 200   | `#FAB6B9` |
| 300   | `#F88B91` |
| 400   | `#F45D65` |
| 500   | `#F03740` |
| 600   | `#D03335` |
| 700   | `#B22B2D` |
| 800   | `#911F22` |
| 900   | `#6D1518` |
| 950   | `#4B0B0B` |

### Success Color (Green)

| Scale | Value     |
| ----- | --------- |
| 25    | `#F3FCF7` |
| 50    | `#E5F9EE` |
| 100   | `#C5F0D8` |
| 200   | `#94DFB8` |
| 300   | `#57C78F` |
| 400   | `#2BB26D` |
| 500   | `#139F62` |
| 600   | `#11985A` |
| 700   | `#0E754D` |
| 800   | `#0A5C41` |
| 900   | `#064130` |
| 950   | `#042B1B` |

### Warning Color (Yellow)

| Scale | Value     |
| ----- | --------- |
| 25    | `#FFFCF5` |
| 50    | `#FFFAEB` |
| 100   | `#FEF0C7` |
| 200   | `#FEDF89` |
| 300   | `#FEC84B` |
| 400   | `#FEB022` |
| 500   | `#F7900A` |
| 600   | `#DC6803` |
| 700   | `#B54708` |
| 800   | `#93370D` |
| 900   | `#7A2E0E` |
| 950   | `#4E1D09` |

### Info Color (Blue)

| Scale | Value     |
| ----- | --------- |
| 25    | `#F5FAFF` |
| 50    | `#EFF8FF` |
| 100   | `#D1E9FF` |
| 200   | `#B2DDFF` |
| 300   | `#84CAFF` |
| 400   | `#53B1FD` |
| 500   | `#2E90FA` |
| 600   | `#1570EF` |
| 700   | `#175CD3` |
| 800   | `#1849A9` |
| 900   | `#194185` |
| 950   | `#102A56` |

### Neutral Gray

| Scale | Value     |
| ----- | --------- |
| 25    | `#FBFBFC` |
| 50    | `#F9FAFB` |
| 100   | `#F3F4F6` |
| 200   | `#E5E7EB` |
| 300   | `#C9CBD4` |
| 400   | `#9DA4AE` |
| 500   | `#6C737F` |
| 600   | `#525A61` |
| 700   | `#404750` |
| 800   | `#29313B` |
| 900   | `#191E26` |
| 950   | `#101319` |

### CSS Variable Format

```
--mzn-color-primitive-{category}-{scale}
```

Examples:
- `--mzn-color-primitive-brand-500`
- `--mzn-color-primitive-gray-100`
- `--mzn-color-primitive-red-600`

---

## Semantic Colors

Defined by usage context, automatically mapped to light/dark modes.

### Context Types

| Context      | Purpose                                                                               |
| ------------ | ------------------------------------------------------------------------------------- |
| `layer`      | Layer backgrounds (01, 02, 03)                                                        |
| `background` | Background colors (33 tones)                                                          |
| `text`       | Text colors (17 tones)                                                                |
| `icon`       | Icon colors (19 tones)                                                                |
| `border`     | Border colors (11 tones)                                                              |
| `separator`  | Separator colors (4 tones)                                                            |
| `scrollbar`  | Scrollbar colors (SCSS-only, 3 tones: `neutral-light`, `neutral`, `strong`)           |
| `overlay`    | Overlay colors (3 tones)                                                              |
| `surface`    | Surface colors (4 tones)                                                              |
| `shadow`     | Shadow colors (6 tones)                                                               |

### Background Tones

| Tone                 | Description             |
| -------------------- | ----------------------- |
| `base`               | Base background         |
| `menu`               | Menu background         |
| `inverse`            | Inverse background      |
| `fixed-dark`         | Fixed dark background   |
| `neutral-ghost`      | Neutral ghost           |
| `neutral-faint`      | Neutral faint           |
| `neutral-subtle`     | Neutral subtle          |
| `neutral`            | Neutral standard        |
| `neutral-strong`     | Neutral strong          |
| `neutral-solid`      | Neutral solid           |
| `brand-ghost`        | Brand ghost             |
| `brand-faint`        | Brand faint             |
| `brand-subtle`       | Brand subtle            |
| `brand-light`        | Brand light             |
| `brand`              | Brand background        |
| `brand-strong`       | Brand strong            |
| `brand-solid`        | Brand solid             |
| `error-ghost`        | Error ghost             |
| `error-faint`        | Error faint             |
| `error-subtle`       | Error subtle            |
| `error-light`        | Error light             |
| `error`              | Error background        |
| `error-strong`       | Error strong            |
| `error-solid`        | Error solid             |
| `warning-ghost`      | Warning ghost           |
| `warning-faint`      | Warning faint           |
| `warning`            | Warning background      |
| `success-ghost`      | Success ghost           |
| `success-faint`      | Success faint           |
| `success`            | Success background      |
| `info-ghost`         | Info ghost              |
| `info-faint`         | Info faint              |
| `info`               | Info background         |

### Text Tones

| Tone              | Description              |
| ----------------- | ------------------------ |
| `fixed-light`     | Fixed light text         |
| `neutral-faint`   | Neutral faint text       |
| `neutral-light`   | Neutral light text       |
| `neutral`         | Neutral standard text    |
| `neutral-strong`  | Neutral strong text      |
| `neutral-solid`   | Neutral solid text (darkest) |
| `brand`           | Brand text               |
| `brand-strong`    | Brand strong text        |
| `brand-solid`     | Brand solid text         |
| `error`           | Error text               |
| `error-strong`    | Error strong text        |
| `error-solid`     | Error solid text         |
| `warning`         | Warning text             |
| `warning-strong`  | Warning strong text      |
| `success`         | Success text             |
| `info`            | Info text                |
| `info-strong`     | Info strong text         |

### Icon Tones

| Tone              | Description              |
| ----------------- | ------------------------ |
| `fixed-light`     | Fixed light icon         |
| `neutral-faint`   | Neutral faint icon       |
| `neutral-light`   | Neutral light icon       |
| `neutral`         | Neutral standard icon    |
| `neutral-strong`  | Neutral strong icon      |
| `neutral-bold`    | Neutral bold icon        |
| `neutral-solid`   | Neutral solid icon       |
| `brand`           | Brand icon               |
| `brand-strong`    | Brand strong icon        |
| `brand-solid`     | Brand solid icon         |
| `error`           | Error icon               |
| `error-strong`    | Error strong icon        |
| `error-solid`     | Error solid icon         |
| `warning`         | Warning icon             |
| `warning-strong`  | Warning strong icon      |
| `success`         | Success icon             |
| `success-strong`  | Success strong icon      |
| `info`            | Info icon                |
| `info-strong`     | Info strong icon         |

### Border Tones

| Tone                 | Description                 |
| -------------------- | --------------------------- |
| `fixed-light`        | Fixed light border          |
| `fixed-light-alpha`  | Fixed light alpha border    |
| `neutral-faint`      | Neutral faint border        |
| `neutral-light`      | Neutral light border        |
| `neutral`            | Neutral standard border     |
| `neutral-strong`     | Neutral strong border       |
| `brand`              | Brand border                |
| `error-subtle`       | Error subtle border         |
| `error`              | Error border                |
| `warning-subtle`     | Warning subtle border       |
| `warning`            | Warning border              |

### CSS Variable Format

```
--mzn-color-{context}-{tone}
```

Examples:
- `--mzn-color-background-base`
- `--mzn-color-text-neutral-solid`
- `--mzn-color-border-brand`

---

## Spacing System

v2 uses a semantic spacing system supporting default/compact densities.

### Size (Element Spacing)

#### Element Tones

| Tone                  | Default | Compact |
| --------------------- | ------- | ------- |
| `hairline`            | 1px     | 1px     |
| `tiny`                | 4px     | 4px     |
| `tight`               | 6px     | 6px     |
| `compact`             | 8px     | 6px     |
| `slim`                | 12px    | 8px     |
| `narrow`              | 14px    | 12px    |
| `base`                | 16px    | 12px    |
| `base-fixed`          | 16px    | 16px    |
| `gentle`              | 20px    | 18px    |
| `relaxed`             | 24px    | 20px    |
| `airy`                | 28px    | 24px    |
| `space-280`           | 28px    | 28px    |
| `roomy`               | 32px    | 28px    |
| `loose`               | 36px    | 32px    |
| `extra-wide`          | 40px    | 36px    |
| `extra-wide-condense` | 40px    | 24px    |
| `expansive`           | 60px    | 56px    |
| `extra`               | 64px    | 48px    |
| `max`                 | 80px    | 64px    |

> Note: SCSS implementation may contain more tones than TypeScript type definitions. This table follows TypeScript types.

#### Container Tones

| Tone        | Default | Description      |
| ----------- | ------- | ---------------- |
| `collapsed` | 52px    | Collapsed        |
| `tiny`      | 80px    | Extra small      |
| `tight`     | 160px   | Tight            |
| `slim`      | 240px   | Slim             |
| `narrow`    | 320px   | Narrow           |
| `compact`   | 360px   | Compact          |
| `standard`  | 400px   | Standard         |
| `balanced`  | 480px   | Balanced         |
| `broad`     | 560px   | Broad            |
| `wide`      | 640px   | Wide             |
| `expanded`  | 720px   | Expanded         |
| `slender`   | -       | Slender          |
| `max`       | 960px   | Maximum          |

### Gap

> ⚠️ **Note**: TypeScript `GapTone` type (15 kinds) and SCSS implementation (12 kinds) use **different tone names**. The following is based on SCSS implementation (SCSS generates actual CSS variables).

#### SCSS Implementation Tones (12, generates CSS variables)

| Tone          | Default | Compact |
| ------------- | ------- | ------- |
| `none`        | 0       | 0       |
| `tiny`        | 2px     | 2px     |
| `tight`       | 4px     | 2px     |
| `tight-fixed` | 4px     | 4px     |
| `slim`        | 6px     | 4px     |
| `base`        | 8px     | 6px     |
| `calm`        | 12px    | 10px    |
| `comfort`     | 16px    | 14px    |
| `roomy`       | 20px    | 16px    |
| `spacious`    | 24px    | 20px    |
| `relaxed`     | 32px    | 28px    |
| `loose`       | 40px    | 36px    |

#### TypeScript `GapTone` Type (15 kinds)

`'none' | 'micro' | 'tiny' | 'tight' | 'compact' | 'base' | 'base-fixed' | 'comfortable' | 'roomy' | 'spacious' | 'relaxed' | 'airy' | 'generous' | 'breath' | 'wide'`

> 💡 TypeScript types are for component prop type checking; SCSS-generated CSS variables are the actual rendered values. The name mismatch between the two is a known issue.

### Padding

#### Horizontal Tones

| Tone            | Default | Compact |
| --------------- | ------- | ------- |
| `none`          | 0       | 0       |
| `micro`         | 2px     | 2px     |
| `tiny`          | 4px     | 2px     |
| `tiny-fixed`    | 4px     | 4px     |
| `tight`         | 6px     | 4px     |
| `tight-fixed`   | 6px     | 6px     |
| `base`          | 8px     | 4px     |
| `base-fixed`    | 8px     | 8px     |
| `calm` (SCSS: `cozy`) | 10px    | 8px     |
| `comfort`       | 12px    | 10px    |
| `comfort-fixed` | 12px    | 12px    |
| `roomy`         | 14px    | 12px    |
| `spacious`      | 16px    | 14px    |
| `relaxed`       | 24px    | 20px    |
| `airy`          | 28px    | 24px    |
| `breath`        | 32px    | 28px    |
| `wide`          | 40px    | 36px    |
| `max`           | 48px    | 40px    |

> Note: SCSS implementation may contain more tones than TypeScript type definitions. This table follows TypeScript types.

#### Vertical Tones

| Tone        | Default | Compact |
| ----------- | ------- | ------- |
| `none`      | 0       | 0       |
| `micro`     | 2px     | 2px     |
| `tiny`      | 4px     | 2px     |
| `tight`     | 6px     | 4px     |
| `base`      | 8px     | 4px     |
| `calm`      | 10px    | 6px     |
| `comfort`   | 12px    | 8px     |
| `roomy`     | 14px    | 10px    |
| `spacious`  | 16px    | 12px    |
| `generous`  | 20px    | 16px    |
| `relaxed`   | 24px    | 20px    |

### CSS Variable Format

```
--mzn-spacing-size-element-{tone}
--mzn-spacing-size-container-{tone}
--mzn-spacing-gap-{tone}
--mzn-spacing-padding-horizontal-{tone}
--mzn-spacing-padding-vertical-{tone}
```

---

## Typography System

### Semantic Typography Types

21 semantic typography types:

| Type                      | Font Size | Font Weight | Description              |
| ------------------------- | --------- | ----------- | ------------------------ |
| `h1`                      | 24px      | semibold    | Heading 1                |
| `h2`                      | 18px      | semibold    | Heading 2                |
| `h3`                      | 16px      | semibold    | Heading 3                |
| `body`                    | 14px      | regular     | Body text                |
| `body-highlight`          | 14px      | medium      | Highlighted body         |
| `body-mono`               | 14px      | regular     | Monospace body           |
| `body-mono-highlight`     | 14px      | medium      | Monospace highlighted    |
| `text-link-body`          | 14px      | regular     | Body link                |
| `text-link-caption`       | 12px      | regular     | Caption link             |
| `caption`                 | 12px      | regular     | Caption text             |
| `caption-highlight`       | 12px      | semibold    | Highlighted caption      |
| `annotation`              | 10px      | regular     | Annotation               |
| `annotation-highlight`    | 10px      | semibold    | Highlighted annotation   |
| `button`                  | 14px      | regular     | Button text              |
| `button-highlight`        | 14px      | medium      | Highlighted button text  |
| `input`                   | 14px      | regular     | Input text               |
| `input-highlight`         | 14px      | medium      | Highlighted input text   |
| `input-mono`              | 14px      | regular     | Monospace input text     |
| `label-primary`           | 14px      | regular     | Primary label            |
| `label-primary-highlight` | 14px      | medium      | Highlighted primary label|
| `label-secondary`         | 12px      | regular     | Secondary label          |

### Font Weight

| Weight     | Value |
| ---------- | ----- |
| `regular`  | 400   |
| `medium`   | 500   |
| `semibold` | 600   |

### CSS Variable Format

```
--mzn-typography-{type}-font-size
--mzn-typography-{type}-font-weight
--mzn-typography-{type}-line-height
--mzn-typography-{type}-letter-spacing
```

---

## Border Radius

| Tone    | Value              |
| ------- | ------------------ |
| `none`  | 0                  |
| `tiny`  | 0.125rem (2px)     |
| `base`  | 0.25rem (4px)      |
| `roomy` | 0.5rem (8px)       |
| `full`  | 62.4375rem (999px) |

TypeScript type: `RadiusSize = 'none' | 'tiny' | 'base' | 'roomy' | 'full'`

CSS variable: `--mzn-radius-{tone}`

---

## Shadows

Uses Semantic shadow colors:

| Tone           | Description         |
| -------------- | ------------------- |
| `dark`         | Dark shadow         |
| `dark-light`   | Light dark shadow   |
| `dark-faint`   | Faint dark shadow   |
| `dark-ghost`   | Ghost dark shadow   |
| `light-faint`  | Faint light shadow  |
| `brand`        | Brand shadow        |

---

## Sizes

General Size:

| Size    | Description   |
| ------- | ------------- |
| `main`  | Main size     |
| `sub`   | Sub size      |
| `minor` | Minor size    |

---

## Z-Index

Starts from a base value (default 1000), incrementing sequentially.

| Name       | Default | Description                     |
| ---------- | ------- | ------------------------------- |
| `base`     | 1001    | Base layer                      |
| `alert`    | 1002    | AlertBanner layer               |
| `drawer`   | 1003    | Drawer layer                    |
| `modal`    | 1004    | Modal layer                     |
| `popover`  | 1005    | Popover/Tooltip layer           |
| `feedback` | 1006    | Message/Notification layer      |

CSS variable: `--mzn-z-index-{name}`

SCSS usage:

```scss
@use '~@mezzanine-ui/system/z-index' as z-index;

.my-overlay {
  z-index: z-index.get(modal);
}
```

---

## Usage

### Using in SCSS

```scss
@use '~@mezzanine-ui/system' as mzn-system;
@use '~@mezzanine-ui/system/palette' as palette;
@use '~@mezzanine-ui/system/spacing' as spacing;
@use '~@mezzanine-ui/system/typography' as typography;
@use '~@mezzanine-ui/system/radius' as radius;

// Set variables
:root {
  @include mzn-system.palette-variables(light);
  @include mzn-system.common-variables(default);
}

[data-theme='dark'] {
  @include mzn-system.palette-variables(dark);
}

[data-density='compact'] {
  @include mzn-system.common-variables(compact);
}

// Use variables
.my-component {
  // Colors
  color: palette.semantic-variable(text, brand);
  background-color: palette.semantic-variable(background, base);
  border-color: palette.semantic-variable(border, neutral);

  // Spacing
  padding: spacing.semantic-variable(padding, horizontal, base);
  gap: spacing.semantic-variable(gap, base);

  // Border radius
  border-radius: radius.variable(base);

  // Typography (mixin)
  @include typography.semantic-variable(body);
}
```

### Custom Palette

```scss
@use '~@mezzanine-ui/system' as mzn-system;

$custom-palette: (
  background: (
    base: (
      light: #f5f5f5,
      dark: #1a1a1a,
    ),
  ),
);

:root {
  @include mzn-system.palette-variables(light, $custom-palette);
}
```

### Custom Spacing

```scss
@use '~@mezzanine-ui/system' as mzn-system;

$custom-variables: (
  spacing: (
    size: (
      element: (
        base: (
          default: 20px,
          compact: 16px,
        ),
      ),
    ),
  ),
);

:root {
  @include mzn-system.common-variables(default, $custom-variables);
}
```
