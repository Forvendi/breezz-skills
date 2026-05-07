---
name: breezz-feature-toggle
description: "Generate Breezz Feature Toggle configurations and FeatureToggleService implementations. Use when the user wants to conditionally enable/disable features, create feature flags, implement forvendi.BreezzPlugins.FeatureToggleService, or use forvendi.BreezzApi.FEATURE in the Breezz framework."
---

# Breezz Feature Toggle Generator

Configure feature toggles for conditional feature availability.

## Feature Toggle Scopes

| Scope | Configuration | Use Case |
|-------|--------------|----------|
| Environment | "All", "Sandboxes", "Production" | Enable in specific environments |
| Custom Permission | Permission API name | Enable for users with permission |
| Custom Settings Field | Hierarchical custom settings field | Enable per user/profile/org |
| Service Plugin | FeatureToggleService class | Complex runtime logic |

## Workflow

### 1. Choose Scope
- Simple env-based → configure metadata only
- Permission-based → set Custom Permission Name field
- Complex logic → generate FeatureToggleService class

### 2. Generate FeatureToggleService (if needed)

```apex
public with sharing class MyFeatureToggleService implements forvendi.BreezzPlugins.FeatureToggleService {

    public Boolean isEnabled(String featureName) {
        if (featureName == 'MyFeature') {
            // Custom logic: check org config, query records, etc.
            return [SELECT COUNT() FROM Product2 WHERE IsActive = true] > 0;
        }
        return false;
    }
}
```

### 3. Usage in Steps

```apex
if (forvendi.BreezzApi.FEATURE.isEnabled('MyFeature')) {
    // Feature-gated logic
}
```

### 4. Trigger-Level Control

```apex
// Disable all triggers for an object temporarily
forvendi.BreezzApi.FEATURE.disableTrigger(Account.SObjectType);
// Re-enable
forvendi.BreezzApi.FEATURE.enableTrigger(Account.SObjectType);
```

## Feature API Reference

- `forvendi.BreezzApi.FEATURE.isEnabled(String featureName)` — Check feature flag
- `forvendi.BreezzApi.FEATURE.isSandbox()` — Environment check
- `forvendi.BreezzApi.FEATURE.isProduction()` — Environment check
- `forvendi.BreezzApi.FEATURE.enableTrigger(SObjectType)` — Enable triggers
- `forvendi.BreezzApi.FEATURE.disableTrigger(SObjectType)` — Disable triggers
- `forvendi.BreezzApi.FEATURE.isTriggerEnabled(SObjectType)` — Check trigger status

## Linking to Triggers/Steps

Set `forvendi__FeatureAvailability__c` on TriggerConfig, StepGroupConfig, or StepConfig to the feature toggle name. The framework checks `isEnabled()` before executing.

## Related Commands
- `/breezz-plugin` — Generate the FeatureToggleService plugin
- `/breezz-trigger` — Link feature toggles to trigger configs
