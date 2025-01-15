trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after undelete) {
    switch on Trigger.operationType{
        when BEFORE_INSERT {
            
        }
        when BEFORE_UPDATE {

        }
        when BEFORE_DELETE {
            AccountHelper.preventDeletion(Trigger.new);
        }
        when AFTER_INSERT {
            AccountHelper.createContact(Trigger.new);
        }
        when AFTER_UPDATE{

        }
    }

}