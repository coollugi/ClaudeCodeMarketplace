# Upload

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/upload) · Verified 1.0.0-rc.4 (2026-04-24)

File upload component with drag-and-drop support, file list rendering, progress tracking, and card modes. Manages `UploadFile[]` state externally — the component emits events and the parent updates the list. Provides `MznUpload` (orchestrator), `MznUploader` (dropzone), `MznUploadPictureCard` (card tile), `MznUploadItem` (list item), and `MznUploadMediaPreviewModal` (preview overlay).

## Import

```ts
import {
  MznUpload,
  MznUploader,
  MznUploadPictureCard,
  MznUploadItem,
  MznUploadMediaPreviewModal,
  // Value helpers — re-exported from @mezzanine-ui/ng/upload/upload-utils
  isImageFile,            // (file: File) => boolean — true when MIME type starts with 'image/'
  resolveFileType,        // resolves a File/URL into a display-friendly file type label
  extractFileNameFromUrl, // derives the trailing file name segment from a URL string
} from '@mezzanine-ui/ng/upload';
import type {
  UploadFile,
  UploadHint,
  UploaderIconConfig,
  UploaderLabelConfig,
  UploadAriaLabels,
  UploadPictureCardAriaLabels,
  UploadItemSize,
  UploadPictureCardImageFit,
  UploadPictureCardSize,
} from '@mezzanine-ui/ng/upload';

// `UploadFileActionEvent` and `UploadMaxFilesExceededEvent` are NOT
// re-exported from the `@mezzanine-ui/ng/upload` barrel. Use output
// type inference (recommended) or declare the shape locally:
//
//   interface UploadFileActionEvent { fileId: string; file: File; }
//   interface UploadMaxFilesExceededEvent { files: File[]; maxFiles: number; }
import type {
  UploadMode,
  UploadSize,
  UploadItemStatus,
  UploaderMode,
  UploadType,
} from '@mezzanine-ui/core/upload';
```

## Selector

`[mznUpload]` — component applied to a container element.

## MznUpload — Inputs

| Input           | Type                                                       | Default  | Description                                                  |
| --------------- | ---------------------------------------------------------- | -------- | ------------------------------------------------------------ |
| `files`         | `readonly UploadFile[]`                                    | `[]`     | Current file list (controlled — manage state externally)     |
| `mode`          | `UploadMode`                                               | `'list'` | `'list' \| 'basic-list' \| 'button-list' \| 'cards' \| 'card-wall'` |
| `accept`        | `string \| undefined`                                      | —        | File type filter (e.g. `'.pdf,.jpg'`)                        |
| `multiple`      | `boolean`                                                  | `false`  | Allow multiple file selection                                |
| `maxFiles`      | `number \| undefined`                                      | —        | Maximum allowed file count                                   |
| `disabled`      | `boolean`                                                  | `false`  | Disable the upload trigger                                   |
| `size`          | `UploadSize`                                               | `'main'` | Component size variant                                       |
| `id`            | `string \| undefined`                                      | —        | Input element id                                             |
| `name`          | `string \| undefined`                                      | —        | Input element name                                           |
| `hints`         | `readonly UploadHint[] \| undefined`                       | —        | Hint text items shown outside the uploader area              |
| `dropzoneHints` | `readonly UploadHint[] \| undefined`                       | —        | Hint items shown inside the dropzone (list/card-wall modes)  |
| `errorMessage`  | `string \| undefined`                                      | —        | Global error message for upload failures                     |
| `errorIcon`     | `IconDefinition \| undefined`                              | —        | Custom error icon                                            |
| `showFileSize`  | `boolean`                                                  | `true`   | Show file size next to file name in list modes               |
| `uploadHandler` | `UploadHandler \| undefined`                               | —        | Custom upload implementation (see UploadHandler type)        |
| `uploaderIcon`  | `UploaderIconConfig \| undefined`                          | —        | Custom uploader icon config                                  |
| `uploaderLabel` | `UploaderLabelConfig \| undefined`                         | —        | Custom uploader label config                                 |
| `ariaLabels`    | `UploadAriaLabels \| undefined`                            | —        | Accessibility label overrides for card actions               |
| `inputProps`    | `Record<string, string \| number \| boolean> \| undefined` | —        | Extra attributes on the `<input type="file">`                |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## MznUpload — Outputs

