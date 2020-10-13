({
    
    doInit : function(component,event,helper) {
        // add related boat to boatreview record
        helper.onInit(component, event, helper);
    },
    
    onSave : function(component, event, helper) {
        component.find("service").saveRecord(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                var resultsToast = $A.get("e.force:showToast");
                if(resultsToast) {
                    resultsToast.setParams({
                        "title": "Saved",
                        "message": "The record was saved."
                    });
                    resultsToast.fire();
                } else {
                    alert("The record was not saved");
                }            
                let boatReviewEvent = component.getEvent("BoatReviewAdded");
                boatReviewEvent.fire();
                // reset the form so user can create another boat review
                helper.onInit(component, event, helper);
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving contact, error: ' + 
                            JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state +
                            ', error: ' + JSON.stringify(saveResult.error));
            }
        });
    },
    onRecordUpdated : function (component, event, helper ) {
        console.log('record is updated');
    }
})