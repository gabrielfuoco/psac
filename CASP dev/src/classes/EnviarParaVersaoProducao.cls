global with sharing class EnviarParaVersaoProducao {
    
    webservice static string enviarProducao(id versaoId) {
		VersaoWizard__c versao = [select id, name, situacao__c, ProjetoWizard__r.id
    									from VersaoWizard__c where id = :versaoId];
        
        if(versao.situacao__c == 'Em produção')
        	return 'Erro: A versão já se encontra em produção.';
        	
        if(versao.situacao__c == 'Inativo')
        	return 'Erro: Não é possível enviar versão para produção, pois a mesma encontra-se inativa.';
        				
 		List<VersaoWizard__c> oldProd = [select id, name, situacao__c, ProjetoWizard__r.id from VersaoWizard__c 
    									where ProjetoWizard__r.id = :versao.ProjetoWizard__r.id and
										situacao__c = 'Em produção'];
		
		for(VersaoWizard__c oldVersion : oldProd)
		{
			oldVersion.situacao__c = 'Inativo';
			update oldVersion;
		}
		
		List<UsuarioVersao__c> usuariosTestersOld = [select id, name from UsuarioVersao__c where Versao__r.id in :oldProd ];
		
		if(usuariosTestersOld.size() > 0)
			delete usuariosTestersOld;
		
		versao.situacao__c = 'Em produção';
		versao.DataLiberacao__c = dateTime.now();
		
		update versao;
		
		return 'Versão ativada com sucesso!';
		
    }
}