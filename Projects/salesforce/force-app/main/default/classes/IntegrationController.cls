public with sharing class IntegrationExtension {
    ApexPages.StandardController controller;
    String nameInput{get;set;}
    public IntegrationExtension(ApexPages.StandardController controller) {
        this.controller = controller;
        nameInput = '';
    }


    public String find(){
        Http http = new Http();
        HttpRequest request = new HTTPRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon/' + EncodingUtil.urlEncode(this.nameInput, 'UTF-8'));
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            return (String) results.get('value');
        } else {
            return 'Error';
        }
        
    }
}