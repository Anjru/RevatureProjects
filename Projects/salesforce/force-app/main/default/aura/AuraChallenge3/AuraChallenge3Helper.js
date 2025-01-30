({
    handlerUserInput: function (component, event) {
        console.log("Button clicked! Starting helperMethod...");

        // Fetch and validate input values
        var name = component.find('inputName').get('v.value');
        var rating = component.find('inputRating').get('v.value');
        var employees = component.find('inputEmployees').get('v.value');
        var annualRevenue = component.find('inputAnnualRevenue').get('v.value');
        console.log('Fetched Values: '+name + ' ' + rating + ' ' + employees + ' ' + annualRevenue);
        // Call Apex method
        var action = component.get('c.createAccount');
        action.setParams({ name: component.find('inputName').get('v.value'),
            rating: component.find('inputRating').get('v.value'),
            employees: component.find('inputEmployees').get('v.value'),
            annualRevenue: component.find('inputAnnualRevenue').get('v.value')});

        action.setCallback(this, function (response) {

            var state = response.getState();
            console.log('Apex response state:', state);

            if (state === 'SUCCESS') {
                console.log('Account created successfully!');

                component.find('notifLib').showNotice({
                    "variant":"Success", //Provides a color variant for successes
                    "header":"Sucess!", //toasts use titles
                    "message":"The record " + component.find('inputName').get('v.value') +' updated'
                });
                
                // var toastEvent = $A.get('e.force:showToast');
                // if (toastEvent) {
                //     toastEvent.setParams({
                //         title: 'Success',
                //         message: 'Account created successfully!',
                //         type: 'success'
                //     });
                //     toastEvent.fire();
                // }
            } else if (state === 'ERROR') {
                var errors = response.getError();
                console.error('Apex error:', errors);
                if (errors && errors[0] && errors[0].message) {
                    var toastEvent = $A.get('e.force:showToast');
                    if (toastEvent) {
                        toastEvent.setParams({
                            title: 'Error',
                            message: errors[0].message,
                            type: 'error'
                        });
                        toastEvent.fire();
                    }
                }
            }
        }
        
        );

        console.log('Enqueueing action...');
        $A.enqueueAction(action);
    }
});
