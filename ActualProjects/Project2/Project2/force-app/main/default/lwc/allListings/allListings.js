import { LightningElement,track } from 'lwc';

export default class AllListings extends LightningElement {
    filterBoolean = false;
    
    @track selectedOption = ''; 
    @track sliderValue = 50; // Default value

    @track bedroom;
    @track location;
    @track other;

    otherOptions = [
        { label: 'Option 1', value: 'option1' },
        { label: 'Option 2', value: 'option2' },
        { label: 'Option 3', value: 'option3' },
        { label: 'Option 4', value: 'option4' }
    ];

    options = [
        { label: 'Option 1', value: 'option1' },
        { label: 'Option 2', value: 'option2' },
        { label: 'Option 3', value: 'option3' }
    ];

    toggleFilter(){
        if(this.filterBoolean){
            this.filterBoolean = false;
        } else {
            this.filterBoolean = true;
        }
    }

    

    handleSliderChange(event) {
        this.sliderValue = event.detail.value;
    }

    handleOptionChange(event) {
        this.selectedOption = event.detail.value;
    }

    handleBedroomChange(event) {
        this.bedroom = event.detail.value;
    }

    handleLocationChange(event) {
        this.location = event.detail.value;
    }

    handleOtherChange(event) {
        this.other = event.detail.value;
    }

}