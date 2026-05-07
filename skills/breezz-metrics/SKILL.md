---
name: breezz-metrics
description: "Generate Breezz Metrics Calculator implementations and configure metrics tracking. Use when the user wants to create custom metrics, track execution performance, monitor governor limits, or implement forvendi.Metrics.MetricCalculator in the Breezz framework."
---

# Breezz Metrics Generator

Generate custom Metrics Calculator implementations and configure metrics tracking.

## Metric Calculation Types

| Type | Use Case |
|------|----------|
| Custom | Implement MetricCalculator class |
| Count SOQL Query | Count records matching a query |
| Count Package Async Future Usage | Monitor future method usage |
| Count Package Async Queueable Usage | Monitor queueable usage |
| Count Package Async Batches Usage | Monitor batch usage |
| Platform Limits Usage | Track overall platform limits |

## Workflow

### 1. For Custom Metrics: Generate Calculator Class

```apex
public with sharing class MyMetricCalculator implements forvendi.Metrics.MetricCalculator {

    public Decimal calculate() {
        return [SELECT COUNT() FROM AsyncApexJob WHERE Status = 'Failed' AND CreatedDate = TODAY];
    }
}
```

### 2. Configure Metadata

Key fields for forvendi__B_MetricConfig:
- **Metric API Name** — Developer identifier
- **Enable Measurement** — Boolean
- **Execution Interval** — How often to calculate
- **Metrics Calculator Class Name** — Your calculator class
- **Group Name** — Category for dashboard organization
- **Warning Threshold** — Alert at this value
- **Error Threshold** — Critical alert at this value
- **Default Limit** — Baseline for comparison

### 3. Using Logger for Custom Metrics in Steps

```apex
// Track execution time
Long startTime = System.currentTimeMillis();
// ... processing ...
Long duration = System.currentTimeMillis() - startTime;
forvendi.BreezzApi.LOGGER.addTimeLog('MyStep', 'initRecordProcessing', 'processTime', duration);

// Track custom metric
forvendi.BreezzApi.LOGGER.addMetricValue('MyProcess', 'recordsProcessed', records.size());

// Track execution count
forvendi.BreezzApi.LOGGER.addNumberOfExecutionsMetric('MyProcess');
```

## Metrics Storage Optimization

For Developer Sandboxes with limited storage:
- Reduce metrics lifespan to 2 days
- Or disable metrics entirely via Breezz App → Metrics Setup

## Related Commands
- `/breezz-steps` — Steps can log custom metrics via Logger
- `/breezz-plugin` — BaseApexPlugin needed for metrics framework
