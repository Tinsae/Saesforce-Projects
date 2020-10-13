@isTest
private class ProjectRESTServiceTest {
  // Implement Apex REST service tests here
  @TestSetup
  static void makeData(){
    Date cd = Date.newInstance(2020, 11, 11);
    Opportunity opp1 = new Opportunity(Name='test-opp1', Type='New Project', StageName='Qualification',CloseDate=cd);
    insert opp1;
  }
  @isTest
  public static void testPositive(){
    Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'test-opp1' LIMIT 1];
    List<Project__c> projects = [SELECT Id FROM Project__c];
    System.assert(projects.size() == 0);
    Date sDate = Date.newInstance(2020, 1, 1);
    Date eDate = Date.newInstance(2021, 1, 1);

    String response = ProjectRESTService.postProjectData('a-project', 'my-test-project', 
    (String) opp.Id, sDate, eDate, (Double) 300.55, 'Billable');
    System.assert(response == 'OK');
    projects = [SELECT Id, Opportunity__c FROM Project__c];
    System.assert(projects.size() == 1);
    System.assert(projects.get(0).Opportunity__c == opp.Id);
  }

  @isTest
  public static void testNegative(){
    Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'test-opp1' LIMIT 1];
    List<Project__c> projects = [SELECT Id FROM Project__c];
    System.assert(projects.size() == 0);
    Date sDate = Date.newInstance(2020, 1, 1);
    Date eDate = Date.newInstance(2021, 1, 1);
    String response = ProjectRESTService.postProjectData('a-project', 'my-test-project', 
    'wrong-opp-id', sDate, eDate, (Double) 300.55, 'Billable');
    System.assertEquals(response, 'Error');
  }
}