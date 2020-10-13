({
    doInit : function(component, event, helper) {
      
    },
    onFormSubmit : function(component, event, helper) {
        let cmpboatSearchResults = component.find("cmpboatSearchResults");
        let boatTypeId = event.getParam("formData").boatTypeId;
        cmpboatSearchResults.search(boatTypeId);
    }
})
