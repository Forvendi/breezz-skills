---
name: breezz-modify-record
description: "Generate Breezz Modify Record step configurations. Use when the user wants to declaratively modify a related record via a lookup field using forvendi.StepModifyRecordStep in the Breezz framework."
---

# Breezz Modify Record Generator

Modify a single related record reached via a lookup field using `forvendi.StepModifyRecordStep`.

## Compatibility

Works with: After Insert, After Update, After Undelete (sync+async)
Does NOT work with: Before Insert, Before Update (sync), After Delete, Platform Events

## Parameters JSON Format

```json
{
  "objectName": "Market__c",
  "processingContextObjectName": "Prospect__c",
  "recordFieldMapping": [
    {"field": "Name", "fieldType": "text", "value": "Updated Name", "valueType": "value"}
  ],
  "modifyRecordLookupPath": "Market__c"
}
```

### Fields:
- **objectName** — The related object to modify
- **processingContextObjectName** — The trigger object
- **modifyRecordLookupPath** — Lookup field API name on the trigger object pointing to the target
- **recordFieldMapping** — Field modifications on the related record

## StepConfig Values
- `forvendi__Type__c` = "ModifyRecord"
- `forvendi__ClassName__c` = "forvendi.StepModifyRecordStep"

## Related Commands
- `/breezz-trigger` — Generate the trigger configuration
