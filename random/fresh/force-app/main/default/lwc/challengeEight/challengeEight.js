import { LightningElement,wire,api, track } from 'lwc';
import getContacts from '@salesforce/apex/ContactHelper.getContacts';
import getContact from '@salesforce/apex/ContactHelper.getContact';

export default class ChallengeEight extends LightningElement {
    @track
    contact;
    error;
    
    @wire(getContact, {id: '$recordId'})
    contactRetrieved({error, data}){
        if(data) {
            this.contact = data;
        } else if (error) {
            this.error = this.error;
        }
    }

    @api 
    recordId;

}