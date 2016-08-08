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
private class TesteClonarFuxoProjetoWizard {

    static testMethod void myUnitTest() {
		Test.startTest();
        
        Database.SaveResult result = null;
        Database.DeleteResult deleteresult = null;
        
        ProjetoWizard__c proj = new ProjetoWizard__c();
        proj.Name = 'proj 1';
        //INSERIR proj
        result =  Database.insert(proj);

        VersaoWizard__c versao = new VersaoWizard__c();
        versao.ProjetoWizard__c = proj.id;
        versao.Situacao__c = 'Em teste';
        result =  Database.insert(versao);

        List<Item__c> itens = new List<Item__c>();
        
		item__c componente = new Item__c();
		componente.RecordTypeId = [select Id from RecordType where Name = 'Componente' and SobjectType = 'Item__c'].Id;
        componente.Name ='Componente Legal';
        itens.add(componente);
        
        item__c equipamento = new Item__c();
        equipamento.RecordTypeId  = [select Id from RecordType where Name = 'Equipamento' and SobjectType = 'Item__c'].Id;
        equipamento.Name = 'Equipamento Legal';
        itens.add(equipamento);

        for(integer j = 0; j < 2; j++)
        {
	        Fluxo__c item = new Fluxo__c();
	        item.Name = 'Item 1' + j;
	        item.Versao__c = versao.Id;
	        
			//INSERIR ITEM 1
	        result =  Database.insert(item);
	        System.assert(result.isSuccess());
	        
	        //INSERIR TRADUÇÃO Inglês
	        TraducaoFluxo__c tradItemIng = new TraducaoFluxo__c();
	        tradItemIng.Fluxo__c = item.id;
	        tradItemIng.Name = 'Item 2 - ' + j;
	        tradItemIng.Linguagem__c = 'Inglês';
	        insert tradItemIng;
	        
	        List<CodigoFonte__c> codigosFluxo = new List<CodigoFonte__c>();
	        
	        for(integer i = 0; i < 2;i++)
	        {
	        	CodigoFonte__c codigo = new CodigoFonte__c();
	        	codigo.Codigo__c = 'string germano=teste;';
	        	codigo.Fluxo__c = item.id;
	        	
	        	codigosFluxo.add(codigo);
	        }
	        
			insert codigosFluxo;
	        
	        List<Parametro__c> parametros = new List<Parametro__c>();
	        
	        for(integer k = 0; k < 10; k++)
	        {
	        	//ISERE PARAMETRO
		        Parametro__c param = new Parametro__c();
		        param.name = 'Parametro_teste- ' + j + ' - ' + k;
		        param.Fluxo__c = item.id;
		        
		        parametros.add(param);
	        }
	        
	        insert parametros;
	        
	        List<CodigoFonte__c> codigos = new List<CodigoFonte__c>();
	        
	         for(integer k = 0; k < 10; k++)
	         {
	          	Parametro__c param = parametros[k];
	          	
		        //INSERE CODIGO FONTE 
		        CodigoFonte__c codigo = new CodigoFonte__c();
	        	codigo.Codigo__c = 'string germano=teste;';
	        	codigo.Parametro__c = param.id;
	        	
	        	codigos.add(codigo);
	         }
	         
	         insert codigos;
	         
	         List<TraducoesParametro__c> traducoesParam = new List<TraducoesParametro__c>();
	         
	         for(integer k = 0; k < 10; k++)
	         {
		        Parametro__c param = parametros[k];
		         //INSERIR TRADUÇÃO Inglês
		        TraducoesParametro__c tradParamIng = new TraducoesParametro__c();
		        tradParamIng.Parametro__c = param.id;
		        tradParamIng.Name = 'Parametro_teste- ' + j + ' - ' + k;
		        tradParamIng.Linguagem__c = 'Inglês';
		        traducoesParam.add( tradParamIng);
	         }
	         
	         insert traducoesParam;
			 List<ParametroOpcao__c> opcoes = new List<ParametroOpcao__c>();
			 for(integer k = 0; k < 10; k++)
	         {
	         	Parametro__c param = parametros[k];
	         	
				for(integer i = 0; i< 5; i++)
				{
					ParametroOpcao__c opt = new ParametroOpcao__c();
					opt.name = 'opt ' + i + ' - ' + j + ' - ' + k;
					opt.Parametro__c = param.id;
					opt.sequencia__c = i;
					
					opcoes.add(opt);
				/*
					TraducaoOpcaoParametro__c tradOptParamIng = new TraducaoOpcaoParametro__c();
			        tradOptParamIng.ParametroOpcao__c = opt.id;
			        tradOptParamIng.Name = 'Parametro_teste ' + i + '-' + j + ' - ' + k;
			        tradOptParamIng.Linguagem__c = 'Inglês';
			        
			        insert tradOptParamIng;*/
				}
	        }
	        
	        insert opcoes;
	        
	        //INSERE MATRIZ
	        List<MatrizLinha__c> novasLinhas = new List<MatrizLinha__c>();
	        
	        for(integer i = 0; i< 30;i++)
	        {
	        	MatrizLinha__c matrizLinha = new MatrizLinha__c();
	        	matrizLinha.ComponentePeca__c = componente.id;
	        	matrizLinha.Equipamento__c = equipamento.id;
	        	matrizLinha.Fluxo__c = item.id;
	        	
	        	novasLinhas.add(matrizLinha);
	        }
	        
	        insert novasLinhas;
	        
	        List<MatrizColuna__c> novasColunas = new List<MatrizColuna__c>();
	        
	        for(integer i = 0; i< parametros.size();i++)
	        {
	        	MatrizColuna__c matrizColuna = new MatrizColuna__c();
				matrizColuna.Parametro__c = parametros[i].id;
	        	matrizColuna.Fluxo__c = item.id;
	        	
	        	novasColunas.add(matrizColuna);
	        }
	        
	        insert novasColunas;
	        
	        List<MatrizResposta__c> respostas = new List<MatrizResposta__c>();
	        
	        for(integer i = 0; i < novasLinhas.size();i++)
	        {
	        	for(integer k = 0; k < novasColunas.size(); k++ )
	        	{
	        		MatrizResposta__c resp = new MatrizResposta__c();
	        		
	        		resp.MatrizLinha__c = novasLinhas[i].id;
	        		resp.MatrizColuna__c = novasColunas[k].id;
	        		resp.Resposta__c = 'Resposta Linha: ' + i + ', Coluna: ' + k;
	        		respostas.add(resp);
	        	}
	        }
	        
	        insert respostas;
	        
        }
        ///INSERE OPÇÃO PARA REALIZAR A CLONAGEM
        VersaoWizard__c origem = new VersaoWizard__c();
        origem.ProjetoWizard__c = proj.id;
        origem.VersaoOrigem__c = versao.id;
        
        result =  Database.insert(origem);
        
        Test.stopTest();
    }
}