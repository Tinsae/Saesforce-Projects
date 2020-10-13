@isTest
private class ProjectCalloutServiceTest  {
  @TestSetup
  static void makeData(){
    ServiceTokens__c st = new ServiceTokens__c(name = 'ProjectServiceToken', Token__c = 'test-service-token');
    insert st;
    
    Date cd = Date.newInstance(2020, 11, 11);
    Opportunity opp1 = new Opportunity(Name='test-opp1', Type='New Project', StageName='Qualification',CloseDate=cd);
    insert opp1;
  }
  //Implement mock callout tests here
  @isTest static void testPositive() {
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
    Opportunity opp = [SELECT Id, Name, CloseDate, StageName FROM Opportunity LIMIT 1];
    Test.startTest();
      opp.StageName = 'Closed Won';
      update opp;
    Test.stopTest();
    opp = [SELECT Id, Name, CloseDate, StageName FROM Opportunity LIMIT 1];
    System.assertEquals(opp.StageName, 'Submitted Project');
  }
  @isTest static void testNegative() {
    // Set mock callout class 
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());  
    Opportunity opp = [SELECT Id, Name, CloseDate, StageName FROM Opportunity LIMIT 1];
    Test.startTest();
      opp.StageName = 'Closed Won';
      update opp;
    Test.stopTest();
    opp = [SELECT Id, Name, CloseDate, StageName FROM Opportunity LIMIT 1];
    System.assertEquals(opp.StageName, 'Resubmit Project');
  }
}