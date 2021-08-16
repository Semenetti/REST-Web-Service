@RestResource(urlMapping='/Account/*')
global with sharing class AccountWebService {
  @HttpGet
  global static List<Account> getAccounts() {
    List<Account> result = [SELECT Id, Name FROM Account];
    return result;
  }

  @HttpPost
  global static ID createAccount() {
    String accountName = request.requestURI.substring(
	RestRequest request = RestContext.request;
      request.requestURI.lastIndexOf('/') + 1
    );
    //Account acc = [SELECT Id FROM Account WHERE Id = :accountId];
	
    Account acc = new Account(Name = :accountName);
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
  global static ID upsertAccount(Id id, String name) {
    Account acc = new Account(id = id, Name = name);
    upsert acc;
    return acc.Id;
  }

  @HttpPatch
  global static ID updateAccount(id id) {
    // RestRequest request = RestContext.request;
    // String accId = request.requestURI.substring(
    //   request.requestURI.lastIndexOf('/') + 1
    // );
    // Account acc = [SELECT Id FROM Account WHERE Id = :accId];
    // Deserialize the JSON string into name-value pairs
    // Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(
    //   request.requestbody.tostring()
    // );
    // Iterate through each parameter field and value
    // for (String fieldName : params.keySet()) {
    // Set the field and value on the Case sObject
    //   thisCase.put(fieldName, params.get(fieldName));
    // }

    Account acc = [SELECT Id FROM Account WHERE Id = :id];
    acc.isPatched__c = true;
    update acc;
    return acc.Id;
  }
}
