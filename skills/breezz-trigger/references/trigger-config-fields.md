# Breezz Trigger Configuration Fields Reference

Complete field documentation for all three metadata types in the Breezz trigger configuration stack.

---

## forvendi__B_TriggerConfig Fields

| Field API Name | Type | Description |
|---|---|---|
| `forvendi__IsActive__c` | Boolean | Whether this trigger config is active |
| `forvendi__ObjectName__c` | String | SObject API name (e.g., `Account`, `My_Object__c`) |
| `forvendi__Order__c` | Double | Execution order when multiple TriggerConfigs exist for the same object+event |
| `forvendi__TriggerEvent__c` | String | Trigger event: Before Insert, After Insert, Before Update, After Update, Before Delete, After Delete, After Undelete |
| `forvendi__RecordsSplitStrategy__c` | String | How records are split before processing: `All`, `Custom`, `Condition`, `RecordType` |
| `forvendi__RecordSplitConfiguration__c` | String | Class name implementing custom split strategy (used when strategy = `Custom`) |
| `forvendi__RecordsSplitConfig__c` | String | JSON configuration for `Condition` or `RecordType` split strategies |
| `forvendi__RecursionPreventionStrategy__c` | String | `None` or `Skip Repeated Records` |
| `forvendi__TotalNumberOfRecurrences__c` | Double | Max allowed recurrences (0 = unlimited). Only relevant when RecursionPreventionStrategy != None |
| `forvendi__StepGroup1__c` | String | Developer name of the 1st step group to execute |
| `forvendi__StepGroup2__c` | String | Developer name of the 2nd step group to execute |
| `forvendi__StepGroup3__c` | String | Developer name of the 3rd step group to execute |
| `forvendi__StepGroup4__c` | String | Developer name of the 4th step group to execute |
| `forvendi__TriggerPreprocessHook__c` | String | Apex class name implementing `TriggerProcessHook` (runs before steps) |
| `forvendi__TriggerPostprocessHook__c` | String | Apex class name implementing `TriggerProcessHook` (runs after steps) |
| `forvendi__FeatureAvailability__c` | String | Feature Toggle name — if set, trigger only fires when this feature is enabled |

---

## forvendi__B_StepGroupConfig Fields

| Field API Name | Type | Description |
|---|---|---|
| `forvendi__AllOrNone__c` | Boolean | If true, all DML in the group is all-or-none |
| `forvendi__DataLoader1__c` | String | SOQL query for data loader 1 |
| `forvendi__DataLoader2__c` | String | SOQL query for data loader 2 |
| `forvendi__DataLoader3__c` | String | SOQL query for data loader 3 |
| `forvendi__DataLoader4__c` | String | SOQL query for data loader 4 |
| `forvendi__DataLoader5__c` | String | SOQL query for data loader 5 |
| `forvendi__DataLoader6__c` | String | SOQL query for data loader 6 |
| `forvendi__DataLoader7__c` | String | SOQL query for data loader 7 |
| `forvendi__DataLoader8__c` | String | SOQL query for data loader 8 |
| `forvendi__Description__c` | String | Human-readable description of the step group |
| `forvendi__IsActive__c` | Boolean | Whether this step group is active |
| `forvendi__ObjectName__c` | String | SObject API name this group relates to |
| `forvendi__Parameters__c` | String | JSON parameters for the step group |
| `forvendi__RecordLevelSecurity__c` | String | `Inherited Sharing`, `With Sharing`, or `Without Sharing` |
| `forvendi__Type__c` | String | `Trigger` (for trigger step groups) or `Custom` (for standalone invocation) |
| `forvendi__FeatureAvailability__c` | String | Feature Toggle name |

---

## forvendi__B_StepConfig Fields

| Field API Name | Type | Description |
|---|---|---|
| `forvendi__Async__c` | Boolean | Whether this step runs asynchronously |
| `forvendi__AsyncStrategy__c` | String | Async execution strategy: `MultiQueueable`, `Direct`, `Future`, `Queueable`, `Batch`, `Custom` |
| `forvendi__AsyncThreshold__c` | Double | Number of records above which async is triggered (0 = always async when Async__c = true) |
| `forvendi__AsyncCustomStrategy__c` | String | Custom strategy class name (used when AsyncStrategy = `Custom`) |
| `forvendi__ClassName__c` | String | Apex class name that implements the step logic |
| `forvendi__ConfigurationScope__c` | String | Always `Own` |
| `forvendi__DataLoader1__c` | String | SOQL query for step-level data loader 1 |
| `forvendi__DataLoader2__c` | String | SOQL query for step-level data loader 2 |
| `forvendi__DelayedQueueObject__c` | String | Always `forvendi__B_DelayedAsyncJob__c` |
| `forvendi__Description__c` | String | Human-readable description of the step |
| `forvendi__EntryConditions__c` | String | JSON entry conditions (see references/entry-conditions.md) |
| `forvendi__IsActive__c` | Boolean | Whether this step is active |
| `forvendi__Order__c` | Double | Execution order within the step group |
| `forvendi__Parameters__c` | String | JSON parameters for declarative step types |
| `forvendi__QueueEventObject__c` | String | Always `forvendi__B_AsyncJobEvent__e` |
| `forvendi__QueueObject__c` | String | Always `forvendi__B_AsyncJob__c` |
| `forvendi__Queued__c` | Boolean | Always `true` |
| `forvendi__SkipProcessAfterAddingToQueue__c` | Boolean | Always `false` |
| `forvendi__StepGroupConfig__c` | String | Developer name of the parent StepGroupConfig |
| `forvendi__Type__c` | String | Step type value (see SKILL.md for full list) |
| `forvendi__UsePlatformEvents__c` | Boolean | Always `true` |
| `forvendi__FeatureAvailability__c` | String | Feature Toggle name |
