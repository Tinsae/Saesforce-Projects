public with sharing class WarehouseCalloutService {
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    @future(callout=true)
    public static void runWarehouseEquipmentSync() {
        //ToDo: complete this method to make the callout (using @future) to the
        //      REST endpoint and update equipment on hand.
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            List<Product2> equipments = new List<Product2>();
            // System.debug(response.getBody());
             List<Object> jsonStrings =   (List<Object>) JSON.deserializeUntyped(response.getBody());
            for (Object jsonInput : jsonStrings) {
                Map<String, Object> parsedInput = (Map<String, Object>)jsonInput;
                Product2 prod = new Product2();
                prod.Warehouse_SKU__c  = (String) parsedInput.get('_id');
                prod.Cost__c = (Double) parsedInput.get('cost');
                prod.Lifespan_Months__c = (Integer) parsedInput.get('lifespan');
                prod.Maintenance_Cycle__c = (Integer) parsedInput.get('maintenanceperiod');
                prod.Name = (String) parsedInput.get('name');
                prod.Current_Inventory__c = (Integer) parsedInput.get('quantity');
                prod.Replacement_Part__c = (Boolean) parsedInput.get('replacement');
                // prod.StockKeepingUnit = (String) parsedInput.get('sku');
                equipments.add(prod);
            }
            upsert equipments Warehouse_SKU__c;
        }           
    }
}