| Output             | Type                                        | Description                                                  |
| ------------------ | ------------------------------------------- | ------------------------------------------------------------ |
| `upload`           | `OutputEmitterRef<File[]>`                  | Fires when user selects/drops files; contains raw `File[]`   |
| `fileSelect`       | `OutputEmitterRef<File[]>`                  | Legacy alias for `upload` — fires simultaneously             |
| `filesChange`      | `OutputEmitterRef<readonly UploadFile[]>`   | Fires with updated list after every internal state change    |
| `delete`           | `OutputEmitterRef<UploadFileActionEvent>`   | Delete icon clicked; update `files` accordingly              |
| `download`         | `OutputEmitterRef<UploadFileActionEvent>`   | Download icon clicked                                        |
| `reload`           | `OutputEmitterRef<UploadFileActionEvent>`   | Reload/retry icon clicked                                    |
| `zoomIn`           | `OutputEmitterRef<UploadFileActionEvent>`   | Preview/zoom icon clicked                                    |
| `maxFilesExceeded` | `OutputEmitterRef<UploadMaxFilesExceededEvent>` | Fires when user selects more files than `maxFiles` allows |

## ControlValueAccessor

No — `MznUpload` does **not** implement `ControlValueAccessor`. File lists are managed externally via `[files]` input and `(filesChange)` / `(delete)` outputs.

## UploadFile Shape

```ts
interface UploadFile {
  readonly id: string;               // unique key
  readonly name: string;             // display name
  readonly status: UploadItemStatus; // 'loading' | 'done' | 'error'
  readonly file?: File;              // raw File object
  readonly progress?: number;        // 0–100
  readonly errorMessage?: string;    // shown when status='error'
  readonly thumbnailUrl?: string;    // legacy preview image URL
  readonly url?: string;             // file access or download URL
}
```

## UploadFileActionEvent Shape

```ts
interface UploadFileActionEvent {
  fileId: string;  // id of the target UploadFile
  file: File;      // the underlying File object
}
```

## UploadMaxFilesExceededEvent Shape

```ts
interface UploadMaxFilesExceededEvent {
  maxFiles: number;      // configured limit
  selectedCount: number; // how many files the user selected
  currentCount: number;  // how many files were in the list
}
```

## Usage

```html
<!-- Basic list mode -->
<div mznUpload
  [files]="files"
  [multiple]="true"
  accept=".pdf,.xlsx"
  (upload)="onUpload($event)"
  (delete)="onDelete($event)"
></div>

<!-- Cards mode (multi-image) -->
<div mznUpload
  [files]="images"
  mode="cards"
  [multiple]="true"
  accept="image/*"
  (filesChange)="images = $event"
  (delete)="onImageDelete($event)"
  (zoomIn)="previewImage($event)"
></div>

<!-- Card-wall mode (full-width dropzone + card grid) -->
<div mznUpload
  [files]="files"
  mode="card-wall"
  [multiple]="true"
  (filesChange)="files = $event"
  (maxFilesExceeded)="onExceeded($event)"
></div>

<!-- Button-list mode (button trigger) -->
<div mznUpload
  [files]="files"
  mode="button-list"
  (filesChange)="files = $event"
></div>
```

```ts
import { MznUpload } from '@mezzanine-ui/ng/upload';
import type { UploadFile } from '@mezzanine-ui/ng/upload';

// Event payload shape is not exported from the barrel — declare locally
// or rely on output type inference.
interface UploadFileActionEvent {
  fileId: string;
  file: File;
}

files: readonly UploadFile[] = [];

onUpload(newFiles: File[]): void {
  const pending: readonly UploadFile[] = newFiles.map((f) => ({
    id: crypto.randomUUID(),
    name: f.name,
    status: 'loading' as const,
    file: f,
  }));
  this.files = [...this.files, ...pending];
  // Upload logic here — update status to 'done' or 'error' when complete
}

onDelete(event: UploadFileActionEvent): void {
  this.files = this.files.filter((f) => f.id !== event.fileId);
}
```

---

## MznUploader

Standalone dropzone/button trigger that wraps a hidden `<input type="file">`. Used internally by `MznUpload`; also suitable for custom upload shells.

### Selector

`[mznUploader]` — component applied to a `<label>` element.

### MznUploader — Inputs

