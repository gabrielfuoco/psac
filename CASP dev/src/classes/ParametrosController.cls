public class ParametrosController {
    
    private Set<string> multiplos;
    
    private Parametro__c parametro;
    
    public Boolean IsMultiplo {get; set;}
    
    public List<ParametroOpcao__c> opcoes {get; set;}
    
    public string opcaoARemover {get; set;}
    
    public Boolean IsCheck {get; set;}
    
    public ParametrosController()
    {
        multiplos = TiposMultiplos();
    }
    
	public ParametrosController(ApexPages.StandardController stdController)
    {
        parametro = (Parametro__c)stdController.getRecord();
        
        multiplos = TiposMultiplos();
         
        opcoes = [Select id, name, Sequencia__c, parametro__c, parametro__r.id, valor__c from ParametroOpcao__c 
                              where parametro__r.id = :parametro.Id ORDER BY Sequencia__c ASC];
        
        IsMultiplo();
    }
    
    public PageReference Salvar()
    {
        if(ValidarCampos())
            return null;
        
        try
        {
        	upsert parametro;
        }catch(Exception ex)
        {
            ApexPages.addMessages(ex);
            return null;
        }
        
        boolean optError = false;
        for(ParametroOpcao__c opt : opcoes)
        {
            if(opt.Name == null || opt.Name == '')
            {
                opt.Name.addError('É necessário inserir um valor');
                optError = true;
            }
            
            if(opt.Valor__c == null || opt.Valor__c == '')
            {
                opt.Valor__c.addError('É necessário inserir um valor');
                optError = true;
            }
            
            if(opt.Parametro__c == null)
                opt.Parametro__c = parametro.Id;
        }
        
        if(optError)
            return null;
        
        List<ParametroOpcao__c> aExcluir = [Select id, name, Sequencia__c, parametro__c, parametro__r.id, valor__c from ParametroOpcao__c 
                              				where parametro__r.id = :parametro.Id and id not in :opcoes];
        
        upsert opcoes;
        
        delete aExcluir;
        
        InserirAtualizarTraducaoEmPortugues();
        
        PageReference send = new PageReference('/' + parametro.Id);
        send.setRedirect(true);
        
        return send;
    }
    
    private void InserirAtualizarTraducaoEmPortugues()
    {
        List<TraducoesParametro__c> tradparam = [select id, name, opcaoPadrao__c, linguagem__c, parametro__c, parametro__r.id
                                                 from TraducoesParametro__c 
                                                 where parametro__r.id = :parametro.Id and
                                                	   Linguagem__c = 'Português'];
        TraducoesParametro__c tradPort = null;
        
        if(tradparam.size() == 0)
        {
        	tradPort = new TraducoesParametro__c();
            tradPort.Parametro__c = parametro.Id;
            tradPort.Linguagem__c = 'Português';
        }
        else
        	tradPort = tradparam[0];
        
        tradPort.Name = parametro.Pergunta__c;
        tradPort.OpcaoPadrao__c = parametro.OpcaoPadrao__c;
        
        upsert tradPort;
        
        List<TraducaoOpcaoParametro__c> traducoesOpt = [select id, name, linguagem__c, ParametroOpcao__r.id, ParametroOpcao__c 
                                                        from TraducaoOpcaoParametro__c
                                                        where ParametroOpcao__r.id in :opcoes and
                                                       		  linguagem__c = 'Português'];
        
        for(ParametroOpcao__c paramOpt : opcoes)
        {
         	boolean novo = true;
            for(TraducaoOpcaoParametro__c opt : traducoesOpt)
            {
                if(paramOpt.Id == opt.ParametroOpcao__c)   
                {
                    opt.Name = paramOpt.Name;
                    novo = false;
                }
            }
            
            if(novo)
            {
                TraducaoOpcaoParametro__c novaTrad = new TraducaoOpcaoParametro__c();
                novaTrad.Name = paramOpt.Name;
                novaTrad.Linguagem__c = 'Português';
                novaTrad.ParametroOpcao__c= paramOpt.Id;
                traducoesOpt.add(novaTrad);
            }
        }
        
        upsert traducoesOpt;
        
        //Excluir
        List<TraducaoOpcaoParametro__c> traducoesOptExcluir = [select id, name, ParametroOpcao__r.id, ParametroOpcao__c 
                                                        from TraducaoOpcaoParametro__c
                                                        where id not in :traducoesOpt and
                                                              ParametroOpcao__r.Parametro__r.id = :parametro.id and
                                                       		  linguagem__c = 'Português'];
        
        delete traducoesOptExcluir;
    }
    
    private boolean ValidarCampos()
    {
        string mensagem = 'É necessário inserir um valor';
        string mensagem2 = 'O valor deve ser maior que 0';
        boolean erro = false;
        
        if(parametro.Name == null)
        {
            parametro.Name.addError(mensagem);
        	erro =  true;
        }
        
        if(parametro.Coluna__c == null)
        {
            parametro.Coluna__c.addError(mensagem);
        	erro =  true;
        }
        
        if(parametro.Largura__c == null)
        {
            parametro.Largura__c.addError(mensagem);
        	erro =  true;
        }
        
        if(parametro.Linha__c == null)
        {
            parametro.Linha__c.addError(mensagem);
        	erro =  true;
        }
        else if(parametro.Linha__c < 1)
        {
            parametro.Linha__c.addError(mensagem2);
        	erro =  true;
        }
            
        if(parametro.Pergunta__c == null)
        {
            parametro.Pergunta__c.addError(mensagem);
        	erro =  true;
        }
        
        if(parametro.Tipo__c == null)
        {
            parametro.Tipo__c.addError(mensagem);
        	erro =  true;
        }
        
        if(parametro.Altura__c == null)
        {
            parametro.Altura__c.addError(mensagem);
        	erro =  true;
        }
        else if(parametro.Altura__c < 1)
        {
            parametro.Altura__c.addError(mensagem2);
        	erro =  true;
        }
        
        if((parametro.OpcaoPadrao__c != null && parametro.OpcaoPadrao__c != '') && IsMultiplo)
        {
            boolean contem = false;
            
            for(ParametroOpcao__c opt : opcoes)
            {
                if(opt.Valor__c == parametro.OpcaoPadrao__c)
                    contem = true;
            }
            
            if(!contem)
            {
            	parametro.OpcaoPadrao__c.addError('Opção padrão inválida');
        		erro =  true;
            }
        }
        
        if(IsMultiplo)
            for(ParametroOpcao__c opt : opcoes)
            {
                if(opt.Name == null || opt.Name == '')
                {
                    opt.Name.addError(mensagem);
                    erro =  true;
                }
            }
        
        return erro;
    }
    
    private void IsMultiplo()
    {
        if(parametro.Tipo__c == 'Caixa de seleção')
            IsCheck = true;
        else
            IsCheck = false;
        
        if(multiplos.contains(parametro.Tipo__c))
        	IsMultiplo= true;
        else
            IsMultiplo= false;
    }
    
    public PageReference MudarTipoResposta()
    {
        IsMultiplo();
        
        if(IsMultiplo && opcoes.size() == 0)
        {
            ParametroOpcao__c opt1 = new ParametroOpcao__c();
            opt1.Sequencia__c = 1;
            opcoes.add(opt1);
        }
        
        parametro.OpcaoPadrao__c = '';
        
        return null;
    }
    
    public PageReference AdicionarOpcao()
    {
        ParametroOpcao__c opt = new ParametroOpcao__c();
        opt.Sequencia__c = opcoes.size() + 1;
        opcoes.add(opt);
        
        return null;
    }
    
    public PageReference RemoverOpcao()
    {
        List<ParametroOpcao__c> newOpt = new List<ParametroOpcao__c>();
        integer sequencia = 1;
        for(ParametroOpcao__c opt : opcoes)
        {
			if(opt.Sequencia__c != integer.valueOf(opcaoARemover))
            { 
                opt.Sequencia__c = sequencia;
                newOpt.add(opt);
                sequencia++;
            }
        }
        
        opcoes = newOpt;
        
        return null;
    }
    
    private Set<string> TiposMultiplos()
    {
        Set<string> lista = new Set<string>();
        lista.add('Lista de opções');
        lista.add('Botão de opção');
        return lista;
        
    }
}