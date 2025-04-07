public with sharing class DailyLeadProcessor implements Schedulable{


    public void execute(SchedulableContext sc){
        List<Lead> leads = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = null];
        for(Lead lead : leads){
            lead.LeadSource = 'Dreamforce';
        }

        update leads;

    }

}