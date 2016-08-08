@isTest
public class TestTriggersIntegracao {
	@isTest
    public static void ExecutarTeste()
    {
        //TESTAR A EXCLUSÃO DE ITENS
        Database.SaveResult result = null;
        Database.DeleteResult deleteresult = null;
        
        Item__c item = new Item__c();
        item.Name = 'Item 1';
        item.Descricao__c = 'Item 1 descrição';
        
        result =  Database.insert(item);
        System.assert(result.isSuccess());
        
        deleteresult =  Database.delete(item.Id);
        System.assert(deleteresult.isSuccess());
        
        // TESTAR EXCLUSÃO CONTATO E CONTA
        
        Account acct = new Account(Name='Test Account');
		acct.IsLeadAcc__c = true;
        acct.RecordTypeId = [select Id from RecordType where Name = 'Pessoa Jurídica' and SobjectType = 'Account'].Id;
        acct.CNPJ__c = '25.181.646/0001-43';
        insert acct;
        
        Contact contato = new Contact();
        contato.LastName = 'Contato';
        contato.FirstName = 'Contato';
        contato.AccountId = acct.id;
        
        result =  Database.insert(contato);
        System.assert(result.isSuccess());
        
        deleteresult =  Database.delete(contato.Id);
        System.assert(deleteresult.isSuccess());
        
        deleteresult =  Database.delete(acct.Id);
        System.assert(deleteresult.isSuccess());
        
        //CAMPANHA
        Campaign camp = new Campaign();
        camp.Name = 'Campanha 1';
        
		result =  Database.insert(camp);
        System.assert(result.isSuccess());
        
        deleteresult =  Database.delete(camp.Id);
        System.assert(deleteresult.isSuccess());
        
        //OPORTUNIDADE
        Opportunity opt = new Opportunity();
        opt.Name = 'portunidae 1';
        opt.StageName = 'Avaliação';
        opt.CloseDate = Date.today();
        result =  Database.insert(opt);
        System.assert(result.isSuccess());
        
        deleteresult =  Database.delete(opt.Id);
        System.assert(deleteresult.isSuccess());
        
        //LEAD
        Lead le = new Lead();
        le.FirstName = 'Nome do Lead';
        le.LastName = 'Nome do Lead';
        le.Country = 'Brasil';
        le.City = 'São Paulo';
        le.State = 'Amazonas';
        le.MobilePhone = '(19)1111-1111';
        result =  Database.insert(le);
        System.assert(result.isSuccess());
        
        deleteresult =  Database.delete(le.Id);
        System.assert(deleteresult.isSuccess());
    }
}