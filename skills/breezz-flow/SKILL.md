---
name: breezz-flow
description: "Generate Breezz Run Flow step configurations. Use when the user wants to execute Autolaunched Flows directly as a Step within a Step Group execution pipeline using forvendi.StepRunFlowStep in the Breezz framework."
---

# Breezz Run Flow Generator

Generate Run Flow step configurations for Autolaunched Flows using `forvendi.StepRunFlowStep`.

## Compatibility

Works with: After Insert, After Update, After Delete, After Undelete (sync+async)
Does NOT work with: Before Insert, Before Update (sync), Before Delete (sync), Platform Events, CDC

## Flow Core Variables
When executing a Flow inside a Breezz Step, the framework passes trigger context records into the Flow and expects updated records returned in a specific collection variable:
- **`records`**: Record Collection variable (Input enabled). Receives current context records.
- **`oldRecords`**: Record Collection variable (Input enabled). Receives prior state records.
- **`results`**: Record Collection variable (Output enabled). Holds all records modified or created by the Flow.

## Parameters JSON Format

```json
{
  "flowName": "Lead_Status_Update_Flow"
}
```

### Fields:
- **flowName** — Provide the API name of the Autolaunched Flow you created.

## StepConfig Values
- `forvendi__Type__c` = "Flow"
- `forvendi__ClassName__c` = "forvendi.StepRunFlowStep"
- `forvendi__Parameters__c` = JSON above

## Related Commands
- `/breezz-trigger` — Generate the trigger configuration
