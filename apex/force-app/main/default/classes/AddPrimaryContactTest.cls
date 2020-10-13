@isTest
public with sharing class AddPrimaryContactTest {
    @testSetup 
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            accounts.add(new Account(Name='ny_acc' + i, BillingState='NY'));
        }
        for (Integer i = 0; i < 50; i++) {
            accounts.add(new Account(Name='ca_acc' + i, BillingState='CA'));
        }
        insert accounts;
    }
    @isTest
    static void testQueueable() {
        Contact cont = new Contact(LastName = 'someone');
        String state = 'CA';
        insert cont;
        // Create an instance of the AddPrimaryContact class, 
        AddPrimaryContact apc = new AddPrimaryContact(cont, state);
        Test.startTest();
        // enqueue the job 
        System.enqueueJob(apc);
        Test.stopTest();
        // and assert that a Contact record was inserted 
        // for each of the 50 Accounts with the BillingState of "CA".
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Account.BillingState = 'CA'];
        System.assertEquals(contacts.size(), 50);
    }
}