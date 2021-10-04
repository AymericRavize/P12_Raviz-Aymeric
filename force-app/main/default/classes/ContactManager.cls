@RestResource(urlMapping='/Contact/*')
global with sharing class ContactManager {
@HttpPost
    global static ID createContact(String mail, String nom, String prenom, String tel) {
        //verifie que le contact existe ou non
        Contact[] contacts = [SELECT Id,Active__c FROM Contact WHERE Email = :mail LIMIT 1];
        Contact thisContact;
        if(contacts.size()==0){//si vide on crée un contact avec les données en paramètre
            thisContact = new Contact(FirstName=prenom, LastName=nom, Phone=tel, Email=mail, Active__c=true);
        insert thisContact;
        }else{//sinon on passe le contact en active dans le cas où il aurait été désactivé
            thisContact=contacts[0];
            thisContact.Active__c=true;
            update thisContact;
        }
        return thisContact.Id;
        //return JSON.serialize(thisContact.Id);
    }   
    @HttpPatch
    global static void updateContact() {
   
        RestRequest request = RestContext.request;//on recupère la requête
        String contacId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);//on découpe la requête pour récupérer l'id
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contacId];//on cherche le contact concerné
        
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());//on recupère le body dans une map
        
        for(String fieldName : params.keySet()) {//on parcourt le tableau obtenu
            
            thisContact.put(fieldName, params.get(fieldName));//on ajoute au contact les champs à modifier (cette manière permert de n'envoyer que les champs à modifier)
        }
        update thisContact;
              
    }
    @HttpDelete
    global static void deleteContact() {
        RestRequest request = RestContext.request;//on recupère la requête
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);//on découpe la requête pour récupérer l'id
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];//on cherche le contact concerné
        thisContact.Active__c=false;//on désactive le contact
    
        update thisContact;
    }     
}