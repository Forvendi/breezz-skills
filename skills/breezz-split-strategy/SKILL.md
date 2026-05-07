---
name: breezz-split-strategy
description: "Generate Breezz TriggerRecordsSplitStrategy implementations and configure record split strategies on trigger configurations. Use when the user wants to filter which records a trigger processes, create custom split strategies, configure condition-based or record-type-based filtering, or mentions forvendi.TriggerRecordsSplitStrategy in the Breezz framework."
---

# Breezz Split Strategy Generator

Generate record split strategy implementations that control which records a Breezz trigger processes.

## Strategy Types

| Strategy | RecordsSplitStrategy__c | Configuration |
|----------|------------------------|---------------|
| All | "All" | None — processes every record |
| Record Type | "RecordType" | RecordsSplitConfig__c = record type developer names (comma-separated) |
| Condition | "Condition" | RecordsSplitConfig__c = JSON condition config |
| Custom | "Custom" | RecordSplitConfiguration__c = Apex class name |

## Workflow

### 1. Determine Strategy Type

- If filtering by record type → use "RecordType" strategy
- If filtering by field conditions (equals, contains, is changed) → use "Condition" strategy
- If complex logic needed → use "Custom" strategy (generate Apex class)

### 2. For Custom Strategy: Generate Apex Class

```apex
public with sharing class MyStrategy implements forvendi.TriggerRecordsSplitStrategy {
    public Boolean canProcess(SObject record, SObject optionalOldRecord) {
        // Return true if this record should be processed
        MyObject__c rec = (MyObject__c) record;
        return rec.Status__c == 'Active';
    }
}
```

See `assets/custom-split-strategy.cls` for a complete example.

### 3. Update TriggerConfig Metadata

Set the appropriate fields on forvendi__B_TriggerConfig:
- For Custom: `RecordsSplitStrategy__c = "Custom"`, `RecordSplitConfiguration__c = "ClassName"`
- For RecordType: `RecordsSplitStrategy__c = "RecordType"`, `RecordsSplitConfig__c = "DevName1,DevName2"`
- For Condition: `RecordsSplitStrategy__c = "Condition"`, `RecordsSplitConfig__c = JSON`

## Condition JSON Format

```json
{
  "criteria": [
    {
      "field": "fieldApiName",
      "fieldValueType": "record",
      "operator": "=",
      "value": "expectedValue",
      "valueType": "value"
    }
  ],
  "criteriaLogicType": "and"
}
```

**Operators**: =, !=, <, >, in, not in, like, starts with, ends with, is set, is not set, is new, is changed, is new or changed

**Value Types**: value, $Record, $User, $UserRole, $Profile, $Organization, $System, $RecordType, $CustomPermission, $Label

## Constraints

- RecordType strategy does NOT work with Platform Events or CDC
- Custom strategy class must be `with sharing`
- `canProcess()` must not perform SOQL/DML — it runs per-record
- `optionalOldRecord` is null for Insert/Undelete events

## Reference Files

- `assets/custom-split-strategy.cls` — Custom strategy example

## Related Commands

- `/breezz-trigger` — Generate the full trigger configuration
