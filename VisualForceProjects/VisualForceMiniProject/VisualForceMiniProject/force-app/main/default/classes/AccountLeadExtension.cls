public with sharing class AccountLeadExtension {
    ApexPages.StandardSetController controller;
    public Boolean showInput { get; set; }
    public String lastNameInputAccount { get; set; }
    public String lastNameInputLead {get; set;}
    public List<Account> accounts { get; set; }
    public List<Lead> Leads { get; set; }
    public Id recordIdToDelete { get; set; }

    public AccountLeadExtension(ApexPages.StandardSetController controller) {
        this.controller = controller;
        
    }

    public PageReference getVisualForcePage(){
        PageReference visualForcePage = Page.VisualForce;

        visualForcePage.setRedirect(true);

        return visualForcePage;
    }
}