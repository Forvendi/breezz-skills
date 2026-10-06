---
name: breezz-email-validation
description: "Generate Breezz Email Validation step configurations. Use when the user wants to automatically verify and standardize email addresses on context records using forvendi.StepEmailValidationStep in the Breezz framework."
---

# Breezz Email Validation Generator

Generate Email Validation step configurations using `forvendi.StepEmailValidationStep`.

## Compatibility

Works with: Before Insert, Before Update, After Insert, After Update, After Undelete (sync+async)
Does NOT work with: Before Delete, After Delete, Platform Events, CDC

## Parameters JSON Format

```json
{
  "emailField": "Email",
  "emailValidationResultField": "EmailValidationResult__c",
  "emailValidationMessageField": "EmailValidationMessage__c",
  "emailValidationDateField": "EmailValidationDate__c",
  "minTotalLength": 5,
  "minLocalPartLength": 1,
  "minDomainLength": 3,
  "customEmailRegex": "^.*$",
  "forbiddenDomains": ["example.com"],
  "forbiddenPhrases": [
    {"phrase": "spam", "scope": "Global"}
  ],
  "forbiddenChars": [
    {"char": "!", "scope": "Local Part"}
  ],
  "useForvendiServices": false
}
```

### Fields:
- **emailField** — Email field from context record
- **emailValidationResultField** — Checkbox field for validation result
- **emailValidationMessageField** — Text Area field for validation message
- **emailValidationDateField** — DateTime field for validation date
- **minTotalLength, minLocalPartLength, minDomainLength** — Minimum length constraints
- **customEmailRegex** — Custom regex for an Email Address
- **forbiddenDomains** — Specific email domains that are not allowed
- **forbiddenPhrases** — Words or phrases that should be blocked
- **forbiddenChars** — Characters that should be blocked
- **useForvendiServices** — Enables validation on an external server (Asynchronous only)

## StepConfig Values
- `forvendi__Type__c` = "EmailValidation"
- `forvendi__ClassName__c` = "forvendi.StepEmailValidationStep"
- `forvendi__Parameters__c` = JSON above

## Related Commands
- `/breezz-trigger` — Generate the trigger configuration
