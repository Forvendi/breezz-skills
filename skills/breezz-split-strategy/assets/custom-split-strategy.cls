public with sharing class CustomTestSplitStrategy implements forvendi.TriggerRecordsSplitStrategy {
    public Boolean canProcess(SObject record, SObject optionalOldRecord) {
        Account acc = (Account) record;
        return acc.Name != null && acc.Name.startsWith('PROCESS_ME');
    }
}
