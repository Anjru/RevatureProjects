
import getPropertyImages from '@salesforce/apex/projectTwoHelper.getPropertyImages';
import PROPERTY_OBJECT from "@salesforce/schema/Property__c"
import { getListRecordsByName } from "lightning/uiListsApi";

import { api, LightningElement,track,wire } from 'lwc';

export default class SearchListings extends LightningElement {
    // properties;
    error;
    query;

    searchInput = '';

    /////
    
    @track listings;
    // Enriched listings with an extra field (ImageURL) from the property images.
    @track enrichedListings;
    // Mapping from property Id to its image URL.
    @track propertyImageMap = {};    

    ///////////////////////

    @api property = '';
    propertyUrl = '';

    passPropertyUrl(event) {
        // Prevent default navigation so we can update the URL and then navigate
        event.preventDefault();
        
        // Retrieve the property ID from the data attribute
        const propId = event.currentTarget.dataset.id;
        this.propertyUrl = `/properties?c__propertyId=${propId}`;
        
        // Optionally, perform any custom logic before redirecting
        console.log('Navigating to:', this.propertyUrl);
        
        // Now navigate manually
        window.location.href = this.propertyUrl;
    }

    /////////////////////////////////////

    //Grabs Records by Name 
    @wire(getListRecordsByName, {
        objectApiName: PROPERTY_OBJECT.objectApiName,
        listViewApiName: "All", 
        fields: ["Property__c.Name", "Property__c.Address__c", "Property__c.DaysAYear__c"],
        searchTerm: "$query",
        sortBy: ['-Property__c.DaysAYear__c'],
        where: ""
    })
    wiredProperties({ data, error }) {
        if (data) {
            // Transform each record to a simplified format:
            this.listings = data.records.map(record => {
                return {
                    Id: record.id, // Uppercase Id for consistency
                    Name: record.fields.Name.value,
                    Address__c: record.fields.Address__c.value,
                    DaysAYear__c: record.fields.DaysAYear__c.value
                };
            });
            console.log('Transformed listings:', this.listings);
            this.enrichListings();
        } else if (error) {
            console.error('Error loading properties:', error);
        }
    }
    
    // Wire adapter for property images.
    // This Apex method returns a list of PropertyImageWrapper objects,
    // each containing (for example) propertyId and versionDataUrl.
    @wire(getPropertyImages, { properties: '$listings' })
    wiredPropertyImages({ error, data }) {
        if (data) {
            // Build a mapping from property Id to its image URL.
            this.propertyImageMap = {};
            data.forEach(wrapper => {
                // If a property has multiple images, here we keep only the first one.
                if (!this.propertyImageMap[wrapper.propertyId]) {
                    this.propertyImageMap[wrapper.propertyId] = wrapper.versionDataUrl;
                }
            });
            // Enrich the listings now that we have the image mapping.
            this.enrichListings();
        } else if (error) {
            console.error('Error retrieving property images:', error);
        }
    }

    // Helper method to combine raw listings with the corresponding image URL.
    enrichListings() {
        if (this.listings) {
            this.enrichedListings = this.listings.map(listing => {
                return {
                    ...listing,
                    ImageURL: this.propertyImageMap[listing.Id] || 'https://via.placeholder.com/150'
                };
            });
            console.log('Enriched Listings:', this.enrichedListings);
        }
    }

    // Updates search field to query
    search(){
        this.query = this.refs.searchInput.value;
    }

}