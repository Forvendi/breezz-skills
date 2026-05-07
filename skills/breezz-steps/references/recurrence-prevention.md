# Recurrence Prevention Configuration

## Overview

Recurrence prevention controls how many times a trigger can re-fire on the same record within a single transaction chain. This is critical for After Update triggers where step logic modifies the trigger context record, causing the trigger to re-fire.

## Configuration Fields (on forvendi__B_TriggerConfig)

| Field | Values | Description |
|-------|--------|-------------|
| `forvendi__RecursionPreventionStrategy__c` | `None`, `Skip Repeated Records` | Strategy for preventing infinite loops |
| `forvendi__TotalNumberOfRecurrences__c` | Number (0 = unlimited) | How many additional re-entries are allowed |

## Behavior

- **"None"** — No recursion prevention. Trigger fires unlimited times. Use only when you are certain no recursive updates will occur.
- **"Skip Repeated Records"** with N recurrences — The trigger will execute a total of **N + 1 times** (1 initial + N allowed recurrences). After that, repeated records are skipped.

## Example

With `RecursionPreventionStrategy = "Skip Repeated Records"` and `TotalNumberOfRecurrences = 4`:
- Initial trigger fire: execution #1
- 1st allowed recurrence: execution #2
- 2nd allowed recurrence: execution #3
- 3rd allowed recurrence: execution #4
- 4th allowed recurrence: execution #5
- 5th attempt: **SKIPPED** — record is not processed

## When to Use

- **Always configure** recurrence prevention for After Update triggers
- **Set to "None"** only for Before Insert, After Insert, Before Delete, After Delete, After Undelete (these cannot cause recursive updates)
- **Before Update** may also need prevention if step logic calls `addModificationToUpdate()` on the same record

## Metadata Example

```xml
<values>
    <field>forvendi__RecursionPreventionStrategy__c</field>
    <value xsi:type="xsd:string">Skip Repeated Records</value>
</values>
<values>
    <field>forvendi__TotalNumberOfRecurrences__c</field>
    <value xsi:type="xsd:double">4.0</value>
</values>
```
