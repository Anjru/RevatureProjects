public with sharing class ClassDeliveryHelper {
    public ClassDeliveryHelper() {

    }

    public static void createDeliveryRecords(){
        
        // Profile p = [SELECT Id FROM Profile WHERE Name='Sales Team Manager'];
        // User u = [SELECT LastName FROM USER WHERE ProfileId =: p.Id];
        // System.runAs(u){

        // 
        //}
        
        Class_Delivery__c cd = new Class_Delivery__c();
        Database.insert(cd); 
        
    }

    public static void deleteDeliveryRecords(Id salesforceId){
        List<Class_Delivery__c> ids = [SELECT Id FROM Class_Delivery__c WHERE Id = :salesforceId];
        if(!ids.isEmpty()){
            Database.delete(ids); 
        }
    }

    public static void changeCourse(Id salesforceId, String fieldUpdate){
        Class_Delivery__c cd = [SELECT Id, Course__c FROM Class_Delivery__c WHERE Id = :salesforceId WITH SECURITY_ENFORCED LIMIT 1];
        // for(Class_Delivery__c course : ids){
        //     
        // }
        cd.Course__c = fieldUpdate;
        Database.update(cd);
    }
    
}