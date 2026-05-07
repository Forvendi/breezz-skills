---
name: breezz-uuid
description: "Generate Breezz Generate UUID step configurations. Use when the user wants to auto-generate UUID values on records using forvendi.StepGenerateUUIDStep in the Breezz framework."
---

# Breezz Generate UUID Generator

Auto-generate UUID values on record fields using `forvendi.StepGenerateUUIDStep`.

## Compatibility

Works with: After Insert, Before Update, After Update, After Undelete (sync+async)
Does NOT work with: Before Insert, Before Delete, After Delete, Platform Events, CDC

## Parameters JSON Format

```json
{
  "requestType": "generateUUID",
  "processingContextObjectName": "Account",
  "recordFieldMapping": [
    {"field": "ExternalId__c"}
  ]
}
```

### Fields:
- **requestType** — Always "generateUUID"
- **processingContextObjectName** — The trigger object
- **recordFieldMapping** — Array with field(s) to populate with UUID

## StepConfig Values
- `forvendi__Type__c` = "GenerateUUID"
- `forvendi__ClassName__c` = "forvendi.StepGenerateUUIDStep"

## Related Commands
- `/breezz-trigger` — Generate the trigger configuration
