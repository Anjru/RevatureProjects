@isTest
public with sharing class WarehouseSyncScheduleTest {
    // implement scheduled code here
    @isTest 
    static void testSchedule() {
        Test.setMock(HTTPCalloutMock.class, new WarehouseCalloutServiceMock());
        String cron = '0 0 1 * * ?'; // 1:00 AM daily
        Test.startTest();
        String jobId =  System.schedule('WarehouseSyncScheduleJob', cron, new WarehouseSyncSchedule());
        Test.stopTest();

        // Validate that the job was scheduled
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime 
                          FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(cron, ct.CronExpression);
        
    }
}