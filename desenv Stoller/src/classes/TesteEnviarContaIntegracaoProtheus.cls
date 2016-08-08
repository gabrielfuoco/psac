/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TesteEnviarContaIntegracaoProtheus {

    static testMethod void integrarConta() {
    	String msg01 = 'Conta enviada para integração com sucesso!';
    	String msg02 = 'Erro: Para integrar a Conta, o Status ERP precisa ser "Não Integrado".';
    	String msg03 = 'Erro: Para integrar a Conta, todos os campos obrigatórios devem estar preenchidos.';
    	
    	List<Account> listaContas = new List<Account>();
    	
    	Account canalCooperativa01 = new Account();
		canalCooperativa01.RecordTypeId = [select Id from RecordType where Name = 'Canal Cooperativa'].Id;
		canalCooperativa01.StatusERP__c = 'Não Integrado';
		canalCooperativa01.Name = 'CanalCooperativa01';
		canalCooperativa01.AccountSource = 'Site';
		canalCooperativa01.Rating = 'Parceiro';
		canalCooperativa01.PessoaFisicaJuridica__c = 'Pessoa Física';
		canalCooperativa01.NomeFantasia__c = 'CanalCooperativa01 ME';
		canalCooperativa01.PotencialVendasDolar__c = 10000;
		canalCooperativa01.PotencialVendasReais__c = 10000;
		canalCooperativa01.PrincipaisCulturas__c = 'Culturas';
		canalCooperativa01.NivelInfluenciaRegiao__c = 'Ótimo';
		listaContas.add(canalCooperativa01);
		
		Account canalCooperativa02 = new Account();
		canalCooperativa02.RecordTypeId = [select Id from RecordType where Name = 'Canal Cooperativa'].Id;
		canalCooperativa02.StatusERP__c = 'Não Integrado';
		canalCooperativa02.Name = 'CanalCooperativa02';
		canalCooperativa02.AccountSource = null;
		canalCooperativa02.Rating = null;
		canalCooperativa02.PessoaFisicaJuridica__c = null;
		canalCooperativa02.NomeFantasia__c = null;
		canalCooperativa02.PotencialVendasDolar__c = null;
		canalCooperativa02.PotencialVendasReais__c = null;
		canalCooperativa02.PrincipaisCulturas__c = null;
		canalCooperativa02.NivelInfluenciaRegiao__c = null;
		listaContas.add(canalCooperativa02);
		
		Account canalRevenda01 = new Account();
		canalRevenda01.RecordTypeId = [select Id from RecordType where Name = 'Canal Revenda'].Id;
		canalRevenda01.StatusERP__c = 'Não Integrado';
		canalRevenda01.Name = 'CanalRevenda01';
		canalRevenda01.AccountSource = 'Site';
		canalRevenda01.Rating = 'Parceiro';
		canalRevenda01.NomeFantasia__c = 'CanalRevenda01 ME';
		canalRevenda01.PotencialVendasDolar__c = 10000;
		canalRevenda01.PotencialVendasReais__c = 10000;
		canalRevenda01.NivelInfluenciaRegiao__c = 'Ótimo';
		listaContas.add(canalRevenda01);
		
		Account canalRevenda02 = new Account();
		canalRevenda02.RecordTypeId = [select Id from RecordType where Name = 'Canal Revenda'].Id;
		canalRevenda02.StatusERP__c = 'Não Integrado';
		canalRevenda02.Name = 'CanalRevenda02';
		canalRevenda02.AccountSource = null;
		canalRevenda02.Rating = null;
		canalRevenda02.NomeFantasia__c = null;
		canalRevenda02.PotencialVendasDolar__c = null;
		canalRevenda02.PotencialVendasReais__c = null;
		canalRevenda02.NivelInfluenciaRegiao__c = null;
		listaContas.add(canalRevenda02);
		
		Account influenciador01 = new Account();
		influenciador01.RecordTypeId = [select Id from RecordType where Name = 'Influenciador'].Id;
		influenciador01.StatusERP__c = 'Não Integrado';
		influenciador01.Name = 'Influenciador01';
		influenciador01.AccountSource = 'Site';
		influenciador01.Rating = 'Parceiro';
		influenciador01.PessoaFisicaJuridica__c = 'Pessoa Física';
		influenciador01.NivelInfluencia__c = 'Alto';
		influenciador01.StatusRelacionamento__c = 'Alto';
		influenciador01.NivelInfluenciaRegiao__c = 'Ótimo';
		influenciador01.TerritoriosAtrelados__c = 'Territórios';
		influenciador01.Industry = 'Bancos';
		listaContas.add(influenciador01);
		
		Account influenciador02 = new Account();
		influenciador02.RecordTypeId = [select Id from RecordType where Name = 'Influenciador'].Id;
		influenciador02.StatusERP__c = 'Não Integrado';
		influenciador02.Name = 'Influenciador02';
		influenciador02.AccountSource = null;
		influenciador02.Rating = null;
		influenciador02.PessoaFisicaJuridica__c = null;
		influenciador02.NivelInfluencia__c = null;
		influenciador02.StatusRelacionamento__c = null;
		influenciador02.NivelInfluenciaRegiao__c = null;
		influenciador02.TerritoriosAtrelados__c = null;
		influenciador02.Industry = null;
		listaContas.add(influenciador02);
		
		Account produtorCanal01 = new Account();
		produtorCanal01.RecordTypeId = [select Id from RecordType where Name = 'Produtor Canal'].Id;
		produtorCanal01.StatusERP__c = 'Não Integrado';
		produtorCanal01.Name = 'ProdutorCanal01';
		produtorCanal01.AccountSource = 'Site';
		produtorCanal01.Rating = 'Cliente';
		produtorCanal01.PotencialVendasDolar__c = 10000;
		produtorCanal01.PotencialVendasReais__c = 10000;
		produtorCanal01.DataUltimaCompraCliente__c = date.newInstance(2016, 5, 1);
		produtorCanal01.ProdutosCompradosStoller__c = 'Produtos';
		produtorCanal01.TerritoriosAtrelados__c = 'Territórios';
		produtorCanal01.AreaPlantio__c = 5000;
		produtorCanal01.NivelInfluenciaRegiao__c = 'Ótimo';
		listaContas.add(produtorCanal01);
		
		Account produtorCanal02 = new Account();
		produtorCanal02.RecordTypeId = [select Id from RecordType where Name = 'Produtor Canal'].Id;
		produtorCanal02.StatusERP__c = 'Não Integrado';
		produtorCanal02.Name = 'ProdutorCanal02';
		produtorCanal02.AccountSource = null;
		produtorCanal02.Rating = null;
		produtorCanal02.PotencialVendasDolar__c = null;
		produtorCanal02.PotencialVendasReais__c = null;
		produtorCanal02.DataUltimaCompraCliente__c = null;
		produtorCanal02.ProdutosCompradosStoller__c = null;
		produtorCanal02.TerritoriosAtrelados__c = null;
		produtorCanal02.AreaPlantio__c = null;
		produtorCanal02.NivelInfluenciaRegiao__c = null;
		listaContas.add(produtorCanal02);
		
		Account produtorStoller01 = new Account();
		produtorStoller01.RecordTypeId = [select Id from RecordType where Name = 'Produtor Stoller'].Id;
		produtorStoller01.StatusERP__c = 'Não Integrado';
		produtorStoller01.Name = 'ProdutorStoller01';
		produtorStoller01.AccountSource = 'Site';
		produtorStoller01.Rating = 'Cliente';
		produtorStoller01.PessoaFisicaJuridica__c = 'Pessoa Física';
		produtorStoller01.NomeFantasia__c = 'ProdutorStoller01 ME';
		produtorStoller01.PotencialVendasDolar__c = 10000;
		produtorStoller01.PotencialVendasReais__c = 10000;
		produtorStoller01.TerritoriosAtrelados__c = 'Territórios';
		produtorStoller01.NivelInfluenciaRegiao__c = 'Ótimo';
		listaContas.add(produtorStoller01);
		
		Account produtorStoller02 = new Account();
		produtorStoller02.RecordTypeId = [select Id from RecordType where Name = 'Produtor Stoller'].Id;
		produtorStoller02.StatusERP__c = 'Não Integrado';
		produtorStoller02.Name = 'ProdutorStoller02';
		produtorStoller02.AccountSource = null;
		produtorStoller02.Rating = null;
		produtorStoller02.PessoaFisicaJuridica__c = null;
		produtorStoller02.NomeFantasia__c = null;
		produtorStoller02.PotencialVendasDolar__c = null;
		produtorStoller02.PotencialVendasReais__c = null;
		produtorStoller02.TerritoriosAtrelados__c = null;
		produtorStoller02.NivelInfluenciaRegiao__c = null;
		listaContas.add(produtorStoller02);
		
		Account clienteIntegrar = new Account();
		clienteIntegrar.RecordTypeId = [select Id from RecordType where Name = 'Produtor Stoller'].Id;
		clienteIntegrar.StatusERP__c = 'Integrar';
		clienteIntegrar.Name = 'Cliente Integrar';
		listaContas.add(clienteIntegrar);
		
		insert listaContas;
		
    	Test.startTest();
    	
    	String info01 = EnviarContaIntegracaoProtheus.atualizarStatusERP(canalCooperativa01.Id);
		System.assertEquals(msg01, info01);
		
    	String info02 = EnviarContaIntegracaoProtheus.atualizarStatusERP(canalCooperativa02.Id);
		System.assertEquals(msg03, info02);
		
		String info03 = EnviarContaIntegracaoProtheus.atualizarStatusERP(canalRevenda01.Id);
		System.assertEquals(msg01, info03);
		
		String info04 = EnviarContaIntegracaoProtheus.atualizarStatusERP(canalRevenda02.Id);
		System.assertEquals(msg03, info04);
		
		String info05 = EnviarContaIntegracaoProtheus.atualizarStatusERP(influenciador01.Id);
		System.assertEquals(msg01, info05);
		
		String info06 = EnviarContaIntegracaoProtheus.atualizarStatusERP(influenciador02.Id);
		System.assertEquals(msg03, info06);
		
		String info07 = EnviarContaIntegracaoProtheus.atualizarStatusERP(produtorCanal01.Id);
		System.assertEquals(msg01, info07);
		
		String info08 = EnviarContaIntegracaoProtheus.atualizarStatusERP(produtorCanal02.Id);
		System.assertEquals(msg03, info08);
		
		String info09 = EnviarContaIntegracaoProtheus.atualizarStatusERP(produtorStoller01.Id);
		System.assertEquals(msg01, info09);
		
		String info10 = EnviarContaIntegracaoProtheus.atualizarStatusERP(produtorStoller02.Id);
		System.assertEquals(msg03, info10);
		
		String info11 = EnviarContaIntegracaoProtheus.atualizarStatusERP(clienteIntegrar.Id);
		System.assertEquals(msg02, info11);

    	Test.stopTest();   
    }
}