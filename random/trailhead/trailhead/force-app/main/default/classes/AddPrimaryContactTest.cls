@isTest
private class AddPrimaryContactTest {

    @TestSetup
    static void makeData(){
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 50; i++){
            Account acc = new Account(Name = String.valueOf(i), BillingState = 'CA');
            accounts.add(acc);
        }
        insert(accounts);
    }

    @isTest
    static void myUnitTest() {
        // Start test context for async job processing.
        Test.startTest();
        System.enqueueJob(new AddPrimaryContact(new Contact(LastName = 'add'), 'CA'));
        Test.stopTest();

        // Query an Account with its Contacts.
        Account acc = [SELECT Id, (SELECT LastName FROM Contacts) 
                       FROM Account 
                       WHERE BillingState = 'CA' 
                       LIMIT 1];

        // Check that the Account has at least one Contact.
        System.assert(acc.Contacts != null && !acc.Contacts.isEmpty(), 'No contacts were created.');
        
        // Access the first Contact in the list.
        Contact con = acc.Contacts[0];

        // Assert that the cloned contact has the correct LastName.
        System.assertEquals('add', con.LastName, 'The contact LastName is not as expected.');
    }
}
