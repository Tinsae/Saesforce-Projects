({
    doInit: function (component, event, helper) {
        let getBoatTypes = component.get("c.getBoatTypes");
        getBoatTypes.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.boatTypes", response.getReturnValue());
            }
        });
        $A.enqueueAction(getBoatTypes);

        let isEnabled = $A.get("e.force:createRecord");
        if (isEnabled) {
            component.set("v.isEnabled", true);

        }
    },
    newBoat: function (component, event, helper) {
        let selValue = component.get("v.selectedValue");
        let createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Boat__c",
            "defaultFieldValues": {
                'BoatType__c' : selValue}
            });
        createRecordEvent.fire();
    },
    onFormSubmit: function (component, event, helper) {
        let fEvent = component.getEvent("formsubmit");
        let selValue = component.get("v.selectedValue");
        let formData = { "boatTypeId": selValue };
        fEvent.setParams({ "formData": formData });
        fEvent.fire();
    }
})
