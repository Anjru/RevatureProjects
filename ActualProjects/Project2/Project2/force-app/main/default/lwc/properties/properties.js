import { LightningElement,api,wire,track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getProperty from '@salesforce/apex/projectTwoHelper.getProperty';
import MULTIPICKLIST_FIELD from '@salesforce/schema/Property__c.Other__c';
import RECORD_ID from '@salesforce/schema/Property__c.Id';
import { getRecord } from 'lightning/uiRecordApi';

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

    @track mapMarkers = [];
    @track mapCenter = {};

    //////////////////////////

    @track picklistValues = [];

    /////////////////////////

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
        } else if (results.error){

        }
    }

}