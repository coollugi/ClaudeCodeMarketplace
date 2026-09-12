# Cropper Component

> **Category**: Foundation
>
> **Storybook**: `Foundation/Cropper`
>
> **Source**: [GitHub Source Code](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Cropper) · Verified 1.5.1 (2026-09-12)

Image cropping component providing interactive image cropping functionality. Includes the base container `Cropper`, the cropping canvas `CropperElement`, the Modal wrapper `CropperModal`, and utility functions `cropToBlob`, `cropToFile`, and `cropToDataURL`.

## Import

```tsx
// Import from main package (Cropper container and types only)
import { Cropper } from '@mezzanine-ui/react';
import type {
  CropperComponent,
  CropperProps,
  CropperPropsBase,
  CropperSize,
} from '@mezzanine-ui/react';

// Import advanced features from sub-module
import {
  CropperElement,
  CropperModal,
  cropToBlob,
  cropToFile,
  cropToDataURL,
} from '@mezzanine-ui/react/Cropper';
import type {
  CropArea,
  CropperElementComponent,
  CropperElementProps,
  CropperModalProps,
  CropperModalConfirmContext,
  CropperModalOpenOptions,
  CropperModalResult,
  CropToBlobOptions,
  CropperModalType,
} from '@mezzanine-ui/react/Cropper';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/feedback-cropper--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Cropper Props (Container)

`CropperProps<C>` is a generic type that extends `CropperPropsBase` plus native attributes of the `C` element.

| Property    | Type               | Default  | Description              |
| ----------- | ------------------ | -------- | ------------------------ |
| `component` | `CropperComponent` | `'div'`  | Root element tag to render |
| `size`      | `CropperSize`      | `'main'` | Cropper size             |
| `children`  | `ReactNode`        | -        | Child elements           |
| `className` | `string`           | -        | Additional CSS class     |

---

## CropperPropsBase (Cropping Functionality)

| Property          | Type                           | Default  | Description                                       |
| ----------------- | ------------------------------ | -------- | ------------------------------------------------- |
| `size`            | `CropperSize`                  | `'main'` | Cropper size                                      |
| `children`        | `ReactNode`                    | -        | Child elements                                    |
| `imageSrc`        | `string \| File \| Blob`       | -        | Image source to crop (URL, File, or Blob)         |
| `onCropChange`    | `(cropArea: CropArea) => void` | -        | Triggered when crop area changes                  |
| `onCropDragEnd`   | `(cropArea: CropArea) => void` | -        | Triggered when crop area drag ends                |
| `onImageDragEnd`  | `() => void`                   | -        | Triggered when image drag ends                    |
| `onScaleChange`   | `(scale: number) => void`      | -        | Triggered when zoom scale changes                 |
| `onImageLoad`     | `() => void`                   | -        | Triggered when image loads successfully           |
| `onImageError`    | `(error: Error) => void`       | -        | Triggered when image fails to load                |
| `initialCropArea` | `CropArea`                     | -        | Initial crop area                                 |
| `aspectRatio`     | `number`                       | -        | Crop aspect ratio (width/height); free ratio if not provided |
| `minWidth`        | `number`                       | `50`     | Minimum crop area width (px)                      |
| `minHeight`       | `number`                       | `50`     | Minimum crop area height (px)                     |

---

## CropperElement

`CropperElement` is the actual cropping canvas based on the `<canvas>` element.

```ts
type CropperElementProps<C extends CropperElementComponent = 'canvas'> =
  ComponentOverridableForwardRefComponentPropsFactory<
    CropperElementComponent,
    C,
    CropperPropsBase
  >;
