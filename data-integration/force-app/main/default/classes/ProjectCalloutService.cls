public with sharing class ProjectCalloutService  {
    @InvocableMethod(label='Post Opportunity To PMS' description='Post Opportunity To PMS' category='Opportunity')
    public static void PostOpportunityToPMS(List<Id> oppIds) {
      if(oppIds.size() > 0){
        QueueablePMSCall qJob = new QueueablePMSCall(oppIds.get(0));
        ID jobID = System.enqueueJob(qJob);
      }
    }
    public class QueueablePMSCall implements Queueable, Database.AllowsCallouts { 
        private String oppId;
        public QueueablePMSCall(String oppId){
            this.oppId = oppId;
        }
        public void execute(QueueableContext context) {
            List<AsycStatus__c> statuses = new List<AsycStatus__c>();
            Opportunity opp = [SELECT Id, Name, Account.Name, CloseDate, Amount, StageName, Description FROM Opportunity WHERE Id =: oppId LIMIT 1];
            String access_token = ServiceTokens__c.getInstance('ProjectServiceToken').Token__c;
            statuses.add(new AsycStatus__c(Name='access_token', Details__c=access_token));
            Map<String, Object> mapToSerialize = new Map<String, Object>();
            mapToSerialize.put('opportunityId', opp.Id);
            mapToSerialize.put('opportunityName', opp.Name);
            mapToSerialize.put('accountName', opp.Account.Name);
            mapToSerialize.put('closeDate', opp.CloseDate);
            mapToSerialize.put('amount', opp.Amount);
            String jsonString = JSON.serialize(mapToSerialize);
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:ProjectService');
            request.setMethod('POST');
            request.setHeader('token', access_token);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody(jsonString);
            try{
                HttpResponse response = http.send(request);
                statuses.add(new AsycStatus__c(Name='status', Details__c=response.toString()));
                if (response.getStatusCode() == 201) {
                    opp.StageName = 'Submitted Project';
                    insert statuses;
                }
                else {
                    opp.StageName = 'Resubmit Project';
                }
                update opp;
            }
            catch(Exception ex){
                insert new AsycStatus__c(Name='error: ', Details__c=ex.getMessage());
            } 
        }
    }
}