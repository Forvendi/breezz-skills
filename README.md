# Breezz Skills

Public Agent Skills for Salesforce Breezz and related tooling. The Breezz Framework Skills repository provides pre-packaged, reusable context, instructions, and prompt patterns for AI agents (such as Claude Code, Cursor, and other compatible developer tools). It targets Salesforce developers using the Forvendi Breezz framework, helping maintain architectural consistency, automate code generation, and reduce prompt token consumption.

## Key Benefits

*   **Architectural Consistency:** Enforces project standards and design patterns across Apex steps, triggers, schedulers, and framework plugins.
*   **Token & Cost Efficiency:** Reduces context window usage by replacing verbose instructions with concise skill triggers.
*   **Workflow Automation:** Streamlines generation of Apex classes, metadata XML configurations, unit tests, and framework plugins.
*   **Standardized Output:** Includes evaluation test suites (`evals/`) to validate structural compliance.

## Repository Layout

Each skill lives in its own folder under `skills/` with a `SKILL.md` file (YAML frontmatter with `name` and `description`).

```text
skills/
  <skill-id>/
    SKILL.md          # required; frontmatter name should match <skill-id>
    ...               # optional supporting files referenced by the skill
```

## How to Get & Install Skills

Skills are installed per developer machine using the `skills` CLI (`npx skills`). Once installed, skill files are automatically placed into `.claude/skills/` (or your targeted agent directory) and loaded during active sessions.

### 1. List Available Skills
Inspect all available skills directly from the remote repository without installing:
```bash
npx skills add forvendi/breezz-skills --list
```

### 2. Install the Complete Suite (Recommended)
Install all 20 Breezz framework skills in a single command:
```bash
npx skills add forvendi/breezz-skills
```

### 3. Install a Specific Skill
To install a single skill folder without pulling the full package:
```bash
npx skills add forvendi/breezz-skills --skill SKILL_FOLDER_NAME
```

### 4. Non-Interactive / Agent-Specific Installation
To target a specific AI editor (such as Cursor) and bypass interactive confirmation prompts:
```bash
npx skills add forvendi/breezz-skills --skill SKILL_FOLDER_NAME -a cursor -y
```

## CLI Flag Reference

| Flag | Short | Description |
| :--- | :--- | :--- |
| `--list` | | Displays all available skills in the remote repository without installing. |
| `--skill <name>` | `-s` | Targets a specific skill folder to install instead of the full package. |
| `--agent <name>` | `-a` | Specifies the target AI editor or integration (e.g., `cursor`, `claude-code`). |
| `--yes` | `-y` | Bypasses interactive prompts and automatically accepts defaults. |

## Skills Catalogue Summary

**Step & Trigger Generation**
*   **breezz-steps**: Generates custom Apex Step classes extending `forvendi.Step` with `.cls-meta.xml` metadata.
*   **breezz-trigger**: Generates trigger metadata (`forvendi__B_TriggerConfig`, `StepGroupConfig`, `StepConfig`).
*   **breezz-test**: Creates unit tests for Steps, Triggers, and Schedulers using `StepsAssembler`.
*   **breezz-split-strategy**: Builds strategy classes (`forvendi.TriggerRecordsSplitStrategy`) for record filtering.

**Context & Record Operations**
*   **breezz-create-record**: Declarative child record creation (`forvendi.StepCreateRecordStep`).
*   **breezz-modify-context**: Field updates on trigger context records (`forvendi.StepModifyContextRecordStep`).
*   **breezz-modify-record**: Modifies a single lookup-related record (`forvendi.StepModifyRecordStep`).
*   **breezz-modify-records**: Modifies multiple SOQL-queried records (`forvendi.StepModifyRecordsStep`).
*   **breezz-concatenate**: Combines multiple field values into a target field (`forvendi.StepConcatenateFieldsStep`).
*   **breezz-field-cleanup**: Applies string operations (truncate, trim, casing) (`forvendi.StepTextFieldCleanupStep`).
*   **breezz-uuid**: Generates UUIDs on target records (`forvendi.StepGenerateUUIDStep`).

**Business Logic & Calculations**
*   **breezz-rollup**: Declarative rollups (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`) (`forvendi.StepRollUpSummaryStep`).
*   **breezz-validation**: Declarative validations with custom error messages (`forvendi.StepCustomValidationStep`).

**Scheduling & Automation**
*   **breezz-scheduler**: Generates Scheduler Job classes and `forvendi__B_SchedulerConfig` metadata.
*   **breezz-run-scheduler**: Triggers a scheduler job directly from inside a Step (`forvendi.StepRunSchedulerStep`).

**Data Access & Framework Utilities**
*   **breezz-data-loader**: Custom data loaders extending `forvendi.DataStore.Loader`.
*   **breezz-plugin**: Framework plugins (`BaseApexPlugin`, `AsyncExecutionStrategy`, `TriggerProcessHook`).
*   **breezz-feature-toggle**: Feature flag management via `forvendi.BreezzPlugins.FeatureToggleService`.
*   **breezz-metrics**: Metrics calculation and governor limit monitoring (`forvendi.Metrics.MetricCalculator`).
*   **breezz-permissions**: Permission assignments and runtime access validation.

## Usage Guidelines

When prompting Claude Code or target agents, trigger skills explicitly by name:

```text
Use breezz-steps skill to generate a custom Apex Step class for Account validation.
```

## License

See [LICENSE](./LICENSE).
