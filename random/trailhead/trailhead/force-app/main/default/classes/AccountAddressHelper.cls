public with sharing class AccountAddressHelper {
    public AccountAddressHelper() {

    }

    public static void setPostalCode(List<Account> accounts){
        for(Account acc : accounts){
            if(acc.Match_Billing_Address__c == true){
                acc.ShippingPostalCode = acc.BillingPostalCode;
            }
        }
        // update accounts;
    }

}