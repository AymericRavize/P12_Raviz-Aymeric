@IsTest
private class ContactManagerTest {
   
    @isTest 
    static void testCreateContact() {
        // appelle la méthode à tester
        Test.startTest();

        ID thisContactId = ContactManager.createContact('mail@monmail.com','nom', 'prenom', '0546258486');
        Contact thisContact = [SELECT Id,FirstName,LastName,Phone,Email,Active__c FROM Contact WHERE Id=:thisContactId];
        //change la variable pour desactiver le contact
        thisContact.Active__c=false;
        update thisContact;
         //seconde insertion "duplicata"
        ID thisContactId2 = ContactManager.createContact('mail@monmail.com','nom', 'prenom', '0546258486');
        
        Test.stopTest();
        // vérifie le résultat
        System.assert(thisContactId != null);
        System.assert(thisContact != null);
        System.assertEquals(thisContact.FirstName, 'prenom');
        System.assertEquals(thisContact.LastName, 'nom');
        System.assertEquals(thisContact.Phone, '0546258486');
        System.assertEquals(thisContact.Email, 'mail@monmail.com');
        System.assertEquals(thisContact.Active__c, true);
        System.assertEquals(thisContactId, thisContactId2);

        // pas de duplicata
        List<Contact> mail = [SELECT Id FROM Contact WHERE Email ='mail@monmail.com'];
        System.assertEquals(mail.size(), 1);
    }
 

    @isTest 
    static void testDeleteContact() {
        Id recordId = createTestRecord();
        // prépare une requête de test
        RestRequest request = new RestRequest();
        request.requestUri ='https://yourInstance.my.salesforce.com/services/apexrest/Contact/'+ recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // appelle la méthode à tester
        Test.startTest();
        ContactManager.deleteContact();
        Test.stopTest();
        // verifie que nous avons désactivé le contact
        Contact contacts = [SELECT Id,Active__c FROM Contact WHERE Id=:recordId];
        System.assertEquals(contacts.Active__c , false);
    }
    
    @isTest
    static void testupdateContact() {
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri ='https://yourInstance.my.salesforce.com/services/apexrest/Contact/' + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"FirstName": "prenomModif"}');
        RestContext.request = request;
        Test.startTest();
        ContactManager.updateContact();
        Test.stopTest();
        // verifie que l'enregistrement est à jour
        Contact thisContact = [SELECT Id,FirstName,LastName,Phone,Email,Active__c FROM Contact WHERE Id=:recordId];
        System.assert(thisContact != null);
        System.assertEquals(thisContact.FirstName, 'prenomModif');
        System.assertEquals(thisContact.LastName, 'nom');
        System.assertEquals(thisContact.Phone, '0546258486');
        System.assertEquals(thisContact.Email, 'mail@monmail.com');
        System.assertEquals(thisContact.Active__c, true);
    }  
    
    static Id createTestRecord() {
        // Crée un enregistrement de test
        Contact contactTest = new Contact(FirstName='prenom', LastName='nom', Phone='0546258486', Email='mail@monmail.com', Active__c=true);
        insert contactTest;
        return contactTest.Id;
    }          
}