public with sharing class AccountProcessor {
 
    @future
    public static void countContacts(List<Id> ids){
        //Store Count for each contact
        Map<Id, AggregateResult> conCount = new Map<Id,AggregateResult>();

        //Iterate through Ids
        //Add to map
        for(Integer i = 0; i < ids.size(); i++){
            List<AggregateResult> count = [SELECT COUNT(Id) conCount FROM Contact WHERE Contact.Account.Id = :ids[i]];
            conCount.put(ids[i], count[0]);
        }

        //Update Num of Contact for each account
        List<Account> accs = new List<Account>();
        for(Id key : conCount.keySet()) {
            Account acc = [SELECT Number_Of_Contacts__c FROM Account WHERE Id = :key LIMIT 1];
            acc.Number_Of_Contacts__c = (Integer)conCount.get(key).get('conCount');
            accs.add(acc);
        }

        Database.update(accs);
    }
}