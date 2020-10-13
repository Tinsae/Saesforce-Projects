({
    doInit : function(component, event, helper) {
        helper.onInit(component, event, helper);
    },
    
    onUserInfoClick : function(component, event, helper) {
        var targetSource = event.currentTarget;
        var userid = targetSource.dataset.userid;
        var navEvt = $A.get("e.force:navigateToSObject");
        if (navEvt) {
            navEvt.setParams({
                "recordId": userid,
                "slideDevName": "detail"
            });
            navEvt.fire();
        }
        
    }
})