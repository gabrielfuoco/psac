global with sharing class EnviarContaIntegracaoProtheus {
	
	webservice static String atualizarStatusERP (id contaId) {
		
		Account conta = [select RecordType.Name, RecordTypeId, Type, StatusERP__c, Name, AccountSource, Rating, PessoaFisicaJuridica__c, NomeFantasia__c,
							PotencialVendasDolar__c, PotencialVendasReais__c, PrincipaisCulturas__c, DataUltimaCompraCliente__c,
							NivelInfluenciaRegiao__c, NivelInfluencia__c, StatusRelacionamento__c, TerritoriosAtrelados__c,
							Industry, AreaPlantio__c, ProdutosCompradosStoller__c
    						from Account where id = :contaId];
        
        	
        if(conta.StatusERP__c == 'Não Integrado' || conta.StatusERP__c == 'Reprovado') {
        	
        	if(conta.RecordType.Name == 'Canal Cooperativa'){
        		
        		if(conta.Name != null && conta.AccountSource != null && conta.Rating != null && conta.PessoaFisicaJuridica__c != null && 
        			conta.NomeFantasia__c != null && conta.PotencialVendasDolar__c != null && conta.PotencialVendasReais__c != null && 
        			conta.PrincipaisCulturas__c != null && conta.NivelInfluenciaRegiao__c != null){
        			
        			conta.StatusERP__c = 'Integrar';
        			update conta;
        		}
        		else{
        			return 'Erro: Para integrar a Conta, todos os campos obrigatórios devem estar preenchidos.';
        		}
        	}
        	else if(conta.RecordType.Name == 'Canal Revenda'){
        		
        		if(conta.Name != null && conta.AccountSource != null && conta.Rating != null && conta.NomeFantasia__c != null && 
        			conta.PotencialVendasDolar__c != null && conta.PotencialVendasReais__c != null && 
        			conta.NivelInfluenciaRegiao__c != null){
        			
        			conta.StatusERP__c = 'Integrar';
        			update conta;
        		}
        		else{
        			return 'Erro: Para integrar a Conta, todos os campos obrigatórios devem estar preenchidos.';
        		}
        	}
        	else if(conta.RecordType.Name == 'Influenciador'){
        		
        		if(conta.Name != null && conta.AccountSource != null && conta.Rating != null && conta.PessoaFisicaJuridica__c != null && 
        			conta.NivelInfluencia__c != null && conta.StatusRelacionamento__c != null && 
        			conta.NivelInfluenciaRegiao__c != null && conta.TerritoriosAtrelados__c != null && conta.Industry != null){
        			
        			conta.StatusERP__c = 'Integrar';
        			update conta;
        		}
        		else{
        			return 'Erro: Para integrar a Conta, todos os campos obrigatórios devem estar preenchidos.';
        		}
        	}
        	else if(conta.RecordType.Name == 'Produtor Canal'){
        		
        		if(conta.Name != null && conta.AccountSource != null && conta.Rating != null && conta.PotencialVendasDolar__c != null && 
        			conta.PotencialVendasReais__c != null && conta.DataUltimaCompraCliente__c != null && conta.ProdutosCompradosStoller__c != null && 
        			conta.TerritoriosAtrelados__c != null &&
        			conta.AreaPlantio__c != null && conta.NivelInfluenciaRegiao__c != null){
        			
        			conta.StatusERP__c = 'Integrar';
        			update conta;
        		}
        		else{
        			return 'Erro: Para integrar a Conta, todos os campos obrigatórios devem estar preenchidos.';
        		}
        	}
        	else if(conta.RecordType.Name == 'Produtor Stoller'){
        		
        		if(conta.Name != null && conta.AccountSource != null && conta.Rating != null && conta.PessoaFisicaJuridica__c != null && 
        			conta.NomeFantasia__c != null && conta.PotencialVendasDolar__c != null && conta.PotencialVendasReais__c != null && 
        			conta.TerritoriosAtrelados__c != null && conta.NivelInfluenciaRegiao__c != null){
        			
        			conta.StatusERP__c = 'Integrar';
        			update conta;
        		}
        		else{
        			return 'Erro: Para integrar a Conta, todos os campos obrigatórios devem estar preenchidos.';
        		}
        	}
        }
        else {
        	return 'Erro: Para integrar a Conta, o Status ERP precisa ser "Não Integrado".';
        }			
		
		return 'Conta enviada para integração com sucesso!';
    }
}