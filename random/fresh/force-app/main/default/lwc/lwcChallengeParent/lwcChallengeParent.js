import { LightningElement,wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountHelper.getAccounts';
import { refreshApex } from '@salesforce/apex'
import OBJECT_API_NAME from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import ANNUAL_REVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';

export default class LwcChallengeParent extends LightningElement {
    @wire(getAccounts)
    accounts;

    objectApiName = OBJECT_API_NAME;
    name = NAME_FIELD;
    annualRevenue = ANNUAL_REVENUE_FIELD;

    refreshCache(){
        refreshApex(this.accounts);
    }

}