@IsTest
private with sharing class AccountWebServiceTest {
  @isTest
  public static void testGET() {
    Id recordId = createTestAccount(); // return account.id and account.name = 'Test account'
    RestRequest request = new RestRequest();
    request.requestUri = 'https://epam144-dev-ed.lightning.force.com/services/apexrest/Account/';
    request.httpMethod = 'GET';
    RestContext.request = request; // что здесь происходит?
    Account acc = [
      SELECT name, id
      FROM Account
      WHERE id IN :AccountWebService.getAccounts() AND id = :recordId
    ];

    System.assert(acc != null);
    System.assertEquals(recordId, acc.id);
    System.assertEquals('Test account', acc.Name);
  }

  @isTest
  public static void testPOST() {
     Id recordId = createTestAccount(); 
    Account accountBeforePatch = [
      SELECT Id, name
      FROM Account
      WHERE Id = :recordId
    ];   
      
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://epam144-dev-ed.my.salesforce.com/services/apexrest/Account/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"name":'+ '"' + accountBeforePatch.name+ '"}');
        RestContext.request = request;
        
              
       ID accountId = AccountWebService.createAccount();
    
    Account account = [
      SELECT Id, name
      FROM Account
      WHERE Name = :accountBeforePatch.Name limit 1
    ];
    System.assert(accountId != null);      	
    System.assertEquals(account.name, 'Test account');
  }

  @isTest
  public static void testDELETE() {
    Id recordId = createTestAccount(); // return account.id and account.name = 'Test account'
    RestRequest request = new RestRequest();
    request.requestUri =
      'https://epam144-dev-ed.my.salesforce.com/services/apexrest/Account/' +
      recordId;
    request.httpMethod = 'DELETE';
    RestContext.request = request;
    AccountWebService.deleteAccount();
    List<Account> accounts = [SELECT Id FROM Account WHERE Id = :recordId];
    System.assert(accounts.size() == 0);
  }

  @isTest
  public static void testUPSERT() {
     Id recordId = createTestAccount(); 
    Account accountBeforePatch = [
      SELECT Id, Name
      FROM Account
      WHERE Id = :recordId
    ];      
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://epam144-dev-ed.my.salesforce.com/services/apexrest/Account/';
        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"name":'+ '"' + accountBeforePatch.name + '"}');
        RestContext.request = request;
                      
       ID accountId = AccountWebService.upsertAccount();
    System.assert(accountId != null);
    Account account = [
      SELECT Id, name
      FROM Account
      WHERE Id = :accountId
    ];
    System.assert(account != null);
    System.assertEquals(account.Name, accountBeforePatch.name + ' PUT_Test');
  }

  @isTest
  static void testPATCH() {
    Id recordId = createTestAccount(); 
    Account accountBeforePatch = [
      SELECT Id, isPatched__c
      FROM Account
      WHERE Id = :recordId
    ];
    System.assertEquals(accountBeforePatch.isPatched__c, false);
      
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://epam144-dev-ed.my.salesforce.com/services/apexrest/Account/';
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"id":'+ '"' + recordId+ '"}');
        RestContext.request = request;        
              
       ID accountId = AccountWebService.updateAccount();
    System.assert(accountId != null);
    Account account = [
      SELECT Id, isPatched__c
      FROM Account
      WHERE Id = :accountId
    ];
    System.assert(account != null);
    System.assertEquals(account.isPatched__c, true);
  }

  // Helper method
  public static Id createTestAccount() {
    Account account = new Account(name = 'Test account');
    insert account;
    return account.Id;
  }
}