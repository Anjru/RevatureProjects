import { createElement } from 'lwc';
import Challenge7 from 'c/challenge7';
import getContact from '@salesforce/apex/ContactHelper.getContact';

// Mocking getContact Imperative Apex Call
jest.mock(
    '@salesforce/apex/ContactHelper.getContact',
    () => ({
        default: jest.fn(),
    }),
    { virtual: true }
);

async function flushPromises() {
    return Promise.resolve();
}

describe('c-challenge7', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks(); 
    });

    it('retrieves and displays a contact data when button is clicked', async () => {
        const element = createElement('c-challenge7', {
            is: Challenge7
        });

        // Mock Record ID
        element.recordId = '003XXXXXXXXXXXXXXX'; // Example Contact ID

        // Mock Apex Response
        const mockContact = { Id: '003XXXXXXXXXXXXXXX', FirstName: 'John', LastName: 'Doe' };
        getContact.mockResolvedValue(mockContact);

        // Act
        document.body.appendChild(element);

        // 
        const button = element.shadowRoot.querySelector('lightning-button');
        button.click();

        await flushPromises();

        const firstName = element.shadowRoot.querySelector('.firstName').textContent;
        const lastName = element.shadowRoot.querySelector('.lastName').textContent;

        expect(firstName).toBe('First Name: John');
        expect(lastName).toBe('Last Name: Doe');
    });
});
