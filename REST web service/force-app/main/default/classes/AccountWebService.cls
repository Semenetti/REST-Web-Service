@RestResource(urlMapping='/Account/*')
global with sharing class AccountWebService {
  @HttpGet
  global static List<Account> getAccounts() {
    List<Account> result = [SELECT Id, Name FROM Account];
    return result;
  }

//  @HttpPost
//  global static ID createAccount(String name) {
//    Account acc = new Account(Name = name);
//    insert acc;
//    return acc.Id;
//  }
	
  @HttpPost
  global static ID createAccount() {
    
     RestRequest request = RestContext.request;    
     Account acc = new Account();
     //Deserialize the JSON string into name-value pairs
     Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
       request.requestbody.tostring()
     );
    // Iterate through each parameter field and value
     for (String fieldName : params.keySet()) {
    // Set the field and value on the Account sObject
       acc.put(fieldName, params.get(fieldName));
     }      
 
    insert acc;
    return acc.Id;
  }
  

  @HttpDelete
  global static void deleteAccount() {
    RestRequest request = RestContext.request;
    String accountId = request.requestURI.substring(
      request.requestURI.lastIndexOf('/') + 1
    );
    Account acc = [SELECT Id FROM Account WHERE Id = :accountId];
    delete acc;
  }

   
  @HttpPut
  global static ID upsertAccount() {
    RestRequest request = RestContext.request;    
    
     //Deserialize the JSON string into name-value pairs
     Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
       request.requestbody.tostring()
     );
     Account acc = new Account();
    // Iterate through each parameter field and value
     for (String fieldName : params.keySet()) {
    // Set the field and value on the Account sObject
       acc.put(fieldName, params.get(fieldName));
     }      
      Account accToUpsert = [select name, id from Account where name =:acc.name];
      accToUpsert.name = accToUpsert.name + ' PUT_Test';
 
    upsert accToUpsert;
    return accToUpsert.Id;
  }

  @HttpPatch
  global static ID updateAccount() {
     RestRequest request = RestContext.request;    
    
     //Deserialize the JSON string into name-value pairs
     Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
       request.requestbody.tostring()
     );
     Account acc = new Account();
    // Iterate through each parameter field and value
     for (String fieldName : params.keySet()) {
    // Set the field and value on the Account sObject
       acc.put(fieldName, params.get(fieldName));
     }      

    Account accToPatch = [SELECT Id FROM Account WHERE Id = :acc.id];
    accToPatch.isPatched__c = true;
      
    update accToPatch;
    return accToPatch.Id;
  }
}