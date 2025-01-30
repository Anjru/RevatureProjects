({
    doInit : function(component, event) {
        component.set('v.columns',[
            {label:'Name', fieldName:'Name', type:'text'},
            {label:'Phone', fieldName:'Phone', type:'text'}
        ]);

        var method = component.get('c.getAllAccounts');
        method.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set('v.accountList', response.getReturnValue());
            }
        });

        /////////////////////////////////////////////////

        component.set('v.columnsLead',[
            {label:'Last Name', fieldName:'LastName', type:'text'},
            {label:'Company', fieldName:'Company', type:'text'}
        ]);

        var methodLead = component.get('c.getAllLeads');
        methodLead.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set('v.leadList', response.getReturnValue());
            }
        });

        $A.enqueueAction(method);
    },

    handleCreateAccount : function(component, event){
        console.log("Creating Account");
        var method = component.get('c.createAccount');
        method.setParams({
            name: component.find('name').get('v.value'),
            phone:component.find('phone').get('v.value')
        });
        method.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                console.log('Inside Callback Create');
                this.refresh(component, event);
                //
            } else {
                console.log("error create");
                //return missing last name
            }
        });
        $A.enqueueAction(method);
    },

    handleRowSelection : function(component, event){
        var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedAccountList', selectedRows);
        
        //$A.enqueueAction(method);
    },

    handleDelete : function(component, event){
        console.log("handleDel");
        var accountList = component.get('v.selectedAccountList');
        var method = component.get('c.deleteAccount');
        method.setParams({accounts:accountList});

        console.log("Selected Accounts (detailed):", JSON.stringify(accountList, null, 2));

        method.setCallback(this,function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                console.log("success");
                this.refresh(component, event);
                
            } else {
                console.log("Error");
            }
        });
        $A.enqueueAction(method);
    },

    refresh : function(component, event){
        var method = component.get('c.getAllAccounts');
        method.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set('v.accountList', response.getReturnValue());
            }
        });
        $A.enqueueAction(method);
    },

    handleCreateAccount : function(component, event){
        
    },

    handleDeleteLead : function(component, event){
        
    }
})