public class ClonarFluxoProjetoWizard
{
	private static VersaoWizard__c versaoWizard;

	@InvocableMethod
	public static void Clonar(List<VersaoWizard__c> versoes)
	{
		if((versoes == null || versoes.size() == 0) || 
					(versoes.size() > 0 && versoes[0].VersaoOrigem__c == null))
			return;
		
		versaoWizard = versoes[0];
		
		//INSERINDO VERSÃO
		VersaoWizard__c novoProjetoWizard = versaoWizard;
		
		//INSERINDO FLUXOS
		List<Fluxo__c> fluxosAClonar = [select id, name, codigo__c, recordtypeid from Fluxo__c 
										where Fluxo__c.Versao__r.Id = :versaoWizard.VersaoOrigem__c];
	    
	    List<ObjetoReferencia> novosFluxos  = new List<ObjetoReferencia>();									
		List<id> idsFluxos = new List<id>();
		
		for(Fluxo__c fluxoAClonar : fluxosAClonar)
		{
			Fluxo__c fluxoGerado = GerarFluxo(novoProjetoWizard,fluxoAClonar);
			
			ObjetoReferencia fluxoNovo = new ObjetoReferencia();
			fluxoNovo.itemOriginal = fluxoAClonar;
			fluxoNovo.itemClone = fluxoGerado;
			
			idsFluxos.add(fluxoAClonar.id);
			novosFluxos.add(fluxoNovo);
		}
		
		CustomIterable iteratorFluxo = new CustomIterable();
		iteratorFluxo.Itens = novosFluxos;
		
		insert iteratorFluxo.getClones();
		
		//INSERINDO TRADUÇÕES DO FLUXO
		
		List<TraducaoFluxo__c> traducoesFluxoOld = [select id, name, linguagem__c, fluxo__r.id from TraducaoFluxo__c
													where Linguagem__c <> 'Português' and Fluxo__r.id in :idsFluxos ];
		
		List<TraducaoFluxo__c> traducaoFluxo = new List<TraducaoFluxo__c>();
		
		for(TraducaoFluxo__c tradFluxoOld : traducoesFluxoOld)
		{
			TraducaoFluxo__c tradNew = new TraducaoFluxo__c();
			tradNew.Name = tradFluxoOld.Name;
			tradNew.linguagem__c = tradFluxoOld.linguagem__c;
			tradNew.Fluxo__c = ((Fluxo__c)FluxoPorId(tradFluxoOld.Fluxo__r.id,novosFluxos).itemClone).id;
			traducaoFluxo.add(tradNew);
		}
		
		insert traducaoFluxo;
		
		//INSERINDO CODIGO FONTE DOS FLUXOS
		List<CodigoFonte__c> codigosFontes = [select id, name, Codigo__c, Fluxo__r.id, Parametro__r.id, RecordTypeId 
												from CodigoFonte__c where  Fluxo__r.id in : idsFluxos];
		
		List<CodigoFonte__c> codigosFontesNovos = new List<CodigoFonte__c>();

		for(CodigoFonte__c codigoOld : codigosFontes)
		{
			ObjetoReferencia objRef = iteratorFluxo.next();
			
			CodigoFonte__c codigoFonte = GerarCodigosFontes(((Fluxo__c)FluxoPorId(codigoOld.Fluxo__r.id,novosFluxos).itemClone).id,
															null, codigoOld);
		
			codigosFontesNovos.add(codigoFonte);
		}

		insert codigosFontesNovos;

		//INSERINDO PARAMETROS
		List<Parametro__c> parametrosAClonar = [select id, name, Coluna__c, Fluxo__r.id, altura__c,
														Largura__c, Linha__c, OpcaoPadrao__c, TipoDados__c, Pergunta__c, Tipo__c from Parametro__c
												where  Fluxo__r.id in :idsFluxos];
		
		List<ObjetoReferencia> paransAInserir  = new List<ObjetoReferencia>();
		List<id> idsParansOld = new List<id>();
		
		for(Parametro__c paramAClonar : parametrosAClonar)
		{
			Parametro__c novoParam = GerarParametros(((Fluxo__c)FluxoPorId(paramAClonar.Fluxo__r.id,novosFluxos).itemClone).id, paramAClonar);

			ObjetoReferencia objRef = new ObjetoReferencia();
			objRef.itemOriginal = paramAClonar;
			objRef.itemClone = novoParam;
			
			idsParansOld.add(paramAClonar.id);			
			paransAInserir.add(objRef);
		}
		
		CustomIterable iterator = new CustomIterable();
		iterator.Itens = paransAInserir;
		
		insert iterator.getClones();
		
		//INSERINDO TRADUÇÕES DOS PARÂMETROS	
		
		List<TraducoesParametro__c> traducoesParamOld = [select id, name, linguagem__c, parametro__r.id from TraducoesParametro__c
													where parametro__r.id in :idsParansOld ];
		
		List<TraducoesParametro__c> traducaoParam = new List<TraducoesParametro__c>();
		
		for(TraducoesParametro__c tradOld : traducoesParamOld)
		{
			TraducoesParametro__c tradNew = new TraducoesParametro__c();
			tradNew.Name = tradOld.Name;
			tradNew.linguagem__c = tradOld.linguagem__c;
			tradNew.Parametro__c = ((Parametro__c)ParametroPorId(tradOld.Parametro__r.id,paransAInserir).itemClone).id;
			traducaoParam.add(tradNew);
		}
		
		insert traducaoParam;
		
		//INSERINDO PARAMETRO OPÇÕES
		
		List<ObjetoReferencia> opcoesAInserir  = new List<ObjetoReferencia>();
		List<id> idsOpcoesOld = new List<id>();
		
		List<ParametroOpcao__c > parametrosOld = [select id, name, Parametro__r.id, Sequencia__c, Valor__c  from ParametroOpcao__c
												  where Parametro__r.id in :idsParansOld];
		
		for(ParametroOpcao__c paramOld : parametrosOld)
		{
			ParametroOpcao__c novoParamOpt = GerarParametroOpcao(((Parametro__c)ParametroPorId(paramOld.Parametro__r.id, paransAInserir).itemClone).id, paramOld);
			
			ObjetoReferencia objRef = new ObjetoReferencia();
			objRef.itemOriginal = paramOld;
			objRef.itemClone = novoParamOpt;
			
			idsOpcoesOld.add(paramOld.id);
			opcoesAInserir.add(objRef);
		}
		
		iterator = new CustomIterable();
		iterator.Itens = opcoesAInserir;
		
		insert iterator.getClones();
		
		//INSERINDO TRADUÇÕES DAS OPÇÕES DO PARÂMETRO
		
		List<TraducaoOpcaoParametro__c> traducoesParamOptOld = [select id, name, linguagem__c, ParametroOpcao__r.id from TraducaoOpcaoParametro__c
													where Linguagem__c <> 'Português' and ParametroOpcao__r.id in :idsOpcoesOld ];
		
		List<TraducaoOpcaoParametro__c> traducaoParamOpr = new List<TraducaoOpcaoParametro__c>();
		
		for(TraducaoOpcaoParametro__c tradOld : traducoesParamOptOld)
		{
			TraducaoOpcaoParametro__c tradNew = new TraducaoOpcaoParametro__c();
			tradNew.Name = tradOld.Name;
			tradNew.linguagem__c = tradOld.linguagem__c;
			tradNew.ParametroOpcao__c = ((ParametroOpcao__c)ParametroOpcaoPorId(tradOld.ParametroOpcao__r.id,opcoesAInserir).itemClone).id;
			traducaoParamOpr.add(tradNew);
		}
		
		insert traducaoParamOpr;
		
		//INSERINDO CÓDIGO FONTE DE PARAMETRO
		codigosFontes = [select id, name, Codigo__c, Fluxo__r.id, Parametro__r.id, RecordTypeId 
						 from CodigoFonte__c where  Parametro__r.id in : idsParansOld];
		
		codigosFontesNovos = new List<CodigoFonte__c>();

		for(CodigoFonte__c codigoOld : codigosFontes)
		{
			ObjetoReferencia objRef = iteratorFluxo.next();
			
			CodigoFonte__c codigoFonte = GerarCodigosFontes(null,((Parametro__c)ParametroPorId(codigoOld.Parametro__r.id, paransAInserir).itemClone).id, codigoOld);
		
			codigosFontesNovos.add(codigoFonte);
		}

		insert codigosFontesNovos;
		
		for(integer i = 0; i< novosFluxos.size();i++)
		{
			CopiarMatrizConfiguracaoEquipamento(novosFluxos[i],paransAInserir );
		}
	}
	
