---
name: breezz-data-enrichment
description: "Generate Breezz Data Enrichment step configurations. Use when the user wants to integrate with external APIs services to retrieve external data and map the results directly to existing system records using forvendi.StepDataEnrichmentStep in the Breezz framework."
---

# Breezz Data Enrichment Generator

Generate Data Enrichment step configurations to retrieve external data and map the results directly to existing system records using `forvendi.StepDataEnrichmentStep`.

## Compatibility

Works with: After Insert, After Update, After Undelete (sync+async)
Does NOT work with: Before Insert, Before Update (sync), Before Delete (sync), Platform Events, CDC

## Parameters JSON Format

```json
{
  "integrationType": "Customer Info Strategy",
  "source": "CEIDG",
  "integrationProfile": "CEIDG Integration",
  "matchingParameter": "REGON",
  "fieldNames": "Select Field",
  "parameterMapping": [
    {"remoteField": "Id", "localField": "Select Field"},
    {"remoteField": "Nazwa", "localField": "Select Field"}
  ]
}
```

### Fields:
- **integrationType** — The type of integration (e.g. Customer Info Strategy).
- **source** — The source of data (e.g. CEIDG, GUS).
- **integrationProfile** — The integration profile to use.
- **matchingParameter** — External field for matching.
- **fieldNames** — Local field to match against.
- **parameterMapping** — Mappings from remote to local fields.

## StepConfig Values
- `forvendi__Type__c` = "DataEnrichment"
- `forvendi__ClassName__c` = "forvendi.StepDataEnrichmentStep"
- `forvendi__Parameters__c` = JSON above

## Related Commands
- `/breezz-trigger` — Generate the trigger configuration
