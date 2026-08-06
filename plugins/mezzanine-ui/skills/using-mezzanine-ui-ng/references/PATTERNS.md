# Mezzanine-UI Angular Usage Patterns

> Baseline: `@mezzanine-ui/ng` `1.0.0-rc.4` · Last verified 2026-04-24.
> Real-world source: TYGForm admin app (Nx monorepo, Angular 21, standalone components).

## Table of Contents

- [Project Setup Patterns](#project-setup-patterns)
- [Page Scaffolding Patterns](#page-scaffolding-patterns)
- [Form Patterns](#form-patterns)
- [Navigation + Layout Patterns](#navigation--layout-patterns)
- [Modal & Drawer Patterns](#modal--drawer-patterns)
- [Table + Pagination Patterns](#table--pagination-patterns)
- [Message / Toast / Notification Patterns](#message--toast--notification-patterns)
- [Theme + Dark-Mode Patterns](#theme--dark-mode-patterns)
- [Calendar / Date Patterns](#calendar--date-patterns)
- [File Structure Conventions](#file-structure-conventions)
- [Utilities](#utilities)

---

## Project Setup Patterns

### Nx Monorepo Baseline (TYGForm convention)

TYGForm uses an Nx workspace with an `apps/admin` application. Angular apps
live under `apps/`, shared libraries under `libs/`.

```
apps/
  admin/
    src/
      main.ts                    # bootstrapApplication entry
      app/
        app.config.ts            # ApplicationConfig providers
        app.routes.ts            # root routes
        app.ts                   # root App component
        core/                    # singletons: auth, interceptors
        layouts/                 # shell layout components
        pages/                   # route-level page components
      styles/
      styles.scss                # global design tokens + mezzanine styles
```

`apps/admin/src/main.ts`:

```ts
import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { App } from './app/app';

bootstrapApplication(App, appConfig).catch(err => console.error(err));
```

### Global SCSS Setup (`styles.scss`)

Required in every Mezzanine app. Missing either include causes unstyled components.

```scss
@use '@mezzanine-ui/system' as mzn-system;
@use '@mezzanine-ui/core' as mezzanine;

// Design tokens — REQUIRED
:root {
  @include mzn-system.colors('light');
  @include mzn-system.common-variables(default);
}

// Dark theme token override
[data-theme='dark'] {
  @include mzn-system.colors('dark');
}

// Compact density override
[data-density='compact'] {
  @include mzn-system.common-variables(compact);
}

// Component styles — REQUIRED
@include mezzanine.styles();

// Selective inclusion (tree-shaking partial):
// @include mezzanine.styles((button: null, icon: null, input: null));

*,
*::before,
*::after { box-sizing: border-box; }

html, body { height: 100%; margin: 0; padding: 0; }

body {
  font-family: 'Noto Sans TC', 'PingFang TC', -apple-system, sans-serif;
  -webkit-font-smoothing: antialiased;
}
```

> Nx projects: register `styles.scss` in `project.json` → `targets.build.options.styles`.

### ApplicationConfig — Provider Setup

Minimal config from TYGForm. Add `MZN_CALENDAR_CONFIG` when date pickers are used.

```ts
import { provideHttpClient, withFetch, withInterceptors } from '@angular/common/http';
import {
  ApplicationConfig,
  provideBrowserGlobalErrorListeners,
  provideZoneChangeDetection,
} from '@angular/core';
import { provideRouter } from '@angular/router';
import { appRoutes } from './app.routes';

export const appConfig: ApplicationConfig = {
  providers: [
    provideBrowserGlobalErrorListeners(),
    provideZoneChangeDetection({ eventCoalescing: true }),
    provideRouter(appRoutes),
    provideHttpClient(withFetch()),
  ],
};
```

With calendar support:

```ts
import { MZN_CALENDAR_CONFIG, createCalendarConfig, CalendarLocale } from '@mezzanine-ui/ng/calendar';
import CalendarMethodsDayjs from '@mezzanine-ui/core/calendarMethodsDayjs';

export const appConfig: ApplicationConfig = {
  providers: [
    // ...other providers
    {
      provide: MZN_CALENDAR_CONFIG,
      useValue: createCalendarConfig(CalendarMethodsDayjs, {
        locale: CalendarLocale.ZH_TW,
        defaultDateFormat: 'YYYY/MM/DD',
      }),
    },
  ],
};
```

---

## Page Scaffolding Patterns

### Page Body Alignment with MznPageHeader (重要 — 容易忽略)

`MznPageHeader` 內建水平/垂直 padding（核心 CSS 為 `padding: spacious spacious 0`，水平對應 `--mzn-spacing-padding-horizontal-spacious`，預設 16px / compact 14px）。`MznPageHeader` 沒有任何 inputs，這個 padding **完全來自元件內部 SCSS**，光看 template / 型別看不出來。因此頁面骨架要遵循：

1. **頁面最外層 container 不可加水平 padding** — 讓 `<header mznPageHeader>` 自己貼齊版面邊緣，padding 由元件內建提供。
2. **`mznPageHeader` / `mznPageFooter` 直接放在最外層 column** — `MznPageFooter` 同樣自帶 padding（`vertical-base horizontal-spacious`，預設 8px / 16px）並帶 `border-top` 與底色，必須滿版，不可放進有 padding 的 wrapper。
3. **下方主要內容必須包一層 wrapper，套上相同的水平 padding** — 通常是 `padding-inline: var(--mzn-spacing-padding-horizontal-spacious)`，讓表格 / 卡片 / 表單的左緣對齊 `MznContentHeader` 的標題文字。
4. **垂直間距靠 container 的 `row-gap`** — `mznPageHeader` 的 `padding-bottom` 刻意為 `0`，區塊分隔由 container 分配（建議 `var(--mzn-spacing-gap-calm)`）；不要對它補 `margin-bottom`。

> 內容若使用 `mznSection`：**外側 gutter 仍要靠 body wrapper 的 `padding-inline`**（它沒有 margin，直接掛在無 padding 的 page container 下會貼齊版面邊緣）；自帶的 `vertical-spacious horizontal-spacious`（16px）是**卡片內側**的 padding，因此不要再對它本身或它的直接子元素補 padding。最終對齊：卡片左緣 = PageHeader 標題文字左緣（16px），卡片內容再內縮 16px。

| 元件                              | 生效條件                                     | host padding                                                             | default       | compact       |
| --------------------------------- | -------------------------------------------- | ------------------------------------------------------------------------ | ------------- | ------------- |
| `[mznPageHeader]`                 | 無條件                                       | `vertical-spacious horizontal-spacious 0`                                | `16 / 16 / 0` | `12 / 14 / 0` |
| `[mznPageFooter]`                 | 無條件                                       | `vertical-base horizontal-spacious`                                      | `8 / 16`      | `4 / 14`      |
| `[mznFilterArea]`                 | `size="main"`（預設）                        | `padding-inline: horizontal-spacious` + `padding-top: vertical-spacious` | `16 / top 16` | `14 / top 12` |
| `[mznTabs]`                       | `size="main"`（預設）+ horizontal            | `vertical-spacious horizontal-spacious 0`                                | `16 / 16 / 0` | `12 / 14 / 0` |
| `[mznTabs]`                       | `size="main"` + vertical                     | `0 0 0 horizontal-spacious`                                              | `left 16`     | `left 14`     |
| `[mznSection]`                    | 無條件（**卡片**，需外層 wrapper 給 gutter） | `vertical-spacious horizontal-spacious`                                  | `16 / 16`     | `12 / 14`     |
| `[mznLayout]` / `[mznLayoutMain]` | —                                            | 無                                                                       | —             | —             |

> **`size="main"` = 頁面級、自帶 gutter、必須貼邊；`size="sub"` = 放在 `[mznSection]` 內、無外距。** `[mznFilterArea]` 與 `[mznTabs]` 的 `size` input 預設值都是 `'main'`，把它們放進套了 `padding-inline` 的 body wrapper 而沒改成 `size="sub"`，就是 16 + 16 的雙層內縮。`[mznSection]` 另有 `> .mzn-tab--horizontal.mzn-tab--main { padding: 0 }`，會把投射進來的 main size Tabs padding 歸零。

```html
<!-- ✅ 正確：外層無 padding，PageHeader 直接貼邊；body 用 wrapper 對齊 -->
<div class="page">
  <header mznPageHeader>
    <nav mznBreadcrumb [items]="breadcrumb()"></nav>
    <header mznContentHeader title="商品管理" description="管理所有商品">
      <div actions>
        <button mznButton variant="base-primary" (click)="create()">新增</button>
      </div>
    </header>
  </header>

  <main class="page__body">
    <div mznTable [columns]="columns" [dataSource]="data()"></div>
    <div mznPagination [total]="total()" [current]="page()"
         (pageChange)="onPageChange($event)"></div>
  </main>

  <!-- PageFooter 與 PageHeader 同層，貼齊版面 -->
  <div mznPageFooter type="standard">
    <div actions>
      <button mznButton variant="base-primary" (click)="save()">儲存</button>
    </div>
  </div>
</div>
```

```scss
// feature.page.scss
.page {
  // ❌ 不要在這裡加 padding-inline / padding-left / padding-right
  // MznPageHeader 已內建水平 padding，外層再加會造成 PageHeader 雙重內縮
  display: flex;
  flex-direction: column;
  // ✅ PageHeader 的 padding-bottom 為 0，區塊分隔由這裡的 row-gap 負責
  row-gap: var(--mzn-spacing-gap-calm);
  min-block-size: 100%;

  &__body {
    // ✅ 對齊 MznPageHeader 的水平 padding，讓表格 / 卡片左緣對齊標題文字
    padding-inline: var(--mzn-spacing-padding-horizontal-spacious);
    padding-block-end: var(--mzn-spacing-padding-vertical-spacious);
    display: flex;
    flex-direction: column;
    row-gap: var(--mzn-spacing-gap-calm);
    flex: 1;
  }
}
```

```html
<!-- ❌ 反例 1：外層加了 padding，導致 PageHeader 雙重內縮 -->
<div style="padding: 24px;">       <!-- PageHeader 比版面少 24px + 內建 16px = 40px -->
  <header mznPageHeader>...</header>
  <div mznTable ...></div>
</div>

<!-- ❌ 反例 2：外層拿掉 padding 了，但下方內容沒有 wrapper -->
<div class="page">
  <header mznPageHeader>...</header>
  <div mznTable ...></div>         <!-- 表格貼齊版面，比標題左緣少 16px -->
</div>

<!-- ❌ 反例 3：PageFooter 被塞進有 padding 的 body wrapper -->
<div class="page">
  <header mznPageHeader>...</header>
  <div class="page__body">
    <div mznTable ...></div>
    <div mznPageFooter>...</div>   <!-- border-top 沒有滿版，兩側各縮 16px -->
  </div>
</div>
```

> **為什麼這個 pattern 容易被忽略**：`MznPageHeader` 是極簡的 shell（無 inputs / outputs），padding 由 `_page-header-styles.scss` 注入。代理或開發者不檢查源碼時，自然會在外層 container 套上一致的 padding，反而造成視覺錯位。**搭配 `MznPageFooter` 時，footer 同樣有自己的 padding，遵循相同規則處理。**

### Standalone Page Component Skeleton

```ts
// feature.page.ts
import { Component } from '@angular/core';
import { MznPageHeader } from '@mezzanine-ui/ng/page-header';
import { MznContentHeader } from '@mezzanine-ui/ng/content-header';
import { MznSection } from '@mezzanine-ui/ng/section';
import { MznTypography } from '@mezzanine-ui/ng/typography';

@Component({
  selector: 'app-feature-page',
  imports: [MznPageHeader, MznContentHeader, MznSection, MznTypography],
  templateUrl: './feature.page.html',
  styleUrl: './feature.page.scss',
})
export class FeaturePage {}
```

```html
<!-- feature.page.html — from TYGForm test page pattern -->
<header mznPageHeader>
  <header mznContentHeader title="功能頁面" description="頁面描述文字。"></header>
</header>

<!--
  feature-page__body 是必要的 wrapper：
  PageHeader 內建水平 padding，下方內容必須套上相同 padding 才能對齊標題文字。
  詳見上方「Page Body Alignment with MznPageHeader」。
-->
<main class="feature-page__body">
  <div mznSection>
    <header mznContentHeader title="區段標題" size="sub" description="區段說明。"></header>
    <!-- page content here -->
  </div>
</main>
```

```scss
// feature.page.scss

// component host 就是 page container：不加水平 padding，用 row-gap 分隔區塊
:host {
  display: flex;
  flex-direction: column;
  row-gap: var(--mzn-spacing-gap-calm);
  min-block-size: 100%;
}

.feature-page {
  &__body {
    padding-inline: var(--mzn-spacing-padding-horizontal-spacious);
    padding-block-end: var(--mzn-spacing-padding-vertical-spacious);
    display: flex;
    flex-direction: column;
    row-gap: var(--mzn-spacing-gap-calm);
    flex: 1;
  }
}
```

> 頁面元件的 host 若沒有設成 flex column，`mznPageHeader` 與 body 之間就沒有 `row-gap`（PageHeader 的 `padding-bottom` 是 `0`），兩塊會直接黏在一起。

### ContentHeader sizes

| `size`  | Use case                                      |
| ------- | --------------------------------------------- |
| `main`  | Top-level page header (inside `mznPageHeader`) |
| `sub`   | Section heading inside `mznSection`           |

### Page with Back Button

```html
<header mznPageHeader>
  <header
    mznContentHeader
    title="詳細頁面"
    [showBackButton]="true"
    (backClick)="goBack()"
  ></header>
</header>
```

---

## Form Patterns

### Simple Form with ReactiveForms (TYGForm login pattern)

```ts
// login.page.ts
import { Component, inject, signal } from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { FormFieldLayout } from '@mezzanine-ui/core/form';
import { MznButton } from '@mezzanine-ui/ng/button';
import { MznFormField } from '@mezzanine-ui/ng/form';
import { MznIcon } from '@mezzanine-ui/ng/icon';
import { MznInlineMessage } from '@mezzanine-ui/ng/inline-message';
import { MznInput } from '@mezzanine-ui/ng/input';
import { MznTypography } from '@mezzanine-ui/ng/typography';
import { UserIcon, LockIcon } from '@mezzanine-ui/icons';

@Component({
  selector: 'app-login-page',
  imports: [ReactiveFormsModule, MznButton, MznFormField, MznIcon, MznInlineMessage, MznInput, MznTypography],
  templateUrl: './login.page.html',
})
export class LoginPage {
  private readonly fb = inject(FormBuilder);

  protected readonly userIcon = UserIcon;
  protected readonly lockIcon = LockIcon;
  protected readonly verticalLayout = FormFieldLayout.VERTICAL;
  protected readonly isLoading = signal(false);
  protected readonly errorMessage = signal<string | null>(null);

  protected readonly loginForm: FormGroup = this.fb.group({
    account: ['', [Validators.required]],
    password: ['', [Validators.required]],
  });

  protected onSubmit(): void {
    if (this.loginForm.invalid) {
      this.loginForm.markAllAsTouched();
      return;
    }
    // handle submission
  }
}
```

```html
<!-- login.page.html -->
<form [formGroup]="loginForm" (ngSubmit)="onSubmit()">
  <div mznFormField name="account" label="帳號" [layout]="verticalLayout">
    <div mznInput variant="base" placeholder="請輸入帳號" [fullWidth]="true" formControlName="account">
      <i mznIcon [icon]="userIcon" [size]="16" slot="prefix"></i>
    </div>
  </div>

  <div mznFormField name="password" label="密碼" [layout]="verticalLayout">
    <div mznInput variant="password" placeholder="請輸入密碼" [fullWidth]="true" formControlName="password">
      <i mznIcon [icon]="lockIcon" [size]="16" slot="prefix"></i>
    </div>
  </div>

  @if (errorMessage(); as msg) {
    <div mznInlineMessage severity="error" [content]="msg"></div>
  }

  <button
    mznButton
    type="submit"
    variant="base-primary"
    size="main"
    [disabled]="loginForm.invalid || isLoading()"
    [loading]="isLoading()"
  >
    登入
  </button>
</form>
```

### FormField Composition

`MznFormField` wraps any form control with a label, hint, and validation state.

```html
<!-- Horizontal layout (default) -->
<div mznFormField name="email" label="電子郵件" [required]="true" [hintText]="'請輸入有效的 Email'">
  <div mznInput variant="base" formControlName="email" [fullWidth]="true"></div>
</div>

<!-- Vertical layout -->
<div mznFormField name="name" label="姓名" [layout]="FormFieldLayout.VERTICAL">
  <div mznInput variant="base" formControlName="name"></div>
</div>

<!-- With error state -->
<div
  mznFormField
  name="phone"
  label="電話"
  severity="error"
  hintText="格式不正確"
>
  <div mznInput variant="base" [error]="true" formControlName="phone"></div>
</div>
```

### Validation Display Pattern

Bind `severity` and `hintText` on `MznFormField` based on `AbstractControl` state:

```ts
// In component
protected getSeverity(ctrl: AbstractControl): 'error' | 'info' {
  return ctrl.invalid && ctrl.touched ? 'error' : 'info';
}
protected getHint(ctrl: AbstractControl, errorMsg: string): string | undefined {
  return ctrl.invalid && ctrl.touched ? errorMsg : undefined;
}
```

```html
<div
  mznFormField
  name="email"
  label="Email"
  [severity]="getSeverity(emailCtrl)"
  [hintText]="getHint(emailCtrl, '請輸入有效的 Email 格式')"
>
  <div mznInput variant="base" [error]="emailCtrl.invalid && emailCtrl.touched"
       formControlName="email"></div>
</div>
```

For API-level errors use `MznInlineMessage` as a sibling:

```html
@if (serverError()) {
  <div mznInlineMessage severity="error" [content]="serverError()!"></div>
}
```

### Select Field

```html
<div mznFormField name="type" label="類型" [layout]="verticalLayout">
  <div
    mznSelect
    formControlName="type"
    [options]="typeOptions"
    placeholder="請選擇類型"
    [fullWidth]="true"
  ></div>
</div>
```

```ts
protected readonly typeOptions: ReadonlyArray<{ id: string; name: string }> = [
  { id: 'personal', name: '個人' },
  { id: 'business', name: '企業' },
];
```

### Dynamic Forms with FormArray

```ts
protected readonly fb = inject(FormBuilder);

protected readonly form = this.fb.group({
  name: ['', Validators.required],
  tags: this.fb.array([this.newTagControl()]),
});

protected get tags(): FormArray {
  return this.form.get('tags') as FormArray;
}

protected addTag(): void {
  this.tags.push(this.newTagControl());
}

protected removeTag(index: number): void {
  this.tags.removeAt(index);
}

private newTagControl(): FormControl<string> {
  return this.fb.control('', { nonNullable: true, validators: Validators.required });
}

// Typed narrow from AbstractControl → FormControl for template bindings.
protected asFormControl(ctrl: AbstractControl): FormControl<string> {
  return ctrl as FormControl<string>;
}
```

```html
@for (ctrl of tags.controls; track $index) {
  <div class="tag-row">
    <div mznFormField [name]="'tag-' + $index" [label]="'標籤 ' + ($index + 1)">
      <div mznInput variant="base" [formControl]="asFormControl(ctrl)"></div>
    </div>
    <button mznButton variant="destructive-text-link" size="sub" (click)="removeTag($index)">
      移除
    </button>
  </div>
}
<button mznButton variant="base-secondary" size="sub" type="button" (click)="addTag()">
  新增標籤
</button>
```

### Multi-Step Form with Stepper

```ts
@Component({
  imports: [ReactiveFormsModule, MznStepper, MznStep, MznButton, MznFormField, MznInput],
  template: `...`,
})
export class MultiStepFormComponent {
  protected readonly currentStep = signal(0);

  protected readonly stepOneForm = this.fb.group({
    name: ['', Validators.required],
    email: ['', [Validators.required, Validators.email]],
  });

  protected readonly stepTwoForm = this.fb.group({
    address: ['', Validators.required],
    city: ['', Validators.required],
  });

  protected nextStep(): void {
    const forms = [this.stepOneForm, this.stepTwoForm];
    if (forms[this.currentStep()]?.valid) {
      this.currentStep.update(s => s + 1);
    } else {
      forms[this.currentStep()]?.markAllAsTouched();
    }
  }
}
```

```html
<div mznStepper [currentStep]="currentStep()" type="number" (stepChange)="currentStep.set($event)">
  <div mznStep title="基本資料"></div>
  <div mznStep title="聯絡資訊"></div>
  <div mznStep title="確認送出"></div>
</div>

@switch (currentStep()) {
  @case (0) {
    <form [formGroup]="stepOneForm">
      <!-- step 1 fields -->
    </form>
  }
  @case (1) {
    <form [formGroup]="stepTwoForm">
      <!-- step 2 fields -->
    </form>
  }
  @case (2) {
    <!-- confirmation view -->
  }
}

<div class="form-actions">
  @if (currentStep() > 0) {
    <button mznButton variant="base-secondary" (click)="currentStep.update(s => s - 1)">上一步</button>
  }
  @if (currentStep() < 2) {
    <button mznButton variant="base-primary" (click)="nextStep()">下一步</button>
  } @else {
    <button mznButton variant="base-primary" (click)="submit()">送出</button>
  }
</div>
```

---

## Navigation + Layout Patterns

### Main Layout with Sidebar (TYGForm pattern)

```ts
// main-layout.component.ts
import { Component, DestroyRef, inject, signal } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { NavigationEnd, Router, RouterModule } from '@angular/router';
import {
  MznNavigation,
  MznNavigationFooter,
  MznNavigationHeader,
  MznNavigationIconButton,
  MznNavigationOption,
} from '@mezzanine-ui/ng/navigation';
import { HomeIcon, LogoutIcon, FileIcon } from '@mezzanine-ui/icons';
import { filter } from 'rxjs';

const ROUTE_TO_OPTION: ReadonlyArray<{ readonly urlStartsWith: string; readonly id: string }> = [
  { urlStartsWith: '/home', id: 'home' },
  { urlStartsWith: '/reports', id: 'reports' },
];

@Component({
  selector: 'app-main-layout',
  imports: [RouterModule, MznNavigation, MznNavigationHeader, MznNavigationOption,
            MznNavigationFooter, MznNavigationIconButton],
  templateUrl: './main-layout.component.html',
})
export class MainLayoutComponent {
  private readonly router = inject(Router);
  private readonly destroyRef = inject(DestroyRef);

  protected readonly homeIcon = HomeIcon;
  protected readonly fileIcon = FileIcon;
  protected readonly logoutIcon = LogoutIcon;

  protected readonly collapsed = signal(false);
  protected readonly activatedPath = signal<readonly string[]>(
    resolveActivatedIds(this.router.url),
  );

  constructor() {
    this.router.events
      .pipe(
        filter((e): e is NavigationEnd => e instanceof NavigationEnd),
        takeUntilDestroyed(this.destroyRef),
      )
      .subscribe(e => this.activatedPath.set(resolveActivatedIds(e.urlAfterRedirects)));
  }

  protected navigate(path: string): void {
    void this.router.navigateByUrl(path);
  }

  protected onCollapseChange(collapsed: boolean): void {
    this.collapsed.set(collapsed);
  }
}

function resolveActivatedIds(url: string): readonly string[] {
  const match = ROUTE_TO_OPTION.find(m => url.startsWith(m.urlStartsWith));
  return match ? [match.id] : [];
}
```

```html
<!-- main-layout.component.html -->
<div class="layout">
  <nav
    mznNavigation
    [activatedPath]="activatedPath()"
    [collapsed]="collapsed()"
    (collapseChange)="onCollapseChange($event)"
  >
    <header mznNavigationHeader title="我的應用程式">
      <img class="layout__logo" src="logo.svg" alt="Logo" />
    </header>

    <mzn-navigation-option optionId="home" title="首頁" [icon]="homeIcon"
      (triggerClick)="navigate('/home')" />
    <mzn-navigation-option optionId="reports" title="報表" [icon]="fileIcon"
      (triggerClick)="navigate('/reports')" />

    <footer mznNavigationFooter>
      <button mznNavigationIconButton type="button" [icon]="logoutIcon" title="登出"></button>
    </footer>
  </nav>

  <main class="layout__content">
    <router-outlet></router-outlet>
  </main>
</div>
```

### Navigation with Nested Sub-options

```html
<mzn-navigation-option title="設定" [icon]="settingsIcon" [hasChildren]="true">
  <mzn-navigation-option title="帳戶" optionId="settings-account"
    (triggerClick)="navigate('/settings/account')" />
  <mzn-navigation-option title="通知" optionId="settings-notifications"
    (triggerClick)="navigate('/settings/notifications')" />
</mzn-navigation-option>
```

`activatedPath` must include the full path array for sub-options to highlight
correctly, e.g. `['settings', 'settings-account']`.

### Tab Navigation

```ts
@Component({
  imports: [MznTabs, MznTabItem],
  template: `
    <div mznTabs [activeKey]="activeKey()" (activeKeyChange)="activeKey.set($event)">
      <div mznTabItem key="overview">概覽</div>
      <div mznTabItem key="details">詳細資訊</div>
      <div mznTabItem key="history">歷史紀錄</div>
    </div>

    @switch (activeKey()) {
      @case ('overview') { <app-overview /> }
      @case ('details')  { <app-details />  }
      @case ('history')  { <app-history />  }
    }
  `,
})
export class TabbedPageComponent {
  protected readonly activeKey = signal<string | number>('overview');
}
```

---

## Modal & Drawer Patterns

### Confirmation Modal

```ts
@Component({
  imports: [MznModal, MznButton],
  template: `
    <button mznButton variant="destructive-secondary" (click)="deleteTarget.set(item)">
      刪除
    </button>

    <div
      mznModal
      modalType="standard"
      size="narrow"
      [open]="deleteTarget() !== null"
      [showModalHeader]="true"
      [showModalFooter]="true"
      title="確認刪除"
      confirmText="刪除"
      cancelText="取消"
      (closed)="deleteTarget.set(null)"
      (confirm)="onConfirmDelete()"
      (cancel)="deleteTarget.set(null)"
    >
      確定要刪除「{{ deleteTarget()?.name }}」嗎？此操作無法復原。
    </div>
  `,
})
export class ItemListComponent {
  protected readonly deleteTarget = signal<Item | null>(null);

  protected onConfirmDelete(): void {
    const target = this.deleteTarget();
    if (target) {
      this.itemService.delete(target.id).subscribe(() => {
        this.deleteTarget.set(null);
      });
    }
  }
}
```

### Form Modal

```ts
@Component({
  imports: [ReactiveFormsModule, MznModal, MznFormField, MznInput],
  template: `
    <div
      mznModal
      modalType="standard"
      [open]="open()"
      [showModalHeader]="true"
      [showModalFooter]="true"
      title="新增項目"
      confirmText="確認"
      cancelText="取消"
      [loading]="isLoading()"
      (closed)="close.emit()"
      (confirm)="onSubmit()"
      (cancel)="close.emit()"
    >
      <form [formGroup]="form">
        <div mznFormField name="name" label="名稱" [required]="true">
          <div mznInput variant="base" formControlName="name" [fullWidth]="true"></div>
        </div>
      </form>
    </div>
  `,
})
export class AddItemModalComponent {
  readonly open = input(false);
  readonly close = output<void>();
  readonly submitted = output<{ name: string }>();

  protected readonly isLoading = signal(false);
  protected readonly form = inject(FormBuilder).group({
    name: ['', Validators.required],
  });

  protected onSubmit(): void {
    if (this.form.valid) {
      this.submitted.emit(this.form.value as { name: string });
    } else {
      this.form.markAllAsTouched();
    }
  }
}
```

### Drawer Detail Panel

```ts
@Component({
  imports: [MznDrawer, MznButton, MznTypography],
  template: `
    <section
      mznDrawer
      [open]="open()"
      placement="right"
      drawerTitle="項目詳情"
      bottomPrimaryActionText="編輯"
      bottomSecondaryActionText="關閉"
      (closed)="close.emit()"
      (bottomPrimaryActionClick)="onEdit()"
      (bottomSecondaryActionClick)="close.emit()"
    >
      <p mznTypography variant="body">{{ item()?.description }}</p>
    </section>
  `,
})
export class DetailDrawerComponent {
  readonly open = input(false);
  readonly item = input<Item | null>(null);
  readonly close = output<void>();
}
```

---

## Table + Pagination Patterns

### Basic Data Table

```ts
import { MznTable } from '@mezzanine-ui/ng/table';
import { TableColumn, TableDataSource } from '@mezzanine-ui/core/table';

@Component({
  imports: [MznTable, MznTag, MznButton],
  template: `
    <div mznTable [columns]="columns" [dataSource]="data" [loading]="isLoading()"></div>
    <div class="pagination-row">
      <div mznPagination
        [total]="total()"
        [current]="currentPage()"
        [pageSize]="pageSize"
        (pageChange)="onPageChange($event)"
      ></div>
    </div>
  `,
})
export class UserListPageComponent {
  protected readonly isLoading = signal(false);
  protected readonly data = signal<User[]>([]);
  protected readonly total = signal(0);
  protected readonly currentPage = signal(1);
  protected readonly pageSize = 10;

  protected readonly columns: ReadonlyArray<TableColumn> = [
    { title: '姓名', dataIndex: 'name' },
    {
      title: '狀態',
      dataIndex: 'status',
      render: (status: string) => ({
        component: MznTag,
        inputs: { type: 'static', label: status === 'active' ? '啟用' : '停用' },
      }),
    },
    { title: '建立時間', dataIndex: 'createdAt', render: (d: string) => new Date(d).toLocaleDateString() },
  ];

  protected onPageChange(page: number): void {
    this.currentPage.set(page);
    this.loadData(page);
  }
}
```

### Column with Template (using `ng-template`)

For complex cell rendering, use `MznTable`'s `renderCell` with an inline
template approach. The simpler path is to pass a component reference directly
in `TableColumn.render`.

```ts
protected readonly columns: ReadonlyArray<TableColumn> = [
  {
    title: '操作',
    dataIndex: 'id',
    render: (_val: unknown, row: User) => ({
      component: ActionsCell,
      inputs: { item: row },
      outputs: { deleted: (item: User) => this.handleDelete(item) },
    }),
  },
];
```

### Server-Side Pagination

```ts
protected loadData(page: number): void {
  this.isLoading.set(true);
  this.userService.getUsers({ page, pageSize: this.pageSize })
    .pipe(finalize(() => this.isLoading.set(false)))
    .subscribe(res => {
      this.data.set(res.items);
      this.total.set(res.total);
    });
}
```

```html
<div
  mznPagination
  [total]="total()"
  [current]="currentPage()"
  [pageSize]="pageSize"
  [showJumper]="true"
  (pageChange)="onPageChange($event)"
></div>
```

---

## Message / Toast / Notification Patterns

### MznMessageService (toasts)

Inject once and call convenience methods. Messages auto-dismiss after 3 s
by default.

```ts
import { MznMessageService } from '@mezzanine-ui/ng/message';

@Component({ ... })
export class MyComponent {
  private readonly message = inject(MznMessageService);

  protected save(): void {
    this.dataService.save(this.form.value).subscribe({
      next: () => this.message.success('儲存成功！'),
      error: (err: Error) => this.message.error(err.message),
    });
  }
}
```

| Method      | Signature                                             |
| ----------- | ----------------------------------------------------- |
| `success()` | `(message: string, props?) => string` (returns key)   |
| `error()`   | `(message: string, props?) => string`                 |
| `info()`    | `(message: string, props?) => string`                 |
| `warning()` | `(message: string, props?) => string`                 |
| `add()`     | `(data: MessageData) => string`                       |
| `remove()`  | `(key: string) => void`                               |

To suppress auto-close: `this.message.error('錯誤', { duration: false })`.

### AlertBanner (page-level persistent warning)

```ts
@Component({
  imports: [MznAlertBanner],
  template: `
    @if (showBanner()) {
      <div
        mznAlertBanner
        severity="warning"
        message="系統將於今晚 22:00 進行維護，預計停機 2 小時。"
        (closed)="showBanner.set(false)"
      ></div>
    }
    <div class="page-content">...</div>
  `,
})
export class PageComponent {
  protected readonly showBanner = signal(true);
}
```

### NotificationCenter (structured notifications)

```html
<div
  mznNotificationCenter
  severity="info"
  [description]="'你有 3 則未讀通知'"
  [from]="'top'"
  [duration]="false"
></div>
```

---

## Theme + Dark-Mode Patterns

### Toggle Theme at Runtime

```ts
@Component({
  imports: [MznButton],
  template: `
    <button mznButton variant="base-secondary" iconType="icon-only"
      [icon]="isDark() ? sunIcon : moonIcon"
      tooltipText="切換主題"
      (click)="toggleTheme()"
    ></button>
  `,
})
export class ThemeToggleComponent {
  protected readonly isDark = signal(false);
  protected readonly sunIcon = SunIcon;
  protected readonly moonIcon = MoonIcon;

  protected toggleTheme(): void {
    const next = !this.isDark();
    this.isDark.set(next);
    document.documentElement.setAttribute('data-theme', next ? 'dark' : 'light');
  }
}
```

### Density Toggle (compact mode)

```ts
document.documentElement.setAttribute('data-density', 'compact');
document.documentElement.removeAttribute('data-density'); // back to default
```

Both attributes work because they match the `[data-theme]` and `[data-density]`
selectors in `styles.scss` which include the appropriate Mezzanine mixins.

---

## Calendar / Date Patterns

### Bootstrap MznCalendarConfigProvider (template-scoped)

Use `[mznCalendarConfigProvider]` when only certain sections of the page need
date pickers, avoiding a global provider.

```ts
import { MznCalendarConfigProvider } from '@mezzanine-ui/ng/calendar';
import { MznDatePicker } from '@mezzanine-ui/ng/date-picker';
import CalendarMethodsDayjs from '@mezzanine-ui/core/calendarMethodsDayjs';

@Component({
  imports: [ReactiveFormsModule, MznCalendarConfigProvider, MznDatePicker],
  template: `
    <div mznCalendarConfigProvider [methods]="methods" locale="zh-TW">
      <div mznDatePicker [formControl]="dateCtrl" [fullWidth]="true"></div>
    </div>
  `,
})
export class FormWithDateComponent {
  protected readonly methods = CalendarMethodsDayjs;
  protected readonly dateCtrl = new FormControl('');
}
```

### DatePicker Value Binding

`MznDatePicker` implements `ControlValueAccessor`. Value type is `DateType`
(string in `YYYY-MM-DD` format by default).

```html
<!-- With formControl -->
<div mznDatePicker [formControl]="startDateCtrl" format="YYYY/MM/DD" [fullWidth]="true"></div>

<!-- With ngModel -->
<div mznDatePicker [(ngModel)]="selectedDate" [clearable]="true"></div>
```

### DateRangePicker

```ts
protected readonly rangeCtrl = new FormControl<[string, string] | null>(null);
```

```html
<div
  mznDateRangePicker
  [formControl]="rangeCtrl"
  inputFromPlaceholder="開始日期"
  inputToPlaceholder="結束日期"
  [fullWidth]="true"
></div>
```

### DateTimePicker

```html
<div
  mznDateTimePicker
  [formControl]="dateTimeCtrl"
  format="YYYY/MM/DD HH:mm"
  [fullWidth]="true"
></div>
```

### Disabled Dates Predicate

```ts
protected readonly isDateDisabled = (date: string): boolean => {
  return new Date(date) < new Date();  // disable past dates
};
```

```html
<div mznDatePicker [formControl]="ctrl" [isDateDisabled]="isDateDisabled"></div>
```

### MultipleDatePicker

```ts
protected readonly datesCtrl = new FormControl<string[]>([]);
```

```html
<div
  mznMultipleDatePicker
  [formControl]="datesCtrl"
  [maxSelections]="5"
  overflowStrategy="counter"
></div>
```

---

## File Structure Conventions

Based on TYGForm's admin app. Adapt to project scope.

```
apps/admin/src/
├── main.ts                          # bootstrapApplication
├── styles.scss                      # global mezzanine styles + tokens
├── app/
│   ├── app.ts                       # root App component (router-outlet)
│   ├── app.config.ts                # ApplicationConfig
│   ├── app.routes.ts                # route definitions
│   │
│   ├── core/                        # singleton services (no components)
│   │   ├── auth/
│   │   │   └── auth.service.ts
│   │   └── interceptors/
│   │       └── auth.interceptor.ts
│   │
│   ├── layouts/                     # shell / layout components
│   │   └── main-layout/
│   │       ├── main-layout.component.ts
│   │       ├── main-layout.component.html
│   │       └── main-layout.component.scss
│   │
│   └── pages/                       # route-level pages (1 folder per route)
│       ├── login/
│       │   ├── login.page.ts
│       │   ├── login.page.html
│       │   └── login.page.scss
│       └── users/
│           ├── user-list.page.ts
│           ├── user-list.page.html
│           ├── user-detail.page.ts
│           └── components/          # page-local components
│               └── user-form/
│                   └── user-form.component.ts
```

### Naming Conventions

| File type       | Suffix             | Example                        |
| --------------- | ------------------ | ------------------------------ |
| Route page      | `.page.ts`         | `login.page.ts`                |
| Layout shell    | `.component.ts`    | `main-layout.component.ts`     |
| Shared widget   | `.component.ts`    | `user-avatar.component.ts`     |
| DI service      | `.service.ts`      | `auth.service.ts`              |
| HTTP interceptor| `.interceptor.ts`  | `auth.interceptor.ts`          |
| Route guard     | `.guard.ts`        | `auth.guard.ts`                |

### Component Declaration

All components are **standalone** (Angular 17+). Import Mezzanine components
directly in the `imports` array — no `NgModule` declarations needed.

```ts
@Component({
  selector: 'app-example',
  standalone: true,          // always omit if Angular 19+ where it's the default
  imports: [
    ReactiveFormsModule,
    MznButton,
    MznFormField,
    MznInput,
  ],
  templateUrl: './example.component.html',
})
export class ExampleComponent { }
```

---

## Utilities

User-facing helpers exported from `@mezzanine-ui/ng/utils`. These cover common
formatting / CVA-wiring chores and mirror what React apps pull from
`@mezzanine-ui/react-utils`.

```ts
import {
  getCSSVariablePixelValue,
  highlightText,
  provideValueAccessor,
  formatNumberWithCommas,
  parseNumberWithCommas,
  type HighlightSegment,
} from '@mezzanine-ui/ng/utils';
```

| Export | Signature | Purpose |
| ------ | --------- | ------- |
| `getCSSVariablePixelValue` | `(variableName: string, fallback?: number) => number` | Reads a `:root` CSS custom property (e.g. `--mzn-spacing-size-element-loose`) and resolves it to a pixel number. Supports `rem` (16px base), `px`, and unitless values; returns `fallback` (default `0`) when `document` is undefined or the value cannot be parsed. |
| `highlightText` | `(text: string, keyword?: string) => ReadonlyArray<HighlightSegment>` | Splits `text` into `{ text, highlight }` segments around every case-insensitive match of `keyword`. Regex metacharacters in the keyword are escaped. Use to render AutoComplete / Search results with `<mark>`. |
| `HighlightSegment` | `{ readonly text: string; readonly highlight: boolean }` | Return element type of `highlightText`. |
| `provideValueAccessor` | `(component: Type<unknown>) => { provide: typeof NG_VALUE_ACCESSOR; useExisting: Type<unknown>; multi: true }` | Shorthand for the standard `NG_VALUE_ACCESSOR` multi-provider with `forwardRef`. Use in custom form-control components that implement `ControlValueAccessor`. |
| `formatNumberWithCommas` | `(input: number \| string, locale?: string, options?: Intl.NumberFormatOptions) => string` | Formats a number (or numeric string) with locale-aware thousands separators via `Intl.NumberFormat`. Default locale `'en-US'`; defaults `maximumFractionDigits: 20`. Returns `''` for non-finite or empty input. |
| `parseNumberWithCommas` | `(input: string, strict?: boolean) => number \| null` | Parses a comma-formatted numeric string back to a `number`. When `strict=true`, only inputs matching `/^-?\d{1,3}(?:,\d{3})*(?:\.\d+)?$/` are accepted. Returns `null` on empty / invalid input. |

### Example — `highlightText` in a template

```ts
import { Component, input } from '@angular/core';
import { highlightText } from '@mezzanine-ui/ng/utils';

@Component({
  selector: 'app-highlight',
  standalone: true,
  template: `
    @for (seg of segments(); track $index) {
      @if (seg.highlight) { <mark>{{ seg.text }}</mark> }
      @else { <span>{{ seg.text }}</span> }
    }
  `,
})
export class HighlightComponent {
  readonly text = input.required<string>();
  readonly keyword = input<string>('');

  protected readonly segments = () => highlightText(this.text(), this.keyword());
}
```

### Example — `provideValueAccessor` in a custom control

```ts
import { Component, forwardRef } from '@angular/core';
import { ControlValueAccessor } from '@angular/forms';
import { provideValueAccessor } from '@mezzanine-ui/ng/utils';

@Component({
  selector: 'app-toggle',
  standalone: true,
  providers: [provideValueAccessor(ToggleComponent)],
  template: `...`,
})
export class ToggleComponent implements ControlValueAccessor {
  writeValue(value: boolean): void { /* ... */ }
  registerOnChange(fn: (value: boolean) => void): void { /* ... */ }
  registerOnTouched(fn: () => void): void { /* ... */ }
  setDisabledState?(isDisabled: boolean): void { /* ... */ }
}
```

### Example — comma formatting in a price input

```ts
import { formatNumberWithCommas, parseNumberWithCommas } from '@mezzanine-ui/ng/utils';

formatNumberWithCommas(1234567.89);            // '1,234,567.89'
formatNumberWithCommas('1000000', 'zh-TW');    // '1,000,000'
parseNumberWithCommas('1,234.5');              // 1234.5
parseNumberWithCommas('1,23,4', true);         // null (strict rejects bad grouping)
```

> **Not user-facing (internal plumbing, omitted from public exports in
> `utils/index.ts`)**: `arrayMove`, `getElement`, `getScrollbarWidth`, and the
> `PickRenameMulti` / `ExtendedProperties` type helpers in `general.ts`. Do not
> import from their file paths directly — they are consumed by library
> internals and may be relocated without notice.