| Input        | Type                                                       | Default     | Description                                                                 |
| ------------ | ---------------------------------------------------------- | ----------- | --------------------------------------------------------------------------- |
| `accept`     | `string \| undefined`                                      | —           | File type filter                                                             |
| `disabled`   | `boolean`                                                  | `false`     | Disable the trigger                                                          |
| `hints`      | `readonly UploadHint[] \| undefined`                       | —           | Hints shown inside the dropzone area (only when `mode='dropzone'`)           |
| `externalHints` | `readonly UploadHint[] \| undefined`                    | —           | Hints rendered outside the label in a `<ul>` (all modes)                    |
| `id`         | `string \| undefined`                                      | —           | ID forwarded to the hidden `<input>`                                         |
| `fillWidth`  | `boolean`                                                  | `false`     | Stretch dropzone to full container width (only `type='base' + mode='dropzone'`) |
| `icon`       | `UploaderIconConfig \| undefined`                          | —           | Custom icon overrides                                                        |
| `inputProps` | `Record<string, string \| number \| boolean> \| undefined` | —           | Extra attributes forwarded to the `<input>` via `Renderer2`                 |
| `label`      | `UploaderLabelConfig \| undefined`                         | —           | Custom label texts                                                           |
| `mode`       | `UploaderMode`                                             | `'basic'`   | `'basic'` (icon+label block) \| `'dropzone'` (drag-and-drop area)           |
| `multiple`   | `boolean`                                                  | `false`     | Allow multiple file selection                                                |
| `name`       | `string \| undefined`                                      | —           | Name forwarded to the hidden `<input>`                                       |
| `type`       | `UploadType`                                               | `'base'`    | `'base'` (label+area) \| `'button'` (button element)                        |

### MznUploader — Outputs

| Output   | Type                         | Description                                               |
| -------- | ---------------------------- | --------------------------------------------------------- |
| `upload` | `OutputEmitterRef<File[]>`   | Fires after user selects or drops files                   |
| `change` | `OutputEmitterRef<Event>`    | Raw native `input change` event forwarded                 |

### MznUploader — Public Methods

| Method    | Signature    | Description                                                |
| --------- | ------------ | ---------------------------------------------------------- |
| `click()` | `(): void`   | Programmatically open the file-selection dialog            |
| `reset()` | `(): void`   | Clear the input value so the same file can be re-selected  |

```html
<label mznUploader
  #uploader="mznUploader"
  accept=".pdf"
  mode="dropzone"
  [multiple]="true"
  [fillWidth]="true"
  (upload)="onUpload($event)"
></label>

<!-- Programmatic trigger -->
<button (click)="uploader.click()">Choose files</button>
```

---

## MznUploadPictureCard

Card tile that displays an uploaded file with status-driven overlays (loading spinner, done tools, error message). Used inside `MznUpload`'s `cards` / `card-wall` modes.

### Selector

`[mznUploadPictureCard]`

### MznUploadPictureCard — Inputs

| Input             | Type                                  | Default     | Description                                              |
| ----------------- | ------------------------------------- | ----------- | -------------------------------------------------------- |
| `file`            | `File \| undefined`                   | —           | Raw File object (used to create a blob preview URL)      |
| `url`             | `string \| undefined`                 | —           | Remote file URL for already-uploaded files               |
| `id`              | `string \| undefined`                 | —           | File identifier                                          |
| `status`          | `UploadItemStatus`                    | `'loading'` | `'loading' \| 'done' \| 'error'`                        |
| `size`            | `UploadPictureCardSize`               | `'main'`    | Card size variant                                        |
| `imageFit`        | `UploadPictureCardImageFit`           | `'cover'`   | CSS `object-fit` for image preview                       |
| `disabled`        | `boolean`                             | `false`     | Disable all interactions                                 |
| `errorMessage`    | `string \| undefined`                 | —           | Error message shown when `status='error'`                |
| `errorIcon`       | `IconDefinition \| undefined`         | —           | Custom error icon; auto-selects ImageIcon/FileIcon       |
| `readable`        | `boolean`                             | `false`     | Read-only — hides all action buttons                     |
| `ariaLabels`      | `UploadPictureCardAriaLabels \| undefined` | —      | Accessible label overrides for action buttons            |
| `replaceEnabled`  | `boolean`                             | `false`     | Emit `replaced` on click when `status='done'`            |
| `zoomInEnabled`   | `boolean`                             | `false`     | Show zoom button when `status='done'`                    |
| `downloadEnabled` | `boolean`                             | `false`     | Show download button when `status='done'`                |

### MznUploadPictureCard — Outputs

