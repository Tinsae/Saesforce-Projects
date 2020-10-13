({
    init: function(component, event, helper) {
        component.set("v.enableFullDetails", $A.get("e.force:navigateToSObject"));
    },
    onFullDetails: function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.boat.Id")
        });
        navEvt.fire();
    },    
    onBoatSelected : function(component, event, helper) {
        var boatSelected = event.getParam("boat");
        component.set("v.id", boatSelected.Id);
        var ldataService = component.find("service");
        ldataService.reloadRecord() ;
    },
    onRecordUpdated : function(component, event, helper){
        // record updated
        console.log('record updated');
        // let cmpBoatReviews = component.find("cmpBoatReviews");
        // cmpBoatReviews.refresh();
       
    },
    onBoatReviewAdded : function(component, event, helper) {
        component.find("tabs").set("v.selectedTabId", "boatreviewtab");
        let cmpBoatReviews = component.find("cmpBoatReviews");
        cmpBoatReviews.refresh();
    }
})