import { createElement } from 'lwc';
import ChallengeEight from 'c/challengeEight';
import getContact from '@salesforce/apex/ContactHelper.getContact';

jest.mock(
    '@salesforce/apex/ContactHelper.getContact',
    () => {
        const { createApexTestWireAdapter } = require('@salesforce/sfdx-lwc-jest');
        return { default: createApexTestWireAdapter(jest.fn()) };
    },
    { virtual: true }
);

async function flushPromises() {
    return Promise.resolve();
}

describe('c-challenge-eight', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('TODO: test case generated by CLI command, please fill in test logic', async () => {
        // Arrange
        const element = createElement('c-challenge-eight', {
            is: ChallengeEight
        });

        // Mock Record ID
        element.recordId = '003XXXXXXXXXXXXXXX'; // Example Contact ID

        // Mock Apex Response
        const mockContact = { Id: '003XXXXXXXXXXXXXXX', FirstName: 'John', LastName: 'Doe' };
        getContact.emit(mockContact);

        // Act
        document.body.appendChild(element);

        await flushPromises();

        const firstName = element.shadowRoot.querySelector('.firstName').textContent;
        const lastName = element.shadowRoot.querySelector('.lastName').textContent;

        expect(firstName).toBe('First Name: John');
        expect(lastName).toBe('Last Name: Doe');
    });
});