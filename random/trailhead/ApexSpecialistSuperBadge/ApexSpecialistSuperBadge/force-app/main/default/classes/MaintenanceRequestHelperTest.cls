
@isTest
private class MaintenanceRequestHelperTest {

    @isTest
    static void positiveTesting() {
        // Insert required equipment
        Product2 equip = new Product2(
            Name = 'Test Equipment',
            Maintenance_Cycle__c = 30,
            Warehouse_SKU__c = 'SKU123',
            Replacement_Part__c =true

        );
        insert equip;

        // Insert vehicle
        Vehicle__c vehicle = new Vehicle__c(Name = 'Test Vehicle');
        insert vehicle;

        // Insert Maintenance Request
        Case posCase = new Case(
            Status = 'New',
            Origin = 'Apex',
            Type = 'Repair',
            Subject = 'Single Case Test',
            Vehicle__c = vehicle.Id
        );
        insert posCase;

        // Link equipment to the case
        Equipment_Maintenance_Item__c item = new Equipment_Maintenance_Item__c(
            Maintenance_Request__c = posCase.Id,
            Equipment__c = equip.Id
        );
        insert item;

        // Trigger the follow-up logic
        posCase.Status = 'Closed';
        update posCase;

        // Validate the follow-up request
        List<Case> posTests = [SELECT Id, Subject, Type, Status FROM Case WHERE Subject='Routine Checkup'];
        System.assertEquals(1, posTests.size(), 'Expected 1 follow-up request');
        System.assertEquals('Routine Checkup', posTests[0].Subject);
        System.assertEquals('Routine Maintenance', posTests[0].Type);
        System.assertEquals('New', posTests[0].Status);
    }


    @isTest
    static void negTesting() {
        // Insert required equipment
        Product2 equip = new Product2(
            Name = 'Test Equipment',
            Maintenance_Cycle__c = 30,
            Warehouse_SKU__c = 'SKU123',
            Replacement_Part__c =true

        );
        insert equip;

        // Insert vehicle
        Vehicle__c vehicle = new Vehicle__c(Name = 'Test Vehicle');
        insert vehicle;

        // Insert Maintenance Request
        Case negCase = new Case(
            Status = 'New',
            Origin = 'Apex',
            Type = 'Feedback',
            Subject = 'Single Case Test',
            Vehicle__c = vehicle.Id
        );
        insert negCase;

        // Link equipment to the case
        Equipment_Maintenance_Item__c item = new Equipment_Maintenance_Item__c(
            Maintenance_Request__c = negCase.Id,
            Equipment__c = equip.Id
        );
        insert item;

        // Trigger the follow-up logic
        negCase.Status = 'Closed';
        update negCase;

        // Validate the follow-up request
        List<Case> negTests = [SELECT Id, Subject, Type, Status FROM Case WHERE Subject='Routine Checkup'];
        System.assertEquals(0, negTests.size(), 'Expected 0 follow-up request');
    }

    @isTest
    static void bulkPosTesting() {
        
        // Insert required equipment
        Product2 equip = new Product2(
            Name = 'Test Equipment',
            Maintenance_Cycle__c = 30,
            Warehouse_SKU__c = 'SKU123',
            Replacement_Part__c =true

        );
        insert equip;

        // Insert vehicle
        Vehicle__c vehicle = new Vehicle__c(Name = 'Test Vehicle');
        insert vehicle;

        // Insert Maintenance Request
        Case negCase = new Case(
            Status = 'New',
            Origin = 'Apex',
            Type = 'Feedback',
            Subject = 'Single Case Test',
            Vehicle__c = vehicle.Id
        );
        insert negCase;

        // Link equipment to the case
        Equipment_Maintenance_Item__c item = new Equipment_Maintenance_Item__c(
            Maintenance_Request__c = negCase.Id,
            Equipment__c = equip.Id
        );
        insert item;

        // Trigger the follow-up logic
        negCase.Status = 'Closed';
        update negCase;

        // Validate the follow-up request
        List<Case> negTests = [SELECT Id, Subject, Type, Status FROM Case WHERE Subject='Routine Checkup'];
        System.assertEquals(0, negTests.size(), 'Expected 0 follow-up request');
    
    }

    @isTest
    static void bulkNegTesting() {
        
        // Insert required equipment
        Product2 equip = new Product2(
            Name = 'Test Equipment',
            Maintenance_Cycle__c = 30,
            Warehouse_SKU__c = 'SKU123',
            Replacement_Part__c =true

        );
        insert equip;

        // Insert vehicle
        Vehicle__c vehicle = new Vehicle__c(Name = 'Test Vehicle');
        insert vehicle;

        // Insert Maintenance Request
        Case negCase = new Case(
            Status = 'New',
            Origin = 'Apex',
            Type = 'Feedback',
            Subject = 'Single Case Test',
            Vehicle__c = vehicle.Id
        );
        insert negCase;

        // Link equipment to the case
        Equipment_Maintenance_Item__c item = new Equipment_Maintenance_Item__c(
            Maintenance_Request__c = negCase.Id,
            Equipment__c = equip.Id
        );
        insert item;

        // Trigger the follow-up logic
        negCase.Status = 'Closed';
        update negCase;

        // Validate the follow-up request
        List<Case> negTests = [SELECT Id, Subject, Type, Status FROM Case WHERE Subject='Routine Checkup'];
        System.assertEquals(0, negTests.size(), 'Expected 0 follow-up request');
    
    }

    
}