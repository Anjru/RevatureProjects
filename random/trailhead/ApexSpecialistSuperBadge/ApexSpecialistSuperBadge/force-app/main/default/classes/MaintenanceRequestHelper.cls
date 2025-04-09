public with sharing class MaintenanceRequestHelper {
    public MaintenanceRequestHelper() {

    }

    public static void upsertRequest(List<Case> requests){
        List<Case> newRequests = new List<Case>();
        Boolean insertRequest = false;

        Map<Case, List<Product2>> mapOfJoins = new Map<Case, List<Product2>>();


        //Create new request when old is closed
        for(Case c : requests){
            if((c.Type == 'Repair' || c.Type == 'Routine Maintenance') && c.Status == 'Closed'){
                Case futureCheckup = new Case();
                //Type set to Routine Maintenance
                futureCheckup.Type = 'Routine Maintenance';
                futureCheckup.Status = 'New';
                //Tie Equipment records
                futureCheckup.ProductId = c.ProductId;
  
                //Subject cannot be null
                futureCheckup.Subject = 'Routine Checkup';
                //Tie to same vehicle
                futureCheckup.Vehicle__c = c.Vehicle__c;

                //Set Report Date
                futureCheckup.Date_Reported__c = Date.today();

                //Tie Acc/Con in case
                futureCheckup.AccountId = c.AccountId;
                futureCheckup.ContactId = c.ContactId;

                //Set future date
                //Might have to calculate shortest maintenance cycle...
                //Equipment maintenance item (Junction)
                    //Query equipment maintence item related to Case/request
                    //Then grab all the Equipment related to that item
                    //Then find the shortes date

                //Queries from junction obj between Equipments / requests (EMT)
                List<Equipment_Maintenance_Item__c> equipmentlist = [SELECT Id, Equipment__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c = :c.Id];

                //Stores shortest days
                Integer shortestDays = 0;

                //Will hold Ids of related "equipment/product"
                    //Needed to query Equipment records
                Set<Id> equipmentIds = new Set<Id>();
                for(Equipment_Maintenance_Item__c e : equipmentlist) {
                    equipmentIds.add(e.Equipment__c);
                }

                //Queries related Equipment records
                List<Product2> equipments = [SELECT Id, Maintenance_Cycle__c FROM Product2 WHERE Id IN :equipmentIds];

                //Calculates shortest days from related Equipment queried
                for(Product2 e : equipments){
                    if(Integer.valueOf(e.Maintenance_Cycle__c) < shortestDays || shortestDays == 0) {
                        shortestDays = Integer.valueOf(e.Maintenance_Cycle__c);
                    }
                }

                futureCheckup.Date_Due__c = Date.today().addDays(Integer.valueOf(shortestDays));

                //Map out joins
                //key - case
                //value - equipment
                mapOfJoins.put(futureCheckup,equipments);

                newRequests.add(futureCheckup);
                insertRequest = true;
            }
        }
        if(insertRequest){
            insert newRequests;

            //Add new joins
            List<Equipment_Maintenance_Item__c> listOfJoins = new List<Equipment_Maintenance_Item__c>();

            for(Case futureCheckup : mapOfJoins.keySet()){
                for(Product2 equipment : mapOfJoins.get(futureCheckup)){
                    Equipment_Maintenance_Item__c joinItem = new Equipment_Maintenance_Item__c();
                    joinItem.Maintenance_Request__c = futureCheckup.Id;
                    joinItem.Equipment__c = equipment.Id;
                    listOfJoins.add(joinItem);
                }
            }

            insert listOfJoins;
        }
    }
}