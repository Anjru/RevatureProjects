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

    //Search
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
    public static List<PropertyImageWrapper> getPropertyImages(List<Property__c> properties) {

        //Retrieve ids of properties
        List<Id> propertyIds = new List<Id>();
        for(Property__c p : properties) {
            propertyIds.add(p.Id);
        }
        
        // Query ContentDocumentLink to find file links for the given properties.
        List<ContentDocumentLink> links = [
            SELECT LinkedEntityId, ContentDocument.LatestPublishedVersionId
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :propertyIds
        ];
        
        // Build a mapping using the LinkedEntityId
        Map<Id, Id> propertyToVersionId = new Map<Id, Id>();
        for(ContentDocumentLink link : links) {
            propertyToVersionId.put(link.LinkedEntityId, link.ContentDocument.LatestPublishedVersionId);
        }
        
        // Query ContentVersion records based on the collected version IDs.
        List<ContentVersion> cvs = [
            SELECT Id, Title, VersionDataUrl, FileType
            FROM ContentVersion
            WHERE Id IN :propertyToVersionId.values()
        ];
        
        // Build a wrapper list that associates a property with its image.
        List<PropertyImageWrapper> wrappers = new List<PropertyImageWrapper>();
            for(ContentVersion cv : cvs) {
                // Now find the property Id that corresponds to this versionId.
                for(Id propertyId : propertyToVersionId.keySet()) {
                    if(propertyToVersionId.get(propertyId) == cv.Id) {
                        wrappers.add(new PropertyImageWrapper(propertyId, cv.VersionDataUrl, cv.Title, cv.FileType));
                        break;
                    }
                }
            }
        return wrappers;
    }

    @AuraEnabled
    public static void addFavorite(String propertyId){
        Id currentUserId = UserInfo.getUserId();
        FavoriteJunc__c fv = new FavoriteJunc__c(Property__c = propertyId, User__c = currentUserId);
        insert fv;
    }

    @AuraEnabled (cacheable=true)
    public static List<Property__c> getFavorite(){
        Id currentUserId = UserInfo.getUserId();
        Set<Id> propertyIds = new Set<Id>();
        List<FavoriteJunc__c> favoriteJunc = [SELECT Property__c FROM FavoriteJunc__c WHERE User__c = :currentUserId];
        for(FavoriteJunc__c fj : favoriteJunc){
            propertyIds.add(fj.Property__c);
        }
        List<Property__c> properties = [SELECT Name, Price__c, Description__c, Location__c FROM Property__c WHERE Id IN :propertyIds];
        return properties;
    }

    @AuraEnabled
    public static void removeFavorite(String propertyId){
        Id currentUserId = UserInfo.getUserId();
        FavoriteJunc__c fv = [SELECT Id FROM FavoriteJunc__c WHERE Property__c = :propertyId];
        System.debug('Removing favorite: ' + fv);
        delete fv;
    }

    //Created a wrapper class to be able to store property ID 
    public class PropertyImageWrapper {
        @AuraEnabled public Id propertyId;
        @AuraEnabled public String versionDataUrl;
        @AuraEnabled public String title;
        @AuraEnabled public String fileType;
        
        public PropertyImageWrapper(Id propertyId, String versionDataUrl, String title, String fileType) {
            this.propertyId = propertyId;
            this.versionDataUrl = versionDataUrl;
            this.title = title;
            this.fileType = fileType;
        }
    }

}