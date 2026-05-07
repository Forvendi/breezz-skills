@IsTest
private class MyAsyncStepTest {
    @TestSetup
    static void setup() {
        forvendi.BreezzApi.TESTS.init('BreezzPlugin');
    }

    @IsTest
    static void shouldProcessAsyncJob() {
        Prospect__c prospect = new Prospect__c(Name = 'Async Test');
        insert prospect;

        Test.startTest();
        prospect.Status__c = 'New';
        update prospect;
        forvendi.BreezzApi.TESTS.deliverAsyncQueueEvents();
        Test.stopTest();

        Prospect__c result = (Prospect__c) forvendi.BreezzApi.TESTS.loadRecordById(prospect.Id);
        Assert.areEqual('Processed', result.Status__c);
        forvendi.BreezzApi.TESTS.assertErrorLogs();
    }
}
