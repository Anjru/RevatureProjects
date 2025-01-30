public with sharing class ContactHelper {
    public ContactHelper() {

    }

    @AuraEnabled (cacheable = true)
    public static List<Contact> getContacts(){
        try {
            return [SELECT Id, LastName, FirstName FROM Contact LIMIT 10];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}