	private static void CopiarMatrizConfiguracaoEquipamento(ObjetoReferencia fluxo, 
															List<ObjetoReferencia> parametros)
	{
		List<MatrizLinha__c> matrizLinhasOld = [select id, name, DescricaoComponentePeca__c, DescricaoEquipamento__c, Quantidade__c, ComponentePeca__r.id, Equipamento__r.id, Fluxo__r.id 
												from MatrizLinha__c where Fluxo__r.id = :((Fluxo__c)fluxo.itemOriginal).id];
		
        List<TraducaoMatriz__c> traducoesOld = [select id, name, MatrizLinha__c, MatrizLinha__r.id,DescricaoEquipamento__c, Linguagem__c 
                                                      from TraducaoMatriz__c where MatrizLinha__r.id in :matrizLinhasOld];
        
		List<MatrizColuna__c> matrizColulasOld = [select id, name, Fluxo__r.id, Parametro__r.id 
												 from MatrizColuna__c where Parametro__c != null and Fluxo__r.id = :((Fluxo__c)fluxo.itemOriginal).id];
												 
		List<MatrizResposta__c> matrizRespostasOld = [select id, name, MatrizColuna__r.id, MatrizLinha__r.id, Resposta__c 
													  from MatrizResposta__c where MatrizColuna__r.Parametro__c != null and MatrizLinha__r.Fluxo__r.id = :((Fluxo__c)fluxo.itemOriginal).id];
		
		//EXCREVER TODAS AS LINHAS

		List<ObjetoReferencia> matrizLinhasNew = new List<ObjetoReferencia>();
												  
		for(MatrizLinha__c linhaOld : matrizLinhasOld)
		{
			ObjetoReferencia objRef = new ObjetoReferencia();
			
			MatrizLinha__c linha = new MatrizLinha__c();
			linha.ComponentePeca__c = linhaOld.ComponentePeca__r.id;
			linha.Equipamento__c = linhaOld.Equipamento__r.id;
			linha.Fluxo__c = ((Fluxo__c)fluxo.itemClone).id;
			linha.DescricaoComponentePeca__c = linhaOld.DescricaoComponentePeca__c;
            linha.DescricaoEquipamento__c = linhaOld.DescricaoEquipamento__c;
            linha.Quantidade__c = linhaOld.Quantidade__c;
            
			objRef.itemOriginal = linhaOld;
			objRef.itemClone = linha;
			matrizLinhasNew.add(objRef);
		}
        CustomIterable iterator = new CustomIterable();
		iterator.Itens = matrizLinhasNew;
		
		insert iterator.getClones();
        
        //ESCREVER AS TRADUÇÕES DA LINHA
        List<TraducaoMatriz__c> traducoesNew = new List<TraducaoMatriz__c>();
        for(TraducaoMatriz__c traducaoOld: traducoesOld)
        {
            TraducaoMatriz__c tradNew = new TraducaoMatriz__c();
            tradNew.name = traducaoOld.Name;
            tradNew.MatrizLinha__c = ((MatrizLinha__c)LinhaPorId(traducaoOld.MatrizLinha__r.id, matrizLinhasNew).itemClone).id;
            tradNew.DescricaoEquipamento__c = traducaoOld.DescricaoEquipamento__c;
            tradNew.Linguagem__c = traducaoOld.Linguagem__c;
            System.debug(tradNew.Linguagem__c);
            traducoesNew.add(tradNew);
        }
        
        insert traducoesNew;
        
		//ESCREVER TODAS AS COLUNAS
		
		List<ObjetoReferencia> matrizColunasNew = new List<ObjetoReferencia>();
												  
		for(MatrizColuna__c linhaOld : matrizColulasOld)
		{
			ObjetoReferencia objRef = new ObjetoReferencia();
			
			MatrizColuna__c linha = new MatrizColuna__c();

			linha.Parametro__c = ((Parametro__c)ParametroPorId(linhaOld.parametro__r.id, parametros).itemClone).id;
			
            linha.Fluxo__c = ((Fluxo__c)fluxo.itemClone).id;
			
			objRef.itemOriginal = linhaOld;
			objRef.itemClone = linha;
			matrizColunasNew.add(objRef);
		}
		
		iterator = new CustomIterable();
		iterator.Itens = matrizColunasNew;
		
		insert iterator.getClones();
		
		//ESCREVER TODAS AS RESPOSTAS
		
		List<MatrizResposta__c> respostasNew = new List<MatrizResposta__c>();
		
		for(MatrizResposta__c respostaOld : matrizRespostasOld)
		{
			MatrizResposta__c resposta = new MatrizResposta__c();
			resposta.MatrizColuna__c =  ((MatrizColuna__c)ColunaPorId(respostaOld.MatrizColuna__r.id, matrizColunasNew).itemClone).id;
			resposta.MatrizLinha__c =  ((MatrizLinha__c)LinhaPorId(respostaOld.MatrizLinha__r.id, matrizLinhasNew).itemClone).id;
			resposta.resposta__c = respostaOld.resposta__c;
			respostasNew.add(resposta);
		}
		
		insert respostasNew;
		
	}
	
