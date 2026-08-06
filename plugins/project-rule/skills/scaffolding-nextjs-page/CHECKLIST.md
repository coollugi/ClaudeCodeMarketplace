# Pre-Scaffolding Checklist

Confirm the following items before starting scaffolding.

## Requirements Confirmation

- [ ] **Entity name**: Both English and localized display name (e.g., Category)
- [ ] **URL path**: `/cms/{domain}` (e.g., `/cms/categories`)
- [ ] **Pagination needed**: Does the list data exceed a single page?
- [ ] **Filters needed**: Does the list require filter conditions?

## GraphQL Operations

- [ ] **Fragment fields**: Which fields should the list display?
- [ ] **Query parameters**: Besides `offset` / `limit`, are there filter parameters?
- [ ] **Create mutation parameters**: Which fields are needed for creation?
- [ ] **Update mutation parameters**: Which fields are needed for editing? (typically = Create + id)
- [ ] **Delete mutation parameters**: Usually only `id`
- [ ] **Backend schema readiness**: Are the corresponding Query / Mutation already deployed?

## Table Columns

- [ ] **Column list**: Each column's `key`, `title`, `width`
- [ ] **Enum columns**: Are there enums requiring label mapping?
- [ ] **Date columns**: Are there dates requiring formatting (`dayjs`)?
- [ ] **Link columns**: Are there fields that navigate to a detail page (`Link`)?
- [ ] **Actions column**: Edit / Delete / other custom actions

## Form Modal

- [ ] **Form field list**: Each field's name, label, type (Input / Select / Textarea)
- [ ] **Validation rules**: Required, length limits, format validation (yup schema)
- [ ] **Create / Edit differences**: Are there fields that are read-only in edit mode?
- [ ] **Default values**: Default value settings for create mode

## Required Components

- [ ] **Page layout contract**: `.page` root has no horizontal padding; `PageHeader` / `PageFooter` are its direct children; only `.content` carries `padding-inline`
- [ ] **Mezzanine UI components**:
  - `PageHeader` + `ContentHeader` (page title area, direct child of the `.page` root)
  - `Table` + `TableColumn` (list)
  - `Modal` + `ModalHeader` + `ModalFooter` (form dialog)
  - `FormField` + `Input` (form)
  - `Button` (action buttons)
  - `Message` (success / error notifications)
- [ ] **Icons**: `PlusIcon` (create button), `EditIcon` (edit), `TrashIcon` (delete), `RefreshCcwIcon` (refresh)
- [ ] **react-hook-form** + **yup**: Form management and validation

## Advanced Features (As Needed)

- [ ] **Expandable Row**: Display child data in an expanded row?
- [ ] **Filters**: Separate Filter component needed?
- [ ] **Delete Confirmation Dialog**: Separate delete confirmation component needed?
- [ ] **Detail Page**: `[id]/page.tsx` detail page needed?
- [ ] **Internationalization**: `useLocale()` for multi-language fields needed?
