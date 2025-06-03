public class BatchApexErrorHelper {
    public static void handleBatchErrorEvents(List<BatchApexErrorEvent> events){
        List<Error_Log__c> errors = new List<Error_Log__c>();
        
        for(BatchApexErrorEvent event : events){
            Error_Log__c error = new Error_Log__c();
            error.Name = 'Batch Apex Error';
            error.Async_Apex_Job_Id__c = event.AsyncApexJobId;
            error.Message__c = event.Message;
            errors.add(error);
        }
        
        if(!errors.isEmpty()){
            insert errors;
        }
    }
}