({
    doInit : function(component, event, helper) {
        helper.onSearch(component, "");
    },
    doSearch : function(component, event, helper) {
        let args = event.getParam("arguments");
        let boatTypeId = args.boatTypeId;
        helper.onSearch(component, boatTypeId);
    },
    onBoatSelect : function(component, event, helper) {
        let boatId = event.getParam("boatId");
        component.set("v.selectedBoatId", boatId);
    }
})
