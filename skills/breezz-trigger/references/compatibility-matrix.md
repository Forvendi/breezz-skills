# Breezz Step Type Compatibility Matrix

This matrix defines which step types work with which trigger events. **REFUSE to generate configurations for invalid combinations.**

## Legend
- **OK** = fully supported (sync and async)
- **NO** = will not work — do NOT generate
- **~** = not optimal — warn the user but allow if they insist
- **NO sync** = only async works, sync will not work
- **NO async** = only sync works, async will not work

## Matrix

| Step Type (`forvendi__Type__c`) | Before Insert | After Insert | Before Update | After Update | Before Delete | After Delete | After Undelete | Platform Event | CDC |
|---|---|---|---|---|---|---|---|---|---|
| Custom | OK | OK | OK | OK | OK | OK | OK | OK | OK |
| Flow | OK | OK | OK | OK | OK | OK | OK | OK | OK |
| StepGroup | NO sync | OK | OK | OK | OK | OK | OK | OK | OK |
| RollUpSummaryField | NO | OK | NO sync | OK | ~ | OK | OK | NO | NO |
| CreateRecord | ~ | OK | ~ | OK | NO | NO | OK | OK | OK |
| TextFieldCleanup | NO async | OK | OK | OK | NO | NO | OK | OK | OK |
| ModifyContextRecord | NO sync | OK | OK | OK | NO | NO | OK | NO | OK |
| ModifyRecord | NO | OK | NO sync | OK | ~ | NO | OK | NO | OK |
| CustomValidation | NO | OK | NO sync | OK | NO sync | OK | OK | NO | OK |
| GenerateUUID | NO | OK | OK | OK | NO | NO | OK | NO | NO |
| ModifyRecords | NO | OK | ~ | OK | NO | NO | OK | NO | OK |
| ConcatenateFields | NO | OK | OK | OK | ~ | NO | OK | NO | OK |
| RunScheduler | NO sync | OK | ~ | OK | ~ | OK | OK | OK | OK |

## Validation Rules

Before generating any StepConfig, check:

1. Look up the `forvendi__Type__c` value in the matrix
2. Cross-reference with the trigger event from the TriggerConfig
3. If the cell says **NO** → refuse and explain why
4. If the cell says **~** (not optimal) → warn the user about limitations
5. If the cell says **NO sync** → ensure `forvendi__Async__c = true`
6. If the cell says **NO async** → ensure `forvendi__Async__c = false`

## Additional Constraints

- **Record Split Strategy "RecordType"** does NOT work with Platform Events or CDC events
- **Record Split Strategy "Condition"** works with all event types
- **Record Split Strategy "Custom"** works with all event types