```

> `CropperElementComponent` is equivalent to `'canvas'`.
> `CropperElementProps` extends `CropperPropsBase` plus native attributes of the `<canvas>` element.

---

## CropperModal Props

`CropperModalProps` extends `ModalProps` (excluding and redefining some properties), providing a complete Modal cropping experience.

| Property                  | Type                                                              | Default        | Description                                    |
| ------------------------- | ----------------------------------------------------------------- | -------------- | ---------------------------------------------- |
| `open`                    | `boolean`                                                         | `false`        | Whether the Modal is open                      |
| `cropperProps`            | `CropperPropsBase`                                                | -              | Cropping parameters passed to CropperElement   |
| `cropperContentClassName` | `string`                                                          | -              | Additional CSS class for cropping content area  |
| `onConfirm`               | `(context: CropperModalConfirmContext) => void \| Promise<void>`  | -              | Confirm button callback, receives crop result  |
| `onCancel`                | `() => void`                                                      | -              | Cancel button callback                         |
| `onClose`                 | `() => void`                                                      | -              | Triggered when Modal closes (inherited from ModalProps) |
| `showModalFooter`         | `boolean`                                                         | `true`         | Whether to show footer button bar              |
| `showModalHeader`         | `boolean`                                                         | `true`         | Whether to show header bar                     |
| `title`                   | `string`                                                          | `'圖片裁切'`   | Modal title text                               |
| `confirmText`             | `string`                                                          | `'確認'`       | Confirm button text                            |
| `cancelText`              | `string`                                                          | `'取消'`       | Cancel button text                             |
| `size`                    | `ModalSize`                                                       | `'wide'`       | Modal size                                     |

---

## CropperModalConfirmContext

The crop result object received by the confirm callback.

| Property   | Type                        | Description                    |
| ---------- | --------------------------- | ------------------------------ |
| `canvas`   | `HTMLCanvasElement \| null` | Canvas element used for cropping |
| `cropArea` | `CropArea \| null`          | Crop area coordinates and size |
| `imageSrc` | `string \| File \| Blob`    | Original image source (optional) |

---

## CropperModal.open Related Types

| Type                       | Definition                           | Description                              |
| -------------------------- | ------------------------------------ | ---------------------------------------- |
| `CropperModalOpenOptions`  | `Omit<CropperModalProps, 'open'>`    | Parameter type for `CropperModal.open()` |
| `CropperModalResult`       | `CropperModalConfirmContext`         | Return type of `CropperModal.open()`     |

---

## Type Definitions

### CropperSize

```ts
type CropperSize = GeneralSize; // 'main' | 'sub' | 'minor'
```

### CropperComponent

```ts
type CropperComponent = 'div' | 'span';
```

### CropperElementComponent

```ts
type CropperElementComponent = 'canvas';
```

### CropArea

```ts
interface CropArea {
  x: number;
  y: number;
  width: number;
  height: number;
}
```

### CropToBlobOptions

| Property       | Type                     | Default       | Description                                           |
| -------------- | ------------------------ | ------------- | ----------------------------------------------------- |
| `imageSrc`     | `string \| File \| Blob` | -             | Required, image source                                |
| `cropArea`     | `CropArea`               | -             | Required, crop area coordinates                       |
| `canvas`       | `HTMLCanvasElement`      | -             | Optional, provide an existing Canvas; auto-created if not provided |
| `format`       | `string`                 | `'image/png'` | Output format                                         |
| `quality`      | `number`                 | `0.92`        | Output quality (0-1), only effective for jpeg/webp    |
| `outputWidth`  | `number`                 | -             | Output width (px), uses crop area width if not provided |
| `outputHeight` | `number`                 | -             | Output height (px), uses crop area height if not provided |

---

## Utility Functions

| Function        | Parameters                               | Return Type       | Description                     |
| --------------- | ---------------------------------------- | ----------------- | ------------------------------- |
| `cropToBlob`    | `(options: CropToBlobOptions)`           | `Promise<Blob>`   | Convert crop area to Blob       |
| `cropToFile`    | `(options: CropToBlobOptions, filename)` | `Promise<File>`   | Convert crop area to File       |
| `cropToDataURL` | `(options: CropToBlobOptions)`           | `Promise<string>` | Convert crop area to Data URL   |

---

## Usage Examples

### Basic Cropper Container

```tsx
import { Cropper } from '@mezzanine-ui/react';

