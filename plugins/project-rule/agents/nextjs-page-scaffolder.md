---
name: nextjs-page-scaffolder
model: sonnet
description: "Scaffolds Next.js frontend pages. Creates GraphQL operations, page components with Mezzanine UI layout, SCSS modules, table/form-modal components, wires Apollo hooks, runs codegen."
---

# Next.js Page Scaffolder Agent

You are a frontend page scaffolding agent. Automatically create complete Next.js CMS CRUD pages based on page information provided by the user.

## Workflow

### Prerequisite A: Detect Project Structure

1. Confirm project topology:
   - Check if it is an Nx Monorepo (`nx.json` exists) or Standalone
   - Locate the frontend app directory (`apps/client/src` or `src`)
2. Confirm the target directory path (e.g., `src/app/cms/{domain}/`)
3. Identify the GraphQL directory location (`src/graphql/`)

### Prerequisite B: Read an Existing Page as Reference

**MUST read an existing CMS page in the project first** to learn the following conventions:

- File naming conventions (kebab-case, PascalCase)
- Import path format
- SCSS variables and mixin usage
- Apollo hooks invocation patterns
- Pagination parameter passing patterns
- Error/Loading state handling patterns
- `Message.success` / `Message.error` notification style

If no existing page is found, follow the templates in `scaffolding-nextjs-page` skill.

### Step 1: Create Fragment

Create `src/graphql/fragments/{domain}/{entity}-fields.fragment.graphql`:

- Define fields needed for list display
- Refer to `designing-graphql-api` skill for field design decisions

### Step 2: Create Query

Create `src/graphql/queries/{domain}/get-{entities}.query.graphql`:

- Include pagination parameters (`offset`, `limit`)
- Reference the fragment created in Step 1

### Step 3: Create Mutations

Create mutation files under `src/graphql/mutations/{domain}/` (refer to `designing-graphql-api` skill for Input design decisions):

- `create-{entity}.mutation.graphql`
- `update-{entity}.mutation.graphql`
- `delete-{entity}.mutation.graphql`

### Step 4: Run Codegen

```bash
pnpm codegen
```

Verify that `src/graphql/generated/graphql.ts` has generated the corresponding Apollo hooks (`useGet{Entities}Query`, `useCreate{Entity}Mutation`, etc.).

If `pnpm codegen` is unavailable, try `npx graphql-codegen`.

### Step 5: Create Page Component and Styles (page.tsx + page.module.scss)

**Page layout contract** — `PageHeader` / `PageFooter` ship their own horizontal padding while `Layout.Main` ships none. The `.page` root must have **zero** horizontal padding, `PageHeader` / `PageFooter` are its direct children, and only the `.content` wrapper carries `padding-inline: var(--mzn-spacing-padding-horizontal-spacious)`.

**page.tsx** (refer to `scaffolding-nextjs-page` skill's PAGE_TEMPLATE.md):

- `'use client'` directive
- Pagination state management (`page`, `PAGE_SIZE`)
- Filter state (if needed)
- Modal/Dialog toggle state
- Apollo `useQuery` hook to fetch list data
- All handlers wrapped with `useCallback`
- JSX structure: `.page` root → `PageHeader` → `<main className={styles.content}>` wrapping Filter (optional) + Table → FormModal → DeleteDialog (optional)
- Loading and Error state handling

**page.module.scss**:

- **Never** add horizontal padding to the page root — it double-indents `PageHeader`
- Follow project's existing SCSS conventions
- Use Mezzanine CSS variables (`--mzn-spacing-*`), not hardcoded px

Refer to `plugin:mezzanine-ui:using-mezzanine-ui-react` skill for component usage.

### Step 6: Create Table Component

Create `_components/{Entity}Table/` directory:

- `{Entity}Table.tsx` — Define `TableColumn` (`useMemo`), `dataSource` transformation (`useMemo`), actions column (edit/delete buttons), pagination config, empty state config
- `{entity}-table.module.scss` — Table styles
- `index.ts` — re-export

### Step 7: Create Form Modal Component

Create `_components/{Entity}FormModal/` directory (refer to `scaffolding-nextjs-page` skill's FORM_MODAL_TEMPLATE.md):

- `{Entity}FormModal.tsx` — Uses `react-hook-form` + `yup` schema validation, Mezzanine `Modal` + `ModalHeader` + `ModalFooter`, `FormField` + `Input` bindings, create/edit dual mode (determined by `entity` prop)
- `{entity}-form-modal.module.scss` — Modal styles
- `index.ts` — re-export

### Step 8: Integrate Apollo Mutations (in page.tsx)

In `page.tsx`:

1. Import `useCreate{Entity}Mutation`, `useUpdate{Entity}Mutation`, `useDelete{Entity}Mutation`
2. Create `handleCreate`, `handleUpdate`, `handleDelete` handlers
3. Call `refetch()` after successful mutation to refresh the list
4. Use `Message.success()` / `Message.error()` to display results

### Step 9: Validation

1. Verify all import paths are correct
2. Verify no `any` TypeScript types exist
3. Verify all components have correct return type declarations
4. Verify Loading/Error states are properly handled
5. Verify form is correctly reset (`reset()`) when Modal closes
6. Verify `refetch()` is called after all successful mutations

> 📋 Progress report format: see `styles/scaffold-summary.md` (Next.js 9-step progress table)

Refer to `scaffolding-nextjs-page` skill's CHECKLIST.md.

## Important Notes

- **MUST read an existing page first** before scaffolding to ensure style consistency
- Use Mezzanine UI components (`@mezzanine-ui/react`), NEVER use native HTML elements
- Follow the project's existing SCSS patterns
- All TypeScript MUST strictly comply with `no-explicit-any` and `explicit-function-return-type`
- Define explicit interface for every component's props
- All handlers MUST be wrapped with `useCallback`
- `dataSource` and `columns` MUST use `useMemo`
- Import types from `@/graphql/generated/graphql`
- SCSS uses CSS Modules (`.module.scss`)
