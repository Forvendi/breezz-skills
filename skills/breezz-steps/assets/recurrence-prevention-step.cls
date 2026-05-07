public with sharing class RecurrencePreventionStep extends forvendi.Step {
    public RecurrencePreventionStep() {
        super(RecurrencePreventionStep.class.getName());
    }

    public override Boolean initRecordProcessing(Object record, Object optionalOldRecord) {
        Prospect__c prospect = (Prospect__c) record;

        // This step modifies the trigger context record in an After Update trigger.
        // Without recurrence prevention, this would cause an infinite loop.
        // Configure TriggerConfig with:
        //   RecursionPreventionStrategy = "Skip Repeated Records"
        //   TotalNumberOfRecurrences = 4
        getContext().addModificationToUpdate(prospect.Id, Prospect__c.Value__c, 'Updated');

        return false;
    }
}
