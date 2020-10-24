@isTest
private class OrderTests {
    @TestSetup
    static void SetupTestData(){
        TestDataFactory.InsertTestData(2);
    }
    @IsTest
    static void OrderUpdate_UnitTest(){
        Map<Id, Product2> origProds = new Map<Id, Product2>([SELECT Quantity_Ordered__c FROM Product2]);
        List<Order> orders = [SELECT AccountId, EffectiveDate, Status, Pricebook2Id FROM Order];
        for(Order o: orders){
            o.Status = Constants.ACTIVATED_ORDER_STATUS;
        }
        Test.startTest();
            UPDATE orders;
        Test.stopTest();
        Map<Id, Product2> updProds = new Map<Id, Product2>([SELECT Quantity_Ordered__c FROM Product2]);
        for(Id prodId: origProds.keySet()){
            TestDataFactory.VerifyQuantityOrdered(origProds.get(prodId), updProds.get(prodId), Constants.DEFAULT_ROWS);
        }
    }
}