import { LightningElement,track,wire } from 'lwc';
import { getListRecordsByName } from 'lightning/uiListsApi';
import PROPERTY_OBJECT from '@salesforce/schema/Property__c';
// import Properties from 'c/properties/properties';

export default class AllListings extends LightningElement {
    filterBoolean = false;
    
    @track selectedOption = ''; 
    @track sliderValue;

    @track bedroom;
    @track locationState;
    @track other;

    @track selectedPropertyType = '';
    @track sort = "-Property__c.Price__c";

    otherOptions = [
        { label: 'Pool', value: 'Pool' },
        { label: 'Pet-Friendly', value: 'Pet-Friendly' },
        { label: 'Garage', value: 'Garage' }
    ];

    sortOptions = [
        {label: 'Price(high-low)', value: "-Property__c.Price__c"},
        {label: 'Price(low-high)', value: "Property__c.Price__c"},
        {label: 'Date Listed(high-low)', value: "-Property__c.DateListed__c"},
        {label: 'Date Listed(high-low)', value: "Property__c.DateListed__c"}
    ]

    propertyTypeOptions = [
        { label: 'Any', value: '' },
        { label: 'Apartment', value: 'Apartment' },
        { label: 'House', value: 'House' },
        { label: 'Condo', value: 'Condo' }
    ];

    bedroomOptions = [
        { label: 'Any', value: '' },
        { label: '1', value: '1' },
        { label: '2', value: '2' },
        { label: '3', value: '3' },
        { label: '4', value: '4' },
        { label: '5', value: '5' },
        { label: '6', value: '6' }
    ];

    

    // Toggle filter pane
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

    //Update location filter
    handleLocationStateChange(event) {
        this.locationState = event.detail.value;
    }

    //Updates filter for other options (More trivial)
    handleOtherChange(event) {
        this.other = event.detail.value;
    }

    handleSortChange(event){
        this.sort = event.detail.value;
    }

    //Filters results based on filters applied 
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
        let filterStr = `{and: [${parts.map(p => `{${p}}`).join(", ")}]}`;
        console.log("Computed filter string:", filterStr);
        return filterStr;
    }
    

    ////////////////////////////////////////

    error;
    query;

    @wire(getListRecordsByName, {
        objectApiName: PROPERTY_OBJECT.objectApiName,
        listViewApiName: "All", 
        fields: ["Property__c.Name", "Property__c.Address__c" , "Property__c.DaysAYear__c",
            "Property__c.Price__c" , "Property__c.Type__c", "Property__c.Location__c", "Property__c.Other__c",
            "Property__c.Bedrooms__c", "Property__c.Bathrooms__c", "Property__c.State__c",
            "Property__c.DateListed__c"
        ],
        searchTerm: "$query",
        sortBy:"$sortArray",
        where: "$filter"
    }) properties;


    get sortArray() {
        return [this.sort];
    }

    get propertyList(){
        return this.properties.data.records;
    }

    
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