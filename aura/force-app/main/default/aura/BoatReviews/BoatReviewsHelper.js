({
	onInit : function(component, event, helper) {
        var action = component.get("c.getAll");
        action.setParams({"boatId" : component.get("v.boat").Id });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {      
                var boatReviews = response.getReturnValue();
                component.set("v.boatReviews",boatReviews);
            }else if (state === "INCOMPLETE") {
                // show a toast or create a callback to control this state as well.
                console.log("Failed to connect Salesforce!!");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (!errors) {
                    errors = [{"message" : "Unknown Error Occured"}];
                }
                
                /*if(failureCallback){
                    failureCallback.call(this,errors);
                }*/
                
                console.log(errors);
            }
        });
        
        $A.enqueueAction(action);
	}
})
