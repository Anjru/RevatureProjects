import searchProperty from '@salesforce/apex/ProjectTwoHelper.searchProperty';
import { LightningElement,wire } from 'lwc';

export default class SearchListings extends LightningElement {
    properties;
    error;

    searchInput = '';

    @wire(searchProperty, {propertyAddress: '$searchInput'})
    propertyWire({error, data} ){
        if(data){
            this.properties = data;
        } else if(error){
            this.error = error;
        }
    }

    search(){
        this.searchInput = this.template.querySelector('searchInput').value;
    }
}