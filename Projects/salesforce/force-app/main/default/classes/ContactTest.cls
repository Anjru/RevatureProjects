@isTest
private with sharing class ContactTest {
    public ContactTest() {

    }

    @isTest
    static void matchingEmailInsertTest(){
        Contact con = new Contact(LastName = 'T', Email = 'test@gmail.com');
        insert con; 
        
        Account acc = new Account(Name = 'Y');
        insert acc;

        con.AccountId = acc.Id;
        update con;

        try{
        Contact con2 = new Contact(LastName = 'J', Email = 'broke@hotmail.com', AccountId = acc.Id);
        insert con2;
        }catch(DmlException e){

        List<Contact> contacts = [SELECT Email FROM Contact];
        System.debug('Size = ' + contacts.size());
        Assert.isTrue(contacts.size() == 1);
        }

    }

    @isTest
    static void defaultEmailTest(){
        Contact con = new Contact(LastName = 'T');
        insert con;
        con = [SELECT LastName, Email FROM Contact LIMIT 1];
        Assert.areEqual('defaultemail@gmail.com', con.Email);
    }
}