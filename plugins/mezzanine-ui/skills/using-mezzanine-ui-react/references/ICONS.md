# Mezzanine-UI Icon Reference

Complete icon library list, based on `@mezzanine-ui/icons` `1.x` (1.0.2).

**Last verified**: 2026-09-12 (against `@mezzanine-ui/react` `1.5.1` baseline; `@mezzanine-ui/icons` itself remains `1.0.2`, unchanged)

> Source: [GitHub](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/icons/src)

## Usage

```tsx
import { Icon } from '@mezzanine-ui/react';
import { PlusIcon, SearchIcon } from '@mezzanine-ui/icons';

// Basic usage
<Icon icon={PlusIcon} />

// Custom size
<Icon icon={SearchIcon} size={24} />

// Spinning animation (for loading)
<Icon icon={SpinnerIcon} spin />
```

---

## System Icons

General system function icons.

| Icon Name               | Import Name            | Description        |
| ----------------------- | ---------------------- | ------------------ |
| Menu                    | `MenuIcon`             | Menu               |
| Menu Open               | `MenuOpenIcon`         | Menu expanded      |
| Menu Close              | `MenuCloseIcon`        | Menu collapsed     |
| Search                  | `SearchIcon`           | Search             |
| Search History          | `SearchHistoryIcon`    | Search history     |
| User                    | `UserIcon`             | User               |
| Slash                   | `SlashIcon`            | Slash              |
| Folder                  | `FolderIcon`           | Folder             |
| Folder Open             | `FolderOpenIcon`       | Folder expanded    |
| Folder Move             | `FolderMoveIcon`       | Move folder        |
| Folder Add              | `FolderAddIcon`        | Add folder         |
| Calendar                | `CalendarIcon`         | Calendar           |
| Calendar Time           | `CalendarTimeIcon`     | Calendar time      |
| Clock                   | `ClockIcon`            | Clock              |
| Currency Dollar         | `CurrencyDollarIcon`   | Dollar sign        |
| Percent                 | `PercentIcon`          | Percent            |
| Light                   | `LightIcon`            | Light mode         |
| Dark                    | `DarkIcon`             | Dark mode          |
| Notification            | `NotificationIcon`     | Notification       |
| Notification Unread     | `NotificationUnreadIcon`| Unread notification|
| Sider                   | `SiderIcon`            | Sidebar            |
| Home                    | `HomeIcon`             | Home               |
| Spinner                 | `SpinnerIcon`          | Loading            |
| Login                   | `LoginIcon`            | Login              |
| Logout                  | `LogoutIcon`           | Logout             |
| Save                    | `SaveIcon`             | Save               |
| System                  | `SystemIcon`           | System             |

---

## Arrow Icons

Directional arrow icons.

| Icon Name             | Import Name                 | Description            |
| --------------------- | --------------------------- | ---------------------- |
| Long Tail Arrow Right | `LongTailArrowRightIcon`    | Long tail arrow right  |
| Long Tail Arrow Left  | `LongTailArrowLeftIcon`     | Long tail arrow left   |
| Long Tail Arrow Up    | `LongTailArrowUpIcon`       | Long tail arrow up     |
| Long Tail Arrow Down  | `LongTailArrowDownIcon`     | Long tail arrow down   |
| Short Tail Arrow Right| `ShortTailArrowRightIcon`   | Short tail arrow right |
| Short Tail Arrow Left | `ShortTailArrowLeftIcon`    | Short tail arrow left  |
| Short Tail Arrow Up   | `ShortTailArrowUpIcon`      | Short tail arrow up    |
| Short Tail Arrow Down | `ShortTailArrowDownIcon`    | Short tail arrow down  |
| Caret Right           | `CaretRightIcon`            | Caret right            |
| Caret Left            | `CaretLeftIcon`             | Caret left             |
| Caret Up              | `CaretUpIcon`               | Caret up               |
| Caret Down            | `CaretDownIcon`             | Caret down             |
| Caret Up Flat         | `CaretUpFlatIcon`           | Flat caret up          |
| Caret Down Flat       | `CaretDownFlatIcon`         | Flat caret down        |
| Caret Vertical        | `CaretVerticalIcon`         | Vertical caret         |
| Chevron Right         | `ChevronRightIcon`          | Chevron right          |
| Chevron Left          | `ChevronLeftIcon`           | Chevron left           |
| Chevron Up            | `ChevronUpIcon`             | Chevron up             |
| Chevron Down          | `ChevronDownIcon`           | Chevron down           |
| Chevron Vertical      | `ChevronVerticalIcon`       | Vertical chevron       |
| Double Chevron Right  | `DoubleChevronRightIcon`    | Double chevron right   |
| Double Chevron Left   | `DoubleChevronLeftIcon`     | Double chevron left    |
| Switch Vertical       | `SwitchVerticalIcon`        | Vertical switch        |
| Switch Horizontal     | `SwitchHorizontalIcon`      | Horizontal switch      |
| Reverse Left          | `ReverseLeftIcon`           | Reverse left           |
| Reverse Right         | `ReverseRightIcon`          | Reverse right          |

