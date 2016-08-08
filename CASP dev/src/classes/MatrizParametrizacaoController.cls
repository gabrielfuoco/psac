public class MatrizParametrizacaoController {
	
    public CadastroComponente cadComponente {get; set;}
    
    public MatrizParametrizacaoResp fluxoResp {get; set;}

    public List<VincularParametros> vincularParametros {get;set;}
    
    public Fluxo__c fluxo {get; set;}
    
    public List<GridLines> linhasColunas {get; set;}
    
    public List<string> headers {get; set;}
    
    public string linhaAcao {get; set;}
    
    public boolean edicao {get; set;}
        
    public MatrizParametrizacaoController(ApexPages.StandardController controller)
    {
        fluxo = [select id, name, versao__r.Name, versao__r.Versao__c, versao__r.Situacao__c from  Fluxo__c where id = :((Fluxo__c)controller.getRecord()).id];
        
        if(fluxo.versao__r.Situacao__c == 'Em teste')
        {
            edicao = true;
        }
        
        AbrirMatriz();
    }
    
    private void AbrirMatriz()
    {
        MonstarfluxoResp();
        
        PopularModalParametros();
        
        PopularMatrizResposta();
    }
    
    private void PopularModalParametros()
    {
        vincularParametros = new List<VincularParametros>();
        List<Parametro__c> itens = [select id, name, pergunta__c from Parametro__c where Fluxo__c = :fluxo.Id or
                                   														 (Fluxo__r.Recordtype.name = 'Fluxo de Configuração' and
                                   														  Fluxo__r.versao__r.id = :fluxo.versao__r.Id) order by CreatedDate ASC];
        
        for(Integer i = 0; i < itens.size(); i++)
        {
           VincularParametros item = new VincularParametros();
           item.parametro = itens[i];
           item.selecionado = ParametroSelecionado(itens[i]);
           vincularParametros.add(item); 
        }
    }
    
    private Boolean ParametroSelecionado(Parametro__c parametro)
    {
        for(Integer i = 0; i < fluxoResp.Colunas.size(); i++ )
        {
            if(fluxoResp.Colunas[i].parametro__r.id == parametro.id)
                return true;
        }
        
        return false;
    }
     
    private void MonstarfluxoResp()
    {
        cadComponente = new CadastroComponente();
        
        fluxoResp = new MatrizParametrizacaoResp();
        
        fluxoResp.Linhas = [select id, ComponentePeca__r.Name, Equipamento__r.Name, Quantidade__C
                                           from MatrizLinha__c where Fluxo__r.id = :fluxo.Id order by CreatedDate ASC];

        fluxoResp.Colunas = [select id, parametro__r.name, parametro__r.id,parametro__r.tipo__c, parametro__r.Pergunta__c
                                            from MatrizColuna__c where Fluxo__r.id = :fluxo.Id order by CreatedDate ASC];

        fluxoResp.Respostas = [select id, MatrizLinha__r.id, 
                                              MatrizColuna__r.id, resposta__c
                                              from MatrizResposta__c where MatrizColuna__r.Fluxo__r.id = :fluxo.Id order by CreatedDate ASC];
        
        for(integer i = 0; i< fluxoResp.Colunas.Size(); i++)
        {
            ItemCadastroComponente itemCad = new ItemCadastroComponente();
            itemCad.Resposta = '';
            itemCad.Coluna  = fluxoResp.Colunas[i];
            
            cadComponente.Colunas.add(itemCad);
        }
    }
    
    private void PopularMatrizResposta()
    {
        linhasColunas = new List<GridLines>();
        headers = new List<string>();
        headers.add('Equipamento');
        headers.add('Componente/Peça');
        headers.add('Quantidade');
        
        for(integer y = 0; y < fluxoResp.Colunas.size(); y++)
            headers.add(fluxoResp.Colunas[y].parametro__r.name);
        
        for(Integer i = 0; i< fluxoResp.Linhas.size(); i++)
        {
            GridLines line = new GridLines();
            line.Columns.add(GerarColuna('ID', fluxoResp.Linhas[i].id, 'SEMID','',''));
            line.Columns.add(GerarColuna('Equipamento', fluxoResp.Linhas[i].Equipamento__r.name, 'SEMID','',''));
            line.Columns.add(GerarColuna('Componente/Peça', fluxoResp.Linhas[i].ComponentePeca__r.name, 'SEMID','',''));
            line.Columns.add(GerarColuna('Quantidade', fluxoResp.Linhas[i].Quantidade__C + '', 'SEMID','',''));
            
            for(integer y = 0; y < fluxoResp.Colunas.size(); y++)
            {
                line.Columns.add(GerarColuna(fluxoResp.Colunas[y].parametro__r.name, 
                                             GetResposta(fluxoResp.Linhas[i].id,
                                                         fluxoResp.Colunas[y].id), 
                                             GetRespostaId(fluxoResp.Linhas[i].id,
                                                           fluxoResp.Colunas[y].id),
                                             fluxoResp.Linhas[i].id,
                                             fluxoResp.Colunas[y].id));
            }
            
            linhasColunas.add(line);
        }
        
    }
    
    private string GetResposta(string idLinha, string idColuna)
    {
        for(integer i =0; i< fluxoResp.Respostas.size(); i++)
        {
            if(fluxoResp.Respostas[i].MatrizColuna__c == idColuna &&
               fluxoResp.Respostas[i].MatrizLinha__c == idLinha)
            {
                return fluxoResp.Respostas[i].Resposta__c;
            }
        } 
        return '';
    }
    
    private string GetRespostaId(string idLinha, string idColuna)
    {
        for(integer i =0; i< fluxoResp.Respostas.size(); i++)
        {
            if(fluxoResp.Respostas[i].MatrizColuna__c == idColuna &&
               fluxoResp.Respostas[i].MatrizLinha__c == idLinha)
            {
                return fluxoResp.Respostas[i].Id;
            }
        } 
        return 'NOVO';
    }
    
    private GridColumn GerarColuna(string nome, string valor, string idResp, string idLinha, string idColuna)
    {
        GridColumn colunaGrid = new GridColumn();
        colunaGrid.Nome = nome;
        colunaGrid.Valor = valor;
        colunaGrid.Id = idResp;
        colunaGrid.IdLinha = idLinha;
        colunaGrid.IdColuna = idColuna;
        
        return colunaGrid;
    }
        
    public PageReference salvarParametros()
    {
        for(Integer i = 0; i< vincularParametros.size(); i++)
        {
            if(vincularParametros[i].selecionado)
            {
                List<MatrizColuna__c> colunasExistentes = [select id, name from MatrizColuna__c where parametro__r.id = :vincularParametros[i].parametro.Id order by CreatedDate ASC];
				
                if(colunasExistentes == null || colunasExistentes.size() == 0)
                {
                 	MatrizColuna__c coluna = new MatrizColuna__c();
                    coluna.Fluxo__c = fluxo.Id;
                    coluna.Parametro__c = vincularParametros[i].parametro.id;
                     
                    insert coluna;   
                }
			}
        }
        
        //REMOVER
        for(Integer i = 0; i< vincularParametros.size(); i++)
        {
            if(!vincularParametros[i].selecionado)
            {
                List<MatrizColuna__c> colunasRemover = [select id, name from MatrizColuna__c where parametro__r.id = :vincularParametros[i].parametro.Id];
                
                if(colunasRemover.size() > 0)
                    delete colunasRemover;
            }
        }
        
        AbrirMatriz();
        
        return null;
    }
    
    public PageReference salvarComponentes()
    {
        
        cadComponente.Linha.Fluxo__c = fluxo.id;
        
        if(cadComponente.Linha.Id == null || cadComponente.Linha.Id + '' == '')
        {
            cadComponente.Linha.Id = null;
            insert cadComponente.Linha;
            
            GerarTraducoes();
        }
        else
        {
            boolean upd = false;
            if(cadComponente.Linha.Equipamento__c == null)
                upd = true;
            
            update cadComponente.Linha;
            AlterarTraducaoPortugues();
            if(upd)
            {
                MatrizLinha__c itns = [select id, equipamento__c from MatrizLinha__c where id = :cadComponente.Linha.id];
                itns.Equipamento__c = null;
                update itns;
            }
        }
        
        AbrirMatriz();
                
        return null;
    }
    
    private void AlterarTraducaoPortugues()
    {
        List<TraducaoMatriz__c>  linhaPort = [select id, name, DescricaoEquipamento__c from TraducaoMatriz__c 
                                     		where MatrizLinha__r.id = :cadComponente.Linha.id and
                                       			  Linguagem__c = 'Português'];
        
        if(linhaPort.size() > 0)
        {
            linhaPort[0].Name = cadComponente.Linha.DescricaoComponentePeca__c;
            linhaPort[0].DescricaoEquipamento__c = cadComponente.Linha.DescricaoEquipamento__c;
            
            update linhaPort;
        }
    }
    
    private void GerarTraducoes()
    {
        List<TraducaoMatriz__c> tradMatriz = new List<TraducaoMatriz__c>();
        List<TraducaoItem__c> componentePeca = [select id, name, Linguagem__c from TraducaoItem__c where Item__r.id = :cadComponente.Linha.ComponentePeca__c];
        List<TraducaoItem__c> equipamentos = [select id, name, Linguagem__c from TraducaoItem__c where Item__r.id = :cadComponente.Linha.Equipamento__c];
        
        for(string itemIter : Linguagens(componentePeca, equipamentos))
        {
            TraducaoMatriz__c itemTraz = new TraducaoMatriz__c();
            itemTraz.Name = EncontrarTraducaoPorLinguagem(componentePeca ,itemIter);
            itemTraz.DescricaoEquipamento__c = EncontrarTraducaoPorLinguagem(equipamentos,itemIter);
            itemTraz.Linguagem__c = itemIter;
            itemTraz.MatrizLinha__c = cadComponente.Linha.Id;
            tradMatriz.add(itemTraz);
        }
        
        insert tradMatriz;
        
    }
    
    private List<string> Linguagens(List<TraducaoItem__c> itens1, List<TraducaoItem__c> itens2)
    {
        List<string> linguagens = new List<string>();
        for(TraducaoItem__c item : itens1)
        {
            linguagens.add(item.Linguagem__c);
        }
        
        for(TraducaoItem__c item : itens2)
        {
            boolean existe = false;
            for(string lingua : linguagens)
            {
                if(lingua == item.Linguagem__c)
                    existe = true;
            }
            
            if(!existe)
            	linguagens.add(item.Linguagem__c);
        }
        
        return linguagens;
    }
    
    private string EncontrarTraducaoPorLinguagem(List<TraducaoItem__c> itens, string linguagem)
    {
        for(TraducaoItem__c item : itens)
        {
            if(item.Linguagem__c == linguagem)
                return item.Name;
        }
        
        return '-';
    }
    
    public PageReference excluirComponente()
    {
        List<MatrizLinha__c> linhaAExcluir = [select id, name from MatrizLinha__c where id = :linhaAcao];
        
        List<MatrizResposta__c> respostas = [select id, name from MatrizResposta__c where MatrizLinha__r.id = :linhaAcao];
        
        delete respostas;
        
        delete linhaAExcluir;
        
        AbrirMatriz();
        
        return null;
    }
}