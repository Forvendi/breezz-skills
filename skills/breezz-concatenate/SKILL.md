---
name: breezz-concatenate
description: "Generate Breezz Concatenate Fields step configurations. Use when the user wants to combine multiple field values into one field using forvendi.StepConcatenateFieldsStep in the Breezz framework."
---

# Breezz Concatenate Fields Generator

Combine multiple field values into a target field using `forvendi.StepConcatenateFieldsStep`.

## Compatibility

Works with: Before Insert (sync), After Insert, Before Update, After Update, After Undelete (sync+async)
Not optimal: Before Delete
Does NOT work with: After Delete, Platform Events, CDC

## Parameters JSON Format

```json
{
  "processingContextObjectName": "Account",
  "recordFieldMapping": [
    {"field": "FullName__c", "param": " ", "value": "undefined"},
    {"field": "FullName__c", "value": "FirstName", "valueType": "text"},
    {"field": "FullName__c", "value": "LastName", "valueType": "text"}
  ]
}
```

### Fields:
- **processingContextObjectName** — The trigger object
- **recordFieldMapping** — Array defining concatenation:
  - First entry: target field + separator in `param` + `value: "undefined"` (signals start)
  - Subsequent entries: source fields with `valueType: "text"` (reference field names)

## StepConfig Values
- `forvendi__Type__c` = "ConcatenateFields"
- `forvendi__ClassName__c` = "forvendi.StepConcatenateFieldsStep"

## Related Commands
- `/breezz-trigger` — Generate the trigger configuration
