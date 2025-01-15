public with sharing class AccountHelper {
    public AccountHelper() {

    }

    public static void preventDeletion(List<Account> accounts) {
        Map<Id, Integer> m1 = new Map<Id, Integer>();
        //Store Account Ids (No duplicates)
        Set<Id> accountIds = new Set<Id>();
        for(Account account : accounts){
            accountIds.add(account.Id);
            m1.put(account.Id, 0);
        }
    
        // Return contacts associated with accounts Ids
        List<Contact> contacts = [SELECT AccountId FROM Contact WHERE AccountId IN :accountIds];
        
        //Store Account Ids with a contact count as value
        //Will check value later to see if account has contact or not
        for(Contact contact : contacts){
            if(m1.get(contact.AccountId) != null){
                m1.put(contact.AccountId, m1.get(contact.AccountId) + 1);
            }
        }
        
        //Check if account has contacts
        //Adds errors if they do 
        for(Account account : accounts) {
            if(m1.get(account.Id) > 0) {
                account.addError('Account cannot be deleted because it has related contacts.');
            }
        }
    }

    public static void createContact(List<Account> accounts){
        Contact contact = new Contact(LastName = accounts[0].Name);
        Database.insert(contact);
    }
    
    
}