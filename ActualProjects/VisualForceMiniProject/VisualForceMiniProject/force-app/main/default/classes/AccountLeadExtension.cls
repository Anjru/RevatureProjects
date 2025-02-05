public with sharing class AccountLeadExtension {
    ApexPages.StandardSetController controller;
    public Boolean showInput { get; set; }
    public String nameInputAccount { get; set; }
    public String lastNameInputLead {get; set;}
    public String companyInputLead {get; set;}
    public String statusInputLead {get; set;}
    public List<Account> accounts { get; set; }
    public List<Lead> leads { get; set; }
    public Id recordIdToDelete { get; set; }

    public AccountLeadExtension(ApexPages.StandardSetController controller) {
        this.controller = controller;
        this.showInput = false;
        this.nameInputAccount = '';
        this.lastNameInputLead = '';
        loadAccounts();
        loadLeads();
    }

    public void loadAccounts(){
        this.accounts = [SELECT Id, Name FROM Account];
    }


    public void loadLeads(){
        this.leads = [SELECT Id, Name, Company, Status FROM Lead];
    }


    public PageReference getVisualForcePage(){
        PageReference visualForcePage = Page.VisualForce;

        visualForcePage.setRedirect(true);

        return visualForcePage;
    }

    // Toggle input visibility
    public void toggleInputField() {
        showInput = true;
    }

    // Create a new account
    public void createAccount() {
        if (String.isNotBlank(nameInputAccount)) {
            Account account = new Account(Name = nameInputAccount);
            insert account;

            showInput = false;

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Account created successfully.'));
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Name cannot be blank.'));
        }
    }

    // Create a new account
    public void createLead() {
        if (String.isNotBlank(lastNameInputLead) && String.isNotBlank(companyInputLead) && String.isNotBlank(statusInputLead)) {
            Lead lead = new Lead(LastName = lastNameInputLead, Company = companyInputLead, Status = statusInputLead);
            insert lead;

            showInput = false;

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Account created successfully.'));
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'All fields are required.'));
        }
    }

    // Method to generate Lead Status options
    public List<SelectOption> getLeadStatusOptions() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Lead.Status.getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            options.add(new SelectOption(entry.getValue(), entry.getLabel()));
        }
        return options;
    }

    public void deleteAccountRecord() {
        if (recordIdToDelete != null) {
            delete [SELECT Id FROM Account WHERE Id = :recordIdToDelete];
        }
    }

    public void deleteLeadRecord() {
        if (recordIdToDelete != null) {
            delete [SELECT Id FROM Lead WHERE Id = :recordIdToDelete];
        }
    }

}