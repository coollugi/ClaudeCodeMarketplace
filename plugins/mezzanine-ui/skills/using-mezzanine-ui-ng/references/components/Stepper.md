# Stepper

> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/ng/stepper) · Verified 1.0.0-rc.4 (2026-04-24)
>
> **Storybook**: https://storybook-ng.mezzanine-ui.org/?path=/docs/navigation-stepper--docs

步驟進度指示器元件，以線性流程呈現多個步驟的完成狀態。子元件 `MznStep` 透過 `MZN_STEPPER_CONTEXT` DI token 從父層 `MznStepper` 取得 `currentStep`/`orientation`/`type`，並自動計算連接線距離。支援水平/垂直排列，以及數字/圓點兩種指示器樣式。

> **Aliases** — Steps (Ant Design) · mat-stepper (Angular Material) · Wizard · 步驟條 · 流程指示 · Figma `Stepper / *`
> **Not for** — 百分比進度（用 [`MznProgress`](Progress.md)）

## Import

```ts
import { MznStepper, MznStep, MznStepperState } from '@mezzanine-ui/ng/stepper';
import type {
  StepOrientation,
  StepStatus,
  StepType,
  MznStepperStateOptions,
} from '@mezzanine-ui/ng/stepper';
```

## Selector

`<div mznStepper [currentStep]="1">` — stepper container

`<div mznStep title="...">` — 單一步驟，必須是 `mznStepper` 的直接子元素

## Inputs — MznStepper

| Input          | Type               | Default        | Description                                          |
| -------------- | ------------------ | -------------- | ---------------------------------------------------- |
| `currentStep`  | `number`           | `0`            | 當前進行中的步驟索引（零基）                           |
| `orientation`  | `StepOrientation`  | `'horizontal'` | `'horizontal' \| 'vertical'` — 步驟排列方向           |
| `type`         | `StepType`         | `'number'`     | `'number'`（數字指示器）/ `'dot'`（圓點指示器）       |

> Inputs declared with signal API (`input()`) accept both static and reactive values.

## Outputs — MznStepper

| Output       | Type                     | Description                         |
| ------------ | ------------------------ | ------------------------------------ |
| `stepChange` | `OutputEmitterRef<number>` | `currentStep` 變化時觸發（初始化時也會觸發一次）|

## Inputs — MznStep

| Input         | Type           | Default | Description                                                               |
| ------------- | -------------- | ------- | ------------------------------------------------------------------------- |
| `title`       | `string` (required) | — | 步驟標題文字                                                          |
| `description` | `string`       | —       | 步驟描述文字（顯示在標題下方）                                             |
| `disabled`    | `boolean`      | `false` | 是否禁用此步驟（僅在非 processing 狀態時生效）                             |
| `error`       | `boolean`      | `false` | 是否為錯誤狀態                                                             |
| `interactive` | `boolean`      | `false` | 是否可互動（加入 `role="button"`、`tabindex="0"`，Enter/Space 觸發 click）  |
| `status`      | `StepStatus`   | auto    | 手動覆蓋步驟狀態；未設定時由父 Stepper 依 `currentStep` 自動計算           |
| `index`       | `number`       | auto    | 手動指定步驟索引；通常由 Stepper 自動注入                                  |

> Inputs declared with signal API (`input()`, `input.required()`) accept both static and reactive values.
>
> `MznStep` 的 `orientation` 與 `type` 不是 input，由父 `MznStepper` 透過 `MZN_STEPPER_CONTEXT` DI token 提供。

## Sub-components / Exports

| Export             | Purpose                                                                   |
| ------------------ | ------------------------------------------------------------------------- |
| `MznStepper`       | 步驟容器，管理 `currentStep`、連接線計算、DI 提供                          |
| `MznStep`          | 單一步驟項目，顯示指示器、標題、描述                                       |
| `MznStepperState`  | signal-based 狀態管理 class，對應 React `useStepper` hook 的 Angular 替代品 |

## MznStepperState 使用

`MznStepperState` 是 signals-era 的步驟狀態管理工具，對應 React `useStepper` hook。

建構子接受 `MznStepperStateOptions?`（選填），選項欄位為 `totalSteps`（預設 `Number.MAX_VALUE`）與 `defaultStep`（預設 `0`）。

### API