	private static ObjetoReferencia ColunaPorId(id codigo, List<ObjetoReferencia> colunas)
	{
		for(Integer i = 0; i< colunas.size(); i++)
		{
			if(((MatrizColuna__c)colunas[i].itemOriginal).id == codigo)
				return colunas[i];
		}
		
		return null;
	}
	
	private static ObjetoReferencia LinhaPorId(id codigo, List<ObjetoReferencia> linhas)
	{
		for(Integer i = 0; i< linhas.size(); i++)
		{
			if(((MatrizLinha__c)linhas[i].itemOriginal).id == codigo)
				return linhas[i];
		}
		
		return null;
	}
	
	private static ParametroOpcao__c GerarParametroOpcao(id idParametro, ParametroOpcao__c paramOpcaoOld)
	{
		ParametroOpcao__c paramOpcao = new ParametroOpcao__c();
		paramOpcao.Name = paramOpcaoOld.Name;
		paramOpcao.Parametro__c = idParametro;
		paramOpcao.Sequencia__c = paramOpcaoOld.Sequencia__c;
		paramOpcao.Valor__c = paramOpcaoOld.Valor__c;
		return paramOpcao;
	}
	
	private static ObjetoReferencia FluxoPorId(id codigo, List<ObjetoReferencia> fluxos)
	{
		for(Integer i = 0; i< fluxos.size(); i++)
		{
			if(((Fluxo__c)fluxos[i].itemOriginal).id == codigo)
				return fluxos[i];
		}
		
		return null;
	}
    
