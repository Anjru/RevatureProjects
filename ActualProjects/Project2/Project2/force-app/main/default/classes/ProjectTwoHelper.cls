/**
 * Created By: Andrew Yang
 * Date: 1/31/2025
 * Class:ProjectTwoHelper
 */
//This class will assist components to interact with Salesforce
public with sharing class ProjectTwoHelper {
    public projectTwoHelper() {

    }

    //Will retrieve featured lists sorted by Number of days it has been rented that year
        //Shows popularity
    @AuraEnabled(cacheable = true)
    public static List<Property__c> getFeaturedListings(){
        try {
            // Database.query(queryString);
            List<Property__c> featuredListings = [SELECT Name, DaysAYear__c FROM Property__c ORDER BY DaysAYear__c DESC LIMIT 10];
            return featuredListings;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled (cacheable = true)
    public static List<Property__c> searchProperty(String propertyAddress){
        try {
            // Database.query(queryString);
            return [SELECT Name, Address__c, Image__c FROM Property__c];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}