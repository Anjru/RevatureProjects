@isTest
private class AnimalLocatorTest {

    @isTest
    static void testGetAnimalNameById_Success() {
        // Set the success mock
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        
        Test.startTest();
        String animalName = AnimalLocator.getAnimalNameById(1);
        Test.stopTest();
        
        System.assertEquals('majestic badger', animalName, 'The returned animal name is incorrect.');
    }
    
    @isTest
    static void testGetAnimalNameById_Failure() {
        // Set the failure mock
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorFailureMock());
        
        Test.startTest();
        String animalName = AnimalLocator.getAnimalNameById(999);
        Test.stopTest();
        
        // Since the failure mock returns 404, the method should return null.
        System.assertEquals(null, animalName, 'Expected null for a failed callout.');
    }
}