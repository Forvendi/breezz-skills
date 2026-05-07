# Breezz Utility Classes Reference

## Collections (`forvendi.BreezzApi.COLLECTIONS`)

Provides data structure manipulation and transformation methods.

### ID Extraction
```apex
Set<Id> ids = forvendi.BreezzApi.COLLECTIONS.extractIdsFromList(records);
Set<Id> ids = forvendi.BreezzApi.COLLECTIONS.extractIdsFromList(records, Account.ParentId);
Set<Id> ids = forvendi.BreezzApi.COLLECTIONS.extractIdsFromList(records, 'ParentId');
```

### Value Extraction
```apex
Set<Object> values = forvendi.BreezzApi.COLLECTIONS.extractValuesFromList(records, Account.Name);
Set<Object> values = forvendi.BreezzApi.COLLECTIONS.extractValuesFromList(records, 'Name');
```

### Collection Operations
```apex
Object[] subset = forvendi.BreezzApi.COLLECTIONS.slice(arr, 0, 10);
Set<String> strings = forvendi.BreezzApi.COLLECTIONS.toStringSet(keys);
Set<Id> idSet = forvendi.BreezzApi.COLLECTIONS.toIdSet(keys);
List<Id> idList = forvendi.BreezzApi.COLLECTIONS.toIdList(keys);
```

### SObject Instantiation
```apex
List<SObject> list = forvendi.BreezzApi.COLLECTIONS.createSObjectList(Account.SObjectType);
Map<Id, SObject> map = forvendi.BreezzApi.COLLECTIONS.createSObjectMap(Account.SObjectType);
Map<Id, SObject> map = forvendi.BreezzApi.COLLECTIONS.createSObjectMap(records);
```

### Grouping Functions
```apex
Map<String, SObject> unique = forvendi.BreezzApi.COLLECTIONS.groupUniqueByTextField(records, Account.Name);
Map<Id, SObject> unique = forvendi.BreezzApi.COLLECTIONS.groupUniqueByField(records, Account.ParentId);
Map<String, List<SObject>> grouped = forvendi.BreezzApi.COLLECTIONS.groupByTextField(records, Account.Name);
Map<Id, List<SObject>> grouped = forvendi.BreezzApi.COLLECTIONS.groupByField(records, Account.ParentId);
```

---

## Describe (`forvendi.BreezzApi.DESCRIBE`)

Schema introspection and metadata retrieval.

### Picklist Values
```apex
List<String> values = forvendi.BreezzApi.DESCRIBE.getPicklistValues('Account', 'Industry');
Map<String, List<String>> deps = forvendi.BreezzApi.DESCRIBE.getPicklistDependencies('Object', 'ControllingField', 'DependentField');
```

### UUID Generation
```apex
String uuid = forvendi.BreezzApi.DESCRIBE.generateUUID();
Boolean valid = forvendi.BreezzApi.DESCRIBE.isValidUUID(uuidValue);
```

### Record Types
```apex
RecordTypeInfo rt = forvendi.BreezzApi.DESCRIBE.getRecordType(Account.SObjectType, 'Business_Account');
RecordTypeInfo defaultRt = forvendi.BreezzApi.DESCRIBE.getDefaultRecordType(Account.SObjectType);
RecordTypeInfo rt = forvendi.BreezzApi.DESCRIBE.getRecordTypeById(Account.SObjectType, recordTypeId);
```

### Schema Introspection
```apex
String ns = forvendi.BreezzApi.DESCRIBE.getNamespace('forvendi__CustomObject__c');
Set<String> fieldNames = forvendi.BreezzApi.DESCRIBE.getAllFieldNames(Account.SObjectType);
Map<String, SObjectField> fields = forvendi.BreezzApi.DESCRIBE.getAllFields(Account.SObjectType);
DescribeSObjectResult desc = forvendi.BreezzApi.DESCRIBE.getDescribe(Account.SObjectType);
DescribeFieldResult fieldDesc = forvendi.BreezzApi.DESCRIBE.getFieldDescribe(Account.SObjectType, 'Name');
```

### Dynamic Instantiation
```apex
Object instance = forvendi.BreezzApi.DESCRIBE.createInstance('MyClassName');
```

---

## Dates (`forvendi.BreezzApi.DATES`)

Date range validation and overlap detection.

```apex
// With custom comparator
Boolean hasOverlap = forvendi.BreezzApi.DATES.validateDateRangesOverlap(
    newRanges, oldRanges, comparator
);

// With SObject fields
Boolean hasOverlap = forvendi.BreezzApi.DATES.validateDateRangesOverlap(
    newRecords, oldRecords, Schema.MyObject__c.StartDate__c, Schema.MyObject__c.EndDate__c
);

// With custom comparator and SObject fields
Boolean hasOverlap = forvendi.BreezzApi.DATES.validateDateRangesOverlap(
    newRecords, oldRecords, Schema.MyObject__c.StartDate__c, Schema.MyObject__c.EndDate__c, comparator
);
```

