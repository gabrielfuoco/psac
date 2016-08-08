@isTest
public class TestAccountTrigger {
	@isTest static void TesteBeforeInsertTrigger() 
    {
        Account acct = new Account(Name='Test Account');
		acct.IsLeadAcc__c = true;
        acct.RecordTypeId = [select Id from RecordType where Name = 'Pessoa Jurídica' and SobjectType = 'Account'].Id;
        acct.CNPJ__c = '25.181.646/0001-43';
        
        Test.startTest();

        Database.SaveResult result =  Database.insert(acct);

        Test.stopTest();

        System.assert(result.isSuccess());
        
    }

}