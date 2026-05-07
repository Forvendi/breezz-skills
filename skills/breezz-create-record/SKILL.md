---
name: breezz-create-record
description: "Generate Breezz Create Record step configurations. Use when the user wants to declaratively create child records or related records from a trigger using forvendi.StepCreateRecordStep in the Breezz framework."
---

# Breezz Create Record Generator

Generate declarative record creation configurations using `forvendi.StepCreateRecordStep`.

## Compatibility

Works with: After Insert, After Update, After Undelete (sync+async)
Not optimal: Before Insert, Before Update
Does NOT work with: Before Delete, After Delete

## Parameters JSON Format

```json
{
  "objectName": "Task",
  "processingContextObjectName": "Opportunity",
  "recordFieldMapping": [
    {"field": "Subject", "value": "Follow up", "valueType": "value"},
    {"field": "WhatId", "value": "Id", "valueType": "record"},
    {"field": "OwnerId", "value": "OwnerId", "valueType": "record"}
  ]
}
```

### Fields:
- **objectName** — The object to create
- **processingContextObjectName** — The trigger object (source of data)
- **recordFieldMapping** — Field assignments for the new record
  - **field** — Target field on the new record
  - **value** — Static value or source field name
  - **valueType** — "value" (literal) or "record" (from trigger record)

## StepConfig Values

- `forvendi__Type__c` = "CreateRecord"
- `forvendi__ClassName__c` = "forvendi.StepCreateRecordStep"
- `forvendi__Parameters__c` = JSON above

## Related Commands

- `/breezz-trigger` — Generate the trigger configuration
