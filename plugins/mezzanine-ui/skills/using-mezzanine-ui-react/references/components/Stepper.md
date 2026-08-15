# Stepper Component

> **Category**: Navigation
>
> **Storybook**: `Navigation/Stepper`
>
> **Source**: [GitHub Source](https://github.com/Mezzanine-UI/mezzanine/tree/main/packages/react/src/Stepper) · Verified 1.4.1 (2026-07-01)

Stepper component for guiding users through multi-step processes.

> **Aliases** — Steps (Ant Design) · Wizard · Progress Steps · 步驟條 · 流程指示 · Figma `Stepper / *`
> **Not for** — 百分比進度（用 [`Progress`](Progress.md)）

## Import

```tsx
import { Stepper, Step, useStepper } from '@mezzanine-ui/react';
import type { StepperProps, StepProps } from '@mezzanine-ui/react';
```

> **Live Examples**: [View in Storybook](https://storybook.mezzanine-ui.org/react/?path=/docs/navigation-stepper--docs) — 當行為不確定時，Storybook 的互動範例為權威參考。

---

## Stepper Props

> Extends `NativeElementPropsWithoutKeyAndRef<'div'>`.

| Property       | Type                                                        | Default        | Description          |
| -------------- | ----------------------------------------------------------- | -------------- | -------------------- |
| `children`     | `ReactElement<StepProps> \| ReactElement<StepProps>[]`      | (required)     | Step elements        |
| `currentStep`  | `number`                                                    | `0`            | Current step index   |
| `onStepChange` | `(stepIndex: number) => void`                               | -              | Step change callback |
| `orientation`  | `'horizontal' \| 'vertical'`                                | `'horizontal'` | Layout direction     |
| `type`         | `'dot' \| 'number'`                                        | `'number'`     | Indicator type       |

---

## Step Props

> Extends `NativeElementPropsWithoutKeyAndRef<'div'>` (excluding `title` and `children`).

| Property      | Type                                       | Default     | Description                          |
| ------------- | ------------------------------------------ | ----------- | ------------------------------------ |
| `description` | `string`                                   | -           | Step description                     |
| `disabled`    | `boolean`                                  | -           | Whether disabled (defined in type, no visual effect yet) |
| `error`       | `boolean`                                  | -           | Whether in error state               |
| `title`       | `string`                                   | -           | Step title                           |
| `index`       | `number`                                   | `0` (auto)  | Step index (auto-set by parent)      |
| `orientation` | `'horizontal' \| 'vertical'`               | inherited   | Layout direction (inherited from Stepper) |
| `status`      | `'processing' \| 'pending' \| 'succeeded'` | `'pending'` | Step status (auto-calculated by parent) |
| `type`        | `'dot' \| 'number'`                        | `'number'`  | Indicator type (inherited from Stepper) |

---

## Step Status (Auto-calculated)

| Status       | Description  | Condition                   |
| ------------ | ------------ | --------------------------- |
| `processing` | In progress  | `index === currentStep`     |
| `succeeded`  | Completed    | `index < currentStep`       |
| `pending`    | Pending      | `index > currentStep`       |

---

## useStepper Hook

Hook for managing step state.

### Parameters

| Property      | Type     | Default             | Description              |
| ------------- | -------- | ------------------- | ------------------------ |
| `defaultStep` | `number` | `0`                 | Default starting step    |
| `totalSteps`  | `number` | `Number.MAX_VALUE`  | Total number of steps    |

### Return Value

| Property      | Type                       | Description            |
| ------------- | -------------------------- | ---------------------- |
| `currentStep` | `number`                   | Current step index     |
| `goToStep`    | `(step: number) => void`   | Jump to specific step  |
| `isFirstStep` | `boolean`                  | Whether first step     |
| `isLastStep`  | `boolean`                  | Whether last step      |
| `nextStep`    | `() => void`               | Go to next step        |
| `prevStep`    | `() => void`               | Go to previous step    |

### Usage Example

```tsx
import { Stepper, Step, useStepper } from '@mezzanine-ui/react';

function WizardWithHook() {
  const { currentStep, nextStep, prevStep, isFirstStep, isLastStep } = useStepper({
    defaultStep: 0,
    totalSteps: 3,
  });

  return (
    <div>
      <Stepper currentStep={currentStep}>
        <Step title="Step 1" />
        <Step title="Step 2" />
        <Step title="Step 3" />
      </Stepper>
      <Button onClick={prevStep} disabled={isFirstStep}>Previous</Button>
      <Button onClick={nextStep} disabled={isLastStep}>Next</Button>
    </div>
  );
}
```

---

## Usage Examples

### Basic Usage

```tsx
import { Stepper, Step } from '@mezzanine-ui/react';

<Stepper currentStep={1}>
  <Step title="Step 1" />
  <Step title="Step 2" />
  <Step title="Step 3" />
</Stepper>
```

### With Description

```tsx
<Stepper currentStep={1}>
  <Step title="Basic Info" description="Fill in name, phone" />
  <Step title="Payment" description="Choose payment method" />
  <Step title="Confirm Order" description="Review order details" />
</Stepper>
```

### Vertical Layout

```tsx
<Stepper currentStep={1} orientation="vertical">
  <Step title="Step 1" description="Step 1 description" />
  <Step title="Step 2" description="Step 2 description" />
  <Step title="Step 3" description="Step 3 description" />
</Stepper>
```

### Dot Type

```tsx
<Stepper currentStep={1} type="dot">
  <Step title="Start" />
  <Step title="In Progress" />
  <Step title="Complete" />
</Stepper>
```

### Error State

```tsx
<Stepper currentStep={1}>
  <Step title="Fill Info" />
  <Step title="Verification" error />
  <Step title="Complete" />
</Stepper>
```

### Dynamic Steps

```tsx
function WizardForm() {
  const [currentStep, setCurrentStep] = useState(0);

  const steps = [
    { title: 'Personal Info', content: <PersonalInfoForm /> },
    { title: 'Account Settings', content: <AccountSettingsForm /> },
    { title: 'Confirmation', content: <ConfirmationForm /> },
  ];

  const next = () => setCurrentStep((prev) => Math.min(prev + 1, steps.length - 1));
  const prev = () => setCurrentStep((prev) => Math.max(prev - 1, 0));

  return (
    <div>
      <Stepper currentStep={currentStep}>
        {steps.map((step, index) => (
          <Step key={index} title={step.title} />
        ))}
      </Stepper>

      <div className="step-content">
        {steps[currentStep].content}
      </div>

      <div className="step-actions">
        <Button onClick={prev} disabled={currentStep === 0}>
          Previous
        </Button>
        <Button onClick={next} disabled={currentStep === steps.length - 1}>
          {currentStep === steps.length - 1 ? 'Finish' : 'Next'}
        </Button>
      </div>
    </div>
  );
}
```

### Step Change Callback

```tsx
<Stepper
  currentStep={currentStep}
  onStepChange={(stepIndex) => {
    console.log('Step changed to:', stepIndex);
  }}
>
  <Step title="Step 1" />
  <Step title="Step 2" />
  <Step title="Step 3" />
</Stepper>
```

### Disable Specific Steps

```tsx
<Stepper currentStep={0}>
  <Step title="Available Step" />
  <Step title="Disabled Step" disabled />
  <Step title="Available Step" />
</Stepper>
```

---

## Keyboard Support

Keyboard interaction is **opt-in**: a `<Step>` only becomes focusable and keyboard-operable when you pass it a native `onClick` handler (available via `StepProps`'s extension of native div attributes). When `onClick` is provided, Step automatically sets `role="button"` and `tabIndex={0}`, and the following keys trigger it:

| Key              | Action                                          |
| ---------------- | ------------------------------------------------ |
| `Enter`          | Activates the step (triggers the `onClick` handler) |
| `Space`          | Activates the step (triggers the `onClick` handler) |

> **Note**: `disabled` currently has **no effect** on focusability, tab order, `role`, or click behavior — it is declared in the type but not yet wired into Step's interaction logic (see the `disabled` row in the Step Props table above). Without an `onClick` handler, a Step is not focusable and has no `role`/`tabIndex` at all.

---

## Processing State Animation

When a Step has `status="processing"`, it displays a subtle breath animation to indicate active progress. This animation is implemented via CSS and applies automatically when the status is set to `processing`.

---

## Figma Mapping

| Figma Variant                 | React Props                              |
| ----------------------------- | ---------------------------------------- |
| `Stepper / Horizontal`        | `orientation="horizontal"`               |
| `Stepper / Vertical`          | `orientation="vertical"`                 |
| `Stepper / Number`            | `type="number"`                          |
| `Stepper / Dot`               | `type="dot"`                             |
| `Step / Processing`           | `status="processing"` (auto)             |
| `Step / Succeeded`            | `status="succeeded"` (auto)              |
| `Step / Pending`              | `status="pending"` (auto)                |
| `Step / Error`                | `error`                                  |

---

## Best Practices

1. **At least three steps**: Stepper is suitable for processes with three or more steps
2. **Clear titles**: Each step title should be concise and clear
3. **Provide descriptions**: Add descriptions for complex steps
4. **Error handling**: Use `error` state for validation failures
5. **Responsive design**: Consider `type="dot"` or `orientation="vertical"` for small screens
