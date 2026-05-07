---
name: breezz-plugin
description: "Generate Breezz Plugin implementations including BaseApexPlugin, AsyncExecutionStrategy, FeatureToggleService, and TriggerProcessHook. Use when the user wants to create Breezz plugins, extend the framework, implement custom async strategies, or create pre/post-process hooks in the Breezz framework."
---

# Breezz Plugin Generator

Generate plugin implementations that extend the Breezz framework.

## Plugin Types

### 1. BaseApexPlugin (Required)
Every Breezz installation needs one. Provides dynamic class instantiation.

```apex
public with sharing class BreezzPlugin implements forvendi.BreezzPlugins.BaseApexPlugin {

    public Object createInstance(String className) {
        return Type.forName(className).newInstance();
    }

    public Boolean hasCustomPermission(String permissionName) {
        return FeatureManagement.checkPermission(permissionName);
    }

    public List<String> searchForClassImplementation(String searchText, String interfaceName, Integer numberOfRecords) {
        return new List<String>();
    }
}
```

Register in: Breezz Setup → General Setup → Plugins Configuration → Base Apex Plugin

### 2. AsyncExecutionStrategy
Custom async execution logic beyond built-in strategies.

```apex
public with sharing class MyAsyncStrategy implements forvendi.AsyncExecutionStrategy {

    public void handle(forvendi.AsyncRequest[] requests, forvendi.ModificationContext ctx) {
        for (forvendi.AsyncRequest request : requests) {
            // Custom execution logic
        }
    }
}
```

Register via: `forvendi.BreezzPlugins.AsyncExecutionStrategyProvider`

### 3. FeatureToggleService
Custom feature availability logic.

```apex
public with sharing class MyToggleService implements forvendi.BreezzPlugins.FeatureToggleService {

    public Boolean isEnabled(String featureName) {
        // Custom logic
        return true;
    }
}
```

### 4. TriggerProcessHook
Pre/post-processing logic around step execution.

```apex
public with sharing class MyPreprocessHook implements forvendi.TriggerProcessHook {

    public void process(SObject[] records, Map<Id, SObject> optionalOldRecords) {
        // Logic before/after steps execute
    }
}
```

Configure in TriggerConfig: `TriggerPreprocessHook__c` or `TriggerPostprocessHook__c`

## Workflow

1. Determine which plugin type is needed
2. Generate the implementation class
3. Generate .cls-meta.xml
4. Provide registration instructions

## Related Commands
- `/breezz-feature-toggle` — Configure feature toggles that use FeatureToggleService
- `/breezz-trigger` — Configure TriggerProcessHook references
