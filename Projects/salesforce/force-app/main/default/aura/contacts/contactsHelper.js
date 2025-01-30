({
    doInit : function(component, event) {
        component.set('v.columns',[
            {label:'First Name', fieldName:'FirstName', type:'text'},{label:'Last Name', fieldName:'LastName', type:'text'},
            {label:'Phone', fieldName:'Phone', type:'text'},{label:'Email', fieldName:'Email', type:'text'}
        ]);

        var method = component.get('c.getAllContacts');
        method.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set('v.contactList', response.getReturnValue());
            }
        });
        $A.enqueueAction(method);
    },

    handleCreateContact : function(component, event){
        var method = component.get('c.createContact');
        method.setParams({
            firstName: component.find('firstName').get('v.value'),
            lastName: component.find('lastName').get('v.value'),
            phone:component.find('phone').get('v.value')
        });
        method.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                console.log('Inside Callback Create');
                this.refresh(component, event);
                //
            } else {
                //return missing last name
            }
        });
        $A.enqueueAction(method);
    },

    handleRowSelection : function(component, event){
        var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedContactList', selectedRows);
        console.log("Selected Rows:", JSON.stringify(selectedRows, null, 2)); //print out data testing
        //$A.enqueueAction(method);
    },

    handleDelete : function(component, event){
        var contactList = component.get('v.selectedContactList');
        console.log("Inside deletee helpr",JSON.stringify(contactList, null, 2));
        var method = component.get('c.deleteContact');
        console.log("Contact List" + contactList);
        method.setParams({contacts:contactList});
        method.setCallback(this,function(response) {
            console.log("yoo");
            var state = response.getState();
            if(state === 'SUCCESS'){
                ///
                this.refresh(component, event);
                console.log('Inside Callback Delete');
            } else {
                console.log('Inside Callback ERROR DELTE');
            }
        });
        $A.enqueueAction(method);
    },

    refresh : function(component, event){
        var method = component.get('c.getAllContacts');
        method.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set('v.contactList', response.getReturnValue());
            }
        });
        $A.enqueueAction(method);
    }
})