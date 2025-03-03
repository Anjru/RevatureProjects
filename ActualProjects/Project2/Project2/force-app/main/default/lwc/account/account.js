import { LightningElement,wire,track } from 'lwc';
import getFavorite from '@salesforce/apex/projectTwoHelper.getFavorite';
import getPropertyImages from '@salesforce/apex/projectTwoHelper.getPropertyImages';
import removeFavorite from '@salesforce/apex/projectTwoHelper.removeFavorite';
import { refreshApex } from '@salesforce/apex';
import NAME_FIELD from '@salesforce/schema/User.Name';
import EMAIL_FIELD from '@salesforce/schema/User.Email';
import PROFILE_PIC_FIELD from '@salesforce/schema/User.ProfilePictureURL__c';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import ID_FIELD from '@salesforce/schema/User.Id';


export default class Accounts extends LightningElement {


    @track listings;
    // Enriched listings with an extra field (ImageURL) from the property images.
    @track enrichedListings;
    // Mapping from property Id to its image URL.
    @track propertyImageMap = {}; 
    
    @track wiredProperty;

    userId = USER_ID;
    name = NAME_FIELD;
    email = EMAIL_FIELD;

    userName;
    userEmail;
    userPicture;

    singleImage = false;

    //////////////////////

    @track userImageUrl;

    @wire(getRecord, { recordId: USER_ID, fields: [NAME_FIELD, EMAIL_FIELD,PROFILE_PIC_FIELD] })
    wiredUser({ error, data }) {
        if (data) {
            this.userName = data.fields.Name.value;
            this.userEmail = data.fields.Email.value;
            this.userPicture = data.fields.ProfilePictureURL__c.value;
        } else if (error) {
            console.error('Error retrieving user data:', error);
        }
    }

    

    @wire(getFavorite)
wiredProperties(result) {
    this.wiredProperty = result;
    if (result.data) {
        this.listings = result.data.map(record => {
            return {
                Id: record.Id, // Use uppercase Id as returned
                Name: record.Name,
                Address__c: record.Address__c,
                Price__c: record.Price__c,
                DateListed__c: record.DateListed__c,
                DaysAYear__c: record.DaysAYear__c
            };
        });
        this.enrichListings();
    } else if (result.error) {
        console.error('Error retrieving featured listings:', result.error);
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
        
        async delFavorite(event){
            const propId = event.currentTarget.dataset.id;
            try{
            await removeFavorite({propertyId: propId});
            await refreshApex(this.wiredProperty);
            } catch (error){
                console.error("Error removing favorite: ", error);
            }
        }

        // Fetch existing profile image
    // @wire(getRecord, { recordId: USER_ID, fields: [PROFILE_PIC_FIELD] })
    // wiredPicture({ error, data }) {
    //     if (data) {
    //         this.userImageUrl = data.fields.ProfilePictureURL__c.value;
    //     } else if (error) {
    //         console.error('Error retrieving profile image:', error);
    //     }
    // }

    // // Handle File Upload
    // handleUploadFinished(event) {
    //     const uploadedFiles = event.detail.files;
    //     if (uploadedFiles.length > 0) {
    //         const contentDocId = uploadedFiles[0].documentId;

    //         // Construct File URL (Assuming it's stored in Salesforce)
    //         const fileUrl = `/sfc/servlet.shepherd/version/download/${contentDocId}`;

    //         // Update User Record
    //         const fields = {};
    //         fields[ID_FIELD.fieldApiName] = USER_ID;
    //         fields[PROFILE_PIC_FIELD.fieldApiName] = fileUrl;

    //         const recordInput = { fields };

    //         updateRecord(recordInput)
    //             .then(() => {
    //                 this.userImageUrl = fileUrl; // Update UI
    //                 this.showToast('Success', 'Profile image updated!', 'success');
    //             })
    //             .catch(error => {
    //                 console.error('Error updating profile image:', error);
    //                 this.showToast('Error', 'Failed to update profile image', 'error');
    //             });
    //     }
    // }

    /////////////////////////

}