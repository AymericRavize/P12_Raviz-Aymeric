@IsTest
private class ContactManagerTest {
   
    @isTest 
    static void testCreateContact() {
        // Call the method to test
        ID thisContactId = ContactManager.createContact('mail@monmail.com','nom', 'prenom', '0546258486');
        // Verify results
        System.assert(thisContactId != null);
        Contact thisContact = [SELECT Id,FirstName,LastName,Phone,Email,Active__c FROM Contact WHERE Id=:thisContactId];//id,p1,...
        System.assert(thisContact != null);
        System.assertEquals(thisContact.FirstName, 'prenom');
        System.assertEquals(thisContact.LastName, 'nom');
        System.assertEquals(thisContact.Phone, '0546258486');
        System.assertEquals(thisContact.Email, 'mail@monmail.com');
        System.assertEquals(thisContact.Active__c, true);
        //changement de la variable
        thisContact.Active__c=false;
        update thisContact;
        //seconde insertion
        thisContactId = ContactManager.createContact('mail@monmail.com','nom', 'prenom', '0546258486');
        // Verify results
        System.assert(thisContactId != null);
        thisContact = [SELECT Id,Active__c FROM Contact WHERE Id=:thisContactId];
        System.assertEquals(thisContact.Active__c, true);
        // pas de duplicata
        List<Contact> mail = [SELECT Id FROM Contact WHERE Email ='mail@monmail.com'];
        System.assertEquals(mail.size(), 1);
    }
    @isTest 
    static void testDeleteContact() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri ='https://yourInstance.my.salesforce.com/services/apexrest/Contact/'+ recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        ContactManager.deleteContact();
        // Verify record is deleted
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
        //regarder si on peut faire sans retourner l id
        // Update status of existing record to Working
        ContactManager.updateContact();
        // Verify record was updated
        Contact thisContact = [SELECT Id,FirstName,LastName,Phone,Email,Active__c FROM Contact WHERE Id=:recordId];
        System.assert(thisContact != null);
        System.assertEquals(thisContact.FirstName, 'prenomModif');
        System.assertEquals(thisContact.LastName, 'nom');
        System.assertEquals(thisContact.Phone, '0546258486');
        System.assertEquals(thisContact.Email, 'mail@monmail.com');
        System.assertEquals(thisContact.Active__c, true);
    }  
    // Helper method
    static Id createTestRecord() {
        // Create test record
        Contact contactTest = new Contact(FirstName='prenom', LastName='nom', Phone='0546258486', Email='mail@monmail.com', Active__c=true);
        insert contactTest;
        return contactTest.Id;
    }          
}