function BasicCropper() {
  return (
    <Cropper size="main">
      {/* Custom cropping content */}
    </Cropper>
  );
}
```

### CropperModal with State Control

```tsx
import { useState } from 'react';
import { CropperModal } from '@mezzanine-ui/react/Cropper';
import type { CropperModalConfirmContext } from '@mezzanine-ui/react/Cropper';

function ImageCropDialog() {
  const [open, setOpen] = useState(false);
  const [imageSrc] = useState('https://example.com/photo.jpg');

  const handleConfirm = async (context: CropperModalConfirmContext): Promise<void> => {
    const { canvas, cropArea } = context;
    console.log('Crop area:', cropArea);
    // Use canvas for further processing
  };

  return (
    <>
      <button onClick={() => setOpen(true)}>Open Cropper</button>
      <CropperModal
        open={open}
        onClose={() => setOpen(false)}
        onConfirm={handleConfirm}
        title="Crop Avatar"
        cropperProps={{
          imageSrc,
          aspectRatio: 1,
          minWidth: 100,
          minHeight: 100,
        }}
      />
    </>
  );
}
```

### Using CropperModal.open Imperative Call

```tsx
import { CropperModal } from '@mezzanine-ui/react/Cropper';
import type { CropperModalResult } from '@mezzanine-ui/react/Cropper';

async function openCropperAndGetResult(): Promise<void> {
  const result: CropperModalResult | null = await CropperModal.open({
    cropperProps: {
      imageSrc: 'https://example.com/photo.jpg',
      aspectRatio: 16 / 9,
    },
    title: 'Crop Cover Image',
    confirmText: 'Apply',
  });

  if (result) {
    console.log('Crop complete:', result.cropArea);
  } else {
    console.log('User cancelled cropping');
  }
}
```

### Using Utility Functions to Export Crop Results

```tsx
import { cropToBlob, cropToFile, cropToDataURL } from '@mezzanine-ui/react/Cropper';

async function exportCroppedImage(): Promise<void> {
  const options = {
    imageSrc: 'https://example.com/photo.jpg',
    cropArea: { x: 100, y: 100, width: 200, height: 200 },
    format: 'image/jpeg',
    quality: 0.9,
  };

  // Convert to Blob
  const blob = await cropToBlob(options);

  // Convert to File (can be used directly in FormData for upload)
  const file = await cropToFile(options, 'cropped-avatar.jpg');

  // Convert to Data URL (can be set directly as img src)
  const dataUrl = await cropToDataURL(options);

  console.log({ blob, file, dataUrl });
}
```

### With Custom Output Size

```tsx
import { cropToBlob } from '@mezzanine-ui/react/Cropper';

async function cropWithCustomSize(): Promise<void> {
  const blob = await cropToBlob({
    imageSrc: fileInput.files[0],
    cropArea: { x: 50, y: 50, width: 400, height: 400 },
    outputWidth: 200,
    outputHeight: 200,
    format: 'image/webp',
    quality: 0.85,
  });

  // Upload the resized cropped image
  const formData = new FormData();
  formData.append('avatar', blob, 'avatar.webp');
}
```

---

## Best Practices

1. **Prefer imperative calls**: If you don't need to control Modal state, use `CropperModal.open()` for a more concise approach.
2. **Set crop aspect ratio**: Use `aspectRatio: 1` for avatars, `aspectRatio: 16 / 9` for cover images.
3. **Specify minimum size**: Use `minWidth` / `minHeight` to ensure the crop result has sufficient resolution.
4. **Choose appropriate output format**: Use `image/jpeg` for photos (higher compression), `image/png` when transparency is needed.
5. **Set outputWidth/outputHeight**: Use utility functions to control the final output size, avoiding uploading oversized images.
