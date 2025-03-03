import { LightningElement,api,wire,track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getProperty from '@salesforce/apex/projectTwoHelper.getProperty';
import getRecordAttachments from '@salesforce/apex/projectTwoHelper.getRecordAttachments';
import MULTIPICKLIST_FIELD from '@salesforce/schema/Property__c.Other__c';
import { getRecord } from 'lightning/uiRecordApi';
import getPropertyImages from '@salesforce/apex/projectTwoHelper.getPropertyImages';
import getRelatedProperties from '@salesforce/apex/projectTwoHelper.getRelatedProperties';

export default class Properties extends LightningElement {
    
    propertyId;
    wiredProperty;

    address;
    bathrooms;
    bedrooms;
    description;
    daysAYear;
    @api location;
    latitude;
    longitude;

    name;
    price;
    squareFootage;
    state;
    type;

    toggle = false;

    @track attachments = [];
    wiredCarousel;

    @track mapMarkers = [];
    @track mapCenter = {};

    //////////////////////////

    @track picklistValues = [];

    @track relatedProperties = [];

    /////////////////////////
    // Returns lists of option fields (pool)
    @wire(getRecord, { recordId: '$recordId', fields: [MULTIPICKLIST_FIELD] })
    wiredRecord({ error, data }) {
        if (data) {
            // Get the picklist field value
            let picklistString = data.fields.Other__c.value;
            if (picklistString) {
                // Split into an array
                this.picklistValues = picklistString.split(';');
            }
        } else if (error) {
            console.error(error);
        }
    }

    //////////////////////////////
    
    // @wire(getRecordAttachments, {recordId : '$propertyId'})
    // wiredAttacchments(result){
    //     this.wiredCarousel = result;
    //     if(result.data){
    //         this.attachments = result.data.map(file => ({
    //             title: file.Title,
    //             fileType: file.FileType,
    //             url: file.VersionDataUrl
    //         }));
    //     } else if(result.error){

    //     }
    // }

    async fetchAttachments() {
        if (!this.propertyId) {
            console.warn("No propertyId available to fetch attachments.");
            return;
        }
        try {
            console.log("Fetching attachments for propertyId:", this.propertyId);
            const result = await getRecordAttachments({ recordId: this.propertyId });
            if (result && result.length > 0) {
                this.attachments = result.map(file => ({
                    title: file.Title,
                    fileType: file.FileType,
                    url: file.VersionDataUrl
                }));
                console.log("Attachments fetched:", this.attachments);
            } else {
                console.warn("No attachments found for propertyId:", this.propertyId);
            }
        } catch (error) {
            console.error("Error fetching attachments:", error);
        }
    }
    
    ////////////////////////////////////

    ////////////////c/aboutUs

    connectedCallback() {
        this.setMapMarkers();
    }

    // This method creates a single marker from the location data
    setMapMarkers() {
        if (this.location && this.latitude && this.longitude) {
            // Set the center of the map to the property's location
            this.mapCenter = {
                Latitude: this.latitude,
                Longitude: this.longitude
            };

            // Create a single marker for the property location
            this.mapMarkers = [{
                location: {
                    Latitude: this.latitude,
                    Longitude: this.longitude
                },
                title: 'Property Location',
                description: 'This is the property location.'
            }];
        }
    }

    //////////////////////////////

    @wire(CurrentPageReference)
    getStateParameters(pageRef) {
        if (pageRef && pageRef.state) {
            // Retrieve the property id from the URL state
            this.propertyId = pageRef.state.c__propertyId;
            console.log('Retrieved Property ID from URL:', this.propertyId);
            this.fetchAttachments();
        }
    }

    @wire(getProperty, {propertyId:'$propertyId'})
    wiredProperty(results){
        this.wiredProperty = results;
        if(results.data){
            const data = results.data;
            this.address = data.Address__c;
            this.bathrooms = data.Bathrooms__c;
            this.bedrooms = data.Bedrooms__c;
            this.description = data.Description__c;
            this.daysAYear = data.DaysAYear__c;
            this.location = data.Location__c;
                this.latitude = this.location.latitude;
                this.longitude = this.location.longitude;
            this.name = data.Name;
            this.price = data.Price__c;
            this.squareFootage = data.SquareFootage__c;
            this.state = data.State__c;
            this.type = data.Type__c;
            this.setMapMarkers();
            this.getRelated();
        } else if (results.error){

        }
    }

    //////////////////////////////////////////

    // Raw featured Property__c records.
    @track listings;
    // Enriched listings with an extra field (ImageURL) from the property images.
    @track enrichedListings;
    // Mapping from property Id to its image URL.
    @track propertyImageMap = {};

    // Helper method to combine raw listings with the corresponding image URL.
    enrichListings() {
        // Only update enrichedListings if we have both listings and a non-empty image mapping.
        if (this.listings && Object.keys(this.propertyImageMap).length > 0) {
            this.enrichedListings = this.listings.map(listing => {
                return {
                    ...listing,
                    ImageURL: this.propertyImageMap[listing.Id]
                };
            });
        }
    }

    async getRelated(){
        try {
            console.log("PropertyId: " + this.propertyId);
            const relatedProperties = await getRelatedProperties({ propertyId: this.propertyId });
            
            if (!relatedProperties || relatedProperties.length === 0) {
                console.warn("No related properties found.");
                return;
            }
    
            this.listings = relatedProperties;
            console.log("Related Properties Retrieved:", this.listings);
        
            // Trigger getPropertyImages after listings are populated
            this.refreshPropertyImages();
        } catch (error) {
            console.error("Error fetching related properties:", error);
        }
    }
    
    // Manually refresh property images after related properties are set
    refreshPropertyImages() {
        if (this.listings && this.listings.length > 0) {
            getPropertyImages({ properties: this.listings })
                .then(data => {
                    console.log("Property Images Retrieved:", data);
    
                    this.propertyImageMap = {};
                    data.forEach(wrapper => {
                        if (!this.propertyImageMap[wrapper.propertyId]) {
                            this.propertyImageMap[wrapper.propertyId] = wrapper.versionDataUrl;
                        }
                    });
    
                    this.enrichListings();
                })
                .catch(error => {
                    console.error("Error fetching property images:", error);
                });
        } else {
            console.warn("Skipping image fetch - no listings available.");
        }
    }

    toggleContact(){
        if(this.toggle){
            this.toggle = false;
        } else {
            this.toggle = true;
        }
    }

}