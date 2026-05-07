---
name: breezz-test
description: "Generate unit tests for Breezz Steps, Triggers, and Scheduler Jobs using the Breezz testing framework. Use when the user wants to test breezz steps, write test classes for forvendi.Step implementations, use StepsAssembler, or test async/scheduler functionality in the Breezz framework. Also trigger on mentions of forvendi.BreezzApi.TESTS or StepsAssembler."
---

# Breezz Test Generator

Generate unit tests for Breezz framework components using the built-in testing utilities.

## Two Testing Approaches

### 1. Database Context Testing (Integration Tests)
Tests trigger logic by performing real DML operations:
```apex
@IsTest
static void shouldProcessRecord() {
    Account acc = new Account(Name = 'Test');
    Test.startTest();
    insert acc;
    Test.stopTest();

    Account result = (Account) forvendi.BreezzApi.TESTS.loadRecordById(acc.Id);
    Assert.areEqual('Expected', result.Status__c);
    forvendi.BreezzApi.TESTS.assertErrorLogs();
}
```

### 2. Modification Context Testing (Unit Tests)
Tests step logic without database persistence using StepsAssembler:
```apex
@IsTest
static void shouldModifyRecord() {
    Account acc = new Account(Id = TestHelper.getFakeId(Account.SObjectType), Name = 'Test');

    Test.startTest();
    forvendi.ModificationContext ctx = forvendi.BreezzApi.STEPS.build()
        .skipModificationContextSave()
        .addStep(new MyCustomStep())
        .execute(new Account[]{ acc });
    Test.stopTest();

    Assert.isNotNull(ctx.getRecordsToUpdate(acc.Id));
    forvendi.BreezzApi.TESTS.assertErrorLogs();
}
```

## Workflow

### 1. Determine What to Test
- Step class → use StepsAssembler (Modification Context)
- Full trigger flow → use Database Context
- Async step → use `deliverAsyncQueueEvents()`
- Scheduler → use `forvendi.BreezzApi.SCHEDULER.run()`

### 2. Generate Test Class

Always include:
- `@TestSetup` with `forvendi.BreezzApi.TESTS.init('BreezzPlugin');`
- `Test.startTest()` / `Test.stopTest()` around the action
- `forvendi.BreezzApi.TESTS.assertErrorLogs()` at the end

### 3. For Async Steps
```apex
Test.startTest();
insert record;
forvendi.BreezzApi.TESTS.deliverAsyncQueueEvents();
Test.stopTest();
```

### 4. For Scheduler Jobs
```apex
Test.startTest();
forvendi.BreezzApi.SCHEDULER.run();
Test.stopTest();
```

## Test API Reference

### Initialization
- `forvendi.BreezzApi.TESTS.init()` — Initialize without plugin
- `forvendi.BreezzApi.TESTS.init('PluginClassName')` — Initialize with BaseApexPlugin

### Async Delivery
- `forvendi.BreezzApi.TESTS.deliverAsyncQueueEvents()` — Deliver all pending async jobs
- `forvendi.BreezzApi.TESTS.deliverStepAsyncQueueEvents('StepConfigDevName')` — Deliver specific step
- `forvendi.BreezzApi.TESTS.deliverDelayedAsyncJobs()` — Deliver delayed async jobs

### Assertions
- `forvendi.BreezzApi.TESTS.assertErrorLogs()` — Assert no errors occurred
- `forvendi.BreezzApi.TESTS.assertErrorLogs(Integer n)` — Assert exactly n errors
- `forvendi.BreezzApi.TESTS.assertAsyncJobsErrors()` — Check async job errors

### Data Loading
- `forvendi.BreezzApi.TESTS.loadRecordById(Id)` — Load single record with all fields
- `forvendi.BreezzApi.TESTS.loadRecordByIds(Set<Id>)` — Load multiple records
- `forvendi.BreezzApi.TESTS.loadAllRecords(SObjectType)` — Load all records of type

### StepsAssembler
- `forvendi.BreezzApi.STEPS.build()` — Create StepsAssembler
- `.skipModificationContextSave()` — Prevent DB save (inspect ctx instead)
- `.forceSyncExecution()` — Force async steps to run synchronously
- `.addStep(Step)` — Add a step
- `.execute(Object[])` — Execute and return ModificationContext

### Callout Mocking
- `forvendi.BreezzApi.TESTS.setCalloutMock()` — Single endpoint mock
- `forvendi.BreezzApi.TESTS.setCalloutMultiMock()` — Multiple endpoints

## Hard-Stop Constraints

1. ALWAYS call `assertErrorLogs()` — silent failures are the #1 testing pitfall
2. ALWAYS use `Test.startTest()`/`Test.stopTest()` — required for governor limit reset
3. For async: ALWAYS call `deliverAsyncQueueEvents()` between startTest/stopTest
4. Use `skipModificationContextSave()` when testing step logic without DB side effects

## Related Commands

- `/breezz-steps` — Generate the Step class to test
- `/breezz-trigger` — Generate trigger config to test against
