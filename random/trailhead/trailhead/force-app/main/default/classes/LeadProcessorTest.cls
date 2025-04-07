
@isTest
private class LeadProcessorTest {

    @TestSetup
    static void makeData(){
        List<Lead> leads = new List<Lead>();
        for(Integer i = 0; i < 200; i++){
            Lead l = new Lead(LastName = String.valueOf(i), Company = String.valueOf(i));
            leads.add(l);
        }
        insert leads;
    }

    @isTest
    static void myUnitTest() {
        // TO DO: implement unit test
        List<Lead> leads = new List<Lead>();
        Test.startTest();
        Database.executeBatch(new LeadProcessor());
        
        Test.stopTest();
        leads = [SELECT Id, LeadSource FROM Lead LIMIT 2];

        Assert.areEqual(leads.get(1).LeadSource, 'Dreamforce');
    }
    

}