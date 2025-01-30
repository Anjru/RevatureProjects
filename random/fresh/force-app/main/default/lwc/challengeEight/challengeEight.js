import { LightningElement,wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactHelper.getContacts';

export default class ChallengeEight extends LightningElement {
    @wire(getContacts)
    contacts;

}