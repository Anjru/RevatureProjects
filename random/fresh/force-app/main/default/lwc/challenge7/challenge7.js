import { wire,LightningElement } from 'lwc';
import getContacts from '@salesforce/apex/ContactHelper.getContacts';

export default class Challenge7 extends LightningElement {
    
    @wire(getContacts)
    contacts;

    
}