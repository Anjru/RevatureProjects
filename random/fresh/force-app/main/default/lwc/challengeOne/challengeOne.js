import { LightningElement, track } from 'lwc';

export default class ChallengeOne extends LightningElement {
    @track
    items=[];

    addItem(){
        var message = this.refs.inputField.value;
        this.items.push(message);
        //`this.items = [...this.items, message];

    }
}