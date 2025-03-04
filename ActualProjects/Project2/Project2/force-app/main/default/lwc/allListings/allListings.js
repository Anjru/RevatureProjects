import { LightningElement,track,wire,api } from 'lwc';
import { getListRecordsByName } from 'lightning/uiListsApi';
import PROPERTY_OBJECT from '@salesforce/schema/Property__c';
import getPropertyImages from '@salesforce/apex/ProjectTwoHelper.getPropertyImages';
import addFavorite from '@salesforce/apex/ProjectTwoHelper.addFavorite';
import isGuest from '@salesforce/user/isGuest';

// import Properties from 'c/properties/properties';
export default class AllListings extends LightningElement {
    //Is toggled and dtermines if filter pane shows
    filterBoolean = false;
    
    //Tracks if User is guest or not
    //Will dynamically render entities
    isNotGuest = !isGuest;

    //Tracks errors returned from uiListsApi
    error;
    
    //These values hold the selected options
    selectedOption = ''; 
    sliderValue;
    bedroom;
    bathroom;
    locationState;
    other;

    selectedPropertyType = '';
    sort = "-Property__c.Price__c";

    @api property = '';
    propertyUrl = '';
        
    //Handles passing in record Id paramters to Property Page
    //Currently not being used...
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

    // Stores property list returned from getListRecordsByName
    @track listings;
    // Enriched listings with an extra field (ImageURL) from the property images.
    @track enrichedListings;
    // Mapping from property Id to its image URL.
    @track propertyImageMap = {}; 

    // Will hold more trivial options to filter by
    otherOptions = [
        { label: 'Pool', value: 'Pool' },
        { label: 'Pet-Friendly', value: 'Pet-Friendly' },
        { label: 'Garage', value: 'Garage' }
    ];

    // Will hold sorting options
    sortOptions = [
        {label: 'Price(high-low)', value: "-Property__c.Price__c"},
        {label: 'Price(low-high)', value: "Property__c.Price__c"},
        {label: 'Date Listed(high-low)', value: "-Property__c.DateListed__c"},
        {label: 'Date Listed(low-high)', value: "Property__c.DateListed__c"}
    ]

    // Will hold optoins of Property types
    propertyTypeOptions = [
        { label: 'Any', value: '' },
        { label: 'Apartment', value: 'Apartment' },
        { label: 'House', value: 'House' },
        { label: 'Condo', value: 'Condo' }
    ];

    // Will hold options displaying the num of Bedrooms
    bedroomOptions = [
        { label: 'Any', value: '' },
        { label: '1', value: '1' },
        { label: '2', value: '2' },
        { label: '3', value: '3' },
        { label: '4', value: '4' },
        { label: '5', value: '5' },
        { label: '6', value: '6' }
    ];

    // Will hold options displaying num of bathrooms
    bathroomOptions = [
        { label: 'Any', value: '' },
        { label: '1', value: '1' },
        { label: '2', value: '2' },
        { label: '3', value: '3' },
        { label: '4', value: '4' },
        { label: '5', value: '5' },
        { label: '6', value: '6' }
    ];

    // adds a property to favorites
    // addFavorite is called from APEX Class
    async favorite(event){        
        const propId = event.currentTarget.dataset.id;
        await addFavorite({propertyId: propId});
    }

    // Toggle filter pane
    // A boolean handles this
    toggleFilter(){
        if(this.filterBoolean){
            this.filterBoolean = false;
        } else {
            this.filterBoolean = true;
        }
    }    

    //Updates property filter
    handlerPropertyTypeChange(event){
        this.selectedPropertyType = event.detail.value;
    }

    //Updates slider filter
    handleSliderChange(event) {
        this.sliderValue = event.detail.value;
    }

    //Update bedroom filter
    handleBedroomChange(event) {
        this.bedroom = event.detail.value;
    }

    //Update bathroom filter
    handleBathroomChange(event) {
        this.bathroom = event.detail.value;
    }

    //Update location filter
    handleLocationStateChange(event) {
        this.locationState = event.detail.value;
    }

    //Updates filter for other options (More trivial)
    handleOtherChange(event) {
        this.other = event.detail.value;
    }

    //Updates the sort option
    handleSortChange(event){
        this.sort = event.detail.value;
    }

