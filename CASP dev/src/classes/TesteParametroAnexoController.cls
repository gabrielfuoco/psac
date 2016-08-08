@isTest
public class TesteParametroAnexoController {
    static testMethod void Testar()
    {
        
        ProjetoWizard__c proj = new ProjetoWizard__c();
        proj.Name = 'proj 1';
        //INSERIR proj
        Database.Upsert(proj);
        
		VersaoWizard__c versao = new VersaoWizard__c();
        versao.ProjetoWizard__c = proj.id;
        
        Database.insert(versao);
        
        
        Fluxo__c item = new Fluxo__c();
        item.Name = 'Item 1';
        item.Versao__c = versao.Id;
        
		//INSERIR ITEM 1
        Database.insert(item);
    
        
        List<Parametro__c> parametros = new List<Parametro__c>();
	        
        for(integer k = 0; k < 1; k++)
        {
            //ISERE PARAMETRO
            Parametro__c param = new Parametro__c();
            param.name = 'Parametro_teste- ' + k;
            param.Fluxo__c = item.id;
            
            parametros.add(param);
        }
        
        insert parametros;
        
        PageReference pageRef = Page.Parametros;
		Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', parametros[0].id);
		
        ApexPages.StandardController stdPa = new ApexPages.StandardController(parametros[0]);

        ParametrosController controller = new ParametrosController(stdPa);
        controller.Salvar();
        controller.parametro.Tipo__c = 'Lista de opções';
        controller.parametro.Name = 'Parametro';
        
		controller.MudarTipoResposta();
        controller.AdicionarOpcao();
        controller.opcaoARemover = '1';
        controller.RemoverOpcao();
        for(ParametroOpcao__c opt : controller.opcoes)
            opt.Name = 'oi';
        
        controller.parametro.Name = 'Parametro';
        controller.parametro.Tipo__c = 'Lista de opções';
        controller.parametro.Altura__c = 1;
        controller.Salvar();
        controller.parametro.Coluna__c = '1';
        controller.Salvar();
        controller.parametro.Largura__c = '1' ;
        controller.Salvar();
        controller.parametro.Linha__c = 1 ;
        controller.Salvar();
        controller.parametro.Pergunta__c = 'Qual o parãmetro?'  ;
        controller.Salvar();
        controller.parametro.TipoDados__c = 'Texto';
        controller.Salvar();
        controller.parametro.OpcaoPadrao__c =  '1';
        controller.Salvar();
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //Testar tradução
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    	
        pageRef = Page.ParametrosTraducao;
		Test.setCurrentPage(pageRef);
        
        TraducoesParametro__c trad = new TraducoesParametro__c();
        trad.parametro__c = parametros[0].id;
        trad.Linguagem__c = 'Inglês';
        trad.Name = 'Tradução';
        
        insert trad;
        
        ApexPages.StandardController stdPag = new ApexPages.StandardController(trad);
        
        ParametrosTraducaoController controllerTrad = new ParametrosTraducaoController(stdPag);
        controllerTrad.Salvar();
        
        /////////////////////////////////////////////////////////////////////////////////////
        //TESTE PARÂMETRO ANEXO
        /////////////////////////////////////////////////////////////////////////////////////
    	
        pageRef = Page.ParametroAnexo;
		Test.setCurrentPage(pageRef);
        
        System.currentPageReference().getParameters().put('id', parametros[0].id);
                
        ParametroAnexoController controllerAnexo = new ParametroAnexoController();
		controllerAnexo.Anexo();
        
        for(AttachmentFile ab : controllerAnexo.allFileList)
        {
            ab.NomeCompletoImagem = 'teste.jpg';
            ab.Nome = 'Teste.jpg';
            ab.Anexo.Body  = Blob.valueOf('Unit Test Document Body');
            
        }
        
        controllerAnexo.Salvar();
        try
        {
            controllerAnexo.opcaoARemover = controllerAnexo.allFileList[0].ParametroOpcao.id;
            controllerAnexo.RemoverAnexo();
        }catch(Exception ex)
        {
            
        }
        controllerAnexo.Cancel();
    }
}