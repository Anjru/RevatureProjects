public with sharing class LeadProcessor implements Database.Batchable<SObject>{
    // public LeadProcessor() {

    // }

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id FROM Lead');
    }

    public void execute(Database.BatchableContext bc, List<Lead> leads){
        for(Lead l : leads){
            l.LeadSource = 'Dreamforce';
        }
        Database.update(leads);
    }

    public void finish(Database.BatchableContext bc){

    }
}