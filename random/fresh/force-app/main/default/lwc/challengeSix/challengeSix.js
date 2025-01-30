import { LightningElement,api } from 'lwc';

export default class ChallengeSix extends LightningElement {
    // @api
    // visibleDetail = false;
    learnMore(){
        // if(this.visible == true){
        //     this.visible = false;
        // } else {
        //     this.visible = true;
        // }
        this.dispatchEvent(new CustomEvent('mycustomevent'));
    }
}