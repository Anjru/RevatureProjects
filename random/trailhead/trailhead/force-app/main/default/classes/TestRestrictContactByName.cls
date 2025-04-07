
@isTest
private class TestRestrictContactByName {

    @isTest
    static void myUnitTest() {
        // TO DO: implement unit test
        Contact con = new Contact(LastName = 'INVALIDNAME');
        Database.SaveResult result = Database.insert(con, false);
        Assert.areEqual(result.isSuccess(), false);
        //delete con;
    }
}