| 成員                                   | 種類               | 描述                                                  |
| -------------------------------------- | ------------------ | ----------------------------------------------------- |
| `currentStep`                          | `Signal<number>`   | 目前步驟索引（唯讀 signal）                            |
| `isFirstStep`                          | `Signal<boolean>`  | 是否為第一步（computed signal）                        |
| `isLastStep`                           | `Signal<boolean>`  | 是否為最後一步（computed signal）                      |
| `nextStep(): void`                     | 方法               | 前進一步（不超出 `totalSteps - 1`）                    |
| `prevStep(): void`                     | 方法               | 後退一步（不低於 0）                                   |
| `goToStep(step: number): void`         | 方法               | 跳至指定步驟（自動夾在 0 ~ `totalSteps - 1` 之間）    |

```ts
import { MznStepperState } from '@mezzanine-ui/ng/stepper';

readonly stepperState = new MznStepperState({ totalSteps: 3, defaultStep: 0 });

// 常用方法（依 stepper-state.ts 實作）：
stepperState.nextStep();         // 前進一步
stepperState.prevStep();         // 後退一步
stepperState.goToStep(1);        // 跳至索引 1
stepperState.currentStep();      // 讀取當前步驟（Signal<number>）
stepperState.isFirstStep();      // true/false（Signal<boolean>）
stepperState.isLastStep();       // true/false（Signal<boolean>）
```

## Usage

```html
<!-- 基本水平數字步驟 -->
<div mznStepper [currentStep]="currentStep()">
  <div mznStep title="填寫基本資料" description="姓名、Email 等必填資訊"></div>
  <div mznStep title="確認訂單內容"></div>
  <div mznStep title="完成付款"></div>
</div>

<!-- 垂直圓點步驟 -->
<div mznStepper orientation="vertical" type="dot" [currentStep]="step()">
  <div mznStep title="資料上傳" description="上傳 CSV 檔案"></div>
  <div mznStep title="資料驗證"></div>
  <div mznStep title="匯入完成"></div>
</div>

<!-- 含錯誤狀態 -->
<div mznStepper [currentStep]="2">
  <div mznStep title="步驟 1"></div>
  <div mznStep title="步驟 2" [error]="hasError()"></div>
  <div mznStep title="步驟 3"></div>
</div>

<!-- 可互動步驟（允許點擊切換） -->
<div mznStepper [currentStep]="activeStep()" (stepChange)="activeStep.set($event)">
  <div mznStep title="個人資料" [interactive]="true" (click)="goToStep(0)"></div>
  <div mznStep title="帳號設定" [interactive]="true" (click)="goToStep(1)"></div>
  <div mznStep title="完成" [interactive]="activeStep() > 1" (click)="goToStep(2)"></div>
</div>
```

```ts
import { Component, signal } from '@angular/core';
import { MznStepper, MznStep, MznStepperState } from '@mezzanine-ui/ng/stepper';
import { MznButton } from '@mezzanine-ui/ng/button';

@Component({
  selector: 'app-wizard',
  imports: [MznStepper, MznStep, MznButton],
  template: `
    <div mznStepper [currentStep]="stepperState.currentStep()">
      <div mznStep title="填寫資料"></div>
      <div mznStep title="確認內容"></div>
      <div mznStep title="送出申請"></div>
    </div>
    <div style="display: flex; gap: 8px; margin-top: 16px;">
      <button mznButton variant="base-secondary" [disabled]="stepperState.isFirstStep()"
        (click)="stepperState.prevStep()">上一步</button>
      <button mznButton variant="base-primary"
        [disabled]="stepperState.isLastStep()"
        (click)="stepperState.nextStep()">下一步</button>
    </div>
  `,
})
export class WizardComponent {
  readonly stepperState = new MznStepperState({ totalSteps: 3, defaultStep: 0 });
}
```

## Notes

- `MznStep` 必須是 `mznStepper` 的**直接子元素**（`querySelectorAll(':scope > [mznstep]')`），中間不能有包裝元素，否則連接線距離計算會失效。
- 步驟狀態由 Stepper 的 `currentStep` 自動推算：索引 `< currentStep` → `succeeded`，`= currentStep` → `processing`，`> currentStep` → `pending`。
- `MZN_STEPPER_CONTEXT` 為 Angular-only 的 DI token，不對外公開匯出，僅 `MznStep` 內部使用。
- 連接線長度由元件在 `AfterViewInit` 及 `ResizeObserver` 事件中動態計算，確保水平/垂直各模式都正確對齊。
- 不同於 React 的 `useStepper` hook，Angular 版使用 `MznStepperState` class 管理步驟狀態（signals-based）。
