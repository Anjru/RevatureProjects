//  Implement an Apex class (called WarehouseCalloutService) that implements the queueable interface and makes 
    //  a callout to the external service used for warehouse inventory management.
    //  This service receives updated values in the external system and updates the related records in Salesforce. 
    //  Before checking this section, enqueue the job at least once to confirm that it's working as expected.

public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    // receives updated values in the external system and updates the related records in Salesforce
    public void execute(QueueableContext context) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(WAREHOUSE_URL);
        HttpResponse response = http.send(request);

        //If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200){
            // Deserialize the JSON string into collections of primitive data types.
            List<Object> equipments = (List<Object>) JSON.deserializeUntyped(response.getBody());
            List<Product2> upserts = new List<Product2>();

            for(Object o : equipments){
                Map<String, Object> item = (Map<String, Object>)o;
                Product2 equip = new Product2();
                equip.Replacement_Part__c = true;
                equip.Cost__c = (Decimal)item.get('cost');
                equip.Current_Inventory__c = (Decimal)item.get('quantity');
                equip.Name = (String)item.get('name');
                equip.Maintenance_Cycle__c = (Integer)item.get('maintenanceperiod');
                equip.Lifespan_Months__c = (Integer)item.get('lifespan');
                
                equip.Warehouse_SKU__c = (String)item.get('sku');
                upserts.add(equip);
            }

            if(!upserts.isEmpty()){
                upsert upserts Warehouse_SKU__c;
            }
        } else {
            System.debug('Callout Failed: ' + response.getStatusCode());
        }

    }
}