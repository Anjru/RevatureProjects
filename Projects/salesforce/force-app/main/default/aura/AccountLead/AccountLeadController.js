({
    doInit : function(component, event, helper) {
        helper.doInit(component, event);
    },
    handleCreateAccount : function(component, event, helper){
        helper.handleCreateAccount(component, event);
    },
    handleRowSelection : function(component, event, helper){
        helper.handleRowSelection(component, event);
    },
    handleDelete : function(component, event, helper){
        helper.handleDelete(component, event);
    },
    refresh : function(component, event, helper){
        helper.refresh(component, event);
    },

    //////////////////////////

    handleCreateAccount : function(component, event, helper){
        helper.handleCreateLead(component, event);
    },

    handleDeleteLead : function(component, event, helper){
        helper.handleDeleteLead(component, event);
    }

    
})