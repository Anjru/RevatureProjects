trigger ClassDeliveryTrigger on Class_Delivery__c (before insert, before update, before delete, after insert, after update, after undelete) {
    switch on Trigger.operationType{
        when BEFORE_INSERT {
            
        }
        when BEFORE_UPDATE {
            
        }
        when AFTER_INSERT {

        }
        when AFTER_UPDATE{

        }
    }
}