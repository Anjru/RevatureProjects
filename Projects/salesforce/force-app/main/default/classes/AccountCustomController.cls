public with sharing class AccountCustomController {
    public Account account { get; private set; }
    
    public AccountCustomController() {
        // Fetching a static account for demonstration (replace the Id with a valid one)
        account = [SELECT Id, Name, Industry, Phone FROM Account WHERE Id = '001Ru00000OiWGEIA3' LIMIT 1];
    }
    
}