import { createElement } from 'lwc';
import LwcChallenge from 'c/lwcChallenge';
import getOpenCases from '@salesforce/apex/CaseHelper.getOpenCases';


const mockGetOpenCases = registerLdsTestWireAdapter(getOpenCases);

describe('c-lwc-challenge', () => {
    afterEach(() => {
        // Reset the DOM after each test
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('renders lightning-record-edit-forms for cases', () => {
        // Arrange
        const element = createElement('c-lwc-challenge', {
            is: LwcChallenge
        });

        // Mock case data
        mockGetOpenCases.emit([
            { Id: '1', Subject: 'Case 1', Status: 'Open', Priority: 'High' },
            { Id: '2', Subject: 'Case 2', Status: 'In Progress', Priority: 'Low' }
        ]);

        // Act
        document.body.appendChild(element);

        // Assert
        const forms = element.shadowRoot.querySelectorAll('lightning-record-edit-form');
        expect(forms.length).toBe(2); // Two cases should render two forms
    });
});
