public with sharing class ClosedOpportunityTriggerHelper {
    public ClosedOpportunityTriggerHelper() {

    }

    public static void createFollowUpTaskForClosedWonOpportunities(List<Opportunity> opportunities){
        List<Task> tasks = new List<Task>();
        for(Opportunity opp : opportunities){
            if(opp.StageName == 'Closed Won'){
                Task t = new Task(Subject = 'Follow Up Test Task', WhatId = opp.Id);
                tasks.add(t);
            }
        }
        insert tasks;
    }
}