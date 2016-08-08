global with sharing class ProcessarCatalogoPreco {
    
    private static string codTab = '';
    private static string empresa = '';
    
    public static RetornoAtualizacaoDados Executar(CatalogoPreco catalogo)
    {
    	RetornoAtualizacaoDados retorno = new RetornoAtualizacaoDados();
    	
    	if(catalogo == null)
    	{
    		 retorno.AdicionarMenasgem('É necessário informar o catálogo', false);
    		 return retorno;
    	}
    	
    	if(catalogo.EMPRESA == null || catalogo.EMPRESA == '')
		{			
			retorno.AdicionarMenasgem('Campo EMPRESA é obrigatório', false);
			return retorno;
		}
    	
    	empresa = catalogo.EMPRESA.trim();
    	codTab = empresa + catalogo.DA0_CODTAB.trim();
    	
    	List<Pricebook2> catalogos = [select id, name, IsActive, IsStandard, Description, DataHoraValidadeFinal__c, 
    								DataHoraValidadeInicial__c, Estados__c, TipoHorario__c from Pricebook2 
    								where name = :codTab];
    								
    	if(catalogos.size() == 0)
    		catalogos.add(new Pricebook2());
    		
    		
    	try
		{
			ConverterCatalogoPreco(catalogos[0], catalogo);
		}
		catch(Exception ex)
		{
			retorno.AdicionarMenasgem(ex.getMessage(), false);
			
			return retorno;
		}
		
		retorno.AdicionarMenasgem('Catalogo de preços atualizado com sucesso!', true);
		
    	return retorno;
    }
    
    private static void NovoItemCatalogoPadrao(List<ItemCatalogoPreco> itemCat, List<Product2> produtos)
    {
    	Pricebook2 standardPB = [Select Id, Name, IsActive From Pricebook2 where IsStandard = true LIMIT 1];

    	List<PricebookEntry> itensCatalogo = [select id, name,ProductCode, Product2id, Pricebook2id, IsActive, UnitPrice, UseStandardPrice, CurrencyIsoCode, TipoOperacao__c, Vigencia__c from PricebookEntry where pricebook2.id = :standardPB.id];
    	
    	List<PricebookEntry> produtosPadrao = new List<PricebookEntry>();
    	
    	for(ItemCatalogoPreco item : itemCat)
    	{
    		boolean existe = false;
    		
    		Product2 pdo = null;
    		
			for(Product2 prod : produtos)
			{
				if(prod.ProductCode == empresa + item.DA1_CODPRO.trim())
					pdo = prod;
			}
			
			for(PricebookEntry prod : itensCatalogo)
			{
				string moeda = '';
				if(item.DA1_MOEDA == '1')
		    		moeda = 'BRL';
		    	else
		    		moeda = 'USD';
		    		
				if(prod.product2id == pdo.id && 
				   moeda == prod.CurrencyIsoCode)
					existe = true;
			}

			if(!existe){
				PricebookEntry standardPrice = new PricebookEntry(  Pricebook2Id = standardPB.Id, 
															    	Product2Id = pdo.Id, 
															    	UnitPrice = item.DA1_PRCVEN, 
															    	IsActive = true,
															    	UseStandardPrice = false);
				if(item.DA1_MOEDA == '1')
		    		standardPrice.CurrencyIsoCode = 'BRL';
		    	else
		    		standardPrice.CurrencyIsoCode = 'USD'; 
		    		
				produtosPadrao.add(standardPrice);
			}
    	}
    	
        upsert produtosPadrao;
    }
    
    private static Pricebook2 ConverterCatalogoPreco(Pricebook2 pricebook, CatalogoPreco catalogo)
    {
    	pricebook.name = empresa + catalogo.DA0_CODTAB.trim();
    	pricebook.Description = catalogo.DA0_DESCRI;
    	pricebook.Empresa__c = empresa;
    	
    	if(catalogo.DA0_ATIVO == '1')
    		pricebook.IsActive = true;
    	else
    		pricebook.IsActive = false;
    		
    	pricebook.DataHoraValidadeFinal__c = DateExtension.ParaSalesforceDateTime(catalogo.DA0_DATDE);
    	pricebook.DataHoraValidadeInicial__c = DateExtension.ParaSalesforceDateTime(catalogo.DA0_DATATE);
    	pricebook.TipoHorario__c = catalogo.DA0_TPHORA;

    	pricebook.Estados__c = catalogo.DA0_ZZEST;
    	
    	upsert pricebook;
    	
    	List<string> itensCat = new List<string>();

    	for(ItemCatalogoPreco item : catalogo.Itens)
    		itensCat.add(empresa + item.DA1_CODPRO.trim());
    		
    	List<PricebookEntry> itens = new List<PricebookEntry>();

    	List<Product2> products = [select id, name, ProductCode from Product2 where ProductCode in :itensCat];

    	List<PricebookEntry> oldItens = [select id, name,ProductCode, Product2id, Pricebook2id, 
							    		IsActive, UnitPrice, UseStandardPrice, CurrencyIsoCode, 
							    		TipoOperacao__c, Vigencia__c from PricebookEntry 
							    		where pricebook2.id = :pricebook.id];
    	
    	if(oldItens.size() > 0)
    		InativarProds(oldItens, catalogo.Itens);
    	
    	NovoItemCatalogoPadrao(catalogo.Itens, products);

    	for(ItemCatalogoPreco item : catalogo.Itens)
    	{
    		PricebookEntry entry = ParaPricebookEntry(EncontrarPriceBookEntry(item, oldItens), pricebook, item, products );
    		
			itens.add(entry);
    	}

    	upsert(itens);

		return pricebook;
    }
    
    private  static PricebookEntry ParaPricebookEntry(PricebookEntry entry, Pricebook2 pricebook,ItemCatalogoPreco item, List<Product2> produtos)
    {
    	if(entry == null)
    	{
    		entry = new PricebookEntry();
   			entry.Product2id = ProdutoPorCodigo(produtos, empresa + item.DA1_CODPRO).id;
   			entry.Pricebook2id = pricebook.id;
   			
   			if(item.DA1_MOEDA == '1')
    			entry.CurrencyIsoCode = 'BRL';
	    	else
	    		entry.CurrencyIsoCode = 'USD'; 
    	}
    	
    	if(item.DA1_ATIVO == '1')
    		entry.IsActive = true;
    	else
    		entry.IsActive = false;
    		
    	if(!entry.UseStandardPrice)
    		entry.UnitPrice = item.DA1_PRCVEN;
    	
    	if(item.DA1_TPOPER == '1')
    		entry.TipoOperacao__c = 'Estadual';
    	else if(item.DA1_TPOPER == '2')
    		entry.TipoOperacao__c = 'InterEstadual';
    	else if(item.DA1_TPOPER == '3')
    		entry.TipoOperacao__c = 'Norte/Nordeste';
    	else if(item.DA1_TPOPER == '4')
    		entry.TipoOperacao__c = 'Todos';
    	else
    		entry.TipoOperacao__c = '';
    	
    	entry.Vigencia__c = DateExtension.ParaSalesforceDate(item.DA1_DATVIG);
    	
    	return entry;
    }
    
    private static Product2 ProdutoPorCodigo(List<Product2> produtos, string codigo)
    {
    	for(Product2 prod : produtos)
    	{
    		if(codigo == prod.ProductCode)
    			return prod;
    	}
    	
		throw new MyException('Produto "' + codigo +'" não encontrado!');
    }
    
    private static void InativarProds(List<PricebookEntry> produtos, List<ItemCatalogoPreco> itens)
    {
    	for(PricebookEntry prod : produtos)
    	{
    		boolean existe = false;
    		
    		for(ItemCatalogoPreco itemTab :itens )
    		{
    			string moeda = '';
			
				if(itemTab.DA1_MOEDA == '1')
		    		moeda = 'BRL';
		    	else
		    		moeda = 'USD';
	    		
	    		if(empresa + itemTab.DA1_CODPRO == prod.ProductCode && prod.CurrencyIsoCode == moeda)
	    			existe = true;
    		}
    		
    		if(!existe)
    			prod.IsActive = false;
    		 
    	}
    }
    
    private static PricebookEntry EncontrarPriceBookEntry(ItemCatalogoPreco item, List<PricebookEntry> itens)
    {
    	for(PricebookEntry itemTab :itens )
		{
			string moeda = '';
			
			if(item.DA1_MOEDA == '1')
	    		moeda = 'BRL';
	    	else
	    		moeda = 'USD';
    		
    		if(itemTab.ProductCode == item.DA1_CODPRO && itemTab.CurrencyIsoCode == moeda)
    		{
    			return itemTab;
    		}
		}
		
		return null;
    }
    
    public class MyException extends Exception {}
}