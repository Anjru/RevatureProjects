trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            
        }
        when BEFORE_UPDATE {

        }
        when BEFORE_DELETE {
            
        }
        when AFTER_INSERT {

        }
        when AFTER_UPDATE{

        }
    }
}
