import { LightningElement } from 'lwc';

export default class ParentLWC extends LightningElement {

    render = false;

    handleInput(){
        this.render = true;
    }
}