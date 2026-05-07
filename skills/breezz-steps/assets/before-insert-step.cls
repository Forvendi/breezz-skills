public with sharing class BeforeInsertCustomStep extends forvendi.Step {
    public BeforeInsertCustomStep() {
        super(BeforeInsertCustomStep.class.getName());
    }

    public override Boolean initRecordProcessing(Object record, Object optionalOldRecord) {
        Prospect__c prospect = (Prospect__c) record;

        // Before-trigger: modify the trigger context record directly
        if (String.isBlank(prospect.Status__c)) {
            prospect.Status__c = 'New';
        }

        return false;
    }
}
