public with sharing class ProcessarNotaFiscal {
	private static string chaveNF = '';
	private static string empresa = '';
    public static RetornoAtualizacaoDados Executar(NotaFiscal notaFiscal)
    {
		RetornoAtualizacaoDados retorno = new RetornoAtualizacaoDados();
    	
    	if(notaFiscal == null)
    	{
    		 retorno.AdicionarMenasgem('É necessário informar a Nota Fiscal', false);
    		 return retorno;
    	}
    	
    	if(notaFiscal.EMPRESA == null || notaFiscal.EMPRESA == '')
		{			
			retorno.AdicionarMenasgem('Campo EMPRESA é obrigatório', false);
			return retorno;
		}
		
		empresa = notaFiscal.EMPRESA.trim();
		
		chaveNF = empresa + notaFiscal.F2_FILIAL.trim() + notaFiscal.F2_DOC.trim() + notaFiscal.F2_SERIE.trim() + notaFiscal.F2_CLIENTE.trim() + notaFiscal.F2_LOJA.trim();
    	
    	List<NotaFiscal__c> notaFiscais = [select id, name from NotaFiscal__c 
    										where Name = :chaveNF];	
		
		if(notaFiscais.size() > 0)
			delete notaFiscais;
			
		try
		{
			ConverterNotaCustom(notaFiscal);
		}
		catch(Exception ex)
		{
			retorno.AdicionarMenasgem(ex.getMessage(), false);
			
			return retorno;
		}
		
		retorno.AdicionarMenasgem('Nota fiscal processada com sucesso!', true);

		return retorno;
    }
    
    private static NotaFiscal__c ConverterNotaCustom(NotaFiscal notaFiscal)
    {
    	NotaFiscal__c nf = new NotaFiscal__c();
		
		string codCli = empresa + notaFiscal.F2_CLIENTE.trim() + notaFiscal.F2_LOJA.trim();
		
		List<Account> conta = [select id, name from account where AccountNumber = :codCli];
    	
    	if(conta.size() == 0)
    		throw new MyException('Cliente não encontrado!');
    	
    	nf.Name = chaveNF;
    	nf.Empresa__c = empresa;
    	nf.Conta__c = conta[0].id;
    	nf.Filial__c = notaFiscal.F2_FILIAL;
		nf.SerieNF__c = notaFiscal.F2_SERIE;
		nf.DataEmissao__c = DateExtension.ParaSalesforceDate(notaFiscal.F2_EMISSAO);
		nf.TipoNF__c = notaFiscal.F2_TIPO;
		nf.ValorDolar__c = notaFiscal.VLR_DOLAR;
		nf.ValorReal__c = notaFiscal.VALBRUT_REAL;
		nf.ValorDolar__c = notaFiscal.VALBRUT_DOLAR;
		nf.EstadoEntrega__c = notaFiscal.CC2_EST;
		nf.CidadeEntrega__c = notaFiscal.CC2_MUN;
		nf.TipoCliente__c = notaFiscal.F2_TIPOCLI;
		nf.NomeRTV__c = notaFiscal.F2_VEND1;
		nf.TaxaDolar__c = notaFiscal.VLR_DOLAR;
		if(notaFiscal.F2_MOEDA == '1')
    		nf.CurrencyIsoCode = 'BRL';
    	else
    		nf.CurrencyIsoCode = 'USD';

		nf.TIPOCONTR__c = notaFiscal.F2_STCONTR;
		nf.DtCutOff__c = DateExtension.ParaSalesforceDate(notaFiscal.F2_ZZDTCTB);
		
		upsert nf;
		
		List<string> prodcuctCode = new List<string>();
		List<string> pedidosCode = new List<string>();
		
    	for(ItemNotaFiscal item : notaFiscal.Itens)
    	{
    		prodcuctCode.add(empresa + item.D2_COD.trim());
    		pedidosCode.add(empresa + item.D2_FILIAL.trim() + item.D2_PEDIDO.trim());
    	}
    	
    	List<Product2> produtos = [select id, name, ProductCode from Product2 where ProductCode in :prodcuctCode ];
    	
    	List<ItemNotaFiscal__c> itensNovos = new List<ItemNotaFiscal__c>();
    	
    	List<Pedido__c> pedidos = [select id, name from Pedido__c where name = :pedidosCode];
    	
    	List<ItemPedido__c> itensPedido = [select id, name from ItemPedido__c where Pedido__r.Name = :pedidosCode];
    	
    	Map<string , ItemPedido__c> itensPedidoMap = new Map<string , ItemPedido__c>();
    	
    	for(ItemPedido__c itPed : itensPedido)
    		itensPedidoMap.put(itPed.Name, itPed);
    	
		for(ItemNotaFiscal item : notaFiscal.Itens )
		{
			string codItem = empresa + item.D2_FILIAL.trim() + item.D2_PEDIDO.trim() +  item.D2_ITEMPV.trim();
			
    		itensNovos.add(ConverteParaItemNotaFiscal(nf, conta[0], item, produtos, pedidos, itensPedidoMap.get(codItem), codItem));
		}
    	insert itensNovos;
    	
    	return nf;
    }
    
    private static ItemNotaFiscal__c ConverteParaItemNotaFiscal(NotaFiscal__c nf, Account conta, 
    									ItemNotaFiscal itemInc, List<Product2> produtos, 
    									List<Pedido__c> pedidos, ItemPedido__c itemPed, string codigoItem)
    {
    	ItemNotaFiscal__c itemNF = new ItemNotaFiscal__c();
    	itemNF.Name = codigoItem;
    	itemNF.Filial__c = itemInc.D2_FILIAL;
		itemNF.NotaFiscal__c = nf.id;
		itemNF.Cliente__c = conta.id;
		
		string codPed = empresa + itemInc.D2_FILIAL.trim() + itemInc.D2_PEDIDO.trim();
		
		Pedido__c ped = PedidoPorCodigo(pedidos, codPed);
		
		if(ped != null)
			itemNF.Pedido__c = ped.id;
			
		itemNF.CodigoProduto__c = ProdutoPorCodigo(produtos , empresa + itemInc.D2_COD.trim()).id;
		
		if(itemPed != null)
			itemNF.ItemPedido__c = itemPed.Id;
			
		itemNF.DescricaoAuxiliar__c = itemInc.C6_DESCRI;
		itemNF.UnidadeMedida__c = itemInc.D2_UM;
		itemNF.TaxaDolar__c = itemInc.VLR_DOLAR;
		itemNF.QuantidadeVendida__c = itemInc.D2_QUANT;
		itemNF.PrecoUnitarioReal__c = itemInc.PRCVEN_REAL;
		itemNF.PrecoUnitarioDolar__c = itemInc.PRCVEN_DOLAR;
		itemNF.ValorTotalItemReal__c = itemInc.TOTAL_REAL;
		itemNF.ValorTotalItemDolar__c = itemInc.TOTAL_DOLAR;
		itemNF.DescontoStoller__c = itemInc.D2_DESC;
		itemNF.DataEntrega__c = DateExtension.ParaSalesforceDate(itemInc.D2_EMISSAO);
		itemNF.SubGrupoProduto__c = itemInc.Z62_DESC;
		itemNF.GrupoProduto__c = itemInc.Z61_DESCRI;
		itemNF.Litros__c = itemInc.AH_ZZFATOR;
		itemNF.Cultura__c = itemInc.D2_ZZCULT;
		itemNF.GrupoCultura__c = itemInc.ZZ8_GRUPO;
		itemNF.GrupoInovacao__c = itemInc.Z62_INOV;
		itemNF.ClassificacaoComercial__c = itemInc.B1_ZZCLCOM;
		itemNF.UnidadeNegocios__c = itemInc.ZB0_UNINEG;
		itemNF.Regional__c = itemInc.ZB0_REGIO;
		itemNF.CodTerritorio__c = itemInc.D2_ZZTERRI;
		itemNF.Territorio__c = itemInc.ZB0_DTERRI;
    	itemNF.NumeroPedido__c = codPed;
    	return itemNF;
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
    
    private static Pedido__c PedidoPorCodigo(List<Pedido__c> pedidos, string codigo)
    {
    	for(Pedido__c ped : pedidos)
    	{
    		if(codigo == ped.name)
    			return ped;
    	}
		
		return null;
    }
    
    public class MyException extends Exception {}
}