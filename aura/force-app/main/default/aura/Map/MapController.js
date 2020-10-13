({
    onPlotMapMarker: function(component, event, helper) {
        let id = event.getParam("sObjectId");
        let latitude = event.getParam("lat");
        let longitude = event.getParam("long");
        let label = event.getParam("label");
        
        var mapContainer = component.find("map").getElement();
        var map = L.map(mapContainer).setView([latitude, longitude], 13);
        
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
			maxZoom: 19,
			attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
		}).addTo(map);

        L.marker([latitude, longitude]).addTo(map);
        component.set("v.location", {
            latitude: latitude,
            longitude: longitude
        });
    },
    jsLoaded: function(component) {
        component.set("v.jsLoaded", true);
    }
})
