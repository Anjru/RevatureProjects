public with sharing class VisualForceExtension {
    ApexPages.StandardSetController controller;
    public VisualForceExtension(ApexPages.StandardSetController controller) {
        this.controller = controller;
    }

    public PageReference getAccountLeadPage(){
        PageReference accountLeadPage = Page.AccountLeadPage;

        accountLeadPage.setRedirect(true);

        return accountLeadPage;
    }

    public PageReference getContactPage(){
        PageReference contactPage = Page.ContactPage;

        contactPage.setRedirect(true);

        return contactPage;
    }

    public PageReference getOppportunityPage(){
        PageReference opportunityPage = Page.OpportunityPage;

        opportunityPage.setRedirect(true);

        return opportunityPage;
    }

}