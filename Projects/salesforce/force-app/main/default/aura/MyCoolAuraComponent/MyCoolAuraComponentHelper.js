({
    doInit : function(component, event) {
        var method = component.get('c.fetchOpps');
        method.setParams({id: component.get('v.recordId')});
        method.Callback(this, function(response) {
            if (state === "SUCCESS") {
            component.set('v.oppList', response.getReturnValue());
            } else if (state === "ERROR") {
                const errors = response.getError();
                console.error(errors[0].message);
            }
        });
        $A.enqueueAction(method);
    }
})