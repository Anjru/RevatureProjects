public with sharing class Batch implements Database.Batchable<SObject>{
    public Batch() {

    }

    public Database.QueryLocator start(Database.BatchableContext bc){  
        return Database.getQueryLocator('SELECT Id, Name, Rating FROM Account WHERE Name = \'name2\'');    
        
        // return Database.getQueryLocator('SELECT Id, Name, Rating ' +
        //                       'FROM Account ' +
        //                       'WHERE Rating != \'Hot\' ' +
        //                       'AND Id IN (' +
        //                       '    SELECT AccountId ' +
        //                       '    FROM Opportunity ' +
        //                       '    WHERE (StageName IN (\'Closed-Won\', \'Closed-Lost\')) ' +
        //                       '    AND Name = \'zcv\'' +
        //                       ')');
                            //   LastModified >= LAST_6_MONTHS
    }

    public void execute(Database.BatchableContext bc, List<sObject> scope){
        List<Account> accounts = new List<Account>();
        for(Sobject s : scope){
            accounts.add((Account) s);
        }
        delete accounts;
    }

    public void finish(Database.BatchableContext bc){

    }

}