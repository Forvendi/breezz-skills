---
name: breezz-modify-context
description: "Generate Breezz Modify Context Record step configurations. Use when the user wants to declaratively modify the trigger context record's fields using forvendi.StepModifyContextRecordStep in the Breezz framework."
---

# Breezz Modify Context Record Generator

Generate declarative configurations to modify the trigger context record using `forvendi.StepModifyContextRecordStep`.

## Compatibility

Works with: After Insert, Before Update, After Update, After Undelete (sync+async)
Does NOT work with: Before Insert (sync), Before Delete, After Delete, Platform Events

## Parameters JSON Format

```json
{
  "processingContextObjectName": "Account",
  "recordFieldMapping": [
    {"field": "Status__c", "fieldType": "text", "value": "Active", "valueType": "value"},
    {"field": "ProcessedDate__c", "fieldType": "date", "value": "TODAY", "valueType": "$System"}
  ]
}
```

### Fields:
- **processingContextObjectName** — The trigger object
- **recordFieldMapping** — Array of field modifications
  - **field** — Field API name to modify
  - **fieldType** — "text", "number", "boolean", "date"
  - **value** — New value or source reference
  - **valueType** — "value", "record", "$System", "$User"

## StepConfig Values
- `forvendi__Type__c` = "ModifyContextRecord"
- `forvendi__ClassName__c` = "forvendi.StepModifyContextRecordStep"

## Related Commands
- `/breezz-trigger` — Generate the trigger configuration
