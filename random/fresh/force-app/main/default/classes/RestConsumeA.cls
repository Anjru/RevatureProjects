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

        String body = 'grant_type=password'
            + '&client_id=' + EncodingUtil.urlEncode('YOUR_CLIENT_ID', 'UTF-8')
            + '&client_secret=' + EncodingUtil.urlEncode('YOUR_CLIENT_SECRET', 'UTF-8')
            + '&username=' + EncodingUtil.urlEncode('YOUR_USERNAME', 'UTF-8')
            + '&password=' + EncodingUtil.urlEncode('YOUR_PASSWORD', 'UTF-8');
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
}