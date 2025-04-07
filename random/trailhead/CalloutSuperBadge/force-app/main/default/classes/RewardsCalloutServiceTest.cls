@isTest
private class RewardsCalloutServiceTest {

    @TestSetup
    static void makeData(){
        //wellness
        Wellness_Journey__c journey = new Wellness_Journey__c();
        
        //set fields
    }

    @isTest
    static void myUnitTest() {
        //Mock
        Test.setMock(HttpCalloutMock.class, new RewardsCalloutServiceMock());


        // Create Test data
        List<Wellness_Journey__c> journeys = new List<Wellness_Journey__c>();

        for(Integer i = 0; i < 12; i++){
            Wellness_Journey__c journey = new Wellness_Journey__c();
            journey.Status__c = 'Complete';
            // journey.Completion_Date__c = 1;
            //start / end date
            journeys.add(journey);
        }

        insert journeys;

        Test.startTest();
        Database.executeBatch(new WellnessJourneyRewardsBatch());
        Test.stopTest();

        ////////////////////////////////////////
        

       //Serialize JSON

        Integer statusCode = RewardsCalloutService.submitUsersForRewardCallout(JSON.serialize(journeys));
        Assert.areEqual(statusCode, 200);

        Integer statusCode2 = RewardsCalloutService.submitUsersForRewardCallout(JSON.serialize('adsf'));
        // Assert.areEqual(statusCode2, 500);
        
    }
}