---
name: breezz-trigger
description: "Generate Breezz trigger configuration metadata (forvendi__B_TriggerConfig, forvendi__B_StepGroupConfig, forvendi__B_StepConfig). Use this skill when the user wants to configure a Breezz trigger handler, create trigger metadata, set up step groups for triggers, or configure entry conditions, async strategies, or trigger events for the Breezz framework."
---

# Breezz Trigger Configuration Generator

Generate the complete metadata stack for Breezz trigger configurations.

## Critical Disclaimer: addToUpdate vs addModificationToUpdate

> **`addToUpdate(SObject)`** — Replaces the entire record. Last writer wins.
> **`addModificationToUpdate(Id, SObjectField, Object)`** — Merges a single field. Safe for multiple steps.
> **RULE: Always use `addModificationToUpdate()` in step configurations.**

## Workflow

### 1. Gather Requirements

Determine:
- **Target SObject** (API name)
- **Trigger Event**: Before Insert, After Insert, Before Update, After Update, Before Delete, After Delete, After Undelete
- **Step Type**: Custom, Flow, RollUpSummaryField, CreateRecord, TextFieldCleanup, ModifyContextRecord, ModifyRecord, ModifyRecords, CustomValidation, GenerateUUID, ConcatenateFields, RunScheduler, StepGroup
- **Async**: Should the step run asynchronously?
- **Entry Conditions**: Should it run only for specific records?
- **Recurrence Prevention**: For Update triggers, what recursion strategy?

### 2. Validate Compatibility

Read `references/compatibility-matrix.md`. REFUSE invalid combinations. Warn about "not optimal" combinations.

### 3. Generate forvendi__B_TriggerConfig

Read `references/trigger-config-fields.md` for all fields. Use assets as templates:
- `assets/trigger-config.xml` — basic sync trigger
- `assets/trigger-config-async.xml` — async trigger
- `assets/trigger-config-recurrence.xml` — with recurrence prevention

### 4. Generate forvendi__B_StepGroupConfig

One StepGroupConfig per step group referenced in TriggerConfig.

### 5. Generate forvendi__B_StepConfig

One StepConfig per step in the group. For Custom type, the ClassName points to an Apex class. For declarative types, use the built-in forvendi class names.

## Trigger Events

Valid values for `forvendi__TriggerEvent__c`:
- Before Insert, After Insert
- Before Update, After Update
- Before Delete, After Delete
- After Undelete

## Step Types (forvendi__Type__c values)

| Type Value | ClassName | Requires Parameters |
|-----------|-----------|---------------------|
| Custom | User's Apex class | No |
| Flow | forvendi.StepFlowStep | Yes |
| RollUpSummaryField | forvendi.StepRollUpSummaryStep | Yes |
| CreateRecord | forvendi.StepCreateRecordStep | Yes |
| TextFieldCleanup | forvendi.StepTextFieldCleanupStep | Yes |
| ModifyContextRecord | forvendi.StepModifyContextRecordStep | Yes |
| ModifyRecord | forvendi.StepModifyRecordStep | Yes |
| ModifyRecords | forvendi.StepModifyRecordsStep | Yes |
| CustomValidation | forvendi.StepCustomValidationStep | Yes |
| GenerateUUID | forvendi.StepGenerateUUIDStep | Yes |
| ConcatenateFields | forvendi.StepConcatenateFieldsStep | Yes |
| RunScheduler | forvendi.StepRunSchedulerStep | Yes (plain string) |

## Hard-Stop Constraints

1. Never generate invalid event + step type combinations (per compatibility matrix)
2. Always set RecursionPreventionStrategy for After Update triggers
3. StepGroupConfig name must match the value in TriggerConfig's StepGroup1__c field
4. StepConfig's StepGroupConfig__c must reference the correct StepGroupConfig

## Reference Files

- `references/trigger-config-fields.md` — All metadata fields
- `references/compatibility-matrix.md` — Valid combinations
- `references/entry-conditions.md` — JSON format for entry conditions

## Related Commands

- `/breezz-steps` — Generate the Apex Step class
- `/breezz-split-strategy` — Configure record split strategies
- `/breezz-test` — Generate tests for the trigger
