trigger MaintenanceRequest on Case (after insert, after update) {
    switch on Trigger.operationType{
        when AFTER_INSERT {
            MaintenanceRequestHelper.upsertRequest(Trigger.new);
        }
        when AFTER_UPDATE {
            MaintenanceRequestHelper.upsertRequest(Trigger.new);
        }
    }
}