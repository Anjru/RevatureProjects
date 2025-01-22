({
    handleMessage : function(component, event) {
        var message = event.getParam('examplePara');
        component.set('v.message', message);
    }
})