    // Filters results based on filters applied 
    // is returned to getListRecords where claus
    get filter() {
        //Will store filter string for individual options
        let parts = [];
    
        // Price filter (Price__c is numeric)
        if (this.sliderValue) {
            parts.push(`Price__c: {lt: ${Number(this.sliderValue)}}`);
        }
    
        // Bedroom filter (numeric comparison)
        if (this.bedroom) {
            parts.push(`Bedrooms__c: {eq: ${Number(this.bedroom)}}`);
        }

        // Bathroom filter (numeric comparison)
        if (this.bathroom) {
            parts.push(`Bathrooms__c: {eq: ${Number(this.bathroom)}}`);
        }
        // Location filter (text comparison)
        if (this.locationState) {
            parts.push(`State__c: {eq: '${this.locationState}'}`);
        }
    
        // Property type filter (text comparison)
        if (this.selectedPropertyType) {
            parts.push(`Type__c: {eq: '${this.selectedPropertyType}'}`);
        }
    
        // Other filter (multi-select)
        if (this.other && Array.isArray(this.other) && this.other.length > 0) {
            // Use "in" operator for multiple values.
            const values = this.other.map(val => `'${val}'`).join(', ');
            parts.push(`Other__c: {includes: [${values}]}`);

        }
    
        // Build the filter using an "and" operator
        let filterBody = "";
        for (let i = 0; i < parts.length; i++) {
            filterBody += `{${parts[i]}}`;
            if (i < parts.length - 1) {
                filterBody += ", ";
            }
        }
      
        // Appends remaing string together
        let filterStr = `{and: [${filterBody}]}`;
        console.log("Computed filter string:", filterStr);
        return filterStr;
    }

    /*
    * Retrieves list of property records (No Apex)
    * Filters and sort options are applied here
    */
    @wire(getListRecordsByName, {
        objectApiName: PROPERTY_OBJECT.objectApiName,
        listViewApiName: "All", 
        fields: ["Property__c.Name", "Property__c.Address__c" , "Property__c.DaysAYear__c",
            "Property__c.Price__c" ,
            "Property__c.DateListed__c"
        ],
        // searchTerm: "$query",
        sortBy:"$sortArray",
        where: "$filter"
    }) wiredProperties({ data, error }) {
        if (data) {
            // Transform each record to a simplified format:
            this.listings = data.records.map(record => {
                return {
                    Id: record.id, // Uppercase Id for consistency
                    Name: record.fields.Name.value,
                    Address__c: record.fields.Address__c.value,
                    Price__c: record.fields.Price__c.value,
                    DateListed__c: record.fields.DateListed__c.value,
                    DaysAYear__c: record.fields.DaysAYear__c.value
                };
            });
            console.log('Transformed listings:', this.listings);
            console.log('Listings before sending to getPropertyImages:', JSON.stringify(this.listings));
            this.enrichListings();
        } else if (error) {
            console.error('Error loading properties:', error);
        }
    }

    /*
    * Wire adapter for property images.
    * This Apex method returns a list of PropertyImageWrapper objects,
    * each containing (for example) propertyId and versionDataUrl.
    */
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
            console.log(JSON.stringify(this.enrichedListings));
            console.log('What is wrong?');

        }
    }

    //Retrieves sorted option (Ex. Price high to low)
    get sortArray() {
        return [this.sort];
    }

    //Retrieves Property Lists
    get propertyList(){
        return this.properties.data.records;
    }
    
    // Stores the Location picklist options (States)
    locationStateOptions = [
        { label: 'Any', value: '' },
        { label: 'AL', value: 'AL' },
        { label: 'AK', value: 'AK' },
        { label: 'AZ', value: 'AZ' },
        { label: 'AR', value: 'AR' },
        { label: 'CA', value: 'CA' },
        { label: 'CO', value: 'CO' },
        { label: 'CT', value: 'CT' },
        { label: 'DE', value: 'DE' },
        { label: 'FL', value: 'FL' },
        { label: 'GA', value: 'GA' },
        { label: 'HI', value: 'HI' },
        { label: 'ID', value: 'ID' },
        { label: 'IL', value: 'IL' },
        { label: 'IN', value: 'IN' },
        { label: 'IA', value: 'IA' },
        { label: 'KS', value: 'KS' },
        { label: 'KY', value: 'KY' },
        { label: 'LA', value: 'LA' },
        { label: 'ME', value: 'ME' },
        { label: 'MD', value: 'MD' },
        { label: 'MA', value: 'MA' },
        { label: 'MI', value: 'MI' },
        { label: 'MN', value: 'MN' },
        { label: 'MS', value: 'MS' },
        { label: 'MO', value: 'MO' },
        { label: 'MT', value: 'MT' },
        { label: 'NE', value: 'NE' },
        { label: 'NV', value: 'NV' },
        { label: 'NH', value: 'NH' },
        { label: 'NJ', value: 'NJ' },
        { label: 'NM', value: 'NM' },
        { label: 'NY', value: 'NY' },
        { label: 'NC', value: 'NC' },
        { label: 'ND', value: 'ND' },
        { label: 'OH', value: 'OH' },
        { label: 'OK', value: 'OK' },
        { label: 'OR', value: 'OR' },
        { label: 'PA', value: 'PA' },
        { label: 'RI', value: 'RI' },
        { label: 'SC', value: 'SC' },
        { label: 'SD', value: 'SD' },
        { label: 'TN', value: 'TN' },
        { label: 'TX', value: 'TX' },
        { label: 'UT', value: 'UT' },
        { label: 'VT', value: 'VT' },
        { label: 'VA', value: 'VA' },
        { label: 'WA', value: 'WA' },
        { label: 'WV', value: 'WV' },
        { label: 'WI', value: 'WI' },
        { label: 'WY', value: 'WY' }
    ];
    

}