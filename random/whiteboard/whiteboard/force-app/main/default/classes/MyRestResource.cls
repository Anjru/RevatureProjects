
@RestResource(urlMapping = '/Account/*')
global with sharing class MyRestResource {
    public MyRestResource() {

    }

    @HTTPGet
    global static Account getRecord(){

    }
}