import getContacts from '@salesforce/apex/ContactController.getContacts';
import { api, LightningElement, wire } from 'lwc';
import FIRST_NAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import { reduceErrors } from 'c/ldsUtils';

export default class ContactList extends LightningElement {
    
    @api firstName = '';
    @api lastName = '';
    @api email = '';

    columns = [
        { label: 'First Name', fieldName: FIRST_NAME_FIELD.fieldApiName, type:'text' },
        { label: 'Last Name', fieldName: LAST_NAME_FIELD.fieldApiName, type: 'text'},
        { label: 'Email', fieldName: EMAIL_FIELD.fieldApiName, type: 'email'}
    ];

    @wire(getContacts)
    contacts;

    get errors(){
        return this.contacts.errors ? reduceErrors(this.contacts.error) : [];
    }
}
