({
    onSearch: function (component, boatTypeId) {
        let getBoats = component.get("c.getBoats");
        getBoats.setParams({ boatTypeId: boatTypeId });
        getBoats.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.boats", response.getReturnValue());
            }
        });
        $A.enqueueAction(getBoats);
    }
})
