import { LightningElement, track, wire } from 'lwc';

export default class LwcExample extends LightningElement {
    message = 'Enter';
    @track
    todos = ['Example'];

    handleInput(){
        let input = this.refs.input.value;
        this.message = input;
        // this.todo.push(this.message);
        this.todos = [...this.todos, input];
    }

}