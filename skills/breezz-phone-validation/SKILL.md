---
name: breezz-phone-validation
description: "Generate Breezz Phone Validation step configurations. Use when the user wants to automatically verify and standardize phone numbers on context records using forvendi.StepPhoneValidationStep in the Breezz framework."
---

# Breezz Phone Validation Generator

Generate Phone Validation step configurations using `forvendi.StepPhoneValidationStep`.

## Compatibility

Works with: Before Insert, Before Update, After Insert, After Update, After Undelete (sync+async)
Does NOT work with: Before Delete, After Delete, Platform Events, CDC

## Parameters JSON Format

```json
{
  "phoneField": "Phone",
  "countryCodeType": "Static Country Code",
  "countryCodeField": "",
  "staticCountryCode": "PL",
  "format": "E.164",
  "phoneValidationResultField": "PhoneValidationResult__c",
  "phoneValidationMessageField": "PhoneValidationMessage__c",
  "phoneValidationDateField": "PhoneValidationDate__c",
  "minLength": 9,
  "allowEmpty": false,
  "allowRepeatingDigit": false,
  "forbiddenSequences": ["123456", "000000"],
  "useForvendiServices": false
}
```

### Fields:
- **phoneField** — Phone field from context record
- **countryCodeType** — 'Field from Object' or 'Static Country Code'
- **countryCodeField** — Text field if 'Field from Object' is used
- **staticCountryCode** — Country code string if 'Static Country Code' is used
- **format** — Raw, Original, E.164, International, National
- **phoneValidationResultField** — Checkbox field for validation result
- **phoneValidationMessageField** — Text Area field for validation message
- **phoneValidationDateField** — DateTime field for validation date
- **minLength** — Minimum required length of a phone number
- **allowEmpty** — Whether the phone number can be empty
- **allowRepeatingDigit** — Whether the phone number can consist of a repeating digit
- **forbiddenSequences** — Number sequences that should be blocked
- **useForvendiServices** — Enables validation on an external server (Asynchronous only)

## StepConfig Values
- `forvendi__Type__c` = "PhoneValidation"
- `forvendi__ClassName__c` = "forvendi.StepPhoneValidationStep"
- `forvendi__Parameters__c` = JSON above

## Related Commands
- `/breezz-trigger` — Generate the trigger configuration
