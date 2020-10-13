trigger ProjectTrigger on Project__c (after update) {
    //Call the Billing Service callout logic here
    // simplified to work for one project only
    Boolean needsUpdate = BillingCalloutService.getProjectId(Trigger.new);
    if(needsUpdate){
        BillingCalloutService.callBillingService(Trigger.new.get(0).Id);
    }
}