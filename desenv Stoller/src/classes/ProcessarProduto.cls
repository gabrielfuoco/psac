public with sharing class ProcessarProduto {
	
	public static List<RetornoAtualizacaoDados> Executar(List<Produto> prods)
	{
		List<RetornoAtualizacaoDados> retorno = new List<RetornoAtualizacaoDados>();
    	
    	if(prods == null || prods.size() == 0)
    	{
    		AdicionarMensagemErro(retorno,'É necessário informar os produtos', false );
    		
    		return retorno;
    	}
    	
    	Map<string, Produto> produtos = new Map<string, Produto>();
    	
    	for(integer i = 0; i < prods.size(); i++)
    	{
    		if(prods[i].EMPRESA == null || prods[i].EMPRESA == '')
    		{
    			AdicionarMensagemErro(retorno,'Campo EMPRESA é obrigatório', false );
    			return retorno;
    		}
    		
    		produtos.put(prods[i].EMPRESA.trim() + prods[i].B1_COD.trim(), prods[i] );
    	}
    	
    	List<Product2> produtos2 = [select id, name, Description, ProductCode,
    									 IsActive,  Bloqueio__c, UnidadeMedida__c, 
    									 Litros__c, PesoBruto__c, PrazoValidade__c
    								 from Product2 where ProductCode = :produtos.keySet()];	
		
		Map<string, Product2> produtosMap = new Map<string, Product2>();
		
		for(integer i = 0; i < produtos2.size(); i++)
    	{
    		produtosMap.put(produtos2[i].ProductCode, produtos2[i]);
    	}
    	
    	List<Product2> aUpsert = new List<Product2>();
    	
		for (string idKey : produtos.keyset())
		{
			try
			{
				aUpsert.add(ConverterParaProduto2(produtosMap.get(idKey), produtos.get(idKey), idKey));
			}
			catch(Exception ex)
			{
				AdicionarMensagemErro(retorno,'Produto: ' + idKey + ' - ' + ex.getMessage(), false );
			} 
		}
		
		upsert aUpsert;
		
		if(retorno.size() == 0)
		{
			AdicionarMensagemErro(retorno, 'Produtos processados com sucesso!', true );
		}

		return retorno;
	}
	
	private static Product2 ConverterParaProduto2(Product2 produto2, Produto produto, string codProd)
	{
		if(produto2 == null)
			produto2 = new Product2();
			
		produto2.name = produto.B1_NOME;
		produto2.Empresa__c = produto.EMPRESA.trim();
		
		if(produto2.Description == null || produto2.Description == '')
			produto2.Description = produto.B1_DESC;
			
		produto2.ProductCode = codProd;
		produto2.DescricaoCientifica__c = produto.B1_DESC;
		
		if(produto.B1_STSITU == '1')
			produto2.IsActive = true;
		else
			produto2.IsActive = false;
			
		if(produto.B1_MSBLQL == '1')
			produto2.Bloqueio__c = 'Não Operacional';
		else
			produto2.Bloqueio__c = 'Operacinal';
			
	  	produto2.UnidadeMedida__c = produto.B1_UM;
		produto2.Litros__c = produto.AH_ZZFATOR;
		produto2.PesoBruto__c = produto.b1_stpesob;
		produto2.PrazoValidade__c = produto.B1_PRVALID;
		
		return produto2;
	}
	
	private static void AdicionarMensagemErro(List<RetornoAtualizacaoDados> retorno, string mensagem, boolean sucesso)
	{
		RetornoAtualizacaoDados ret = new RetornoAtualizacaoDados();
		ret.AdicionarMenasgem(mensagem, sucesso);
		retorno.add(ret);
	}
	
}