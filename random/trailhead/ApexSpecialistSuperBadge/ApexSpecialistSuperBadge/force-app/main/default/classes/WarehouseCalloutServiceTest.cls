@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here

    @IsTest
    static void testWarehouseCalloutService(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        // WarehouseCalloutService.runWarehouseEquipmentSync());
        Test.startTest();
        System.enqueueJob(new WarehouseCalloutService());
        Test.stopTest();

        List<Product2> products = [
            SELECT Name, Cost__c, Current_Inventory__c, Maintenance_Cycle__c, 
                   Lifespan_Months__c, Warehouse_SKU__c, Replacement_Part__c
            FROM Product2
            WHERE Warehouse_SKU__c = '100003'];

        System.assertEquals(1, products.size(), 'Expected 1 upserted product');

        Product2 p = products[0];
        System.assertEquals('Generator 1000 kW', p.Name);
        System.assertEquals(5000, p.Cost__c);
        System.assertEquals(5, p.Current_Inventory__c);
        System.assertEquals(365, p.Maintenance_Cycle__c);
        System.assertEquals(120, p.Lifespan_Months__c);
        System.assertEquals(true, p.Replacement_Part__c, 'Replacement_Part__c should always be true');
    
    }

}