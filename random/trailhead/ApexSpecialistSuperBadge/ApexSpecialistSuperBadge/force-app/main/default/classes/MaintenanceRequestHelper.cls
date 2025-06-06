public with sharing class MaintenanceRequestHelper {
    public MaintenanceRequestHelper() {

    }

    public static void upsertRequest(List<Case> requests){
        //List "newRequests" will store all the new Maintenance Request to be bulk inserted!
        List<Case> newRequests = new List<Case>();
        //Boolean insertRequest will determine if we perform an insert or an update for the list "newRequests"
        Boolean insertRequest = false;

        //Will Map all case ids with related equipment so we don't need to query everytime
        Map<Id, List<Product2>> mapEquipToMaintenance = new Map<Id, List<Product2>>();

        //Will Map Cases with related equipment to create the joins
        //NOTE: This might be redundant due to "mapEquipToMaintenance" being used
        Map<Case, List<Product2>> mapOfJoins = new Map<Case, List<Product2>>();

        //Set will store all Case Ids to be queried for related Equipment records (Junction Object)
        Set<Id> caseIds = new Set<Id>();
        for(Case c : requests){
            caseIds.add(c.Id);
        }

        //All Equipment_Maintenance Items
        //List listEquipmentMaintenance will store all related records (Equipment/Product)
        List<Equipment_Maintenance_Item__c> listEquipmentMaintenance = [SELECT Id, Equipment__c, Maintenance_Request__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :caseIds];
        
        //Set equipmentIds will store Ids of all related Equipment to query for the Equipment / Product
        Set<Id> equipmentIds = new Set<Id>();
        for(Equipment_Maintenance_Item__c eq : listEquipmentMaintenance){
            equipmentIds.add(eq.Equipment__c);
        }

        //List listEquipment will store all Equipment/Product
        List<Product2> listEquipment = [SELECT Id, Maintenance_Cycle__c FROM Product2 WHERE Id IN :equipmentIds];

        //Need to map out Maintenance Requests (case) with Equipmnet (Product2)
        //Iterate through cases
        for(Id caseId : caseIds){
            //The map holds a list of Product2 for it's Value
            //Will need to add this list
            List<Product2> relatedEquipment = new List<Product2>();

            //Iterate through related Equipment Maintenance Items (Junction object)
            //The junction object is needed to know how they are mapped (Request/Equipment)
            for(Equipment_Maintenance_Item__c junction : listEquipmentMaintenance){
                //Checks for related Junction Item to the current Case Id
                if(junction.Maintenance_Request__c == caseId){
                    // Add related equipment to the list
                    //Checks for related Equiment to the current junction item
                    for(Product2 e : listEquipment){
                        if(e.id == junction.Equipment__c){
                            relatedEquipment.add(e);
                        }
                    }
                }
            }
            //Insert the relatedEquipment List to the Map
            mapEquipToMaintenance.put(caseId, relatedEquipment);
        }


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

                //Stores shortest days
                Integer shortestDays = 0;

                //Retrieve list of related Equipment
                List<Product2> equipments = mapEquipToMaintenance.get(c.Id);

                //Calculates shortest days from related Equipment queried
                for(Product2 e : equipments){
                    if(Integer.valueOf(e.Maintenance_Cycle__c) < shortestDays || shortestDays == 0) {
                        shortestDays = Integer.valueOf(e.Maintenance_Cycle__c);
                    }
                }
                //Sets future date based on shortest day
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