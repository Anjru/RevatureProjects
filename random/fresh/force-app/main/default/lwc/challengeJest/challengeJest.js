import { LightningElement } from 'lwc';

export default class ChallengeJest extends LightningElement {
    message = '';

    updateInput(){
        this.message = this.template.querySelector('.input').value;
    }

}