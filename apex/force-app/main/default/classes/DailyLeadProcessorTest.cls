@isTest
public with sharing class DailyLeadProcessorTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @isTest
    public static void test1(){
        // In the test class, insert 200 Lead records, 
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            leads.add(new Lead(Company = 'comp' + i , LastName='someone', Status='Open - Not Contacted'));
        }
        insert leads;
        // List<String> leadIds = new List<String>();
        // for(Lead lead : leads){
        //     leadIds.add(lead.Id);
        // }
        // schedule the DailyLeadProcessor class to run and test that all Lead records were updated correctly.
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new DailyLeadProcessor());         
        Test.stopTest();

        List<Lead> dreamForceLeads = [SELECT Id FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.assertEquals(dreamForceLeads.size(), 200);
    }
}