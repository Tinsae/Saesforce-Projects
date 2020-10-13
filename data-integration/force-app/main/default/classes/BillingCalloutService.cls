public class BillingCalloutService {
    public static Boolean getProjectId(List<Project__c> projects){
        if(projects.size() > 0){
            Project__c projectToUpdate = projects.get(0);
            if(projectToUpdate.Status__c == 'Billable'){
                return true;
            }
        }
        return false;
    }

    @future(callout=true)
    //Implement business and callout logic methods here
    public static void callBillingService(String projectId){
        String username = ServiceCredentials__c.getInstance('BillingServiceCredential').Username__c;
        String password = ServiceCredentials__c.getInstance('BillingServiceCredential').Password__c;
        List<Project__c> projects = [SELECT ProjectRef__c, Billable_Amount__c, Status__c FROM Project__c WHERE Id =: projectId];
        if(projects.size() > 0){
            Project__c pp = projects.get(0);
            if(pp.Status__c == 'Billable'){
                // do soap call
                BillingServiceProxy.InvoicesPortSoap11 ips = new  BillingServiceProxy.InvoicesPortSoap11();
                BillingServiceProxy.project project = new BillingServiceProxy.project();
                project.username = username;
                project.password = password;
                project.projectId = pp.ProjectRef__c;
                project.billAmount = pp.Billable_Amount__c;
                String response = ips.billProject(project);
                if(response == 'OK'){
                    pp.Status__c = 'Billed';
                }
                update pp;
            }
        }
    }
}