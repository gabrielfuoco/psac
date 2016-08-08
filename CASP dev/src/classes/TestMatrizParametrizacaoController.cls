@isTest
public class TestMatrizParametrizacaoController {
	@isTest
    public static void TestarParametrizacao()
    {
        Database.SaveResult result = null;
        Database.DeleteResult deleteresult = null;
        
        ProjetoWizard__c proj = new ProjetoWizard__c();
        proj.Name = 'proj 1';
        //INSERIR proj
        result =  Database.insert(proj);
        
		VersaoWizard__c versao = new VersaoWizard__c();
        versao.ProjetoWizard__c = proj.id;
        
        result =  Database.insert(versao);
        
        
        Fluxo__c item = new Fluxo__c();
        item.Name = 'Item 1';
        item.Versao__c = versao.Id;
        
		//INSERIR ITEM 1
        result =  Database.insert(item);
        System.assert(result.isSuccess());
        
        List<Parametro__c> parametros = new List<Parametro__c>();
	        
        for(integer k = 0; k < 10; k++)
        {
            //ISERE PARAMETRO
            Parametro__c param = new Parametro__c();
            param.name = 'Parametro_teste- ' + k;
            param.Fluxo__c = item.id;
            
            parametros.add(param);
        }
        
        insert parametros;
        
        TraducoesParametro__c tradPort = new TraducoesParametro__c();
        tradPort.linguagem__c ='Português';
        tradPort.Parametro__c = parametros[0].id;
        tradPort.name = 'hue';
        insert tradPort;
        
        TraducoesParametro__c paTrad = [select id, name from TraducoesParametro__c where Parametro__r.id = :parametros[0].id
                                        and linguagem__c ='Português'];
        
        try
        {
            delete paTrad;
            
            system.assert(false);
        }catch(Exception ex)
        {
            system.assert(true);
        }
        
        Item__c equipamento = new Item__c();
        equipamento.Name = 'Item 12';
        equipamento.Descricao__c = 'Item 12 descrição';
        equipamento.RecordTypeId = Schema.SObjectType.Item__c.getRecordTypeInfosByName().get('Equipamento').getRecordTypeId();
        insert equipamento;
        
        Item__c componente = new Item__c();
        componente.Name = 'Item 1';
        componente.Descricao__c = 'Item 1 descrição';
        componente.RecordTypeId = Schema.SObjectType.Item__c.getRecordTypeInfosByName().get('Componente').getRecordTypeId();
        componente.Equipamento__c = equipamento.Id;
        insert componente;
        
        
        Test.startTest();
        
        
        /*******************************************************************************************************/
        
        ApexPages.StandardController stdMatriz = new ApexPages.StandardController(item);
		MatrizParametrizacaoController ctrl = new MatrizParametrizacaoController(stdMatriz);
		
        for(VincularParametros oparam : ctrl.vincularParametros)        
            oparam.selecionado = true;
        
        ctrl.salvarParametros();
        
        MatrizLinha__c linhaM = new MatrizLinha__c();
        linhaM.ComponentePeca__c = componente.Id;
        linhaM.Quantidade__c = 'Quantidade';
        linhaM.DescricaoComponentePeca__c = 'Desc com Peça';
        linhaM.Equipamento__c = equipamento.Id;
        linhaM.DescricaoEquipamento__c = 'Descricao Equipamento';  
        
        ctrl.cadComponente.Linha = linhaM;
        
        //Insert
        ctrl.salvarComponentes();
        
        //Update
        linhaM.DescricaoComponentePeca__c = 'Desc';
        
        MatrizLinha__c linha =  [select id, ComponentePeca__r.Name, Equipamento__r.Name, Quantidade__C
                                           from MatrizLinha__c where id = :linhaM.Id];
        
        ctrl.cadComponente.Linha = linha;
        ctrl.salvarComponentes();
        
        ctrl.linhaAcao = linhaM.Id;
        ctrl.cadComponente.Linha = linhaM;
        ctrl.excluirComponente();
        
        Test.stopTest();
    }
}