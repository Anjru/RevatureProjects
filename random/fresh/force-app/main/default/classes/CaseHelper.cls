public with sharing class CaseHelper {
    public CaseHelper() {
        // Constructor logic (if any)
    }

    @AuraEnabled
    public static List<Case> getHighPriorityCases() {
        try {
            return [SELECT AccountId, ContactId, Subject FROM Case WHERE Priority = 'High'];
            //  WHERE Priority = 'High' AND IsEscalated = TRUE
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void createCase(String origin, String status) {
        try {
            Case c = new Case(Origin = origin, Status = status);
            insert c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void closeCase(String id){
        try {
            Case c = [SELECT Id,Status FROM Case WHERE Id = :id];
            c.Status = 'Closed';
            update c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
