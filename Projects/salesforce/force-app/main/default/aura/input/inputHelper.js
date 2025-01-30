({
    helperMethod : function(component, event) {
        var userInput = component.find('input').get('v.value');
        component.set('v.input', userInput);
    },

    doInit : function(componenet, event){

        var userInput = componenet.find('input').get('v.value');

        componenet.set('v.columns', [{label: 'Account Name', fieldName: 'Name', type:'text'},
            {label: 'Annual Revenue', fieldName: 'AnnualRevenue', type:'currency', typeAttributes:{currencyCode: 'USD'}},
            {label: 'Rating', fieldName: 'Rating', type:'text'}]);

        var method = componenet.get('c.getAllAccounts');
        method.setParams({query:userInput});
        method.setCallback(this, function(response){
            if(response.getState() ==  'SUCCESS'){
                componenet.set('v.accList', response.getReturnValue());
            }
        });
        $A.enqueueAction(method);
    },

    refreshTable : function(componenet, event){
        var method = componenet.get('c.getAllAccounts');
        method.setParams({query:userInput});
        method.setCallback(this, function(response){
            if(response.getState() ==  'SUCCESS'){
                componenet.set('v.accList', response.getReturnValue());
            }
        });
        $A.enqueueAction(method);
    }
    
})