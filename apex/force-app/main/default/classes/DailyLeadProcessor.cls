public with sharing class DailyLeadProcessor implements Schedulable{
    public void execute(SchedulableContext ctx) {
        // The execute method must find the first 200 Leads with a blank LeadSource field 
        List<Lead> leads = [SELECT Id FROM Lead WHERE LeadSource = null LIMIT 200];
        // and update them with the LeadSource value of 'Dreamforce'.
        for(Lead lead: leads){
            lead.LeadSource = 'Dreamforce';
        }
        update leads;
    }
}