---

## Controls Icons

Operation control icons.

| Icon Name          | Import Name            | Description        |
| ------------------ | ---------------------- | ------------------ |
| Close              | `CloseIcon`            | Close              |
| Trash              | `TrashIcon`            | Delete             |
| Setting            | `SettingIcon`          | Settings           |
| Filter             | `FilterIcon`           | Filter             |
| Reset              | `ResetIcon`            | Reset              |
| Refresh CCW        | `RefreshCcwIcon`       | Counter-clockwise refresh |
| Refresh CW         | `RefreshCwIcon`        | Clockwise refresh  |
| Eye                | `EyeIcon`              | Show               |
| Eye Invisible      | `EyeInvisibleIcon`     | Hide               |
| Plus               | `PlusIcon`             | Add                |
| Minus              | `MinusIcon`            | Subtract           |
| Checked            | `CheckedIcon`          | Checked            |
| Dot Vertical       | `DotVerticalIcon`      | Vertical dots      |
| Dot Horizontal     | `DotHorizontalIcon`    | Horizontal dots    |
| Dot Grid           | `DotGridIcon`          | Dot grid           |
| Dot Drag Vertical  | `DotDragVerticalIcon`  | Vertical drag      |
| Dot Drag Horizontal| `DotDragHorizontalIcon`| Horizontal drag    |
| Zoom In            | `ZoomInIcon`           | Zoom in            |
| Zoom Out           | `ZoomOutIcon`          | Zoom out           |
| Pin                | `PinIcon`              | Pin                |
| Pin Filled         | `PinFilledIcon`        | Pin (filled)       |
| Maximize           | `MaximizeIcon`         | Maximize           |
| Minimize           | `MinimizeIcon`         | Minimize           |
| Resize Handle      | `ResizeHandleIcon`     | Resize             |
| Lock               | `LockIcon`             | Lock               |
| Unlock             | `UnlockIcon`           | Unlock             |

---

## Alert Icons

Status alert and notification icons.

| Icon Name       | Import Name            | Description          |
| --------------- | ---------------------- | -------------------- |
| Checked Filled  | `CheckedFilledIcon`    | Success (filled)     |
| Checked Outline | `CheckedOutlineIcon`   | Success (outline)    |
| Error Filled    | `ErrorFilledIcon`      | Error (filled)       |
| Error Outline   | `ErrorOutlineIcon`     | Error (outline)      |
| Warning Filled  | `WarningFilledIcon`    | Warning (filled)     |
| Warning Outline | `WarningOutlineIcon`   | Warning (outline)    |
| Info Filled     | `InfoFilledIcon`       | Info (filled)        |
| Info Outline    | `InfoOutlineIcon`      | Info (outline)       |
| Dangerous Filled| `DangerousFilledIcon`  | Danger (filled)      |
| Dangerous Outline| `DangerousOutlineIcon`| Danger (outline)     |
| Question Filled | `QuestionFilledIcon`   | Question (filled)    |
| Question Outline| `QuestionOutlineIcon`  | Question (outline)   |

---

## Content Icons

Content operation icons.

| Icon Name       | Import Name         | Description        |
| --------------- | ------------------- | ------------------ |
| Edit            | `EditIcon`          | Edit               |
| Copy            | `CopyIcon`          | Copy               |
| Download        | `DownloadIcon`      | Download           |
| Upload          | `UploadIcon`        | Upload             |
| File            | `FileIcon`          | File               |
| File Attachment | `FileAttachmentIcon`| Attachment         |
| File Search     | `FileSearchIcon`    | Search file        |
| Link            | `LinkIcon`          | Link               |
| Link External   | `LinkExternalIcon`  | External link      |
| Image           | `ImageIcon`         | Image              |
| Gallery         | `GalleryIcon`       | Gallery            |
| List            | `ListIcon`          | List               |
| Align Left      | `AlignLeftIcon`     | Align left         |
| Align Right     | `AlignRightIcon`    | Align right        |
| Star Filled     | `StarFilledIcon`    | Star (filled)      |
| Star Outline    | `StarOutlineIcon`   | Star (outline)     |
| Bookmark Add    | `BookmarkAddIcon`   | Add bookmark       |
| Bookmark Added  | `BookmarkAddedIcon` | Bookmarked         |
| Bookmark Filled | `BookmarkFilledIcon`| Bookmark (filled)  |
| Bookmark Outline| `BookmarkOutlineIcon`| Bookmark (outline)|
| Bookmark Remove | `BookmarkRemoveIcon`| Remove bookmark    |
| Share           | `ShareIcon`         | Share              |
| Mail            | `MailIcon`          | Mail               |
| Mail Unread     | `MailUnreadIcon`    | Unread mail        |
| Box             | `BoxIcon`           | Box                |
| Camera          | `CameraIcon`        | Camera             |
| Camera Add      | `CameraAddIcon`     | Add camera/photo   |
| Code            | `CodeIcon`          | Code               |
| NFC             | `NfcIcon`           | NFC                |

