
@isTest
private class AccountProcessorTest {

    @TestSetup
    static void makeData(){
        Account acc = new Account(Name = 'Josh');
        Contact con = new Contact(LastName = 'Tim');
        con.Account = acc;
        insert acc;
        insert con;
    }

    @isTest
    static void myUnitTest() {
        // TO DO: implement unit test
        List<Account> accs = [SELECT Id FROM Account];
        List<Id> accIds = new List<Id>();

        for(Integer i = 0; i < accs.size(); i++){
            accIds.add(accs[i].Id);
        }
        Test.startTest();
        AccountProcessor.countContacts(accIds);
        Test.stopTest();
        accs = [SELECT Id, Number_Of_Contacts__c FROM Account];
        Assert.isTrue(accs[0].Number_Of_Contacts__c != 0);
    }
}