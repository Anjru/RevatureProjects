import { LightningElement } from 'lwc';

export default class ChallengeFive extends LightningElement {
    parentInput = '';

    updateInput(event) {
        this.parentInput = event.target.value;
        const childComponent = this.template.querySelector('c-challenge-five-band');
        
        if (childComponent) {
            childComponent.output(this.parentInput);
        }
    }

   
}
