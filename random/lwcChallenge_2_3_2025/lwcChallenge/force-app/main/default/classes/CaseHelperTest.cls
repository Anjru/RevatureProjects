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
private class CaseHelperTest {

    @isTest
    static void getOpenCaseTest() {
        // Tests a single record
        Case a  = new Case(Subject='a', Status='New', Priority='Low');
        insert a;
        List<Case> b = CaseHelper.getOpenCases();
        Assert.areEqual(1,b.size());

        // Tests 10 more records - should retrieve 11 after(previous included)

        //insert 10 records
        List<Case> c = new List<Case>();
        for(Integer i = 0; i < 10; i++){    
            c.add(new Case(Subject=String.valueOf(i)));
        }

        insert c;

        //Should return 11
        b = CaseHelper.getOpenCases();

        Assert.areEqual(11,b.size());

    }
}