---
name: breezz-permissions
description: "Guide Breezz permission assignment and access rights validation. Use when the user needs to assign Breezz permissions, configure the Minimal Access Permission Set, validate user access rights, or troubleshoot permission issues in the Breezz framework."
---

# Breezz Permissions Guide

Assign Breezz permissions and validate user access rights.

## Required Permission Sets

### Breezz Admin Permission Set
For users managing framework configuration (triggers, steps, scheduler):
- Full access to Breezz custom metadata
- Access to Breezz Setup pages
- Scheduler management

### Breezz Minimal Access Permission Set
For all users whose records are processed by Breezz:
- Apex REST Services
- API Enabled
- Lightning Experience User

## Assignment

```bash
# Via SF CLI
sf org assign permset --name forvendi__Breezz_Admin --target-org myOrg
sf org assign permset --name forvendi__Breezz_Minimal_Access --target-org myOrg
```

## Access Validation in Code

### Check Custom Permission
```apex
Boolean hasAccess = forvendi.BreezzApi.FEATURE.isEnabled('MyPermissionFeature');
```

### Using BaseApexPlugin
```apex
// In your BreezzPlugin class:
public Boolean hasCustomPermission(String permissionName) {
    return FeatureManagement.checkPermission(permissionName);
}
```

### In Steps
```apex
public override Boolean initRecordProcessing(Object record, Object optionalOldRecord) {
    // Skip processing if user lacks permission
    if (!forvendi.BreezzApi.FEATURE.isEnabled('AdvancedProcessing')) {
        return false;
    }
    // Process...
    return false;
}
```

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| "Insufficient privileges" | Missing permission set | Assign Breezz Minimal Access |
| Triggers not firing | BaseApexPlugin not configured | Register plugin in Breezz Setup |
| Scheduler not running | No admin permission | Assign Breezz Admin |
| Feature toggle always false | Permission not assigned | Assign custom permission |

## Related Commands
- `/breezz-plugin` — Generate the BaseApexPlugin (required for permissions)
- `/breezz-feature-toggle` — Configure permission-based feature toggles
