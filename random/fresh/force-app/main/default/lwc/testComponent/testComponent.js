import { LightningElement, wire } from 'lwc';
import getHighPriorityCases from '@salesforce/apex/CaseHelper.getHighPriorityCases';
import {refreshApex} from '@salesforce/apex';

export default class TestComponent extends LightningElement {

    @wire(getHighPriorityCases)
    caseList;

    columns = [
        { label: 'Subject', fieldName: 'Subject', type: 'text' }];
    
    // { label: 'Account', fieldName: 'AccountId', type: 'text' },
    // { label: 'Contact', fieldName: 'ContactId', type: 'text' }

    handleNewCase(){
        refreshApex(this.caseList);
    }
}