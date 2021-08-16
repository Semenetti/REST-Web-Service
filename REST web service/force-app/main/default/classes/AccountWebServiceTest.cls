@IsTest
private with sharing class AccountWebServiceTest {
  @isTest
  public static void testGET() {
    Id recordId = createTestAccount(); // return account.id and account.name = 'Test account'
    RestRequest request = new RestRequest();
    request.requestUri = 'https://epam144-dev-ed.my.salesforce.com/services/apexrest/Account/';
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
    ID accountId = AccountWebService.createAccount('Test account');
    System.assert(accountId != null);
    Account acc = [SELECT Name, Id FROM Account WHERE Id = :accountId];
    System.assert(acc != null);
    System.assertEquals(acc.Name, 'Test account');
  }

  @isTest
  public static void testDELETE() {
    Id recordId = createTestAccount(); // return account.id and account.name = 'Test account'
    RestRequest request = new RestRequest();
    request.requestUri =
      'https://epam144-dev-ed.my.salesforce.com/services/apexrest/Account/' +
      recordId;
    request.httpMethod = 'GET';
    RestContext.request = request;
    AccountWebService.deleteAccount();
    List<Account> accounts = [SELECT Id FROM Account WHERE Id = :recordId];
    System.assert(accounts.size() == 0);
  }

  @isTest
  public static void testUPSERT() {
    ID account1Id = AccountWebService.upsertAccount(null, 'test account');

    System.assert(account1Id != null);
    Account account1 = [SELECT Id, Name FROM Account WHERE Id = :account1Id];
    System.assert(account1 != null);
    System.assertEquals(account1.name, 'test account');

    ID account2Id = AccountWebService.upsertAccount(
      account1Id,
      'second test account'
    );
    System.assertEquals(account1Id, account2Id);
    Account account2 = [SELECT Id, name FROM Account WHERE Id = :account2Id];
    System.assert(account2 != null);
    System.assertEquals(account2.Name, 'second test account');
  }

  @isTest
  static void testPATCH() {
    Id recordId = createTestAccount(); // return account.id and account.name = 'Test account'
    Account accountBeforePatch = [
      SELECT Id, isPatched__c
      FROM Account
      WHERE Id = :recordId
    ];
    System.assertEquals(accountBeforePatch.isPatched__c, false);

    ID accountId = AccountWebService.updateAccount(recordId);
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
