public with sharing class BoatSearchForm {
    @AuraEnabled
    public static List<BoatType__c> getBoatTypes(){
        List<BoatType__c> boatTypes =
         [SELECT 
            ID, 
            Name
        FROM BoatType__c];
        return boatTypes;
    }
}
