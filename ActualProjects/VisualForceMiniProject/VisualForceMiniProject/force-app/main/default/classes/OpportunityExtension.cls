public with sharing class OpportunityExtension {
    ApexPages.StandardSetController controller;
    public Boolean showInput { get; set; }
    public String nameInputOpportunity { get; set; }
    public List<Opportunity> opportunities { get; set; }
    public Id recordIdToDelete { get; set; }

    public OpportunityExtension(ApexPages.StandardSetController controller) {
        this.controller = controller;
        this.showInput = false;
        this.nameInputOpportunity = '';
        loadOpportunities();
    }

    public void loadOpportunities() {
        this.opportunities = [SELECT Id, Name FROM Opportunity];
    }

    public PageReference getVisualForcePage() {
        PageReference visualForcePage = Page.VisualForce;

        visualForcePage.setRedirect(true);

        return visualForcePage;
    }

    public void toggleInputField() {
        showInput = true;
    }

    public void createOpportunity() {
        if (String.isNotBlank(nameInputOpportunity)) {
            Opportunity opportunity = new Opportunity(Name = nameInputOpportunity, StageName = 'Prospecting', CloseDate = System.today());
            insert opportunity;

            showInput = false;

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Opportunity created successfully.'));
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Name cannot be blank.'));
        }
    }

    public void deleteOpportunityRecord() {
        if (recordIdToDelete != null) {
            delete [SELECT Id FROM Opportunity WHERE Id = :recordIdToDelete];
        }
    }
}
