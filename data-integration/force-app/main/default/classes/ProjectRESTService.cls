@RestResource(urlMapping='/project/*')
global class ProjectRESTService {
    //Implement service logic here
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName,
        String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status) {
        Savepoint sp = Database.setSavePoint();
        try{
            Project__c proj = new Project__c();
            proj.ProjectRef__c = ProjectRef;
            proj.Name = ProjectName;
            proj.Opportunity__c = OpportunityId;
            proj.Start_Date__c =  StartDate;
            proj.End_Date__c = EndDate; 
            proj.Billable_Amount__c = Amount;
            proj.Status__c = Status;
            insert proj;
            if(OpportunityId != '' && OpportunityId != null){
                List<Opportunity> opps = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id =: OpportunityId];
                if(opps.size() > 0){
                    opps.get(0).DeliveryInstallationStatus__c = 'In Progress';
                    update opps;
                    return 'OK';
                }
            }
            Database.rollback(sp);
            return 'Error';
        }
        catch(Exception ex){
            Database.rollback(sp);
            return 'Error';
        }
    }   
}