| Output       | Type                           | Description                                      |
| ------------ | ------------------------------ | ------------------------------------------------ |
| `deleted`    | `OutputEmitterRef<MouseEvent>` | Delete button clicked                            |
| `downloaded` | `OutputEmitterRef<MouseEvent>` | Download button clicked                          |
| `reloaded`   | `OutputEmitterRef<MouseEvent>` | Retry button clicked (status='error')            |
| `replaced`   | `OutputEmitterRef<MouseEvent>` | Card clicked in replace mode (status='done')     |
| `zoomed`     | `OutputEmitterRef<MouseEvent>` | Zoom button clicked                              |

---

## MznUploadItem

Single-file list item. Renders three states: `loading` (spinner + cancel), `done` (download icon), `error` (retry icon). Always shows a delete button when finished (`done` or `error`).

### Selector

`[mznUploadItem]`

### MznUploadItem — Inputs

| Input          | Type                           | Default     | Description                                                  |
| -------------- | ------------------------------ | ----------- | ------------------------------------------------------------ |
| `file`         | `File \| undefined`            | —           | Raw File object (used for file name and size)                |
| `url`          | `string \| undefined`          | —           | File URL (used when file is not provided)                    |
| `id`           | `string \| undefined`          | —           | File identifier                                              |
| `type`         | `UploadItemType`               | `'icon'`    | `'icon'` (file icon) \| `'thumbnail'` (card preview)        |
| `size`         | `UploadItemSize`               | `'main'`    | Size variant                                                 |
| `status`       | `UploadItemStatus`             | `'loading'` | `'loading' \| 'done' \| 'error'`                            |
| `fileSize`     | `number \| undefined`          | —           | Explicit file size in bytes (overrides `file.size`)          |
| `showFileSize` | `boolean`                      | `true`      | Show formatted file size when finished                       |
| `disabled`     | `boolean`                      | `false`     | Disable all action buttons                                   |
| `errorMessage` | `string \| undefined`          | —           | Error message shown when `status='error'`                    |
| `errorIcon`    | `IconDefinition \| undefined`  | —           | Custom error icon; defaults to `DangerousFilledIcon`         |
| `icon`         | `IconDefinition \| undefined`  | —           | Custom file type icon; defaults to `FileIcon`                |
| `fileName`     | `string \| undefined`          | —           | Override auto-resolved file name                             |
| `thumbnailUrl` | `string \| undefined`          | —           | Legacy alias for `url` (compat)                              |

### MznUploadItem — Outputs

| Output     | Type                           | Description                              |
| ---------- | ------------------------------ | ---------------------------------------- |
| `cancel`   | `OutputEmitterRef<MouseEvent>` | Cancel clicked (status='loading')        |
| `download` | `OutputEmitterRef<MouseEvent>` | Download clicked (status='done')         |
| `reload`   | `OutputEmitterRef<MouseEvent>` | Retry clicked (status='error')           |
| `delete`   | `OutputEmitterRef<MouseEvent>` | Delete clicked (status='done' or 'error') |

---

## MznUploadMediaPreviewModal

Single-image preview overlay. Used internally by `MznUpload` when the user clicks the zoom button on a card. Wraps `MznBackdrop` (not a full `MznModal`) so transparent images render correctly.

### Selector

`mzn-upload-media-preview-modal`

### Inputs — MznUploadMediaPreviewModal

| Input        | Type                | Default | Description                                    |
| ------------ | ------------------- | ------- | ---------------------------------------------- |
| `open`       | `boolean`           | `false` | 是否顯示預覽overlay                            |
| `mediaItems` | `readonly string[]` | `[]`    | 預覽項目來源；**目前只會顯示第一筆**           |

### Outputs — MznUploadMediaPreviewModal

| Output  | Type                     | Description                                     |
| ------- | ------------------------ | ----------------------------------------------- |
| `close` | `OutputEmitterRef<void>` | 點擊 backdrop、按 Escape 或點關閉鈕時觸發        |

---

## Notes

- `MznUpload` is **not** a `ControlValueAccessor`. File lists are managed externally; add a custom validator if form validation is needed.
- `UploadItemStatus` values are `'loading' | 'done' | 'error'`. There is no `'uploading'` status.
- `UploadFileActionEvent` carries `{ fileId: string; file: File }` — not `event.uid`.
- `UploadMode` values are `'list' | 'basic-list' | 'button-list' | 'cards' | 'card-wall'`. There is no `'picture-card'` or `'dragger'` mode.
- `cards` mode with `maxFiles=1` automatically enters Replace mode (click card to swap file).
- `upload` and `fileSelect` outputs both fire with the same `File[]`; `fileSelect` is a legacy alias.
- `uploadHandler` is optional — when omitted, files are immediately marked `done`.
