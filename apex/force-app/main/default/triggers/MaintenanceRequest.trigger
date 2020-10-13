trigger MaintenanceRequest on Case (after update) {
    MaintenanceRequestHelper.updateWorkOrders(Trigger.oldMap, Trigger.newMap);
}