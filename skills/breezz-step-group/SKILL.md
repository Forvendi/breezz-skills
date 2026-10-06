---
name: breezz-step-group
description: "Generate Breezz Step Group step configurations. Use when the user wants to run a specific Step Group using forvendi.StepGroupStep in the Breezz framework."
---

# Breezz Step Group Generator

Generate Step Group step configurations using `forvendi.StepGroupStep`.

## Compatibility

Works with: After Insert, Before Update, After Update, Before Delete, After Delete, After Undelete, Platform Events, CDC
Does NOT work with: Before Insert (sync)

## Parameters JSON Format

```json
{
  "stepGroupDeveloperName": "My_Step_Group_Name"
}
```

### Fields:
- **stepGroupDeveloperName** — The DeveloperName of the Step Group configuration to execute.

## StepConfig Values
- `forvendi__Type__c` = "StepGroup"
- `forvendi__ClassName__c` = "forvendi.StepGroupStep"
- `forvendi__Parameters__c` = JSON above

## Related Commands
- `/breezz-trigger` — Generate the trigger configuration
