global with sharing class Schedule implements Schedulable{
    public Schedule() {

    }

    global void execute(SchedulableContext sc) {
        Batch b = new Batch();
        Database.executeBatch(b);
    }

}