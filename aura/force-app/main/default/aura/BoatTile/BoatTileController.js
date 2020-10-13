({
    onBoatClick : function(component, event, helper) {
        let boat = component.get("v.boat");

        let boatEvent = component.getEvent("boatselected");
        boatEvent.setParams({ "boatId": boat.Id });
        boatEvent.fire();

        let boatEvent2 =  $A.get("e.c:BoatSelected");
        boatEvent2.setParams({ "boat": boat});
        boatEvent2.fire();
        let boatEvent3 =  $A.get("e.c:PlotMapMarker");
        console.log(boat.Geolocation__Latitude__s);
        console.log(boat.Geolocation__Longitude__s);
        boatEvent3.setParams({
            "sObjectId": boat.Id,
            "lat": boat.Geolocation__Latitude__s,
            "long": boat.Geolocation__Longitude__s,
            "label": boat.Name
        });
        boatEvent3.fire();
    }
})
