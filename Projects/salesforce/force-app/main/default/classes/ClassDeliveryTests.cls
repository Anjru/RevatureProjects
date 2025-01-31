
@isTest
private class ClassDeliveryTests {

    @isTest
    static void testCreateDeliveryRecords() {
        Id idOfUser = UserInfo.getUserid();
        User user = [SELECT Alias, ProfileId FROM User WHERE Id = :idOfUser];
        System.runAs(user){
            Integer size1;
            Integer size2;
            List<Class_Delivery__c> cd = [SELECT Id FROM Class_Delivery__c];
            size1 = cd.size();

            ClassDeliveryHelper.createDeliveryRecords();
            cd = [SELECT Id FROM Class_Delivery__c];

            size2 = cd.size();

            Assert.isTrue((size2-size1) == 1, 'Size should be greater by 1');
        }

       

        // Profile lowProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        // User testUser = new User(
        //     Alias = 'lowprof',
        //     Email = 'lowprofileuser@test.com',
        //     EmailEncodingKey = 'UTF-8',
        //     LastName = 'TestUser',
        //     LanguageLocaleKey = 'en_US',
        //     LocaleSidKey = 'en_US',
        //     ProfileId = lowProfile.Id,
        //     TimeZoneSidKey = 'America/New_York',
        //     UserName = 'lowprofileuser@test.com'
        // );
        // insert testUser;

        // System.runAs(testUser){
        //     Integer size1;
        //     Integer size2;
        //     List<Class_Delivery__c> cd = [SELECT Id FROM Class_Delivery__c];
        //     size1 = cd.size();

        //     ClassDeliveryHelper.createDeliveryRecords();
        //     cd = [SELECT Id FROM Class_Delivery__c];

        //     size2 = cd.size();

        //     Assert.isFalse((size2-size1) == 1, 'Size should be greater by 1');
        // }
    }

    @isTest
    static void testDeleteRecords(){
        Id idOfUser = UserInfo.getUserid();
        User user = [SELECT Alias, ProfileId FROM User WHERE Id = :idOfUser];

        Class_Delivery__c classDel = new Class_Delivery__c(Course__c = 'old');
        insert classDel;

        System.runAs(user){
            Integer size1;
            Integer size2;
            List<Class_Delivery__c> cd = [SELECT Id FROM Class_Delivery__c];
            Class_Delivery__c classD = cd[0];

            size1 = cd.size();

            ClassDeliveryHelper.deleteDeliveryRecords(classD.Id);
            cd = [SELECT Id FROM Class_Delivery__c];

            size2 = cd.size();

            Assert.isTrue((size1-size2) == 1, 'Size should be less by 1');
        }
    }

    @isTest
    static void testChangeCourse(){
        Id idOfUser = UserInfo.getUserid();
        User user = [SELECT Alias, ProfileId FROM User WHERE Id = :idOfUser];
        Class_Delivery__c classDel = new Class_Delivery__c(Course__c = 'old');
        insert classDel;

        System.runAs(user){

            ClassDeliveryHelper.changeCourse(classDel.Id, 'new');
            
            classDel = [SELECT Id, Course__c FROM Class_Delivery__c WHERE Id = :classDel.Id LIMIT 1];

            Assert.isTrue(classDel.Course__c == 'new', 'Change did not occur');
        }

        // Profile lowProfile = [SELECT Id FROM Profile WHERE Name = 'Trial Customer Portal User' LIMIT 1];
        // User testUser = new User(
        //     Alias = 'lowprof',
        //     Email = 'lowprofileuser@test.com',
        //     EmailEncodingKey = 'UTF-8',
        //     LastName = 'TestUser',
        //     LanguageLocaleKey = 'en_US',
        //     LocaleSidKey = 'en_US',
        //     ProfileId = lowProfile.Id,
        //     TimeZoneSidKey = 'America/New_York',
        //     UserName = 'lowprofileuser@test.com'
        // );
        // insert testUser;

        // Class_Delivery__c classDel2 = new Class_Delivery__c(Course__c = 'old');
        // insert classDel2;

        // Schema.ObjectResult 

        // System.runAs(testUser){

        //     ClassDeliveryHelper.changeCourse(classDel2.Id, 'new');
            
        //     classDel2 = [SELECT Id, Course__c FROM Class_Delivery__c WHERE Id = :classDel2.Id LIMIT 1];

        //     Assert.isTrue(classDel2.Course__c == 'old', 'Change did not occur');
        // }
        

    }



}