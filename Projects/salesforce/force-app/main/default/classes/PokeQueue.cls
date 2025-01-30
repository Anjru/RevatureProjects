public with sharing class PokeQueue implements Queueable{
    public String imageUrl;
    public String imageAlt;
    public PokeQueue() {
        imageUrl = '';
        imageAlt = '';
    }

    public PokeQueue(String iu, String ia) {
        this.imageUrl = iu;
        this.imageAlt = ia;
    }

    public void execute(QueueableContext qc) {
        Id runningUser = UserInfo.getUserId();
        User u = [SELECT Id, FirstName, LastName FROM User WHERE Id = :runningUser];
        u.imageUrl__c = imageUrl;
        update u;
    }



}