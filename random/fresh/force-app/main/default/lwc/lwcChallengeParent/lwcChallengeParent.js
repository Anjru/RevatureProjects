import { LightningElement,wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountHelper.getAccounts';
import { refreshApex } from '@salesforce/apex'
import OBJECT_API_NAME from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import ANNUAL_REVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';
import GREETING_LABEL from '@salesforce/label/c.greeting';

export default class LwcChallengeParent extends LightningElement {
    @wire(getAccounts)
    accounts;

    objectApiName = OBJECT_API_NAME;
    name = NAME_FIELD;
    annualRevenue = ANNUAL_REVENUE_FIELD;
    greeting = GREETING_LABEL;

    refreshCache(){
        refreshApex(this.accounts);
    }

}