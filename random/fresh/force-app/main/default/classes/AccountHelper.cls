public with sharing class AccountHelper {
    public AccountHelper() {

    }

    @AuraEnabled (cacheable=true)
    public static List<Account> getAccounts(){
        try {
            return [SELECT Id, AnnualRevenue, Name FROM Account LIMIT 20];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteAccount(String id){
        try {
            Account acc = [SELECT Id FROM Account WHERE Id = :id];
            delete acc;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveAccount(String id){
        try {
            Account acc = new Account(Id = id);
            insert acc;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}