@isTest
public with sharing class MaintenanceRequestHelperTest {
    @TestSetup
    public static void makeData(){
        // vehicle
        Vehicle__c v1 = new Vehicle__c(Name='test-vehicle-1');
        Vehicle__c v2 = new Vehicle__c(Name='test-vehicle-2');
        insert v1;
        insert v2;

        // equipment
        Product2 e1 = new Product2(Name='test-equipment-1', Replacement_Part__c = true, Maintenance_Cycle__c = 2);
        Product2 e2 = new Product2(Name='test-equipment-2', Replacement_Part__c = true, Maintenance_Cycle__c = 4);
        insert e1;
        insert e2;

        // maintenace request
        Case c1 = new Case(Type = 'Repair', Status = 'New', 
                            Origin = 'Web' , Equipment__c = e1.Id, 
                            Vehicle__c = v1.Id);
        Case c2 = new Case(Type = 'Routine Maintenance', Status = 'New', 
                            Origin = 'Web', Equipment__c = e2.Id, 
                            Vehicle__c = v2.Id);
        insert c1;
        insert c2;

        // work part
        Work_Part__c w1 = new Work_Part__c(Maintenance_Request__c = c1.Id, Equipment__c = e1.Id);
        Work_Part__c w2 = new Work_Part__c(Maintenance_Request__c = c2.Id, Equipment__c = e2.Id);
        Work_Part__c w3 = new Work_Part__c(Maintenance_Request__c = c1.Id, Equipment__c = e2.Id);
        Work_Part__c w4 = new Work_Part__c(Maintenance_Request__c = c2.Id, Equipment__c = e1.Id);
        
        insert w1;
        insert w2;
        insert w3;
        insert w4;
    }
    @isTest
    public static void test1(){
        List<Case> cases = [SELECT ID, Status FROM Case LIMIT 2];
        for(Case c : cases){
            c.Status = 'Closed';
        }
        Test.startTest();
            update cases;
        Test.stopTest();
        cases = [SELECT ID, Status FROM Case];
        System.assert(cases.size() == 4);
    }
}
