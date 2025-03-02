global with sharing class RestConsumeB {
    global RestConsumeB() {

    }

    global static String getAccessToken() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        String username = 'andrew.yang2022@brave-impala-5ipiqn.com';
        String password = 'Password123';
        String cId = '3MVG91oqviqJKoEFX.ZynYX46BumEXtLCHMVT4qQ5JbzIxfuQK5LaGEjEeX5rWzXlHJrZguzLg9Kdbpm94qHy';
        String cSecret = '09959CDDB91091E6D32031F938528E4609533A3AC9F02F96A7CFFF5416617AE4';
        String securityToken = 'Wip0KmIuS9YETiY1q3IgXBHkv';


        String body = 'grant_type=password'
            + '&client_id=' + EncodingUtil.urlEncode(cId, 'UTF-8')
            + '&client_secret=' + EncodingUtil.urlEncode(cSecret, 'UTF-8')
            + '&username=' + EncodingUtil.urlEncode(username, 'UTF-8')
            + '&password=' + EncodingUtil.urlEncode(password, 'UTF-8');
        req.setBody(body);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        if (res.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            return (String) result.get('access_token');
        } else {
            throw new CalloutException('Failed to get access token: ' + res.getBody());
        }
    }

    
    global static void callExternalEndpoint(Contact sourceContact) {
        String accessToken = getAccessToken();
        System.debug('Access TOken: ' + accessToken);
        // String accessToken = '6Cel800Dbm00000IvFsw888bm000000HftBqLbtBBVzYgEMv73cCPegX07UzZNLmn6r1Uc73wdnMOl5V4G4tQgAVWB4ROxZZu6yIqzsHeC6';
        
        Map<String, Object> contactFields = new Map<String, Object>{
            'FirstName' => sourceContact.FirstName,
            'LastName'  => sourceContact.LastName,
            'Email'     => sourceContact.Email,
            'Phone'     => sourceContact.Phone
        };
        
        // Serialize the map to JSON.
        String jsonBody = JSON.serialize(contactFields);

        HttpRequest req = new HttpRequest();
        // Replace the endpoint URL with the one you need to call
        // req.setEndpoint('https://brave-impala-5ipiqn-dev-ed.salesforce.com/services/data/v55.0/sobjects/Contact/');
        // req.setEndpoint('https://brave-impala-5ipiqn-dev-ed.salesforce.com/services/apexrest/ContactAPI/');
        // req.setEndpoint('https://na1.salesforce.com/services/apexrest/ContactAPI/');
        req.setEndpoint('https://brave-impala-5ipiqn-dev-ed.trailblaze.my.salesforce.com/services/apexrest/ContactAPI/');
        req.setMethod('POST');
        
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonBody);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('Response: ' + res.getBody());
    }

    global static void callExternalBulkEndpoint(){
        //https://brave-impala-5ipiqn-dev-ed.trailblaze.my.salesforce.com/services/data/vXX.X/jobs/ingest/{jobId}/batches
            //Use jobId to grab 
        //https://yourInstance.salesforce.com/services/data/vXX.X/jobs/ingest/{jobId}
        String accessToken = getAccessToken();

        HttpRequest req = new HttpRequest();
        req.setMethod('PUT');
        req.setEndpoint('https://brave-impala-5ipiqn-dev-ed.trailblaze.my.salesforce.com/services/data/vXX.X/jobs/ingest/');

    }


}