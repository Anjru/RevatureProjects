@isTest
global class WarehouseCalloutServiceMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        if (req.getMethod() == 'GET') {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"}]');
            res.setStatusCode(200);
            return res;
        } else {
            return null;
        }
    }
}
