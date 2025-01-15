public with sharing class ContactHelper {
    public ContactHelper() {

    }
    
    public static void sendMessage() {
        System.debug('Hello World');
    }

    public static void matchingEmailInsert(List<Contact> contacts){
        
        Set<Id> accountIds = new Set<Id>();
        for(Contact contact : contacts){
            accountIds.add(contact.AccountId);
        }
        List<Contact> otherContacts = [SELECT email, AccountId FROM Contact WHERE AccountId IN :accountIds];
        for(Integer i = 0; i < otherContacts.size(); i++){
            for(Integer j = 0; j < contacts.size(); j++){
                if(otherContacts.get(i).AccountId == contacts.get(j).AccountId){
                    //get domain of contact
                    List<String> emailsplit = contacts.get(j).Email.split('@');
                    String domain = emailsplit[1];
                    if(!otherContacts.get(j).Email.contains(domain)){
                        contacts.get(j).addError('You cannot add contact, wrong domain');
                    }
                }
            }
        }
    }

    public static void defaultEmail(List<Contact> contacts){
        for(Integer i = 0; i < contacts.size(); i++){
        if(String.isBlank(contacts.get(i).Email)){
            contacts.get(i).Email = 'defaultemail@gmail.com'; 
        }
        }
    } 

    public static void updateAccountPhone(List<Contact> contacts){
        Set<Id> accountIds = new Set<Id>();
        for(Contact contact : contacts){
            if(contact.AccountId != null){
                accountIds.add(contact.AccountId);
            }
        }
        List<Account> accounts = [SELECT Email FROM Account WHERE ID IN :accountIds];

        for(Account account : accounts){
            for(Contact contact : contacts){
                if(contact.AccountId == account.Id){
                    account.Email = contact.Email;
                }
            }
        }
        Database.update(accounts);
    }

}