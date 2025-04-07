@isTest
private class WellnessJourneyRewardsBatchTest {

    @TestSetup
    static void makeData(){
        //wellness (12 records)
            //required fields
        List<Wellness_Journey__c> journeys = new List<Wellness_Journey__c>();
        for (Integer i = 0; i < 13; i++) {
            journeys.add(new Wellness_Journey__c(
                Name = 'Journey ' + i,
                Status__c = 'Complete',
                Completion_Date__c = Date.today().addDays(-90)
            ));
        }
        insert journeys;

    }

    @isTest
    static void myUnitTest() {
        
        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock());

        Test.startTest();
        Database.executeBatch(new WellnessJourneyRewardsBatch());
        Test.stopTest();

        List<Wellness_Journey__c> processedJourneys = [SELECT Id FROM Wellness_Journey__c WHERE Status__c = 'Complete'];
        System.assertEquals(13, processedJourneys.size());

    }
}