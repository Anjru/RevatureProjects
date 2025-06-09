import {wire, LightningElement, api, track } from 'lwc';
import getBoats from '@salesforce/apex/BoatDataService.getBoats';
import { MessageContext, publish  } from 'lightning/messageService';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

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
  @wire(getBoats, {boatTypeId: '$selectedBoatId'})
  wiredBoats({error, data}) {
      if(data) {
          this.boats = data;
      } else if (error) { 

      }
   }
  
  // public function that updates the existing boatTypeId property
  // uses notifyLoading
  @api
  searchBoats(boatTypeId) {
      this.boatTypeId = boatTypeId;
   }
  
  // this public function must refresh the boats asynchronously
  // uses notifyLoading
  @api
  refresh() {
      refreshApex(this.notifyLoading(this.isLoading));
   }
  
  // this function must update selectedBoatId and call sendMessageService
  updateSelectedTile() {
      this.selectedBoatId = this.boatTypeId;
      this.sendMessageService(this.selectedBoatId);
   }
  
  // Publishes the selected boat Id on the BoatMC.
  sendMessageService(boatId) { 
    // explicitly pass boatId to the parameter recordId
  }
  
  // The handleSave method must save the changes in the Boat Editor
  // passing the updated fields from draftValues to the 
  // Apex method updateBoatList(Object data).
  // Show a toast message with the title
  // clear lightning-datatable draft values
  handleSave(event) {
    // notify loading
    const updatedFields = event.detail.draftValues;
    // Update the records via Apex
    updateBoatList({data: updatedFields})
    .then(() => {})
    .catch(error => {})
    .finally(() => {});
  }
  // Check the current value of isLoading before dispatching the doneloading or loading custom event
  notifyLoading(isLoading) { }
}
