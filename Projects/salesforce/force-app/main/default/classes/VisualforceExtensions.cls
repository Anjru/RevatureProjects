public with sharing class VisualforceExtensions {
    ApexPages.StandardSetController sd;
    public List<Account> accounts {get; set;}
    public Boolean showGreeting {get; set;}
    public String userInput {get; set;}
    public List<Account> accountInput{get; set;}

    public VisualforceExtensions() {

    }
    public VisualforceExtensions(ApexPages.StandardSetController controller) {
        sd = controller;
        sd.setPageSize(1);
        userInput = '';
        // Extract Account IDs from the list
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : (List<Account>)controller.getRecords()) {
            accountIds.add(acc.Id);
        }

        // Query the accounts using the extracted IDs
        this.accounts = [SELECT Id, Name FROM Account WHERE Id IN :accountIds];
        this.showGreeting = false;
    }


    public void greet(){
        showGreeting = true;
    }


    public void displayAccount(){
        accountInput = [SELECT Name FROM Account Where Name = :userInput];
        showGreeting = true;
    }
}