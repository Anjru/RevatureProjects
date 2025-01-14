
public with sharing class DataLord {
    //SOQL
    public dataLord() {

    }

    public static Integer numAccounts() {
        Integer num = [SELECT COUNT() FROM Account];
        return num;
    }

    public static Integer numHot() {
        Integer num = [SELECT COUNT() FROM Account WHERE Account.Rating = 'Hot'];
        return num;
    }

    public static Integer numComplex(){
        Integer num = [SELECT COUNT() FROM Account WHERE Name LIKE '%&%'];
        return num;
    }

    public static List<Account> bigFive(){
        return [SELECT AnnualRevenue, NAME FROM Account ORDER BY AnnualRevenue DESC NULLS LAST LIMIT 5];
    }

    public static Opportunity lastBigOpportunity(){
        return [SELECT CloseDate FROM Opportunity WHERE AMOUNT > 100000 ORDER BY CloseDate DESC LIMIT 1];
    }

    public static List<Contact> majorPlayers(){
        return [SELECT Account.Rating FROM CONTACT WHERE Account.Rating = 'Hot'];
    }

    public static List<AggregateResult> mostPopularAccount(){
        return [SELECT Account.Name, COUNT(Id) 
        FROM Contact 
        GROUP BY Account.Name ORDER BY Count(Id) DESC LIMIT 1];
    }
        

    //////////////////////////////////////////////////////////

    //SOSL
    public static List<List<sObject>> getContactLead(){
        List<List<sObject>> conLead = [FIND 'Tom' RETURNING Contact(Name), Lead(Name)];
        return conLead;
    }  
   
    public static List<List<sObject>> getAccount(){
        List<List<sObject>> accounts = [FIND 'a* and o*' RETURNING Account(Name)];
        return accounts;
    }

    public static List<List<sObject>> getPhone(){
        List<List<sObject>> phone = [FIND '1000' IN PHONE FIELDS RETURNING Account(Name), Contact(Name), Lead(Name)];
        return phone;
    } 

    ////////////////////////////////////////////////////
    //DML
    public static void spawnContacts(){
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < 200; i++){
            String name = 'name'+i;
            Contact a = new Contact(LastName = name);
            contacts.add(a);
        }

        Database.insert(contacts);
        
    }

    public static void createHomes(){
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 3; i++){
            String name = 'name'+i;
            Account a = new Account(Name = name);
            accounts.add(a);
            
        }
        Database.insert(accounts);
    }

    //fix
    public static void relocate(){
        List<Contact> contacts = [SELECT LastName FROM Contact ORDER BY CreatedDate DESC LIMIT 50];
        Database.delete(contacts);
    }

    public static void assignHomes(){
        List<Contact> contacts = [SELECT LastName FROM Contact ORDER BY CreatedDate DESC LIMIT 150];
        List<Account> accounts = [SELECT Name FROM Account ORDER BY CreatedDate DESC LIMIT 3];
        
        for(Integer i = 0; i < contacts.size(); i++){
            Double randomDouble = Math.random();
            Integer randomNumber = (Integer)(randomDouble * 3);
            contacts[i].AccountId = accounts[randomNumber].Id;
            
        }
        Database.update(contacts); 

    }

    public static void play(){
        Savepoint sp1 = Database.setSavepoint();
            try {
                // Initial state
                Integer initialAccounts = numAccounts();
                Integer initialContacts = [SELECT COUNT() FROM Contact];
        
                spawnContacts();  
                createHomes();
                relocate();      
                assignHomes();
        
                // Current state after DML operations
                Integer currentAccounts = numAccounts();
                Integer currentContacts = [SELECT COUNT() FROM Contact];
        
                // Log statistics
                System.debug('DATABASE STATISTICS');
                System.debug('Number of Accounts at Start: ' + initialAccounts);
                System.debug('Number of Contacts at Start: ' + initialContacts);
                System.debug('Number of Accounts Currently: ' + currentAccounts);
                System.debug('Number of Contacts Currently: ' + currentContacts);
                
                // Retrieve and log the number of related contacts for each account
                List<AggregateResult> relatedContacts = [
                    SELECT Account.Name, COUNT(Id) contactsCount 
                    FROM Contact 
                    WHERE AccountId != null 
                    GROUP BY Account.Name
                ];
                
                for (AggregateResult result : relatedContacts) {
                    System.debug('Account: ' + result.get('Name') + ', Number of Related Contacts: ' + result.get('contactsCount'));
                }
        
                // Rollback operations
                Database.rollback(sp1);
                System.debug('Rollback complete.');
        
            } catch (Exception e) {
                // If any error occurs, rollback and report
                Database.rollback(sp1);
                System.debug('Error encountered: ' + e.getMessage());
            }
    }

}