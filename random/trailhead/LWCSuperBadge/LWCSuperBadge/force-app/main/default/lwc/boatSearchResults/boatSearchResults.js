import {wire, LightningElement, api, track } from 'lwc';
import getBoats from '@salesforce/apex/BoatDataService.getBoats';
import { MessageContext, publish  } from 'lightning/messageService';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateBoatList from '@salesforce/apex/BoatDataService.updateBoatList';
import { updateRecord } from 'lightning/uiRecordApi';
import BOATMC from '@salesforce/messageChannel/BoatMessageChannel__c';

const SUCCESS_TITLE = 'Success';
const MESSAGE_SHIP_IT     = 'Ship it!';
const SUCCESS_VARIANT     = 'success';
const ERROR_TITLE   = 'Error';
const ERROR_VARIANT = 'error';
export default class BoatSearchResults extends LightningElement {
  @api
  selectedBoatId;
  columns = [ {label: 'Name', fieldName: 'Name', editable: true },
      { label: 'Length', fieldName: 'Length__c', type: number},
      { label: 'Price', fieldName: 'Price__c', type: currency},
      { label: 'Description', fieldName: 'Description__c'}
  ];

  @api
  boatTypeId = '';
  
  @track
  boats;
  isLoading = false;

  @track
  values = [];
  
  // wired message context
  @wire(MessageContext)
  messageContext;
  // wired getBoats method 
  @wire(getBoats, {boatTypeId: '$boatTypeId'})
  wiredBoats({error, data}) {
      if(data) {
          this.boats = data;
      } else if (error) { 
          this.error = error;
      }
      this.isLoading = false;
      this.notifyLoading(this.isLoading);
  }
  
  // public function that updates the existing boatTypeId property
  // uses notifyLoading
  @api
  searchBoats(boatTypeId) {
      this.isLoading = true;
      this.notifyLoading(this.isLoading);
      this.boatTypeId = boatTypeId;
  }
  
  // this public function must refresh the boats asynchronously
  // uses notifyLoading
  @api
  async refresh() {
      this.isLoading = true;
      this.notifyLoading(this.boats);
      await refreshApex(this.boats);
      this.isLoading = false;
      this.notifyLoading(this.isLoading);
  }
  
  // this function must update selectedBoatId and call sendMessageService
  updateSelectedTile(event) {
      this.selectedBoatId = event.detail.boatId;
      this.sendMessageService(this.selectedBoatId);
  }
  
  // Publishes the selected boat Id on the BoatMC.
  sendMessageService(boatId) { 
    // explicitly pass boatId to the parameter recordId
    publish(this.messageContext, BOATMC, {recordId: boatId});
  }
  
  // The handleSave method must save the changes in the Boat Editor
  // passing the updated fields from draftValues to the 
  // Apex method updateBoatList(Object data).
  // Show a toast message with the title
  // clear lightning-datatable draft values
  handleSave(event) {
    this.notifyLoading(true);
   const recordInputs = event.detail.draftValues.slice().map(draft=>{
       const fields = Object.assign({}, draft);
       return {fields};
   });

   console.log(recordInputs);
   const promises = recordInputs.map(recordInput => updateRecord(recordInput));
   Promise.all(promises).then(res => {
       this.dispatchEvent(
           new ShowToastEvent({
               title: SUCCESS_TITLE,
               message: MESSAGE_SHIP_IT,
               variant: SUCCESS_VARIANT
           })
       );
       this.draftValues = [];
       return this.refresh();
   }).catch(error => {
       this.error = error;
       this.dispatchEvent(
            new ShowToastEvent({
                title: ERROR_TITLE,
                message: CONST_ERROR,
                variant: ERROR_VARIANT
            })
        );
        this.notifyLoading(false);
   }).finally(() => {
        this.draftValues = [];
    });
}

  // Check the current value of isLoading before dispatching the doneloading or loading custom event
  notifyLoading(isLoading) {
      if(isLoading) {
        this.dispatchEvent(new CustomEvent('loading'));
      } else {
        this.dispatchEvent(CustomEvent('doneloading'));
      }
  }
}
