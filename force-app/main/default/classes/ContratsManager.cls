@RestResource(urlMapping='/Contract/*')
global with sharing class ContratsManager {
@HttpPost
    global static ID createContract(Id accountId,Integer contractTerm, Date startDate, String status) {
        Contract thisContract = new Contract(AccountId=accountId, ContractTerm=contractTerm, StartDate=startDate, Status=status);
        insert thisContract;
        return thisContract.Id;
        // return JSON.serialize(thisContract.Id);
    }   
    @HttpPatch
    global static void updateContract() {
        
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contract thisContract = [SELECT Id FROM Contract WHERE Id = :contractId];
        
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        
        for(String fieldName : params.keySet()) {
            
            thisContract.put(fieldName, params.get(fieldName));
        }
        update thisContract;
    }
}