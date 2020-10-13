public with sharing class AddPrimaryContact implements Queueable {
    private Contact cont;
    private String state;
    public AddPrimaryContact( Contact cont, String state) {
        this.cont = cont;
        this.state = state;
    }

    public void execute(QueueableContext context){
        List<Account> accounts = [SELECT Id, BillingState FROM Account WHERE BillingState =: this.state LIMIT 200];
        List<Contact> contacts = new List<Contact>();
        for(Account account: accounts){
            Contact cloned = cont.clone(false);
            cloned.AccountId = account.Id;
            contacts.add(cloned);
        }
        insert contacts;
    }
}