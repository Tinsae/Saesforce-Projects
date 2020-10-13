public with sharing class MaintenanceRequestHelper {
    /**
     * updateWorkOrders
     *
     * create a Routine Maintenance request every time a maintenance request of type Repair or
     * Routine Maintenance is updated to Closed
     * 
     * ## oldMap (Map<Id, Case>): oldMap
     * ## newMap (Map<Id, Case>): newMap
     */

    public static void updateWorkOrders(Map<Id, Case> oldMap, Map<Id, Case> newMap) {
        // TODO: Complete the method to update workorders
        System.debug('update work orders');
        List<String> closedCases =  new List<String>();
        for(String key: newMap.keySet()){
            List<String> allowedTypes = new List<String> {'Repair', 'Routine Maintenance'};
            Case oldCase = oldMap.get(key);
            String oldType = oldCase.Type;
            String oldStatus = oldCase.Status;               
            Case newCase = newMap.get(key);
            String newType = newCase.Type;
            String newStatus = newCase.Status;
            if(allowedTypes.contains(newType)){
                if(oldStatus != newStatus && newStatus == 'Closed'){
                    closedCases.add(key);
                }
            }
        }
        System.debug('Updated cases >' + closedCases);
        Map<String, List<Work_Part__c>> workMap = getWorkParts(closedCases);
        Map<String, Integer> minCycle = getMinimumMaintenanceCycle(workMap);
        createRoutineMaintenance(closedCases, newMap, minCycle);
    }
    
    public static Map<String, Integer> getMinimumMaintenanceCycle(Map<String, List<Work_Part__c>> workMap){
        List<String> closedCases = new List<String>(workMap.keySet());
        Map<String, Integer> minCycle = new Map<String, Integer>(); 
        List<AggregateResult> result = [SELECT Maintenance_Request__c, MIN(Equipment__r.Maintenance_Cycle__c) min FROM Work_Part__c WHERE Maintenance_Request__c IN :closedCases GROUP BY Maintenance_Request__c ];
        for(AggregateResult agg: result){
            minCycle.put((String)agg.get('Maintenance_Request__c'), Integer.valueOf(agg.get('min')));
        }
        return minCycle;
    }
    public static Map<String, List<Work_Part__c>>  getWorkParts(List<String> closedCases){
        Map<String, List<Work_Part__c>> workMap = new Map<String, List<Work_Part__c>>();
        List<Work_Part__c> workParts = [SELECT ID, Maintenance_Request__c, Equipment__r.Maintenance_Cycle__c FROM Work_Part__c WHERE Maintenance_Request__c IN :closedCases];
        for(Work_Part__c wp: workParts){
            if(!workMap.containsKey(wp.Maintenance_Request__c)){
                workMap.put(wp.Maintenance_Request__c, new List<Work_Part__c>());
            }
            else{
                workMap.get(wp.Maintenance_Request__c).add(wp);
            }
        }
        return workMap;
    }

    /**
     * createRoutineMaintenance
     * 
     * This new request's Type should be set as Routine Maintenance. 
     * The Subject should not be null and 
     * the Report Date field reflects the day the request was created. 
     * Another aspect about parts is they all have different lifespans. 
     * Therefore, you need to calculate and 
     * set the next due date using the maintenance cycle defined on the related work part records. 
     * If multiple work parts are used in the maintenance 
     * request, choose the shortest maintenance cycle to define the service date.
     * 
     * closedCases (List<String>): closedCases
     * ## newMap (Map<IdCase>): newMap
     * ## minCycle (Map<StringInteger>): minCycle
     */
    public static void createRoutineMaintenance( List<String> closedCases, Map<Id, Case> newMap,  Map<String, Integer> minCycle){
        List<Case> newCases = new List<Case>();
        for(String caseId: closedCases){
            Case theCase = newMap.get(caseId).clone(false);
            theCase.Status = 'New';
            theCase.Type = 'Routine Maintenance';
            if(String.isBlank(theCase.Subject)){
                theCase.Subject = 'Routine Maintenance Request';
            }
            theCase.Date_Reported__c = Date.today();
            Integer minimum = 1;
            if(minCycle.keySet().size() > 0){
                minimum = minCycle.get(caseId);
            }
            theCase.Date_Due__c = System.today() + minimum;
            newCases.add(theCase);
        }
        insert newCases;
    }
}        