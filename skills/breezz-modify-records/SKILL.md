---
name: breezz-modify-records
description: "Generate Breezz Modify Records step configurations. Use when the user wants to declaratively modify multiple records found via a SOQL query using forvendi.StepModifyRecordsStep in the Breezz framework."
---

# Breezz Modify Records Generator

Modify multiple records found via SOQL query using `forvendi.StepModifyRecordsStep`.

## Compatibility

Works with: After Insert, After Update, After Undelete (sync+async)
Not optimal: Before Update
Does NOT work with: Before Insert, Before Delete, After Delete, Platform Events

## Parameters JSON Format

```json
{
  "objectName": "Market__c",
  "processingContextObjectName": "Prospect__c",
  "recordFieldMapping": [
    {"field": "Name", "fieldType": "text", "value": "Updated", "valueType": "value"}
  ],
  "query": "SELECT Id FROM Market__c WHERE Name = 'Target'"
}
```

### Fields:
- **objectName** — The object to modify
- **processingContextObjectName** — The trigger object
- **query** — SOQL query to find records to modify
- **recordFieldMapping** — Field modifications to apply

## StepConfig Values
- `forvendi__Type__c` = "ModifyRecords"
- `forvendi__ClassName__c` = "forvendi.StepModifyRecordsStep"

## Related Commands
- `/breezz-trigger` — Generate the trigger configuration
