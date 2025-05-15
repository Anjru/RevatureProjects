
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
        Product2 equip2 = new Product2(
            Name = 'Test Equipment 2',
            Maintenance_Cycle__c = 30,
            Warehouse_SKU__c = 'SKU123',
            Replacement_Part__c =true

        );
        insert equip;
        insert equip2;

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

        Equipment_Maintenance_Item__c item2 = new Equipment_Maintenance_Item__c(
            Maintenance_Request__c = posCase.Id,
            Equipment__c = equip2.Id
        );
        insert item2;

        // Trigger the follow-up logic
        posCase.Status = 'Closed';
        update posCase;

        // Validate the follow-up request
        List<Case> posTests = [SELECT Id, Subject, Type, Status, ProductId FROM Case WHERE Subject='Routine Checkup'];
        System.assertEquals(1, posTests.size(), 'Expected 1 follow-up request');
        System.assertEquals('Routine Checkup', posTests[0].Subject);
        System.assertEquals('Routine Maintenance', posTests[0].Type);
        System.assertEquals('New', posTests[0].Status);

        List<Equipment_Maintenance_Item__c> joins = [
        SELECT Id, Equipment__c, Maintenance_Request__c
        FROM Equipment_Maintenance_Item__c
        WHERE Maintenance_Request__c = :posTests[0].Id];

        System.assertEquals(2, joins.size(), 'Expected 2 equipment joins for the follow-up case');

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
            Replacement_Part__c = true
        );
        insert equip;

        // Insert vehicle
        Vehicle__c vehicle = new Vehicle__c(Name = 'Test Vehicle');
        insert vehicle;

        // Insert 200 Maintenance Requests
        List<Case> posCases = new List<Case>();
        for (Integer i = 0; i < 200; i++) {
            posCases.add(new Case(
                Status = 'New',
                Origin = 'Apex',
                Type = 'Repair',
                Subject = 'Bulk Case Test ' + i,
                Vehicle__c = vehicle.Id
            ));
        }
        insert posCases;

        // Insert Equipment_Maintenance_Item__c in bulk
        List<Equipment_Maintenance_Item__c> items = new List<Equipment_Maintenance_Item__c>();
        for (Case c : posCases) {
            items.add(new Equipment_Maintenance_Item__c(
                Maintenance_Request__c = c.Id,
                Equipment__c = equip.Id
            ));
        }
        insert items;

        // Set all to Closed
        for (Case c : posCases) {
            c.Status = 'Closed';
        }
        update posCases;

        // Assert 200 follow-up cases created
        List<Case> followups = [
            SELECT Id, Subject, Type, Status, ProductId
            FROM Case
            WHERE Subject = 'Routine Checkup'
        ];

        System.assertEquals(200, followups.size(), 'Expected 200 follow-up requests');
        for (Case c : followups) {
            System.assertEquals('Routine Checkup', c.Subject);
            System.assertEquals('Routine Maintenance', c.Type);
            System.assertEquals('New', c.Status);
            // Optional: System.assertEquals(equip.Id, c.ProductId);
        }
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

        List<Case> negCases = new List<Case>();
        // Insert Maintenance Request
        for(Integer i = 0; i < 200; i++){
            Case negCase = new Case(
                Status = 'New',
                Origin = 'Apex',
                Type = 'Feedback',
                Subject = 'Bulk Case Test ' + i,
                Vehicle__c = vehicle.Id
            );
            negCases.add(negCase);
        }

        insert negCases;

        // Link equipment to the case
        List<Equipment_Maintenance_Item__c> items = new List<Equipment_Maintenance_Item__c>();
        for (Case c : negCases) {
            items.add(new Equipment_Maintenance_Item__c(
                Maintenance_Request__c = c.Id,
                Equipment__c = equip.Id
            ));
        }
        insert items;

        // Trigger the follow-up logic
        for(Case negCase : negCases){
            negCase.Status = 'Closed';
        }
        
        update negCases;

        // Validate the follow-up request
        List<Case> negTests = [SELECT Id, Subject, Type, Status FROM Case WHERE Subject='Routine Checkup'];
        System.assertEquals(0, negTests.size(), 'Expected 0 follow-up request');
    }
}