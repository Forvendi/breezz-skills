public with sharing class AfterInsertCustomStep extends forvendi.Step {
    public AfterInsertCustomStep() {
        super(AfterInsertCustomStep.class.getName());
    }

    public override Boolean initRecordProcessing(Object record, Object optionalOldRecord) {
        Prospect__c prospect = (Prospect__c) record;

        // After-trigger: use addModificationToUpdate for field-level changes
        // NEVER use addToUpdate() when multiple steps may modify the same record
        getContext().addModificationToUpdate(prospect.Id, Prospect__c.Status__c, 'Qualified');

        return false;
    }
}