---

## DB (`forvendi.BreezzApi.DATABASE`)

Database operations with sharing control and structured error handling.

### Getting a DML Instance
```apex
forvendi.DB.DML dml = forvendi.BreezzApi.DATABASE.getDML('with sharing');
forvendi.DB.DML dml = forvendi.BreezzApi.DATABASE.getDML('without sharing');
forvendi.DB.DML dml = forvendi.BreezzApi.DATABASE.getDML('inherited sharing');
```

### CRUD Operations
```apex
forvendi.DB.DBResult result = dml.create(record);
forvendi.DB.DBResult result = dml.create(records);
forvendi.DB.DBResult result = dml.modify(record);
forvendi.DB.DBResult result = dml.modify(records);
forvendi.DB.DBResult result = dml.modify(records, true); // allOrNone
forvendi.DB.DBResult result = dml.remove(record);
forvendi.DB.DBResult result = dml.remove(recordIds);
forvendi.DB.DBResult result = dml.hardRemove(record); // permanent delete
forvendi.DB.DBResult result = dml.upsertRecords(records);
forvendi.DB.DBResult result = dml.upsertRecords(records, externalIdField);
```

### Async DML
```apex
forvendi.DB.DBResult result = dml.createAsync(record);
forvendi.DB.DBResult result = dml.modifyAsync(records);
forvendi.DB.DBResult result = dml.removeAsync(records);
```

### Queries
```apex
List<SObject> results = dml.query('SELECT Id FROM Account');
List<SObject> results = dml.query('SELECT Id FROM Account WHERE Name = :name', bindMap);
Integer count = dml.countQuery('SELECT COUNT() FROM Account');
Database.QueryLocator locator = dml.getQueryLocator('SELECT Id FROM Account');
```

### Other Operations
```apex
forvendi.DB.DBResult result = dml.convert(leadConvert);
forvendi.DB.DBResult result = dml.send(emailMessage);
forvendi.DB.DBResult result = dml.publish(platformEvent);
```

### Error Handling with DBResult
```apex
forvendi.DB.DBResult result = dml.modify(records, false);
if (result.hasErrors) {
    String errorMsg = result.getErrorMessage();
    forvendi.BreezzApi.LOGGER.addErrorLog('MyClass', 'myMethod', result);
    // Access individual errors:
    for (forvendi.DB.DBResultItem item : result.errorResult) {
        System.debug(item.getErrorMessage());
    }
}
// Access successful records:
List<SObject> successRecords = result.getSuccessRecords();
```

---

## Logger (`forvendi.BreezzApi.LOGGER`)

Comprehensive diagnostic and metric capabilities.

### Error Logging
```apex
forvendi.BreezzApi.LOGGER.logError('MyClass', 'myMethod', 'Something went wrong');
forvendi.BreezzApi.LOGGER.logError('MyClass', 'myMethod', ex); // Exception
forvendi.BreezzApi.LOGGER.addErrorLog('MyClass', 'myMethod', dbResult); // DB.DBResult
```

### Warning Logging
```apex
forvendi.BreezzApi.LOGGER.addWarnLog('MyClass', 'myMethod', 'Non-critical issue');
```

### Performance Metrics
```apex
forvendi.BreezzApi.LOGGER.addTimeLog('MyClass', 'myMethod', 'processRecords', timeInMs);
forvendi.BreezzApi.LOGGER.addTimeLog('MyClass', 'myMethod', 'processRecords', timeInMs, 'extra details');
forvendi.BreezzApi.LOGGER.addMetricValue('MyProcess', 'recordsProcessed', 150);
forvendi.BreezzApi.LOGGER.addNumberOfExecutionsMetric('MyProcess');
forvendi.BreezzApi.LOGGER.addNumberOfProcessedRecordsMetric('MyProcess', 50);
```

### Publishing
```apex
forvendi.BreezzApi.LOGGER.publish(); // Publish via platform events
forvendi.BreezzApi.LOGGER.save();    // Save directly to database
```

---

## Feature (`forvendi.BreezzApi.FEATURE`)

Feature toggle management and environment detection.

### Environment Detection
```apex
Boolean isSandbox = forvendi.BreezzApi.FEATURE.isSandbox();
Boolean isProduction = forvendi.BreezzApi.FEATURE.isProduction();
```

### Trigger Control
```apex
forvendi.BreezzApi.FEATURE.enableTrigger(Account.SObjectType);
forvendi.BreezzApi.FEATURE.disableTrigger(Account.SObjectType);
Boolean enabled = forvendi.BreezzApi.FEATURE.isTriggerEnabled(Account.SObjectType);
```

### Feature Flags
```apex
if (forvendi.BreezzApi.FEATURE.isEnabled('MyFeatureName')) {
    // Feature-gated logic
}
```
