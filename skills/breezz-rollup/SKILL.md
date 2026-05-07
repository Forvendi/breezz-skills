---
name: breezz-rollup
description: "Generate Breezz RollUp Summary Field step configurations. Use when the user wants to create declarative rollup calculations, aggregate child records to parent, COUNT/SUM/AVG/MIN/MAX fields, or configure forvendi.StepRollUpSummaryStep in the Breezz framework."
---

# Breezz RollUp Summary Field Generator

Generate declarative rollup summary configurations using `forvendi.StepRollUpSummaryStep`.

## Compatibility

Works with: After Insert, After Update, After Undelete, After Delete (sync+async)
Does NOT work with: Before Insert, Platform Events, CDC
Not optimal: Before Update (sync only), Before Delete

## Parameters JSON Format

```json
{
  "sourceObjectName": "ChildObject__c",
  "sourceObjectFieldName": "Amount__c",
  "sourceObjectLookupFieldName": "ParentLookup__c",
  "targetObjectName": "ParentObject__c",
  "targetObjectFieldName": "TotalAmount__c",
  "aggregationType": "SUM",
  "conditions": "Status__c = 'Active'"
}
```

### Fields:
- **sourceObjectName** — The child object being aggregated (usually the trigger object)
- **sourceObjectFieldName** — Field to aggregate (empty string for COUNT)
- **sourceObjectLookupFieldName** — Lookup field pointing to the parent
- **targetObjectName** — Parent object receiving the rollup value
- **targetObjectFieldName** — Field on parent to store the result
- **aggregationType** — COUNT, SUM, AVG, MIN, or MAX
- **conditions** — Optional SOQL WHERE clause (without WHERE keyword)

## StepConfig Values

- `forvendi__Type__c` = "RollUpSummaryField"
- `forvendi__ClassName__c` = "forvendi.StepRollUpSummaryStep"
- `forvendi__Parameters__c` = JSON above

## Workflow

1. Ask: source object, lookup field, target object, target field, aggregation type, conditions
2. Validate against compatibility matrix
3. Generate forvendi__B_StepConfig metadata with Parameters JSON

## Related Commands

- `/breezz-trigger` — Generate the trigger configuration to host this step
