({
    helperMethod : function(component, event) {
        var userInput = component.find('userInput').get('v.value');
        component.set('v.input', userInput);
    }
})