@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    @isTest static void testCallout() {
        List<Product2> equipments = [SELECT ID FROM Product2];
        System.assert(equipments.size() == 0);
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
        Test.startTest();
            WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
        equipments = [SELECT ID FROM Product2];
        System.assert(equipments.size() > 1);
    }
}