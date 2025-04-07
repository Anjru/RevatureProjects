trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    switch on Trigger.operationType {
        when AFTER_INSERT{
            ClosedOpportunityTriggerHelper.createFollowUpTaskForClosedWonOpportunities(Trigger.new);

        }
        when AFTER_UPDATE{
            ClosedOpportunityTriggerHelper.createFollowUpTaskForClosedWonOpportunities(Trigger.new);
        }
    }
}