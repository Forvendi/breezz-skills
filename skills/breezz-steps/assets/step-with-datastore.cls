public with sharing class StepWithDataStore extends forvendi.Step {
    private static final String STORE_KEY = 'parentAccounts';

    public StepWithDataStore() {
        super(StepWithDataStore.class.getName());
    }

    public override Boolean initRecordProcessing(Object record, Object optionalOldRecord) {
        Contact contact = (Contact) record;

        // Request data from the store — NO SOQL here
        if (contact.AccountId != null) {
            getStore().requestToLoad(STORE_KEY, contact.AccountId);
        }

        // Return true to signal that finishRecordProcessing should be called
        return true;
    }

    public override void finishRecordProcessing(Object record, Object optionalOldRecord) {
        Contact contact = (Contact) record;

        // Data is now available — NO SOQL here either
        Account parentAccount = (Account) getStore().getFromStore(contact.AccountId);

        if (parentAccount != null && parentAccount.Industry == 'Technology') {
            getContext().addModificationToUpdate(contact.Id, Contact.Department, 'Tech');
        }
    }
}
