public class ParametrosTraducaoController {
    
    private TraducoesParametro__c traducoesParametro;
    
    public Parametro__c parametro {get; private set;}
    
    public List<ParametroOpcaoTraducao> opcoes {get; set;}
    
    public Boolean IsMultiplo {get; set;}
	
    private List<ParametroOpcao__c> opcoesTrad;
    
    public Boolean IsCheck {get; set;}
    
    public ParametrosTraducaoController(ApexPages.StandardController stdController)
    {
        
        traducoesParametro = (TraducoesParametro__c)stdController.getRecord();
        
        parametro = [select id, name, tipo__c, OpcaoPadrao__c, pergunta__c from parametro__c where id = :traducoesParametro.Parametro__c ];
        
        opcoesTrad = [Select id, name, Sequencia__c, parametro__c, parametro__r.id from ParametroOpcao__c 
                          where parametro__r.id = :traducoesParametro.Parametro__c ORDER BY Sequencia__c ASC];
        
        List<TraducaoOpcaoParametro__c> traducoesParametroOpt = [select id, name, ParametroOpcao__r.id, ParametroOpcao__c, linguagem__c
                                                              	from TraducaoOpcaoParametro__c 
                                                              	where ParametroOpcao__r.id in :opcoesTrad and
                                                             		  linguagem__c = :traducoesParametro.linguagem__c];
        
        opcoes = new List<ParametroOpcaoTraducao>();
        
        for(ParametroOpcao__c item : opcoesTrad)
        {
            ParametroOpcaoTraducao paramOptTrad = new ParametroOpcaoTraducao();
            paramOptTrad.parametroOpcao = item;
            
            for(TraducaoOpcaoParametro__c itemB : traducoesParametroOpt)
            {
                if(itemB.ParametroOpcao__c == item.id)
                {
                    paramOptTrad.traducaoParametroOpcao = itemB;
                }
            }
            
            if(paramOptTrad.traducaoParametroOpcao == null)
            {
                paramOptTrad.traducaoParametroOpcao = new TraducaoOpcaoParametro__c();
            	paramOptTrad.traducaoParametroOpcao.ParametroOpcao__c = item.Id;
            }
            
        	opcoes.add(paramOptTrad);
        }
        IsMultiplo();
    }
    
    public PageReference Salvar()
    {
        //VERIFICA COM MAIS DE UMA LINGUAGEM
        List<TraducoesParametro__c> tradParans = [select id, name from TraducoesParametro__c 
                                                  where parametro__r.id = :traducoesParametro.Parametro__c and
                                                 		id <> :traducoesParametro.Id and
                                                  		linguagem__c = :traducoesParametro.Linguagem__c];
        if(tradParans.size() > 0)
        {
            traducoesParametro.addError('Não é possível cadastrar uma tradução com uma linguagem já existente');
            return null;
        }
        
        //NÃO É POSSIVEL ALTERAR A LINGUAGEM PORTUGUÊS
        tradParans = [select id, name from TraducoesParametro__c 
                      where id = :traducoesParametro.Id and
                          linguagem__c <> :traducoesParametro.Linguagem__c and
                          linguagem__c = 'Português'];
        
        if(tradParans.size() > 0)
        {
            traducoesParametro.Linguagem__c.addError('Não é possível alterar o tipo da linguagem português!');
            return null;
        }
        
        try
        {
        	upsert traducoesParametro;
        }catch(Exception ex)
        {
            ApexPages.addMessages(ex);
            return null;
        }
        List<TraducaoOpcaoParametro__c> lista = new List<TraducaoOpcaoParametro__c>();
        
        for(ParametroOpcaoTraducao opt : opcoes)
        {
            opt.traducaoParametroOpcao.Linguagem__c = traducoesParametro.Linguagem__c;
            lista.add(opt.traducaoParametroOpcao);
        }
        
        upsert lista;
        
        AtualizaValoresParametro();
        
        PageReference send = new PageReference('/' + traducoesParametro.Id);
        send.setRedirect(true);
        
        return send;
    }
    
    private void AtualizaValoresParametro()
    {
        if(traducoesParametro.Linguagem__c == 'Português')
        {
            parametro.Pergunta__c = traducoesParametro.Name;
            parametro.OpcaoPadrao__c = traducoesParametro.OpcaoPadrao__c;
            
            update parametro;
            
            opcoesTrad = [Select id, name, Sequencia__c, parametro__c, parametro__r.id from ParametroOpcao__c 
                          where parametro__r.id = :traducoesParametro.Parametro__c ORDER BY Sequencia__c ASC];
        
            for(ParametroOpcao__c item : opcoesTrad )
            {
                for( ParametroOpcaoTraducao itemB : opcoes)
                {
                    if(item.Id == itemB.traducaoParametroOpcao.parametroOpcao__c)
                        item.Name = itemB.traducaoParametroOpcao.Name;
                }
            }
            
            update opcoesTrad;
        }
    }
    
    private void IsMultiplo()
    {
        if(parametro.Tipo__c == 'Caixa de seleção')
            IsCheck = true;
        else
            IsCheck = false;
        
        if(TiposMultiplos().contains(parametro.Tipo__c))
        	IsMultiplo= true;
        else
            IsMultiplo= false;
    }
    
    private Set<string> TiposMultiplos()
    {
        Set<string> lista = new Set<string>();
        
        lista.add('Lista de opções');
        lista.add('Botão de opção');
        return lista;
    }
}