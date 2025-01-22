public with sharing class WorkOrderExtension {
    ApexPages.StandardSetController controller;
    public Boolean showInput { get; set; }
    public String subjectInputWorkOrder { get; set; }
    public String statusInputWorkOrder { get; set; }
    public Id accountIdInputWorkOrder { get; set; }
    public Id contactIdInputWorkOrder { get; set; }
    public List<WorkOrder> workorders { get; set; }
    public Id recordIdToDelete { get; set; }

    public WorkOrderExtension(ApexPages.StandardSetController controller) {
        this.controller = controller;
        this.showInput = false;
        this.subjectInputWorkOrder = '';
        this.statusInputWorkOrder = 'New'; // Default status
        loadWorkOrders();
    }

    public void loadWorkOrders() {
        this.workorders = [SELECT Id, Subject, Status, AccountId, ContactId FROM WorkOrder];
    }

    public void toggleInputField() {
        showInput = true;
    }

    public void createWorkOrder() {
        if (String.isNotBlank(subjectInputWorkOrder) && accountIdInputWorkOrder != null && contactIdInputWorkOrder != null) {
            WorkOrder workOrder = new WorkOrder(
                Subject = subjectInputWorkOrder,
                Status = statusInputWorkOrder,
                AccountId = accountIdInputWorkOrder,
                ContactId = contactIdInputWorkOrder
            );
            insert workOrder;

            showInput = false;

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Work Order created successfully.'));
            loadWorkOrders();
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'All fields are required.'));
        }
    }

    public void deleteWorkOrderRecord() {
        if (recordIdToDelete != null) {
            delete [SELECT Id FROM WorkOrder WHERE Id = :recordIdToDelete];
            loadWorkOrders();
        }
    }

    public List<SelectOption> getAccountOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for (Account acc : [SELECT Id, Name FROM Account]) {
            options.add(new SelectOption(acc.Id, acc.Name));
        }
        return options;
    }

    public List<SelectOption> getTechnicianContactOptions() {
        Id technicianRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Technician' AND SObjectType = 'Contact' LIMIT 1].Id;
        List<SelectOption> options = new List<SelectOption>();
        for (Contact con : [SELECT Id, Name FROM Contact WHERE RecordTypeId = :technicianRecordTypeId]) {
            options.add(new SelectOption(con.Id, con.Name));
        }
        return options;
    }

    public List<SelectOption> getStatusOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('New', 'New'));
        options.add(new SelectOption('In Progress', 'In Progress'));
        options.add(new SelectOption('Completed', 'Completed'));
        return options;
    }
}
