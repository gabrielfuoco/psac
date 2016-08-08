global with sharing class ConverterLead {
	
	@InvocableMethod
    public static void converterLeadConta(List<Id> accountIds)
    {
        List<Account> contas = [select Id, RecordTypeId, AccountSource, LeadContaHidden__c, LeadOrigemHidden__c from Account 
        						where Id = :accountIds];
 		

      	for (Account auxConta : contas) {
			auxConta.RecordTypeId = [select Id from RecordType where Name = :auxConta.LeadContaHidden__c ].Id;
            auxConta.AccountSource = auxConta.LeadOrigemHidden__c;
		}
		
        update contas;
    }
}