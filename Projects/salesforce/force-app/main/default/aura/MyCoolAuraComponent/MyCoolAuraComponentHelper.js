({
    doInit : function(component, event) {

        component.set('v.columns',[{label:'Account Name', fieldName:'Name', type:'text'},
            {label:'Rating', fieldName:'Rating', type:'text'},
            {label:'Industry', fieldName:'Industry', type:'text'}
        ]);


        var method = component.get('c.getAllAccounts');
        method.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.accList', response.getReturnValue());
            } 
            
            // else if (state === "ERROR") {
            //     var errors = response.getError();
            //     console.error(errors[0].message);
            // }
        });
        $A.enqueueAction(method);
    }
})