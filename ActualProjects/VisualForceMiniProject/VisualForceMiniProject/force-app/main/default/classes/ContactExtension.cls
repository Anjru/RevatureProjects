public with sharing class ContactExtension {
    public ApexPages.StandardSetController controller { get; set; }
    public Boolean showInput { get; set; }
    public String lastNameInputCustomer { get; set; }
    public String lastNameInputTechnician {get; set;}
    public List<Contact> customerContacts { get; set; }
    public List<Contact> technicianContacts { get; set; }
    public Id recordIdToDelete { get; set; }

    // Constructor
    public ContactExtension(ApexPages.StandardSetController controller) {
        this.controller = controller;
        this.showInput = false;
        this.lastNameInputCustomer = '';
        this.lastNameInputTechnician = '';
        loadCustomerContacts();
        loadTechnicianContacts();
    }

    // Load customer contacts
    public void loadCustomerContacts() {
        Id customerRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Customer' AND SObjectType = 'Contact' LIMIT 1].Id;
        customerContacts = [SELECT Id, Name FROM Contact WHERE RecordTypeId = :customerRecordTypeId];
    }

    // Load technician contacts
    public void loadTechnicianContacts() {
        Id technicianRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Technician' AND SObjectType = 'Contact' LIMIT 1].Id;
        technicianContacts = [SELECT Id, Name FROM Contact WHERE RecordTypeId = :technicianRecordTypeId];
    }

    // Toggle input visibility
    public void toggleInputField() {
        showInput = true;
    }

    // Create a new customer contact
    public void createCustomerContact() {
        if (String.isNotBlank(lastNameInputCustomer)) {
            Contact customer = new Contact(LastName = lastNameInputCustomer);
            insert customer;

            showInput = false;

            // Refresh the contact list
            loadCustomerContacts();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Customer contact created successfully.'));
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Last Name cannot be blank.'));
        }
    }

    // Create a new customer contact
    public void createTechnicianContact() {
        Id technicianRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Technician' AND SObjectType = 'Contact' LIMIT 1].Id;
        if (String.isNotBlank(lastNameInputTechnician)) {
            Contact customer = new Contact(LastName = lastNameInputTechnician, RecordTypeId = technicianRecordTypeId);
            insert customer;

            showInput = false;

            // Refresh the contact list
            loadCustomerContacts();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Technician contact created successfully.'));
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Last Name cannot be blank.'));
        }
    }

    public void deleteRecord() {
        if (recordIdToDelete != null) {
            delete [SELECT Id FROM Contact WHERE Id = :recordIdToDelete];
        }
    }
}
