public with sharing class RandomContactFactory {

    public static List<Contact> generateRandomContacts(Integer i, String s){
        List<Contact> randC = new List<Contact>();
        for(Integer j = 0; j < i; j++){
            Contact c = new Contact(firstName = math.random() + '', LastName = s);
            randC.add(c);
        }


        insert randC;

        return randC;
    }
}