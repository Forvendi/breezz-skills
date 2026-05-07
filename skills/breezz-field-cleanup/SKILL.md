---
name: breezz-field-cleanup
description: "Generate Breezz Text Field Cleanup step configurations. Use when the user wants to truncate, lowercase, uppercase, or trim text fields declaratively using forvendi.StepTextFieldCleanupStep in the Breezz framework."
---

# Breezz Text Field Cleanup Generator

Generate declarative text field cleanup configurations using `forvendi.StepTextFieldCleanupStep`.

## Compatibility

Works with: Before Insert (sync only), After Insert, Before Update, After Update, After Undelete (sync+async)
Does NOT work with: Before Insert (async), Before Delete, After Delete

## Parameters JSON Format

```json
{
  "processingContextObjectName": "Account",
  "recordFieldMapping": [
    {"field": "Name", "value": "", "operator": "trunc", "param": "25"},
    {"field": "Name", "value": "", "operator": "lowercase", "param": ""}
  ]
}
```

### Operators:
- **trunc** — Truncate to `param` characters
- **lowercase** — Convert to lowercase
- **uppercase** — Convert to uppercase
- **trim** — Remove leading/trailing whitespace

### Fields:
- **processingContextObjectName** — The trigger object API name
- **recordFieldMapping** — Array of operations (executed in order)
  - **field** — Field API name to process
  - **operator** — Operation to perform
  - **param** — Parameter for the operation (e.g., max length for trunc)

## StepConfig Values

- `forvendi__Type__c` = "TextFieldCleanup"
- `forvendi__ClassName__c` = "forvendi.StepTextFieldCleanupStep"
- `forvendi__Parameters__c` = JSON above

## Related Commands

- `/breezz-trigger` — Generate the trigger configuration
