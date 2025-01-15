public with sharing class VisualforceExtensions {
    ApexPages.StandardSetController sd;
    public VisualforceExtensions() {

    }
    public VisualforceExtensions(ApexPages.StandardSetController controller) {
        sd = controller;
        sd.setPageSize(1);
    }

}