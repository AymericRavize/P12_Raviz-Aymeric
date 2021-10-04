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
        String contractId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);//on découpe la requête pour récupérer l'id
        Contract thisContract = [SELECT Id FROM Contract WHERE Id = :contractId];//on cherche le contrat concerné
        
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());//on récupère le body dans une map
        
        for(String fieldName : params.keySet()) {//on parcourt le tableau obtenu
            
            thisContract.put(fieldName, params.get(fieldName));//on ajoute au contrat les champs à modifier (cette manière permert de n'envoyer que les champs à modifier)
        }
        update thisContract;
    }
}