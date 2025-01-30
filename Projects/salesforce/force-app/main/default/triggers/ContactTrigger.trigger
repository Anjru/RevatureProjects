trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after undelete) {
    switch on Trigger.operationType{
        when BEFORE_INSERT {
            ContactHelper.defaultEmail(Trigger.new);
        }
        when BEFORE_UPDATE {

        }
        when AFTER_INSERT {

        }
        when AFTER_UPDATE{
            //ContactHelper.updateAccountPhone(Trigger.new);
        }
    }
}