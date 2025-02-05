public with sharing class CaseHelper {
    public CaseHelper() {

    }

    @AuraEnabled (cacheable = true)
    public static List<Case> getOpenCases(){
        try {
            return [SELECT Subject, CaseNumber, Id, Status FROM Case WHERE Status != 'Closed'];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}