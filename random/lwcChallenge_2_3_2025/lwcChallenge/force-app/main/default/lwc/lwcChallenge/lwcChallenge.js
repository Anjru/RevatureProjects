import { LightningElement,wire,api } from 'lwc';
import getOpenCases from '@salesforce/apex/CaseHelper.getOpenCases';
import CASE_OBJECT from '@salesforce/schema/Case';
import CASE_SUBJECT from '@salesforce/schema/Case.Subject';
import CASE_CASE_NUMBER from '@salesforce/schema/Case.CaseNumber';
import CASE_PRIORITY from '@salesforce/schema/Case.Priority';
import CASE_STATUS from '@salesforce/schema/Case.Status';
import { refreshApex } from '@salesforce/apex';

export default class LwcChallenge extends LightningElement {
    subject = CASE_SUBJECT;
    caseNumber = CASE_CASE_NUMBER;
    priority = CASE_PRIORITY;
    status = CASE_STATUS;

    @wire(getOpenCases)
    caseList;

    @api
    refresh(){
        refreshApex(this.caseList);
        // await notifyRecordUpdateAvailable(recordIds);
    }
}