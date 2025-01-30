import { LightningElement } from 'lwc';

export default class ChallengeTwo extends LightningElement {
    message = "";
    visible = true;

    update(){
        this.message = this.refs.inputField.value;
    }

    toggle(){
        if(this.visible == true){
            this.visible = false;
        } else {
            this.visible = true;
        }
    }
}