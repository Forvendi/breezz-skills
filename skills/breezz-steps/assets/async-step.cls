public with sharing class AfterInsertAsyncStep extends forvendi.Step {
    public AfterInsertAsyncStep() {
        super(AfterInsertAsyncStep.class.getName());
    }

    public override Boolean initRecordProcessing(Object record, Object optionalOldRecord) {
        Prospect__c prospect = (Prospect__c) record;

        // Only queue for async when running in async mode
        if (getConfig().isAsync) {
            addAsyncJob(prospect.Id);
        }

        return false;
    }

    public override void executeAsyncProcess(Map<String, forvendi.AsyncJobInfo> asyncJobsByRecordKey) {
        // Full DML/SOQL/callout capability here — runs ~2 min later
        for (String recordId : asyncJobsByRecordKey.keySet()) {
            // Process each queued record
            getContext().addModificationToUpdate(Id.valueOf(recordId), Prospect__c.Status__c, 'Processed Async');
        }
    }
}
