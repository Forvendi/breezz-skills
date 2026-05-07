# Breezz Step Patterns Reference

## Table of Contents

1. [Step Lifecycle Methods](#step-lifecycle-methods)
2. [Base Step Class Template](#base-step-class-template)
3. [Concrete Step Templates](#concrete-step-templates)
4. [DataStore Pattern](#datastore-pattern)
5. [ModificationContext Pattern](#modificationcontext-pattern)
6. [Async Processing Pattern](#async-processing-pattern)

---

## Step Lifecycle Methods

Steps extend `forvendi.Step` and execute lifecycle methods in this order:

| # | Method | Runs | DML/SOQL Allowed | Purpose |
|---|--------|------|-------------------|---------|
| 1 | `initialize()` | Once per step execution | Yes | One-time setup, load config |
| 2 | `initRecordProcessing(Object, Object)` | Per record | **No** | Process each record, request data via `getStore()`. Return `true` if data needed, `false` if done. |
| 3 | `finishRecordProcessing(Object, Object)` | Per record (only if init returned `true`) | **No** | Consume data from `getStore()`, apply logic |
| 4 | `finishSyncProcess(List<Object>, List<Object>)` | Once after all records | Yes | Batch operations, DML, aggregate logic |
| 5 | `executeAsyncProcess(Map<String, forvendi.AsyncJobInfo>)` | Once, ~2 min later | Yes | Heavy processing, callouts, async work |

**Key rule**: Methods 2 and 3 must not perform SOQL or DML. This is because the framework batches data loading across all steps in a Step Group for efficiency. Use `getStore().requestToLoad()` in method 2, then read results in method 3 via `getFromStore()`.

---

## Base Step Class Template

This abstract class wraps `forvendi.Step` to provide typed parameters. Generate one per SObject type. Replace `{SObject}` with the target SObject API name (e.g., `Account`, `Opportunity`, `Invoice__c`), and `{SObjectType}` with the Apex type name (e.g., `Account`, `Opportunity`, `Invoice__c`).

For class naming, use the SObject name without `__c` suffix for custom objects: `Invoice__c` → `InvoiceStep`.

```apex
public with sharing abstract class {SObject}Step extends forvendi.Step {
    public {SObject}Step(String className) {
        super(className);
    }

    public abstract Boolean initRecordProcessing({SObjectType} record, {SObjectType} optionalOldRecord);
    public override Boolean initRecordProcessing(Object record, Object optionalOldRecord) {
        return initRecordProcessing(({SObjectType}) record, ({SObjectType}) optionalOldRecord);
    }

    public override void finishRecordProcessing(Object record, Object optionalOldRecord) {
        finishRecordProcessing(({SObjectType}) record, ({SObjectType}) optionalOldRecord);
    }

    public virtual void finishRecordProcessing({SObjectType} record, {SObjectType} optionalOldRecord) {
    }

    public virtual override void finishSyncProcess(List<Object> records, List<Object> optionalOldRecords) {
        List<{SObjectType}> typedRecords = new List<{SObjectType}>();
        List<{SObjectType}> typedOldRecords = new List<{SObjectType}>();
        Map<Id, {SObjectType}> oldRecordsMap = new Map<Id, {SObjectType}>();
        if (records != null) {
            for (Object record : records) {
                typedRecords.add(({SObjectType}) record);
            }
        }
        if (optionalOldRecords != null && !optionalOldRecords.isEmpty()) {
            for (Object record : optionalOldRecords) {
                typedOldRecords.add(({SObjectType}) record);
                if (record != null) {
                    oldRecordsMap.put((({SObjectType}) record).Id, ({SObjectType}) record);
                }
            }
        }
        finishSyncProcess(typedRecords, typedOldRecords, oldRecordsMap);
    }

    public virtual void finishSyncProcess(List<{SObjectType}> records, List<{SObjectType}> optionalOldRecords, Map<Id, {SObjectType}> optionalOldRecordsMap) {
    }
}
```

---

## Concrete Step Templates

### Before-Trigger: Field Validation / Defaults

Use when: validating field values, setting default values, blocking saves with `addError()`.

Only implement `initRecordProcessing()`. The record is mutable — set fields directly or call `addError()` to block the save.

```apex
public with sharing class {StepName} extends {SObject}Step {
    public {StepName}() {
        super({StepName}.class.getName());
    }

    public override Boolean initRecordProcessing({SObjectType} record, {SObjectType} optionalOldRecord) {
        // Validate or set defaults on the record
        // Example: record.Status__c = 'Draft';
        // Example: record.addError('Amount must be positive');
        return false;
    }
}
```

### After-Trigger: Related Record Updates

Use when: updating parent/child/related records after the trigger record is saved.

Never modify the trigger context record in after-trigger steps. Use `getContext()` to queue modifications to related records.

```apex
public with sharing class {StepName} extends {SObject}Step {
    public {StepName}() {
        super({StepName}.class.getName());
    }

    public override Boolean initRecordProcessing({SObjectType} record, {SObjectType} optionalOldRecord) {
        // Queue data requests if needed
        // getStore().requestToLoad('relatedData');
        return false;
    }

    public override void finishSyncProcess(List<{SObjectType}> records, List<{SObjectType}> optionalOldRecords, Map<Id, {SObjectType}> optionalOldRecordsMap) {
        for ({SObjectType} record : records) {
            // Use getContext() to modify related records
            // getContext().addModificationToUpdate(relatedRecord, Schema.SObjectField, value);
            // getContext().addToInsert(newRecord);
            // getContext().addToDelete(recordToDelete);
        }
    }
}
```

### DataStore: Loading Related Data

Use when: the step needs data from related records that isn't on the trigger record itself. The DataStore is shared across all steps in a Step Group, so data loaded once is available to all subsequent steps.

```apex
public with sharing class {StepName} extends {SObject}Step {
    private static final String STORE_KEY = '{StepName}_data';

    public {StepName}() {
        super({StepName}.class.getName());
    }

    public override Boolean initRecordProcessing({SObjectType} record, {SObjectType} optionalOldRecord) {
        // Request data load — the framework will batch this across records
        getStore().requestToLoad(STORE_KEY);
        return true; // Signal that finishRecordProcessing should be called
    }

    public override void finishRecordProcessing({SObjectType} record, {SObjectType} optionalOldRecord) {
        // Data is now available from the store
        Object data = getFromStore(STORE_KEY);
        // Process record with the loaded data
    }
}
```

Note: The actual data loading is handled by a Data Loader class configured at the Step Group level. The step only requests and consumes data — it does not query directly.

### Async Processing

Use when: the step needs to perform callouts, heavy computation, or operations that should run outside the trigger transaction (~2 minutes later).

```apex
public with sharing class {StepName} extends {SObject}Step {
    public {StepName}() {
        super({StepName}.class.getName());
    }

    public override Boolean initRecordProcessing({SObjectType} record, {SObjectType} optionalOldRecord) {
        // Queue this record for async processing
        addAsyncJob(record.Id);
        return false;
    }

    public override void executeAsyncProcess(Map<String, forvendi.AsyncJobInfo> asyncJobsByRecordKey) {
        // Full DML/SOQL/callout capability here
        for (String recordKey : asyncJobsByRecordKey.keySet()) {
            // Process each queued record
            // recordKey is the Id passed to addAsyncJob()
        }
    }
}
```

### Combined: Before-Trigger with Change Detection

Use when: the step should only run when specific fields have changed (update triggers).

```apex
public with sharing class {StepName} extends {SObject}Step {
    public {StepName}() {
        super({StepName}.class.getName());
    }

    public override Boolean initRecordProcessing({SObjectType} record, {SObjectType} optionalOldRecord) {
        // Skip if not an update or field hasn't changed
        if (optionalOldRecord == null) {
            return false;
        }
        if (record.FieldName__c == optionalOldRecord.FieldName__c) {
            return false;
        }
        // Apply logic only when field changed
        return false;
    }
}
```

---

## DataStore Pattern

The DataStore is a shared cache across all steps in a Step Group. It reduces SOQL queries by loading data once and sharing it.

**In initRecordProcessing (request data):**
```apex
getStore().requestToLoad('myDataKey');
return true; // Must return true for finishRecordProcessing to be called
```

**In finishRecordProcessing (consume data):**
```apex
Object result = getFromStore('myDataKey');
// Cast and use the result
```

**Check if data is cached:**
```apex
if (getStore().notInStore('myDataKey')) {
    getStore().requestToLoad('myDataKey');
}
```

**Store custom data (in Data Loader classes):**
```apex
store.storeData('myDataKey', myComputedData);
```

---

## ModificationContext Pattern

The ModificationContext accumulates DML operations and executes them in a single batch at the end of the Step Group. This is the correct way to modify records in after-trigger steps.

**Insert a new record:**
```apex
getContext().addToInsert(newRecord);
```

**Update a related record (full record replacement):**
```apex
getContext().addToUpdate(existingRecord);
```

**Update specific fields safely (prevents overwrites from other steps):**
```apex
getContext().addModificationToUpdate(record, Schema.{SObjectType}.FieldName__c, newValue);
```
Use `addModificationToUpdate` when multiple steps might update the same record — it merges field-level changes rather than overwriting the entire record.

**Delete a record:**
```apex
getContext().addToDelete(recordToDelete);
```

---

## Async Processing Pattern

**Queue a record for async processing:**
```apex
addAsyncJob(record.Id); // or any unique string key
```

**Schedule delayed async execution:**
```apex
addDelayedAsyncJob(record.Id, Datetime.now().addMinutes(30));
```

**Cancel a pending async job:**
```apex
cancelAsyncRequest(record.Id);
```

**Helper methods available in steps:**
- `isNew()` — true if this is an insert trigger
- `isChanged()` — true if this is an update trigger
- `isNewOrChanged()` — true for either
- `getConfig()` — access the step's metadata configuration
