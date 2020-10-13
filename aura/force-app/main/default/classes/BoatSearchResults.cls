public with sharing class BoatSearchResults {
    @AuraEnabled
    public static List<Boat__c> getBoats(String boatTypeId){
        List<Boat__c> boats;
        String query = 
        'SELECT ID, Name, BoatType__c, Description__c'
            + ', Length__c, Picture__c, Price__c' 
            + ', Year_Built__c, Contact__r.Name'
            + ', Geolocation__latitude__s, Geolocation__longitude__s'
            + ' FROM Boat__c';
        if(boatTypeId != '' && boatTypeId != null){
            query += ' WHERE BoatType__c = :boatTypeId';
        }
        boats = Database.query(query);
        return boats;
    }
}
