@isTest
public class BatchApexErrorHelperTest implements Database.RaisesPlatformEvents{
	@testSetup
    static void dataSetup(){
        List<Contact> cons = new List<Contact>();
        for(Integer i = 0; i < 10; i++){
            Contact con = new Contact(LastName = 'Pilot'+i,
            Pilot_Rating__c = 3.0);
            cons.add(con);
        }
        insert cons;
        
        List<Mission__c> missions = new List<Mission__c>();
        List<Mission__c> mis2 = new List<Mission__c>();
        
        for(Contact con : cons){
            Mission__c mission = new Mission__c(Pilot__c = con.Id,
                                                Completion_Rating__c = 5.0,
                                                Overall_Rating__c = 5.0,
                                                Safety_Incidents__c = 1.0,
                                                Status__c = 'Complete',
                                                Subject__c = 'Mission Test');
            missions.add(mission);
            
        }
        insert missions;
        
        Mission__c mission = new Mission__c(Pilot__c = cons.get(0).Id,
                                                Completion_Rating__c = 5.0,
                                                Overall_Rating__c = 5.0,
                                                Safety_Incidents__c = 1.0,
                                                Status__c = 'Complete',
                                                Subject__c = 'Mission Test');
        insert mission; 
        
    }
    
    @isTest
    static void testBatchEventTrigger(){
        Database.SaveResult sr = EventBus.publish(new BatchApexErrorEvent());
        
        Test.getEventBus().deliver();
        
        List<Error_Log__c> errors = [SELECT Id, Name, Async_Apex_Job_Id__c, Message__c FROM Error_Log__c];
        Assert.areEqual(1, errors.size());
    }
    
    
    
}