# forvendi__B_SchedulerConfig Metadata Fields

| Field API Name | Type | Description |
|---------------|------|-------------|
| forvendi__ClassName__c | String | Apex class name or StepConfig/StepGroupConfig dev name |
| forvendi__ConfigurationScope__c | String | "Own" |
| forvendi__Description__c | String | Human-readable description of the job |
| forvendi__ExecutionInterval__c | String | "10min", "30min", "1h", "2h", "4h", "8h", "12h", "24h" |
| forvendi__IsActive__c | Boolean | Whether the job is active |
| forvendi__JobConfiguration__c | String | SOQL query for step-based types |
| forvendi__RecordConfiguration__c | String | Additional configuration |
| forvendi__RecordLevelSecurity__c | String | "Inherited Sharing", "With Sharing", "Without Sharing" |
| forvendi__RelatedObject__c | String | SObject API name for step-based types |
| forvendi__Type__c | String | Scheduler type value (Custom, StepFunction, StepFunctionsGroup, etc.) |
| forvendi__FeatureAvailability__c | String | Feature flag availability |
