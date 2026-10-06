---
name: breezz-scheduler
description: "Generate Breezz Scheduler Job classes and configuration metadata (forvendi__B_SchedulerConfig). Use when the user wants to create scheduled jobs, batch schedulers, or configure the Breezz Job Scheduler. Trigger on mentions of SchedulerJob, SchedulerQueueable, SchedulerBatch, scheduled tasks, or forvendi.BreezzApi.SCHEDULER in the Breezz framework."
---

# Breezz Scheduler Generator

Generate Scheduler Job implementations and their configuration metadata.

## Scheduler Job Types

| Type Value | Use Case | Requires Apex Class |
|-----------|----------|---------------------|
| Custom | Simple one-off logic | Yes (implements forvendi.SchedulerJob) |
| Custom - Batch | Batch processing | Yes (extends forvendi.SchedulerBatch) |
| StepFunction | Run a single step on queried records | No (reuses existing Step) |
| StepFunctionsGroup | Run a step group on queried records | No (reuses existing StepGroup) |
| Autolaunched Flow | Trigger a Flow | No |
| Create Record | Auto-create records | No |
| Modify Context Record | Update records | No |
| Anonymous Apex | Execute Apex code | No |
| Text Field Cleanup | Clean text fields | No |
| Generate UUID | Auto-generate UUIDs | No |
| Concatenate Fields | Combine field values | No |
| Phone Validation | Validate phone numbers | No |
| Email Validation | Validate email addresses | No |
| Cleanup - Batch | Delete large volumes of records | No |

## Workflow

### 1. Determine Scheduler Type

Ask: What should happen on schedule? If custom logic → generate Apex class. If declarative → configure metadata only.

### 2. Generate Apex Class (if Custom type)

Two patterns available — read assets for templates:
- `assets/scheduler-job-custom.cls` — implements `forvendi.SchedulerJob` (simple, no queueable context)
- `assets/scheduler-job-queueable.cls` — extends `forvendi.SchedulerQueueable` (gets ModificationContext)

### 3. Generate forvendi__B_SchedulerConfig Metadata

Read `references/scheduler-config-fields.md` for all fields. Use assets as templates.

### 4. Generate .cls-meta.xml (if Apex class created)

Use API version 62.0.

## Hard-Stop Constraints

1. Custom SchedulerJob classes must implement `init()`, `shouldRun()`, and `run()`
2. SchedulerQueueable must call `super(ClassName.class.getName())` in constructor
3. For StepFunction/StepFunctionsGroup types, `ClassName__c` must reference the StepConfig/StepGroupConfig developer name
4. `JobConfiguration__c` contains the SOQL query for step-based schedulers
5. `RelatedObject__c` must be set for step-based schedulers

## Scheduler API

```apex
forvendi.BreezzApi.SCHEDULER.run();     // Start scheduler
forvendi.BreezzApi.SCHEDULER.kill();    // Stop scheduler
forvendi.BreezzApi.SCHEDULER.rerun();   // Refresh configurations
// Run specific job:
forvendi.BreezzApi.SCHEDULER.run('SchedulerConfigDeveloperName');
```

## Reference Files

- `references/scheduler-config-fields.md` — All SchedulerConfig metadata fields

## Related Commands

- `/breezz-steps` — Generate the Step class used by StepFunction type
- `/breezz-trigger` — Generate trigger configs (separate from scheduler)