    private static ObjetoReferencia ParametroPorId(id codigo, List<ObjetoReferencia> parametros)
	{
		for(Integer i = 0; i< parametros.size(); i++)
		{
			if(((Parametro__c)parametros[i].itemOriginal).id == codigo)
				return parametros[i];
		}
		
		return null;
	}
	
	private static ObjetoReferencia ParametroOpcaoPorId(id codigo, List<ObjetoReferencia> paramOpt)
	{
		for(Integer i = 0; i< paramOpt.size(); i++)
		{
			if(((ParametroOpcao__c)paramOpt[i].itemOriginal).id == codigo)
				return paramOpt[i];
		}
		
		return null;
	}

	private static CodigoFonte__c GerarCodigosFontes(id fluxoNew, id paramNew, CodigoFonte__c fonteOld)
	{
		CodigoFonte__c codigoNew = new CodigoFonte__c();
		
        codigoNew.name = fonteOld.Name;
		codigoNew.Codigo__c = fonteOld.Codigo__c;
		codigoNew.RecordTypeId = fonteOld.RecordTypeId;
		
		if(fluxoNew != null)
			codigoNew.Fluxo__c = fluxoNew;
		
		if(paramNew != null)
			codigoNew.Parametro__c = paramNew;
			
		return codigoNew;
	}
	
