trigger AccountAddressTrigger on Account (before insert, before update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT{
            AccountAddressHelper.setPostalCode(Trigger.New);
        }
        when BEFORE_UPDATE {
            AccountAddressHelper.setPostalCode(Trigger.New);
        }
    }
}