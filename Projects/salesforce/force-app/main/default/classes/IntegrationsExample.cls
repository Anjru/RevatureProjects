
@RestResource(urlMapping='/AccountIntegration/*')
global with sharing class IntegrationsExample {
    public IntegrationsExample() {

    }

    @httpGet
    global static Account getAccount(){
        String accName = RestContext.request.params.get('name');
        Account acc = [SELECT AnnualRevenue FROM Account Where Name = :accName LIMIT 1];
        return acc;
    }

    @httpPost
    global static Account createAccount(){
        String accName = RestContext.request.params.get('name');
        Account acc = new Account(Name = accName);
        insert acc;
        return acc;
    }

    public static String getJoke(){
        Http http = new Http();
        HttpRequest request = new HTTPRequest();
        request.setEndpoint();
        request.setMethod();
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializedUntyped(response.getBody());
            return (String) results.get();
        }
    }

}