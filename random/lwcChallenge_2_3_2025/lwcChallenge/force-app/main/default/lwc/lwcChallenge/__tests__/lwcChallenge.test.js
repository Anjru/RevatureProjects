import { createElement } from 'lwc';
import LwcChallenge from 'c/lwcChallenge';
import getOpenCases from '@salesforce/apex/CaseHelper.getOpenCases';
import CaseNumber from '@salesforce/schema/Case.CaseNumber';
import Priority from '@salesforce/schema/Case.Priority';
import { refreshApex } from '@salesforce/apex';

// import { registerApexTestWireAdapter } from '@salesforce/sfdx-lwc-jest';

// Mock the Apex wire adapter
jest.mock(
    '@salesforce/apex/CaseHelper.getOpenCases',
    () => {
        const { createApexTestWireAdapter } = require('@salesforce/sfdx-lwc-jest');
        return { default: createApexTestWireAdapter(jest.fn()) };
    },
    { virtual: true }
);

// mock refreshApex
jest.mock('@salesforce/apex', () => ({
    refreshApex: jest.fn(),
}));


async function flushPromises(){
    return Promise.resolve();
}

describe('c-lwc-challenge', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        //jest.clearAllMocks();
        jest.resetModules();
    });

    it('renders lightning-record-edit-form', async () => {

        const element = createElement('c-lwc-challenge', { is: LwcChallenge });

        const mockOpenCaseList = require('./data/_wireAdapter.json');
        getOpenCases.emit(mockOpenCaseList.data);

        document.body.appendChild(element);

        await flushPromises();

        const caseForms = element.shadowRoot.querySelector('.first');
        const id = caseForms.getAttribute("data-record-id");

        expect(id).toBe("XXXXXXXXXXXXXXXXXX");

    });

    it('Checks if onsuccess calls refresh', async () => {

        const element = createElement('c-lwc-challenge', { is: LwcChallenge });
        
        document.body.appendChild(element);

        const refreshSpy = jest.spyOn(element, 'refresh');

        const form = element.shadowRoot.querySelector('.second');

        form.dispatchEvent(new CustomEvent('success'));

        await flushPromises();
        
        //expect(refreshSpy).toHaveBeenCalledTimes(1);

    });


});
