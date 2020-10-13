({
    doInit : function (component, event ,helper ) {
        var navEvt = $A.get("e.force:navigateToSObject");
        component.set("v.showFullDetails",true);
        if(!navEvt) {
            component.set("v.showFullDetails",false);
        }
    },
    onFullDetails : function(component, event, helper) {
        console.log(component.get("v.boat.Id"));
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.boat.Id"),
            "slideDevName": "detail"
        });
        navEvt.fire();
    }
})