public with sharing class DataLord {
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

}