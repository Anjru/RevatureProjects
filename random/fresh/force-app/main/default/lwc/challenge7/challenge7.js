import { api, LightningElement, track } from 'lwc';
import getContacts from '@salesforce/apex/ContactHelper.getContacts';
import getContact from '@salesforce/apex/ContactHelper.getContact';

export default class Challenge7 extends LightningElement {
    @track
    contacts = [];

    @track
    contact;

    @api
    recordId

    handleClick(){
    //    getContacts().
    //    then((res)=> {
    //     this.contacts = res;
    //     contact = this.recordId;
    //    }).catch((e) => {
    //     console.log(e);
    //    });

       getContact({id:this.recordId}).
       then((res)=> {
        this.contact = res;
       }).catch((e) => {
        console.log(e);
       });
    }
    
}