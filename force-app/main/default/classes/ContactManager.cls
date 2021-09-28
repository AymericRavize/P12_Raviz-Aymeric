@RestResource(urlMapping='/Contact/*')
global with sharing class ContactManager {
@HttpPost
    global static ID createContact(String mail, String nom, String prenom, String tel) {
        Contact[] contacts = [SELECT Id,Active__c FROM Contact WHERE Email = :mail LIMIT 1];
        Contact thisContact;
        if(contacts.size()==0){//verifier la valeur de retour si vide
            thisContact = new Contact(FirstName=prenom, LastName=nom, Phone=tel, Email=mail, Active__c=true);
        insert thisContact;
        }else{
            thisContact=contacts[0];
            thisContact.Active__c=true;
            update thisContact;
        }
        return thisContact.Id;// le paser en json ?
        //return JSON.serialize(thisContact.Id);
    }   
    @HttpPatch
    global static void updateContact() {
   
        RestRequest request = RestContext.request;
        String contacId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contacId];
        
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        
        for(String fieldName : params.keySet()) {
            
            thisContact.put(fieldName, params.get(fieldName));
        }
        update thisContact;
              
    }
    @HttpDelete
    global static void deleteContact() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];
        thisContact.Active__c=false;
    
        update thisContact;
    }     
}