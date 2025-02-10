import searchProperty from '@salesforce/apex/ProjectTwoHelper.searchProperty';
import getPropertyImageUrl from '@salesforce/apex/ProjectTwoHelper.getPropertyImageUrl';
import getPropertyImages from '@salesforce/apex/ProjectTwoHelper.getPropertyImages';
import PROPERTY_OBJECT from "@salesforce/schema/Property__c"
import NAME from "@salesforce/schema/Property__c.Name"
import { getListRecordsByName } from "lightning/uiListsApi";
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';


import { api, LightningElement,track,wire } from 'lwc';

export default class SearchListings extends LightningElement {
    // properties;
    error;
    query;

    @track
    recordId;

    relatedFiles;

    searchInput = '';

    imageUrl;

    // imageMapping = {};

    @wire(getPropertyImageUrl, { propertyId: 'a00ak00000gCEP3AAO' })
    wiredImage({ error, data }) {
        if (data) {
            this.imageUrl = data;
        } else if (error) {
            console.error('Error retrieving image URL:', error);
        }
    }

    //Grabs Records by Name WORKS
    @wire(getListRecordsByName, {
        objectApiName: PROPERTY_OBJECT.objectApiName,
        listViewApiName: "All", 
        fields: ["Property__c.Name", "Property__c.Address__c" , "Property__c.DaysAYear__c"],
        searchTerm: "$query",
        sortBy:['-Property__c.DaysAYear__c'],
        where: ""
    }) properties;
    
    //Retruns list of Property Works)
    get propertyList(){
        console.log("ImageURL: " + this.imageUrl);
        console.log("RecordID " + this.recordId)
        return this.properties.data.records;
        // return this.properties || [];
    }

    updateRecordId(){
        console.log("updated");
        this.recordId = this.template.querySelector('.img').getAttribute('data-record-id');
    }

    // Updates search field to query
    search(){
        this.query = this.refs.searchInput.value;
        this.updateRecordId();
    }

    //works with wireservice getListRecords name (REPLACE properties)
        // wiredProperties({ error, data }) {
    //     if (data) {
    //         this.properties = data.records;
    //         // Build an array of property Ids
    //         const propertyIds = this.properties.map(record => record.Id);
    //         // Call Apex to get the mapping of propertyId to image URL
    //         getPropertyImages({ propertyIds })
    //             .then(result => {
    //                 this.imageMapping = result;
    //             })
    //             .catch(error => {
    //                 console.error('Error retrieving image mapping:', error);
    //             });
    //     } else if (error) {
    //         console.error('Error fetching properties:', error);
    //     }
    // }

    //TESTING IMages (related Lists)
    // @wire(getRelatedListRecords, {
    //     parentRecordId: '$recordId',
    //     relatedListId: 'ContentDocumentLinks',
    //     fields: ['ContentDocumentLink.ContentDocumentId']
    // })
    // wiredRelatedFiles({ error, data }) {
    //     if (data) {
    //         this.relatedFiles = data.records;
    //     } else if (error) {
    //         // Handle error
    //     }
    // }

    //Testing images
    // @wire(getProductImages, { productId: '$recordId' })
    // wiredImages({ error, data }) {
    //     if (data) {
    //         this.images = data.map(image => ({
    //             ...image,
    //             imageUrl: `/sfc/servlet.shepherd/version/download/${image.Id}`
    //         }));
    //     } else if (error) {
    //         // Handle error
    //     }
    // }
}