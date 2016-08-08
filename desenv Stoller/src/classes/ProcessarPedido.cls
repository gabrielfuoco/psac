public with sharing class ProcessarPedido {
	
	private static string empresa = '';
	private static string codPed = '';
	private static string codCli = '';
	private static string codTabPre = '';
    public static RetornoAtualizacaoDados Executar(Pedido ped)
    {
		RetornoAtualizacaoDados retorno = new RetornoAtualizacaoDados();
    	
    	if(ped == null)
    	{
    		 retorno.AdicionarMenasgem('É necessário informar o pedido', false);
    		 return retorno;
    	}
    	
    	if(ped.EMPRESA == null || ped.EMPRESA == '')
		{			
			retorno.AdicionarMenasgem('Campo EMPRESA é obrigatório', false);
			return retorno;
		}
    	
    	empresa = ped.EMPRESA.trim();
    	
		codPed = empresa + ped.C5_FILIAL.trim() + ped.C5_NUM.trim();
		
		codCli = empresa + ped.C5_CLIENTE.trim() + ped.C5_LOJACLI.trim();
    	
    	codTabPre = empresa + ped.C5_TABELA.trim();
    	
    	List<Pedido__c> pedidos = [select id, name from Pedido__c where Name = :codPed];	
		
		if(pedidos.size() > 0)
			delete pedidos;
			
		try
		{
			ConverterParaPedidoCustom(ped);
		}
		catch(Exception ex)
		{
			retorno.AdicionarMenasgem(ex.getMessage(), false);
			
			return retorno;
		}
		
		retorno.AdicionarMenasgem('Pedido processado com sucesso!', true);

		return retorno;
    }
    
    private static Pedido__c ConverterParaPedidoCustom(Pedido pedOld)
    {
    	Pedido__c ped = new Pedido__c();
   	
    	ped.DataAtivada__c = DateExtension.ParaSalesforceDate(pedOld.C5_EMISSAO);
    	
    	List<Account> conta = [select id, name from account where AccountNumber = :codCli];
    	
    	if(conta.size() == 0)
    		throw new MyException('Cliente não encontrado!');
    	
    	List<Pricebook2> catalogos = [select id, name from Pricebook2 where name =:codTabPre];
    	
    	ped.Name = codPed;
    	ped.Conta__c = conta[0].id;
    	ped.Empresa__c = empresa;
    	
    	if(catalogos.size() > 0)
    	{
    		ped.CatalogoPreco__c = catalogos[0].Id;
    	}
    	
    	if(pedOld.C5_TIPO == 'N')
    		ped.TipoPedido__c = 'Normal';
    	else if(pedOld.C5_TIPO == 'C')
    		ped.TipoPedido__c = 'Compl. Precos';
    	else if(pedOld.C5_TIPO == 'I')
    		ped.TipoPedido__c = 'Compl. ICMS';
    	else if(pedOld.C5_TIPO == 'P')
    		ped.TipoPedido__c = 'Compl. IPI';
    	else if(pedOld.C5_TIPO == 'D')
    		ped.TipoPedido__c = 'Dev. Compras';
    	else if(pedOld.C5_TIPO == 'B')
    		ped.TipoPedido__c = 'Utiliza Fornecedor';
    	else
    		ped.TipoPedido__c = '';
    		
    	ped.CondicaoPagamento__c = pedOld.C5_CONDPAG;
    	ped.TaxaStoller__c	= pedOld.C5_STTXSTR;
		ped.TaxaPetax__c = pedOld.C5_STTXPTX;
    	ped.TipoFreteUtilizado__c = pedOld.C5_TPFRETE;
    	ped.ObservacaoPedido__c = pedOld.C5_STOBSPV;
    	
    	insert ped;

		List<string> prodcuctCode = new List<string>();
    	for(ItemPedido item : pedOld.Itens)
    		prodcuctCode.add(empresa + item.C6_PRODUTO.trim());
    	
    	List<Product2> produtos = [select id, name, ProductCode from Product2 where ProductCode in :prodcuctCode ];
    	
    	Map<string, Product2> produtosMap = new Map<string, Product2>();
    	
    	for(Product2 prod :produtos )
    		produtosMap.put(prod.ProductCode, prod);
    		
    	List<ItemPedido__c> itensNovos = new List<ItemPedido__c>();
    	
		for(ItemPedido item :pedOld.Itens )
    		itensNovos.add(ConverteParaItemPedido(ped, item, produtosMap.get(empresa + item.C6_PRODUTO.trim())));
    	
    	insert itensNovos;
    	
    	return ped;
    }
    
    private static ItemPedido__c ConverteParaItemPedido(Pedido__c ped, ItemPedido itemOld, Product2 produto)
    {
    	if(produto == null)
    		throw new MyException('Produto "' + empresa + itemOld.C6_PRODUTO + '" não encontrado!');
    		
    	ItemPedido__c itemPed = new ItemPedido__c();
    	
    	itemPed.name = empresa + itemOld.C6_FILIAL + itemOld.C6_NUM + itemOld.C6_ITEM;
		
		itemPed.ItemCatalogoPreco__c = codTabpre + itemOld.C6_PRODUTO;
    	itemPed.Produto__c = produto.id;
    	itemPed.DescricaoAuxiliar__c = itemOld.C6_DESCRI;
    	itemPed.QuantidadeVendida__c = itemOld.C6_QTDVEN;
    	itemPed.PrecoUnitarioLiquido__c = itemOld.C6_PRCVEN;
    	itemPed.ValorTotalItem__c = itemOld.C6_VALOR;
    	itemPed.DescontoStoller__c = itemOld.C6_STDESC1;
    	itemPed.DataEntrega__c = DateExtension.ParaSalesforceDate(itemOld.C6_ENTREG);
    	itemPed.DescCultura__c = itemOld.C6_STDESCC;
    	itemPed.Pedido__c = ped.id;
    	
    	return itemPed;
    }
    
    public class MyException extends Exception {}

}