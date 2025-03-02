public with sharing class RestConsumeA {
    public RestConsumeA() {

    }
    
    public static String getAccessToken() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        String username = 'andrew.yang2022@wise-unicorn-egtpon.com';
        String password = 'Password123';
        String cId ='3MVG91oqviqJKoEEQXWW.lSxvmvPhYSSgz8ghgTX6BzpyRyxwSVY0Qsc8uZSwF5eSiInVQuYMPWXO6_8lRvk0';
        String cSecret = 'C0FADEED53CFD38572D3B1BB2AE6446D05A962AB9E3ECBAE847A7194BC57498F';

        // String authorizationCode = 'the_code_from_query_params'; // obtained from the redirect
        // String redirectUri = 'https://yourapp.example.com/oauth/callback'; // must match the one

        String body = 'grant_type=password'
            + '&client_id=' + EncodingUtil.urlEncode(cId, 'UTF-8')
            + '&client_secret=' + EncodingUtil.urlEncode(cSecret, 'UTF-8')
            + '&username=' + EncodingUtil.urlEncode(username, 'UTF-8')
            + '&password=' + EncodingUtil.urlEncode(password, 'UTF-8');
        req.setBody(body);

        // String body = 'grant_type=authorization_code'
        //     + '&code=' + EncodingUtil.urlEncode(authorizationCode, 'UTF-8')
        //     + '&client_id=' + EncodingUtil.urlEncode(CLIENT_ID, 'UTF-8')
        //     + '&client_secret=' + EncodingUtil.urlEncode(CLIENT_SECRET, 'UTF-8')
        //     + '&redirect_uri=' + EncodingUtil.urlEncode(REDIRECT_URI, 'UTF-8');
        // req.setBody(body);
        
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
        // req.setEndpoint('https://wise-unicorn-egtpon-dev-ed.my.salesforce.com/services/data/v55.0/sobjects/Contact/}');
        req.setEndpoint('https://wise-unicorn-egtpon-dev-ed.my.salesforce.com/services/apexrest/ContactAPI/');
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonBody);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('Response: ' + res.getBody());
    }
}