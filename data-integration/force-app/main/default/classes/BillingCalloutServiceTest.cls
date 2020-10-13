@isTest
private class BillingCalloutServiceTest {
  @TestSetup
  static void makeData(){
    ServiceCredentials__c sc = new ServiceCredentials__c();
    sc.Name = 'BillingServiceCredential';
    sc.Username__c = 'bsUser1';
    sc.Password__c = 'bsPass1';
    insert sc;

    Date cd = Date.newInstance(2020, 11, 11);
    Opportunity opp1 = new Opportunity(Name='test-opp1', Type='New Project', StageName='Qualification',CloseDate=cd);
    insert opp1;
    Double amount = 500.55;
    Project__c proj = new Project__c(Name= 'my-test-project', Opportunity__c = opp1.Id, Status__c='Running', ProjectRef__c = '788999', Billable_Amount__c = amount);
    insert proj;
  }
  @isTest
  //Implement mock callout tests here
  public static void test1(){
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
    Project__c proj = [SELECT Status__c, ProjectRef__c, Billable_Amount__c FROM Project__c LIMIT 1];
    Test.startTest();
    proj.Status__c = 'Billable';
    update proj;
    Test.stopTest();
    proj = [SELECT Status__c, ProjectRef__c, Billable_Amount__c FROM Project__c LIMIT 1];
    System.assert(proj.Status__c == 'Billed');
  }
}