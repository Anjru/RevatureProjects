import { LightningElement,wire } from 'lwc';
import getFeaturedListings from '@salesforce/apex/projectTwoHelper.getFeaturedListings';

export default class FeaturedListings extends LightningElement {
    @wire(getFeaturedListings)
    featuredListings


}