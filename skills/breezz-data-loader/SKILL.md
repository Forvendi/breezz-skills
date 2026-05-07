---
name: breezz-data-loader
description: "Generate Breezz Data Loader classes and configurations. Use when the user wants to create custom data loaders extending forvendi.DataStore.Loader, configure data loading for step groups, or optimize data retrieval patterns in the Breezz framework."
---

# Breezz Data Loader Generator

Generate custom Data Loader implementations for efficient data retrieval across steps.

## When to Use

Data Loaders are needed when:
- Multiple steps in a group need the same related data
- Complex queries (joins, aggregates) are needed beyond simple ID lookups
- Data must be transformed before consumption (grouped by field, mapped)

## Workflow

### 1. Determine Loading Strategy
- **Query-based** — Configure via metadata (no Apex needed)
- **Custom** — Generate Apex class extending `forvendi.DataStore.Loader`

### 2. Generate Custom Loader Class

```apex
public with sharing class MyDataLoader extends forvendi.DataStore.Loader {

    public override void load() {
        Set<Id> requestedIds = getStore().getIds(Account.SObjectType);

        if (requestedIds.isEmpty()) {
            return;
        }

        List<Contact> contacts = [
            SELECT Id, AccountId, Name
            FROM Contact
            WHERE AccountId IN :requestedIds
        ];

        Map<Id, List<Contact>> grouped = new Map<Id, List<Contact>>();
        for (Contact c : contacts) {
            if (!grouped.containsKey(c.AccountId)) {
                grouped.put(c.AccountId, new List<Contact>());
            }
            grouped.get(c.AccountId).add(c);
        }

        getStore().storeData('accountContacts', grouped);
    }
}
```

### 3. Register in StepGroupConfig

Set `forvendi__DataLoader1__c` (through DataLoader8__c) to the loader's developer name.

### 4. Consume in Steps

```apex
// In initRecordProcessing:
getStore().requestToLoad('accountContacts', record.AccountId);
return true;

// In finishRecordProcessing:
Map<Id, List<Contact>> data = (Map<Id, List<Contact>>) getStore().getFromStore('accountContacts');
```

## DataStore API

### Requesting Data
- `getStore().requestToLoad(String storeKey, Id key)` — Request by key
- `getStore().requestToLoad(Id key)` — Request by SObject ID (auto-loads record)
- `getStore().requestFields(String storeKey, Set<String> fields)` — Request specific fields

### Consuming Data
- `getStore().getFromStore(String storeKey)` — Get by store key
- `getStore().getFromStore(Id recordId)` — Get loaded SObject by ID
- `getStore().hasInStore(String storeKey)` — Check availability
- `getStore().notInStore(String storeKey)` — Check unavailability

### Storing Data (in Loader)
- `getStore().storeData(String key, Object data)` — Store for current group execution
- `getStore().storeGlobalData(String key, Object data)` — Store globally (persists across groups)

## Constraints
- Loaders run ONCE per step group execution (after all initRecordProcessing calls)
- Never call DML in a Loader — it's for reading only
- Use `storeGlobalData()` when the same data is needed across multiple step groups

## Related Commands
- `/breezz-steps` — Generate steps that consume loaded data
- `/breezz-trigger` — Configure DataLoader references in StepGroupConfig
