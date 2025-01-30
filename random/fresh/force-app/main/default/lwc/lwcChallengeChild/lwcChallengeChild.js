import { LightningElement,api } from 'lwc';
import deleteAccount from '@salesforce/apex/AccountHelper.deleteAccount';


export default class LwcChallengeChild extends LightningElement {
    @api
    record;
   
    deleteAccount(e){
        deleteAccount({id: e.target.dataset.recordid})
        .then(() => this.dispatchEvent(new CustomEvent('mycustomevent')));
    }
}