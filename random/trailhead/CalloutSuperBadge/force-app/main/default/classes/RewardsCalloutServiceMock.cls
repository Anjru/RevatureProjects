global with sharing class RewardsCalloutServiceMock implements HttpCalloutMock{
    
    global HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        return res;
    }  
}