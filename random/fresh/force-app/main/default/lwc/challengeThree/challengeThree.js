import { LightningElement } from 'lwc';
export default class ChallengeThree extends LightningElement {
    
    red(){
        this.template.querySelector('.square').style.backgroundColor = "Red";

    }

    green(){
        this.template.querySelector('.square').style.backgroundColor = "Green";
    }

    blue(){
        this.template.querySelector('.square').style.backgroundColor= "Blue";
    }
}