public with sharing class AuraExpController {
    public AuraExpController() {

    }

    @AuraEnabled
    public static List<Contact> getAllContacts(){
        try {
            return [SELECT Id, FirstName, LastName, Phone, Email FROM Contact];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void createContact(String firstName, String lastName, String phone){
        try {
            Contact contact = new Contact(FirstName = firstName,LastName = lastName, Phone = phone);
            insert contact;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteContact(List<Contact> contacts){
        try {
            delete contacts;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Account> getAllAccounts(){
        try {
            return [SELECT Id, Name, Phone FROM Account];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void createAccount(String name, String phone){
        try {
            Account account = new Account(Name = name, Phone = phone);
            insert account;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteAccount(List<Account> accounts){
        try {
            delete accounts;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Lead> getAllLeads(){
        try {
            return [SELECT Name FROM Lead];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Opportunity> getAllOpportunities(){
        try {
            return [SELECT Name FROM Opportunity];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}