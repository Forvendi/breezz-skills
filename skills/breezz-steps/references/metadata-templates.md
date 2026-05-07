# Metadata Templates for Breezz Steps

## .cls-meta.xml Template

Every `.cls` file requires a companion `.cls-meta.xml` file with the same base name. Generate this alongside each Apex class.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>62.0</apiVersion>
    <status>Active</status>
</ApexClass>
```

## Rules

- **Filename**: Must match the class name exactly. `OpportunityStep.cls` requires `OpportunityStep.cls-meta.xml`.
- **API Version**: Use the latest Salesforce API version unless the project uses a different version. Check existing `.cls-meta.xml` files in the project to match.
- **Status**: Always `Active`.
- **Encoding**: UTF-8, XML declaration on line 1.
- **Namespace**: Use `http://soap.sforce.com/2006/04/metadata` — this is the standard Salesforce metadata namespace.

## Checking Project API Version

Before generating, check an existing meta.xml in the project to match the API version:
```
Glob for **/*.cls-meta.xml and read one to check the apiVersion value.
```

If found, use that version. If not found, default to the latest Salesforce API version.
