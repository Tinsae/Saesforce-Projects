public with sharing class BoatReviews {
    @AuraEnabled
    public static List<BoatReview__c> getAll (String boatId ) {
        
        List<BoatReview__c> boatReviews = [SELECT Id,Name,Comment__c, Rating__c, LastModifiedDate,
                                           CreatedDate, CreatedBy.Name, CreatedBy.Id,CreatedBy.SmallPhotoUrl,CreatedBy.CompanyName 
                                           from BoatReview__c WHERE Boat__c=:boatId];
 		return boatReviews;
    }
}