---

## Stepper Icons

Step indicator number icons.

| Icon Name | Import Name | Description |
| --------- | ----------- | ----------- |
| Item 0    | `Item0Icon` | Step 0      |
| Item 1    | `Item1Icon` | Step 1      |
| Item 2    | `Item2Icon` | Step 2      |
| Item 3    | `Item3Icon` | Step 3      |
| Item 4    | `Item4Icon` | Step 4      |
| Item 5    | `Item5Icon` | Step 5      |
| Item 6    | `Item6Icon` | Step 6      |
| Item 7    | `Item7Icon` | Step 7      |
| Item 8    | `Item8Icon` | Step 8      |
| Item 9    | `Item9Icon` | Step 9      |

---

## Legacy (Deprecated Icons)

> ⚠️ The following icon names are deprecated and no longer exported from `@mezzanine-ui/icons`. Listed here for migration reference only — use the replacement icon instead.

| Deprecated Icon                | Replacement                             |
| ------------------------------ | --------------------------------------- |
| `ArrowDownIcon`                | `LongTailArrowDownIcon`                 |
| `ArrowRightIcon`               | `LongTailArrowRightIcon`                |
| `ArrowUpIcon`                  | `LongTailArrowUpIcon`                   |
| `ArrowLeftIcon`                | `LongTailArrowLeftIcon`                 |
| `BellIcon`                     | `NotificationIcon`                      |
| `CancelIcon`                   | `CloseIcon`                             |
| `CheckBoldIcon`                | `CheckedIcon`                           |
| `CheckCircleFilledIcon`        | `CheckedFilledIcon`                     |
| `CheckIcon`                    | `CheckedIcon`                           |
| `DocIcon`                      | `FileIcon`                              |
| `DollarIcon`                   | `CurrencyDollarIcon`                    |
| `DragIcon`                     | `DotDragVerticalIcon`                   |
| `ExclamationCircleFilledIcon`  | `ErrorFilledIcon`                       |
| `EyeCloseIcon`                 | `EyeInvisibleIcon`                      |
| `EyeSlashIcon`                 | `EyeInvisibleIcon`                      |
| `HelpCircleFilledIcon`         | `QuestionFilledIcon`                    |
| `InfoCircleFilledIcon`         | `InfoFilledIcon`                        |
| `MinusBoldIcon`                | `MinusIcon`                             |
| `MinusCircleFilledIcon`        | `ErrorFilledIcon`                       |
| `MoreHorizontalIcon`           | `DotHorizontalIcon`                     |
| `MoreVerticalIcon`             | `DotVerticalIcon`                       |
| `ProfileIcon`                  | `UserIcon`                              |
| `SettingsIcon`                 | `SettingIcon`                           |
| `StarIcon`                     | `StarFilledIcon` / `StarOutlineIcon`    |
| `StarPressedIcon`              | `StarFilledIcon`                        |
| `SwitcherIcon`                 | `SwitchVerticalIcon`                    |
| `TimesCircleFilledIcon`        | `ErrorFilledIcon`                       |
| `TimesIcon`                    | `CloseIcon`                             |

---

## Common Icon Combination Examples

### Button with Icon

```tsx
import { Button } from '@mezzanine-ui/react';
import { PlusIcon, TrashIcon, DownloadIcon } from '@mezzanine-ui/icons';

// Leading icon
<Button icon={PlusIcon} iconType="leading">Add</Button>

// Trailing icon
<Button icon={ChevronDownIcon} iconType="trailing">Expand</Button>

// Icon only
<Button icon={TrashIcon} iconType="icon-only" variant="destructive-ghost" />
```

### Input with Icon

```tsx
import { TextField } from '@mezzanine-ui/react';
import { SearchIcon, CloseIcon } from '@mezzanine-ui/icons';

<TextField
  prefix={<SearchIcon />}
  suffix={<CloseIcon />}
  placeholder="Search..."
/>
```

### Status Icons

```tsx
import { Icon } from '@mezzanine-ui/react';
import {
  CheckedFilledIcon,
  ErrorFilledIcon,
  WarningFilledIcon,
  InfoFilledIcon,
} from '@mezzanine-ui/icons';

// Success
<Icon icon={CheckedFilledIcon} color="success" />

// Error
<Icon icon={ErrorFilledIcon} color="error" />

// Warning
<Icon icon={WarningFilledIcon} color="warning" />

// Info
<Icon icon={InfoFilledIcon} color="primary" />
```
