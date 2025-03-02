@RestResource(urlMapping = '/ContactAPI/')
global with sharing class RestExposeA {
    global RestExposeA() {

    }

    @HTTPPost
    global static void addContact(){
        RestRequest req = RestContext.request;
        String jsonString = req.requestBody.toString();

        Map<String, Object> fields = (Map<String,Object>) JSON.deserializeUntyped(jsonString);
        String firstName = String.valueOf(fields.get('FirstName'));
        String lastName = String.valueOf(fields.get('LastName'));
        String email = String.valueOf(fields.get('Email'));
        String phone = String.valueOf(fields.get('Phone'));

        Contact con = new Contact(FirstName = firstName, LastName = lastName, Email = email, Phone = phone);

        insert con; 

        RestResponse res = RestContext.response;
        res.responseBody = Blob.valueOf('Contact Created');
        res.statusCode = 201;

    }

    @HTTPGet
    global static String test() {
        return 'Service reachable';
    }

}