	private static Parametro__c GerarParametros(id fluxoNew, Parametro__c paramOld)
	{
		Parametro__c novoParam = new Parametro__c();
		novoParam.name = paramOld.name;
		novoParam.Coluna__c = paramOld.Coluna__c ;
		novoParam.Fluxo__c = fluxoNew;
 		novoParam.Largura__c = paramOld.Largura__c ;
        novoParam.TipoDados__c = paramOld.TipoDados__c;
 		novoParam.Linha__c = paramOld.Linha__c ;
		novoParam.OpcaoPadrao__c = paramOld.OpcaoPadrao__c ;
		novoParam.Pergunta__c = paramOld.Pergunta__c ;
		novoParam.Tipo__c = paramOld.Tipo__c ;
		novoParam.Altura__c = paramOld.Altura__c;
		return novoParam;
		
	}
	
	private static VersaoWizard__c GerarProjetoWizard()
	{
		VersaoWizard__c novaVersao = new VersaoWizard__c();
		novaVersao.ProjetoWizard__c = versaoWizard.ProjetoWizard__c;
		return novaVersao;
	}
	
	private static Fluxo__c GerarFluxo(VersaoWizard__c versao,  Fluxo__c fluxoOld)
	{
		Fluxo__c fluxo = new Fluxo__c();
		fluxo.Name = fluxoOld.Name;
		fluxo.Versao__c = versao.id;
		fluxo.recordtypeid  = fluxoOld.recordtypeid;
		fluxo.Codigo__c = fluxoOld.Codigo__c;
		return fluxo;
	}
	
	class ObjetoReferencia
	{
		public ObjetoReferencia()
		{
			itensFilhos = new List<ObjetoReferencia>();
		}
		
		public sObject itemOriginal {get; set;}
		public sObject itemClone {get; set;}
		public List<ObjetoReferencia> itensFilhos {get; set;}
	}
	
	class CustomIterable  implements Iterator<ObjetoReferencia>{ 

	   List<ObjetoReferencia > Itens {get; set;} 
	   Integer i {get; set;} 
	
	   public CustomIterable(){ 
	      Itens = new List<ObjetoReferencia>();
	      i = 0;
	   }   
	
	   public boolean hasNext(){ 
	       if(i >= Itens.size()) {
	           return false; 
	       } else {
	           return true; 
	       }
	   }    
	
	   public ObjetoReferencia next(){ 
	       if(i == Itens.size()){return null;} 
	       i++; 
	       return Itens[i-1]; 
	   }
	   
	   public List<sObject> getOriginais()
	   {
	   		List<sObject> itensOriginais = new List<sObject>();
	   		
	   		for(ObjetoReferencia item : Itens)
	   		{
	   			itensOriginais.add(item.itemOriginal);
	   		}
	   		
	   		return itensOriginais;
	   }
	   
	   public List<sObject> getClones()
	   {
	   		List<sObject> itensOriginais = new List<sObject>();
	   		
	   		for(ObjetoReferencia item : Itens)
	   		{
	   			itensOriginais.add(item.itemClone);
	   		}
	   		
	   		return itensOriginais;
	   }
	}
}