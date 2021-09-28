@IsTest
private class ContratsManagerTest {
   
    @isTest 
    static void testCreateContrat() {
        // Call the method to test
		Account acc =new Account(Name='accTest');
        insert acc;
        Date dt = Date.today();
        ID thisContractId = ContratsManager.createContract(acc.Id,1,dt,'Draft');
        // Verify results
        System.assert(thisContractId != null);
        Contract thisContract = [SELECT Id,AccountId,ContractTerm,StartDate,Status FROM Contract WHERE Id=:thisContractId];//id,p1,... 
        System.assert(thisContract != null);
        System.assertEquals(thisContract.AccountId, acc.Id);
        System.assertEquals(thisContract.ContractTerm, 1);
        System.assertEquals(thisContract.StartDate, dt);
        System.assertEquals(thisContract.Status, 'Draft');
        
    }
        
    @isTest
    static void testupdateContrat() {
        Date dt =Date.today();
        Account acc =new Account(Name='accTest');
        insert acc;
        Id recordId = createTestRecord(dt,acc);
        RestRequest request = new RestRequest();
        request.requestUri ='https://yourInstance.my.salesforce.com/services/apexrest/Contrat/' + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Status": "Activated"}');
        RestContext.request = request;
        //regarder si on peut faire sans retourner l id
        // Update status of existing record to Working
        ContratsManager.updateContract();
        // Verify record was updated
        Contract thisContract = [SELECT Id,AccountId,ContractTerm,StartDate,Status FROM Contract WHERE Id=:recordId]; 
        System.assert(thisContract != null);
        System.assertEquals(thisContract.AccountId, acc.Id);
        System.assertEquals(thisContract.ContractTerm, 1);
        System.assertEquals(thisContract.StartDate, dt);
        System.assertEquals(thisContract.Status, 'Activated');
    }  
    // Helper method
    static Id createTestRecord(Date dt,Account acc) {
        // Create test record
        Contract contratTest = new Contract(AccountId=acc.id,ContractTerm=1, StartDate=dt, Status='Draft');
        insert contratTest;
        return contratTest.Id;
    }          
}