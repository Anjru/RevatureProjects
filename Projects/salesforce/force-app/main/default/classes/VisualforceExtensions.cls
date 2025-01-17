public with sharing class VisualforceExtensions {
    // ApexPages.StandardSetController sd;
    public List<Account> accounts {get; set;}
    // public Boolean showGreeting {get; set;}
    public String userInput {get; set;}
    public String userInput2 {get; set;}
    // public List<Account> accountInput{get; set;}
    public List<Contact> contacts {get; set;}
    public List<Contact> contactsFilter {get; set;}
    public String contactListString{get; set;}
    public String accountContactListString{get; set;}
    public String contactFilterString{get; set;}
    public String accountContactFilterString{get; set;}
    public List<String> stringcontactList = new List<String>();
    public Map<Id, List<Contact>> mapAccCon {get; set;}

    public VisualforceExtensions() {

    }

    public VisualforceExtensions(ApexPages.StandardSetController controller) {
        //For challenge 2
        //  sd = controller;
        //  sd.setPageSize(10);

        /////////////////////////////////////////////

        // Extract Account IDs from the list
        //For Challenge 6
        // Set<Id> accountIds = new Set<Id>();
        // for (Account acc : (List<Account>)controller.getRecords()) {
        //     accountIds.add(acc.Id);
        // }
        // Query the accounts using the extracted IDs
        // this.accounts = [SELECT Id, Name FROM Account WHERE Id IN :accountIds];
        // this.showGreeting = false;

        /////////////////////////////////////////////

        //For challenge 7
        // userInput = '';  

        /////////////////////////////////////////////

        //Challenge 8
        // sd = controller;
        // sd.setPageSize(10);
        // Set<Id> accountIds = new Set<Id>();
        // for (Account acc : (List<Account>)controller.getRecords()) {
        //     accountIds.add(acc.Id);
        // }
        // this.contacts = [SELECT Name FROM Contact WHERE AccountId IN :accountIds];
        // this.contactListString = '';
        // displayRelatedContacts();

        //Challenge 9 / 11

        //stringcontactList.clear();
        
        // Set<Id> accountIds = new Set<Id>();
        // accounts = [SELECT Id, Name FROM Account];
        // contactListString = '';

        // for(Account account : accounts) {
        //     accountIds.add(account.Id);
        // }
        // contacts = [SELECT Id, Name, AccountId FROM Contact WHERE AccountId IN :accountIds];
        // for(Account account : accounts){
        //     //Add contacts
        //     List<Contact> contactList = new List<Contact>();
        //     accountContactListString+='Account: ' + account.name + '\nRelated Contacts: ';
        //     for(Contact contact : contacts){
        //         if(contact.AccountId == account.Id){
        //             contactList.add(contact);
        //             //stringcontactList.add(contact.Name+', ');
                    
        //             accountContactListString+=contact.Name + ', ';
        //         }
        //     }
        //     mapAccCon.put(account, contactList);

        //     accountContactListString += ' \n';
        // }

        //Challenge 10
        userInput2 = '';
        accountContactFilterString = '';

        //Challenge 11
        userInput = '';
        accountContactListString = '';

        //Challenge 13
        mapAccCon = new Map<Id, List<Contact>>();
        
        Set<Id> accountIds = new Set<Id>();
        accounts = [SELECT Id, Name FROM Account];

        for(Account account : accounts) {
            accountIds.add(account.Id);
        }
        contacts = [SELECT Id, Name, AccountId, LastName, Email, Phone FROM Contact WHERE AccountId IN :accountIds];
        for(Account account : accounts){
            //Add contacts
            List<Contact> contactList = new List<Contact>();
            for(Contact contact : contacts){
                if(contact.AccountId == account.Id){
                    contactList.add(contact);
                }
            }
            mapAccCon.put(account.Id, contactList);
        }
        


    }

    // public void greet(){
    //     showGreeting = true;
    // }

    // public void displayAccount(){
    //     accountInput = [SELECT Name FROM Account Where Name = :userInput];
    //     showGreeting = true;
    // }

    public void displayRelatedContacts(){
        for(Contact contact : contacts){
            contactListString += contact.Name + ', ';
        }
    }

    //Challenge 9-12
    // public void filterAccount(){
    //     String searchString = '%';
    //     searchString+=userInput;
    //     searchString+='%';

    //     accountContactListString = '';

    //     Set<Id> accountIds = new Set<Id>();
    //     accounts = [SELECT Id, Name FROM Account WHERE Name LIKE :searchString];
    //     for(Account account : accounts) {
    //         mapAccCon.put(account, );
    //         accountIds.add(account.Id);
    //     }
    //     contacts = [SELECT Id, Name, AccountId FROM Contact WHERE AccountId IN :accountIds];
    //     for(Account account : accounts){
    //         accountContactListString+='Account: ' + account.name + '\nRelated Contacts: ';
    //         for(Contact contact : contacts){
    //             if(contact.AccountId == account.Id){
    //                 accountContactListString+=contact.Name + ', ';
    //             }
    //         }
    //         accountContactListString += ' \n';
    //     }
    // }

    //Challenge 13
    public void filterAccount(){
        //Used to query String with LIKE clause
        //Append user input between it
        String searchString = '%';
        searchString+=userInput;
        searchString+='%';

        //Clear map each time updated
        mapAccCon.clear();

        //Store Account Ids, used to query for contacts
        Set<Id> accountIds = new Set<Id>();
        accounts = [SELECT Id, Name FROM Account WHERE Name LIKE :searchString];
        for(Account account : accounts) {
            accountIds.add(account.Id);
        }
        //Query Contacts
        contacts = [SELECT Id, Name, AccountId, LastName, Email, Phone FROM Contact WHERE AccountId IN :accountIds];
        
        //Will add Accounts and corresponding contacts to map
        for(Account account : accounts){
            List<Contact> contactList = new List<Contact>();
            for(Contact contact : contacts){
                if(contact.AccountId == account.Id){
                    contactList.add(contact);
                }
            }
            mapAccCon.put(account.Id, contactList);
        }
    }

    //Challenge 10 
    public void filterAccount2(){
        accountContactFilterString = '';
        String searchString = '%';
        searchString+=userInput2;
        searchString+='%';
        List<Account> accountFiltered = [SELECT Id, Name FROM Account WHERE Name LIKE :searchString];
        
        Set<Id> accountIds = new Set<Id>();
        accountContactListString = '';

        for(Account account : accountFiltered) {
            accountIds.add(account.Id);
        }
        contactsFilter = [SELECT Id, Name, AccountId, LastName, Email, Phone FROM Contact WHERE AccountId IN :accountIds];
        for(Account account : accountFiltered){
            accountContactFilterString+='Account: ' + account.name + '\nRelated Contacts: ';
            for(Contact contact : contactsFilter){
                if(contact.AccountId == account.Id){
                    accountContactFilterString+=contact.Name + ', ';
                }
            }
            accountContactFilterString += ' \n';
        }
    }

    public void quicksave() {
        // Collect updated Accounts
        List<Account> updatedAccounts = new List<Account>();
        for (Id accountId : mapAccCon.keySet()) {
            // Retrieve the Account using the accountId
            Account acc = [SELECT Id, Name FROM Account WHERE Id = :accountId LIMIT 1];
            updatedAccounts.add(acc);
        }
    
        // Collect updated Contacts
        List<Contact> updatedContacts = new List<Contact>();
        for (List<Contact> contactList : mapAccCon.values()) {
            updatedContacts.addAll(contactList);
        }
    
        // Perform updates
        if (!updatedAccounts.isEmpty()) {
            database.update(updatedAccounts);
        }
        if (!updatedContacts.isEmpty()) {
            database.update(updatedContacts);
        }
    }   

    //Return a list of Accounts from the map
    public List<Account> getKeys() {
        // Query Account records for the Ids in mapAccCon
        return [SELECT Id, Name FROM Account WHERE Id IN :mapAccCon.keySet()];
    }
    
}