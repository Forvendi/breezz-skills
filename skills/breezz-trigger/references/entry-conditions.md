# Entry Conditions JSON Format

Entry conditions control whether a step executes for a given record. They are stored in the `forvendi__EntryConditions__c` field on `forvendi__B_StepConfig`.

## Structure

```json
{
  "criteria": [...],
  "criteriaLogicType": "and|or"
}
```

## Criterion Object

Each criterion in the `criteria` array has this structure:

```json
{
  "field": "fieldApiName",
  "fieldValueType": "record",
  "operator": "<operator>",
  "value": "<value>",
  "valueType": "<valueType>"
}
```

## Operators

| Operator | Description | Example Value |
|---|---|---|
| `=` | Equals | `"TEST"` |
| `!=` | Not equals | `"CLOSED"` |
| `<` | Less than | `"100"` |
| `>` | Greater than | `"0"` |
| `in` | In list (comma-separated) | `"Open,In Progress,Pending"` |
| `not in` | Not in list | `"Closed,Cancelled"` |
| `like` | Contains | `"partial"` |
| `starts with` | Starts with | `"PREFIX"` |
| `ends with` | Ends with | `"SUFFIX"` |
| `is set` | Field is not null | (no value needed) |
| `is not set` | Field is null | (no value needed) |
| `is new` | Field was just populated (insert or null->value) | (no value needed) |
| `is changed` | Field value changed from old to new | (no value needed) |
| `is new or changed` | Field is new or changed | (no value needed) |

## Value Types

| valueType | Description | Example |
|---|---|---|
| `value` | Literal value | `"TEST"`, `"100"`, `"true"` |
| `$Record` | Field from the current record | `"OwnerId"` |
| `$User` | Field from the running user | `"Id"` |
| `$UserRole` | Field from the user's role | `"DeveloperName"` |
| `$Profile` | Field from the user's profile | `"Name"` |
| `$Organization` | Field from the org | `"Id"` |
| `$System` | System variable | `"now"`, `"today"` |
| `$RecordType` | Record type field | `"DeveloperName"` |
| `$CustomPermission` | Custom permission name | `"My_Permission"` |
| `$Label` | Custom label | `"My_Label"` |

## Examples

### Simple equality check

```json
{
  "criteria": [
    {
      "field": "Name",
      "fieldValueType": "record",
      "operator": "=",
      "value": "TEST",
      "valueType": "value"
    }
  ],
  "criteriaLogicType": "and"
}
```

### Multiple conditions with AND logic

```json
{
  "criteria": [
    {
      "field": "Status__c",
      "fieldValueType": "record",
      "operator": "in",
      "value": "Open,In Progress",
      "valueType": "value"
    },
    {
      "field": "Amount__c",
      "fieldValueType": "record",
      "operator": ">",
      "value": "0",
      "valueType": "value"
    }
  ],
  "criteriaLogicType": "and"
}
```

### Field changed condition (for Update triggers)

```json
{
  "criteria": [
    {
      "field": "Status__c",
      "fieldValueType": "record",
      "operator": "is changed",
      "value": "",
      "valueType": "value"
    }
  ],
  "criteriaLogicType": "and"
}
```

### Check against current user

```json
{
  "criteria": [
    {
      "field": "OwnerId",
      "fieldValueType": "record",
      "operator": "=",
      "value": "Id",
      "valueType": "$User"
    }
  ],
  "criteriaLogicType": "and"
}
```

### Record type filter

```json
{
  "criteria": [
    {
      "field": "RecordTypeId",
      "fieldValueType": "record",
      "operator": "=",
      "value": "DeveloperName",
      "valueType": "$RecordType"
    }
  ],
  "criteriaLogicType": "and"
}
```
