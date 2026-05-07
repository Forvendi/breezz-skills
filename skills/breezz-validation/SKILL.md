---
name: breezz-validation
description: "Generate Breezz Custom Validation step configurations. Use when the user wants to create declarative validation rules that block record saves with custom error messages using forvendi.StepCustomValidationStep in the Breezz framework."
---

# Breezz Custom Validation Generator

Generate declarative validation configurations using `forvendi.StepCustomValidationStep`.

## Compatibility

Works with: After Insert, After Update, After Delete, After Undelete (sync+async)
Does NOT work with: Before Insert, Before Update (sync), Before Delete (sync), Platform Events, CDC

## Parameters JSON Format

```json
{
  "processingContextObjectName": "Account",
  "errorMessage": "You cannot save this record because the required field is missing."
}
```

### Fields:
- **processingContextObjectName** — The trigger object API name
- **errorMessage** — Error message displayed to the user (blocks the save)

## Usage Notes

- Combine with Entry Conditions to validate only specific records
- The error message is added via `addError()` on the record
- Use descriptive, user-friendly error messages

## StepConfig Values

- `forvendi__Type__c` = "CustomValidation"
- `forvendi__ClassName__c` = "forvendi.StepCustomValidationStep"
- `forvendi__Parameters__c` = JSON above

## Related Commands

- `/breezz-trigger` — Generate the trigger configuration with entry conditions
