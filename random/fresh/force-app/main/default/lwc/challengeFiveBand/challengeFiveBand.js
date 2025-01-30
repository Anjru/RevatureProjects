import { api, LightningElement, track } from 'lwc';
import cole from '@salesforce/resourceUrl/cole';
import kendrick from '@salesforce/resourceUrl/kendrick';
import drake from '@salesforce/resourceUrl/drake';

export default class ChallengeFiveBand extends LightningElement {
    @track selectedBand = null; 

    bands = [
        { image: cole, name: "cole", description: "Best rapper" },
        { image: kendrick, name: "kendrick", description: "Next Best rapper" },
        { image: drake, name: "drake", description: "He a bop" }
    ];

    @api
    output(inputValue) {
        this.selectedBand = this.bands.find(band => band.name.toLowerCase() === inputValue.toLowerCase()) || null;
    }
}
