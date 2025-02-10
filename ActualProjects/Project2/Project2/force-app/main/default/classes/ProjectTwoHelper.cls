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

    @AuraEnabled(cacheable=true)
    public static String getPropertyImageUrl(Id propertyId) {
        // Query for the file attached to the property with Title = '1.jpg'
        ContentDocumentLink link = [
            SELECT ContentDocument.LatestPublishedVersionId, ContentDocument.Title 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :propertyId 
            AND ContentDocument.Title = '1.jpg'
            LIMIT 1
        ];
        // AND ContentDocument.Title = '1.jpg'
        if(link != null && link.ContentDocument != null) {
            System.debug('File found for propertyId: ' + propertyId);
            // Construct the URL for the image
            return '/sfc/servlet.shepherd/version/download/' + link.ContentDocument.LatestPublishedVersionId;
        }
        System.debug('No file found for propertyId: ' + propertyId);
        return null;
    }

    @AuraEnabled(cacheable=true)
    public static Map<Id, String> getPropertyImages(List<Id> propertyIds) {
        Map<Id, String> imageUrls = new Map<Id, String>();
        // Query all ContentDocumentLinks for the given properties (filtering by file name if needed)
        for(ContentDocumentLink link : [
            SELECT LinkedEntityId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :propertyIds 
              AND ContentDocument.Title = '1.jpg'  // For testing a specific image
        ]){
            imageUrls.put(link.LinkedEntityId, '/sfc/servlet.shepherd/version/download/' 
                + link.ContentDocument.LatestPublishedVersionId);
        }
        return imageUrls;
    }
    

}