@IsTest
private class ContratsManagerTest {
   
    @isTest 
    static void testCreateContrat() {
        // apelle la méthode à tester
		Account acc =new Account(Name='accTest');
        insert acc;
        Date dt = Date.today();
        Test.startTest();
        ID thisContractId = ContratsManager.createContract(acc.Id,1,dt,'Draft');
        Test.stopTest();
        // verifie que nous avons bien enregistré le contrat
        System.assert(thisContractId != null);
        Contract thisContract = [SELECT Id,AccountId,ContractTerm,StartDate,Status FROM Contract WHERE Id=:thisContractId];
        System.assert(thisContract != null);
        System.assertEquals(thisContract.AccountId, acc.Id);
        System.assertEquals(thisContract.ContractTerm, 1);
        System.assertEquals(thisContract.StartDate, dt);
        System.assertEquals(thisContract.Status, 'Draft');
        
    }
        
    @isTest
    static void testupdateContrat() {
        //on crée les variables et objets permettant le test 
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
        //apelle la fonction à tester
        Test.startTest();
        ContratsManager.updateContract();
        Test.stopTest();
        // verifie que les données sont celles attendues 
        Contract thisContract = [SELECT Id,AccountId,ContractTerm,StartDate,Status FROM Contract WHERE Id=:recordId]; 
        System.assert(thisContract != null);
        System.assertEquals(thisContract.AccountId, acc.Id);
        System.assertEquals(thisContract.ContractTerm, 1);
        System.assertEquals(thisContract.StartDate, dt);
        System.assertEquals(thisContract.Status, 'Activated');
    }  

    static Id createTestRecord(Date dt,Account acc) {
        // crée un contrat
        Contract contratTest = new Contract(AccountId=acc.id,ContractTerm=1, StartDate=dt, Status='Draft');
        insert contratTest;
        return contratTest.Id;
    }          
}