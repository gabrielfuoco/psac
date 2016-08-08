public class InativarVersoesEmTeste
{
	@InvocableMethod
	public static void InativarTestes(List<VersaoWizard__c> versoes)
	{
		List<VersaoWizard__c> versoesAAtualizar = new List<VersaoWizard__c>();
		
		for(VersaoWizard__c versao : versoes)
		{
			List<VersaoWizard__c> versoesEmTeste = [select id, name, Situacao__c from VersaoWizard__c
													 where ProjetoWizard__r.id = :versao.ProjetoWizard__c
													   and id <> :versao.id
													   and Situacao__c = 'Em teste'];
													   
			for(integer i = 0; i < versoesEmTeste.size() ; i++)
			{
				versoesEmTeste[i].Situacao__c = 'Inativo';
			
				versoesAAtualizar.add(versoesEmTeste[i]);
			}
		}
		update versoesAAtualizar; 
	}
}