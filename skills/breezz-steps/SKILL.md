---
name: breezz-steps
description: "Generate breezz framework Step classes (forvendi.Step) for Salesforce automation. Creates typed abstract base step classes and concrete step implementations with .cls-meta.xml files. Use this skill whenever the user mentions breezz steps, forvendi steps, Step Groups, or wants to create trigger automation using the breezz framework. Also trigger when the user asks to create a class extending forvendi.Step, or mentions Breezz framework steps. Covers custom Apex steps only — for declarative steps (RollUp, CreateRecord, etc.) use the corresponding /breezz-* command."
---

# Breezz Steps Generator

Generate production-ready breezz framework Step classes for Salesforce. This skill creates both abstract base step classes (typed wrappers around `forvendi.Step`) and concrete step implementations.

## Critical Disclaimer: addToUpdate vs addModificationToUpdate

> **`addToUpdate(SObject record)`** — Adds the ENTIRE record to the update list. If multiple steps call this for the same record, the LAST one wins and **overwrites all previous field changes**.
>
> **`addModificationToUpdate(Id recordId, SObjectField field, Object value)`** — Adds a SINGLE FIELD modification. Multiple steps can safely modify different fields on the same record **without overwriting each other**.
>
> **RULE: Always use `addModificationToUpdate()` unless you are intentionally replacing the entire record.**

## Workflow

### 1. Gather Requirements

Before generating code, determine:

- **Target SObject**: Which object does this step operate on?
- **Step purpose**: What business logic does this step implement?
- **Trigger timing**: Before trigger (field validation/defaults), after trigger (related record updates), or async (heavy processing, callouts)?
- **Data needs**: Does the step need data from related records via DataStore?

If the user's request is clear enough, proceed directly. Otherwise ask briefly.

### 2. Validate Against Compatibility Matrix

Read `references/compatibility-matrix.md` to ensure the requested step type + trigger event combination is valid. REFUSE to generate configurations that "will not work."

### 3. Check for Existing Base Step

Before generating a base step class, check if one already exists for the target SObject:
- Search for `{SObject}Step.cls` in the project
- If found, skip base step generation and extend the existing one

### 4. Generate the Base Step Class

Read `references/step-patterns.md` for the exact template. The base step class:
- Is an abstract class named `{SObject}Step`
- Extends `forvendi.Step`
- Casts all `Object` parameters to the typed SObject
- Provides typed abstract/virtual methods for subclasses to override

### 5. Generate the Concrete Step

Read `references/step-patterns.md` for scenario-specific templates. Review `assets/` for real examples:
- `assets/before-insert-step.cls` — sync before-insert step
- `assets/after-insert-step.cls` — sync after-insert step
- `assets/async-step.cls` — async step with addAsyncJob + executeAsyncProcess
- `assets/step-with-datastore.cls` — step using DataStore pattern
- `assets/recurrence-prevention-step.cls` — step requiring recurrence prevention

### 6. Generate .cls-meta.xml Files

Read `references/metadata-templates.md` for the template.

## Hard-Stop Constraints

1. **No SOQL/DML in `initRecordProcessing()` or `finishRecordProcessing()`** — use `getStore()` instead.
2. **No SOQL/DML in loops** — governor limits: 100 SOQL, 150 DML per transaction.
3. **Mandatory sharing declaration** — `with sharing`, `without sharing`, or `inherited sharing`.
4. **No hardcoded IDs** — use Custom Metadata, Custom Labels, or queries.
5. **Constructor must call `super(ClassName.class.getName())`** — required for async routing.
6. **Before-trigger steps: only modify trigger context record** — never related records.
7. **After-trigger steps: never modify trigger context record** — use `getContext().addModificationToUpdate()`.
8. **Always use `addModificationToUpdate()` for field-level changes** — `addToUpdate()` causes data loss when multiple steps modify the same record.

## Good Practices

- Return `true` from `initRecordProcessing()` only when `getStore().requestToLoad()` was called
- Use Records Split Strategy to filter records that don't need processing
- Set recursion prevention for After Update triggers (see `references/recurrence-prevention.md`)
- Log errors with `forvendi.BreezzApi.LOGGER.addErrorLog()` — never swallow exceptions silently
- Use `forvendi.BreezzApi.DATABASE.getDML()` for DML with proper error handling
- Use `Feature.isEnabled()` for conditional execution of feature-gated logic
- Use utility classes (Collections, Describe, Dates, DB) — see `references/utility-classes.md`

## Bad Practices (Anti-Patterns)

- Using `addToUpdate()` when multiple steps modify same record — causes data loss
- Async calls in before triggers — will fail
- Modifying non-context records in before triggers — undefined behavior
- Returning `true` without calling `getStore().requestToLoad()` — pointless overhead
- Using `@future` methods — use Queueable instead
- Using `System.debug()` in production — use Logger instead
- Ignoring `DB.DBResult.hasErrors` — silent data loss
- Not calling `assertErrorLogs()` in tests — silent failures

## Naming Conventions

| Artifact | Pattern | Example |
|----------|---------|---------|
| Base step class | `{SObject}Step` | `OpportunityStep` |
| Concrete step | `{Descriptive}{SObject}Step` | `OpportunityAmountValidationStep` |
| Meta.xml | `{ClassName}.cls-meta.xml` | `OpportunityStep.cls-meta.xml` |

For custom objects, strip `__c`: `Invoice_Line__c` → `InvoiceLineStep`.

## Reference Files

- **`references/step-patterns.md`** — Base step template + concrete step templates (before, after, DataStore, async)
- **`references/apex-generation.md`** — Apex best practices, governor limits, security
- **`references/metadata-templates.md`** — .cls-meta.xml file template
- **`references/compatibility-matrix.md`** — Valid step type + trigger event combinations
- **`references/recurrence-prevention.md`** — Recursion prevention configuration
- **`references/utility-classes.md`** — Collections, Describe, Dates, DB, Logger, Feature APIs

## Related Commands

- `/breezz-trigger` — Generate full trigger metadata configuration stack
- `/breezz-test` — Generate unit tests for steps
- `/breezz-scheduler` — Generate scheduler job classes
- `/breezz-split-strategy` — Generate record split strategy classes
- `/breezz-data-loader` — Generate Data Loader classes
