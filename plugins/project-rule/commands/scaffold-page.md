---
name: scaffold-page
description: "Interactively guide frontend Next.js page creation and launch the scaffolder agent. Use when creating a new CMS page, adding a frontend view, or scaffolding a list/detail page. Trigger when user says scaffold page, create page, new page, add frontend page, generate page."
argument-hint: "<page-path>"
---

# Scaffold Frontend Page

Follow the workflow below to guide the user through creating a new Next.js CMS page.

## Argument Parsing

{{#if args}}
Parse the user-provided arguments: `{{ args }}`

- Treat the path as the page location (e.g., `cms/products`, `cms/categories`)
- If the path does not include the `cms/` prefix, add it automatically
{{/if}}

## Guided Workflow

### 1. Confirm Page Path

{{#unless args}}
Ask the user for the page path, e.g., `cms/products`, `cms/categories`.
{{/unless}}

### 2. Collect Page Information

Ask the user for the following information in order:

1. **Page Title** (display name shown in the page header)
   - Examples: "Product Management", "Category Management"
   - Used for the `title` prop of the `ContentHeader` inside `PageHeader` (`PageHeader` itself takes no `title` prop)

2. **Data Entity Name** (English PascalCase)
   - Examples: `Product`, `Category`
   - Used for component naming and GraphQL operation naming

3. **List Columns** (Table columns)
   - Ask which fields should be displayed
   - Each column requires: field name, display title, data type
   - Examples: `name Name string`, `price Price number`, `status Status enum`

4. **Whether a Form Modal is needed**
   - If yes, proceed to step 5
   - If no (list page only), skip form-related configuration

5. **Form Fields** (only when Modal is needed)
   - Ask which form fields are required
   - Each field requires: field name, display label, field type (text / number / select / date / textarea), required flag
   - Examples: `name Name text required`, `description Description textarea optional`

### 3. Confirm Information Summary

Compile all collected information into a summary table and ask the user to confirm:

| Item           | Value          |
| -------------- | -------------- |
| Page Path      | `cms/{domain}` |
| Page Title     | {Chinese name} |
| Entity Name    | {Entity}       |
| List Columns   | {N}            |
| Form Modal     | Yes / No       |
| Form Fields    | {N}            |

### 4. Launch Scaffolder Agent

Once confirmed, launch the `nextjs-page-scaffolder` agent with the following information:

- Page path
- Page title (Chinese)
- Entity name (PascalCase)
- List column definitions (including name, title, type)
- Form field definitions (including name, label, type, required flag)

The agent will create all files following the `scaffolding-nextjs-page` skill templates.

## Example Usage

```
/scaffold-page
/scaffold-page cms/products
/scaffold-page cms/categories
```
