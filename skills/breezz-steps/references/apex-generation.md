# Apex Generation Rules for Breezz Steps

Self-contained Apex authoring guidelines for breezz step classes. These rules ensure generated code is safe, performant, and deployable.

## Governor Limit Constraints

Salesforce enforces per-transaction limits. Violating these causes runtime exceptions.

| Limit | Value | Rule |
|-------|-------|------|
| SOQL queries | 100 (sync), 200 (async) | Never place SOQL inside a loop |
| DML statements | 150 | Never place DML inside a loop |
| DML rows | 10,000 | Bulkify — process collections, not individual records |
| CPU time | 10,000ms (sync), 60,000ms (async) | Avoid unnecessary computation in loops |
| Heap size | 6MB (sync), 12MB (async) | Don't accumulate large collections unnecessarily |

**Breezz-specific**: `initRecordProcessing()` and `finishRecordProcessing()` must not perform SOQL or DML at all — the framework handles data loading through the DataStore.

## Sharing Model

Every Apex class must declare a sharing model. Choose based on the step's purpose:

| Keyword | When to Use |
|---------|-------------|
| `with sharing` | Default choice. Respects the running user's record access. Use for most business logic. |
| `without sharing` | When the step must access records the user can't see (e.g., system-level updates, cross-account rollups). |
| `inherited sharing` | When the step is called from different contexts and should inherit the caller's sharing. Rare for steps. |

Default to `with sharing` unless there's a specific reason not to.

## Security

- **Bind variables in SOQL**: Always use `:variableName` instead of string concatenation to prevent SOQL injection.
  ```apex
  // Good
  List<Account> accts = [SELECT Id FROM Account WHERE Id IN :accountIds];

  // Bad — SOQL injection risk
  String query = 'SELECT Id FROM Account WHERE Id = \'' + userInput + '\'';
  ```

- **USER_MODE for dynamic queries**: When using `Database.query()`, pass `AccessLevel.USER_MODE` to enforce field-level security.

- **No hardcoded IDs**: Use Custom Metadata, Custom Labels, Custom Settings, or queries to resolve IDs.

## Bulkification

Steps must handle collections of records, not just single records. Even though `initRecordProcessing` processes one record at a time, the framework calls it for every record in the trigger batch (up to 200).

- Collect IDs/data in `initRecordProcessing`, then batch-process in `finishSyncProcess`
- Use Maps for O(1) lookups instead of nested loops
- Pre-query related data once, not per-record

## Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Class name | PascalCase | `OpportunityAmountValidationStep` |
| Method name | camelCase | `initRecordProcessing` |
| Constants | UPPER_SNAKE | `STORE_KEY` |
| Variables | camelCase | `oldAccountsMap` |
| Custom fields | PascalCase__c | `Invoice_Amount__c` |

## Common Anti-Patterns

| Anti-Pattern | Fix |
|-------------|-----|
| SOQL in `initRecordProcessing` | Use `getStore().requestToLoad()` and read in `finishRecordProcessing` |
| DML in a for loop | Collect records in a List, DML once after the loop |
| Hardcoded record IDs | Query by Name, use Custom Metadata, or Custom Labels |
| Missing null checks on `optionalOldRecord` | Always check `optionalOldRecord != null` before accessing (it's null on insert) |
| Modifying trigger record in after-trigger step | Use `getContext().addModificationToUpdate()` for related records only |
| `System.debug()` in production code | Remove debug statements; use breezz Logger if logging is needed |

## Exception Handling

- Don't silently swallow exceptions — log them or rethrow
- Use `record.addError('message')` in before-trigger steps to block saves with user-facing messages
- In async steps, exceptions are captured by the framework — return error details via the async job info
