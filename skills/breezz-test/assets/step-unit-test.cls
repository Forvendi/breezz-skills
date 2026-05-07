@IsTest
private class MyCustomStepTest {
    @TestSetup
    static void setup() {
        forvendi.BreezzApi.TESTS.init('BreezzPlugin');
    }

    @IsTest
    static void shouldModifyProspectStatus() {
        Prospect__c prospect = new Prospect__c(Name = 'Test');
        insert prospect;

        Test.startTest();
        forvendi.ModificationContext ctx = forvendi.BreezzApi.STEPS.build()
            .skipModificationContextSave()
            .addStep(new MyCustomStep())
            .execute(new List<Prospect__c>{ prospect });
        Test.stopTest();

        Assert.isNotNull(ctx.getRecordsToUpdate(prospect.Id));
        forvendi.BreezzApi.TESTS.assertErrorLogs();
    }
}
