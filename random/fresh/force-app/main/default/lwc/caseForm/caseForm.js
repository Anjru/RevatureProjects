import { LightningElement } from 'lwc';
import createCase from '@salesforce/apex/CaseHelper.createCase';

export default class CaseForm extends LightningElement {
    async createCase(){
        await createCase({origin:this.refs.origin.value, status: this.refs.status.status.value});
        this.dispatchEvent(new CustomEvent('caseCreate'));
    }


}