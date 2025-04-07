public with sharing class AddPrimaryContact implements Queueable {
    
    Contact contact;
    String state; 

    public AddPrimaryContact(Contact con, String state) {
        this.contact = con;
        this.state = state;
    }

    //query 200 accounts w billing state
    //
    public void execute(QueueableContext qc){
        List<Account> accs = [SELECT Id FROM Account WHERE BillingState =: this.state];

        List<Contact> cons = new List<Contact>();

        for(Account acc : accs){
            Contact cloneContact = this.contact.clone(false);
            cloneContact.AccountId = acc.Id;
            cons.add(cloneContact);
        }

        insert(cons);
    }

    
}