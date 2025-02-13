import { LightningElement, track, wire,api } from 'lwc';
import getFeaturedListings from '@salesforce/apex/projectTwoHelper.getFeaturedListings';
import getPropertyImages from '@salesforce/apex/projectTwoHelper.getPropertyImages';

export default class FeaturedListings extends LightningElement {
    // Raw featured Property__c records.
    @track listings;
    // Enriched listings with an extra field (ImageURL) from the property images.
    @track enrichedListings;
    // Mapping from property Id to its image URL.
    @track propertyImageMap = {};

    ////////
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

        ///////////

    // Wire adapter for featured listings.
    @wire(getFeaturedListings)
    wiredFeaturedListings({ error, data }) {
        if (data) {
            this.listings = data;
            // Process listings to enrich them with images if available.
            this.enrichListings();
        } else if (error) {
            console.error('Error retrieving featured listings:', error);
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
}
