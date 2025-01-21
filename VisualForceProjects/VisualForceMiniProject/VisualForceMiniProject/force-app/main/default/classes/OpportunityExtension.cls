public with sharing class OpportunityExtension {
    ApexPages.StandardSetController controller;
    public OpportunityExtension(ApexPages.StandardSetController controller) {
        this.controller = controller;
    }

    public PageReference getVisualForcePage(){
        PageReference visualForcePage = Page.VisualForce;

        visualForcePage.setRedirect(true);

        return visualForcePage;
    }
    
}