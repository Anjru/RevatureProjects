/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ClassDeliveryTests {

    @isTest
    static void testCreateDeliveryRecords() {
        // TO DO: implement unit test
        Integer size1;
        Integer size2;
        List<Class_Delivery__c> cd = [SELECT Id FROM Class_Delivery__c];
        size1 = cd.size();

        ClassDeliveryHelper.createDeliveryRecords();
        cd = [SELECT Id FROM Class_Delivery__c];

        size2 = cd.size();

        Assert.isTrue((size2-size1) == 1, 'Size should be greater by 1');

    }

    @isTest
    static void testDeleteRecords(){
        // TO DO: implement unit test
        Integer size1;
        Integer size2;
        List<Class_Delivery__c> cd = [SELECT Id FROM Class_Delivery__c];
        size1 = cd.size();

        ClassDeliveryHelper.createDeliveryRecords();
        cd = [SELECT Id FROM Class_Delivery__c];

        size2 = cd.size();

        Assert.isTrue((size2-size1) == 1, 'Size should be greater by 1');
    }

    @isTest
    static void testChangeCourse(){

    }



}