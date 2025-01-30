import { LightningElement, track } from 'lwc';
import getContacts from '@salesforce/apex/ContactHelper.getContacts';

export default class Challenge7 extends LightningElement {
    @track
    contacts = [];

    handleClick(){
       getContacts().
       then((res)=> {
        this.contacts = res;
       }).catch((e) => {
        console.log(e);
       });
    }
    
}