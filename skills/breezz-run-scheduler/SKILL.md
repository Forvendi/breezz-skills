---
name: breezz-run-scheduler
description: "Generate Breezz Run Scheduler step configurations. Use when the user wants to trigger a scheduler job from within a step/trigger using forvendi.StepRunSchedulerStep in the Breezz framework."
---

# Breezz Run Scheduler Step Generator

Trigger a scheduler job from within a trigger step using `forvendi.StepRunSchedulerStep`.

## Compatibility

Works with: After Insert, After Update, After Delete, After Undelete (sync+async)
Not optimal: Before Update, Before Delete
Does NOT work with: Before Insert (sync)

## Parameters Format

Unlike other declarative steps, RunScheduler uses a **plain string** (not JSON) as the Parameters value:

```
SchedulerConfigDeveloperName
```

This references the developer name of the forvendi__B_SchedulerConfig record to execute.

## StepConfig Values
- `forvendi__Type__c` = "RunScheduler"
- `forvendi__ClassName__c` = "forvendi.StepRunSchedulerStep"
- `forvendi__Parameters__c` = "MySchedulerConfigName" (plain string)

## Related Commands
- `/breezz-scheduler` — Generate the scheduler configuration being triggered
- `/breezz-trigger` — Generate the trigger configuration
