public with sharing class MyAuraController {
    public MyAuraController() {

    }

    @AuraEnabled
    public static void createAccount(String name, String rating, String employees, String annualRevenue){
        try {
            Account acc = new Account(
                Name = name, 
                Rating = rating, 
                NumberOfEmployees = Integer.valueOf(employees), 
                AnnualRevenue = Decimal.valueOf(annualRevenue)
            );
            insert acc;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    

    
}