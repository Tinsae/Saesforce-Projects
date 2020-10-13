@isTest
public with sharing class WarehouseSyncScheduleTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @isTest static void testSchedule() {
        List<Product2> equipments = [SELECT ID FROM Product2];
        System.assert(equipments.size() == 0);
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest1', CRON_EXP, new WarehouseSyncSchedule()); 
        // Verify the scheduled job has not run yet.
        equipments = [SELECT ID FROM Product2];
        System.assertEquals(0, equipments.size(), 'Tasks exist before job has run');
        Test.stopTest();
        // Now that the scheduled job has executed,
        // check that our tasks were created
        //equipments = [SELECT ID FROM Product2];
        //System.assert(equipments.size() > 1);  
    }
}
