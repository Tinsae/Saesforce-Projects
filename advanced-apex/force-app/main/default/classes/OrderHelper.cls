public without sharing class OrderHelper {

    /**
     * @name AfterUpdate
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void AfterUpdate(List<Order> newList, List<Order> oldList){
        Set<Id> orderIds = new Set<Id>();
        for ( Integer i=0; i<newList.size(); i++ ){
            String activated = Constants.ACTIVATED_ORDER_STATUS;
            if ( newList[i].Status == activated && oldList[i].Status != activated ){
                orderIds.add(newList[i].Id);
            }
        }
        RollUpOrderItems(orderIds);
    }

    /**
     * @name RollUpOrderItems
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
    **/
    public static void RollUpOrderItems(Set<Id> activatedOrderIds){
        //ToDo: Declare a Map named "productMap" of Ids to Product2 records
        Map<Id, Product2> productMap = new Map<Id, Product2>();
        //ToDo: Loop through a query of OrderItems related to the activatedOrderIds
        for (OrderItem oi: [SELECT Id, Product2Id, Product2.Quantity_Ordered__c FROM OrderItem WHERE OrderId IN: activatedOrderIds]){
            //ToDo: Populate the map with the Id of the related Product2 as the key and Product2 record as the value
            Decimal currQty = oi.Product2.Quantity_Ordered__c;
            productMap.put(oi.Product2Id, new Product2(Id=oi.Product2Id, Quantity_Ordered__c=currQty));
        }   
        //ToDo: Loop through a query that aggregates the OrderItems related to the Products in the ProductMap keyset
        for(AggregateResult ag: [SELECT Product2Id, SUM(Quantity) qty FROM OrderItem WHERE Product2Id IN: ProductMap.keySet() GROUP BY Product2Id]){
            Id prodId = (Id) ag.get('Product2Id');
            Decimal total = (Decimal) ag.get('qty');
            Product2 prod = productMap.get(prodId);
            Decimal currQty = prod.Quantity_Ordered__c;
            prod.Quantity_Ordered__c = currQty + total;
        }
        //ToDo: Perform an update on the records in the productMap
        update ProductMap.values();
    }
} 