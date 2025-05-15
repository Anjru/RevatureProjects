public with sharing class MaintenanceRequestHelper {

    public static void upsertRequest(List<Case> requests){
        List<Case> newRequests = new List<Case>();
        Boolean insertRequest = false;

        List<List<Product2>> joinTargets = new List<List<Product2>>();

        //Get Ids of relevant cases
        Set<Id> caseIds = new Set<Id>();
        for(Case c : requests){
            if (c.Subject == 'Routine Checkup') {
                continue;
            }
            if((c.Type == 'Repair' || c.Type == 'Routine Maintenance') && c.Status == 'Closed'){
                caseIds.add(c.Id);
            }
        }

        //Queries from junction obj between Equipments / requests (EMT)
        Map<Id, List<Id>> caseToEquipIds = new Map<Id, List<Id>>();
        for(Equipment_Maintenance_Item__c e : [
            SELECT Maintenance_Request__c, Equipment__c 
            FROM Equipment_Maintenance_Item__c 
            WHERE Maintenance_Request__c IN :caseIds
        ]) {
            if (!caseToEquipIds.containsKey(e.Maintenance_Request__c)) {
                caseToEquipIds.put(e.Maintenance_Request__c, new List<Id>());
            }
            caseToEquipIds.get(e.Maintenance_Request__c).add(e.Equipment__c);
        }

        //Flatten equipment ids
        Set<Id> allEquipIds = new Set<Id>();
        for(List<Id> ids : caseToEquipIds.values()) {
            allEquipIds.addAll(ids);
        }

        //Queries related Equipment records
        Map<Id, Product2> equipMap = new Map<Id, Product2>(
            [SELECT Id, Maintenance_Cycle__c FROM Product2 WHERE Id IN :allEquipIds]
        );

        //Create new request when old is closed
        for(Case c : requests){
            if (c.Subject == 'Routine Checkup') {
                continue;
            }
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

                //Will hold Ids of related "equipment/product"
                    //Needed to query Equipment records
                List<Id> equipmentIds = caseToEquipIds.get(c.Id);
                List<Product2> equipments = new List<Product2>();
                if (equipmentIds != null) {
                    for(Id equipId : equipmentIds){
                        Product2 e = equipMap.get(equipId);
                        if (e != null) {
                            equipments.add(e);
                            if(Integer.valueOf(e.Maintenance_Cycle__c) < shortestDays || shortestDays == 0) {
                                shortestDays = Integer.valueOf(e.Maintenance_Cycle__c);
                            }
                        }
                    }
                }

                futureCheckup.Date_Due__c = Date.today().addDays(Integer.valueOf(shortestDays));

                //Map out joins
                newRequests.add(futureCheckup);
                joinTargets.add(equipments);

                insertRequest = true;
            }
        }

        if(insertRequest){
            insert newRequests;

            //Add new joins
            List<Equipment_Maintenance_Item__c> listOfJoins = new List<Equipment_Maintenance_Item__c>();

            for (Integer i = 0; i < newRequests.size(); i++) {
                Case futureCheckup = newRequests[i];
                List<Product2> equipmentList = joinTargets[i];
                if (equipmentList == null) continue;

                for (Product2 equipment : equipmentList) {
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
