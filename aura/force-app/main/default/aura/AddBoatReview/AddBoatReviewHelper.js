({
    onInit: function (component, event) {
        // sObject Type: BoatReview__c
        // recordTypeId : null
        // cache: false
        component.find("service").getNewRecord(
            "BoatReview__c",
            null,
            false, 
            $A.getCallback(function () {
                let boatReview = component.get("v.boatReview");
                let error = component.get("v.recordError");
                let boat = component.get("v.boat");
                if (error || (boatReview === null)) {
                    console.log("Error initializing record template: " + error);
                } else {
                    //component.set("v.newBoatReview.Boat__c", boat.Id);
                    component.set("v.boatReview.Boat__c", boat.Id);
                }
            })
        );
    }
})