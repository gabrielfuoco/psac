/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */


@isTest
public class TesteAtualizacaoCliente {

	static testMethod void myUnitTest() {
		
		Test.startTest();
		
		testarProduto();
		
		testarClienteDummy();

		testarPedido();
		
		testarClientesNovosSolicitacao();
        
        Test.stopTest();
    }
    
    public static void testarProduto()
    {
    	List<Produto> prods = new List<Produto>();
    	for(integer i = 0; i < 10; i++)
    	{
	    	Produto ped = new Produto();
	    	ped.B1_NOME = 'Produto 1'  + i;
			ped.B1_DESC = 'Desc Produto 1'  + i;
			ped.B1_COD = i + '';
			ped.B1_STSITU = '2';
			ped.B1_MSBLQL = '1';
			ped.B1_UM = 'UNidade';
			ped.AH_ZZFATOR = 5.5;
			ped.b1_stpesob = 73.48;
			ped.B1_PRVALID = 12;
			ped.EMPRESA = '01';
			prods.add(ped);
	    	
    	}
    	
    	List<RetornoAtualizacaoDados> retorno = RecepcaoService.AtualizarProduto(prods);
			
			for(RetornoAtualizacaoDados msg : retorno)
				System.assert(msg.Sucesso);
				
		
		retorno = RecepcaoService.AtualizarProduto(prods);
			
			for(RetornoAtualizacaoDados msg : retorno)
				System.assert(msg.Sucesso);
    }
    
    public static void testarClienteDummy()
    {
    	Account cliente = new Account();
		cliente.name = 'Germano ME';
		cliente.AccountNumber = '011001';
		cliente.Empresa__c = '01';
		cliente.CodigoLoja__c = '01';
		cliente.StatusERP__c = 'Integrar';
		cliente.AccountSource = 'site';
		cliente.Rating ='Parceiro';
		cliente.PessoaFisicaJuridica__c = 'Pessoa Física';
		cliente.NivelInfluencia__c ='Alto';
		cliente.StatusRelacionamento__c = 'Alto';
		cliente.NivelInfluenciaRegiao__c = 'Bom';
		cliente.TerritoriosAtrelados__c = 'Territórios';
		cliente.recordtypeid = [SELECT Id,name FROM RecordType WHERE SObjectType='Account' AND Name='Influenciador' LIMIT 1].id;
		cliente.recordtype = [SELECT Id,name FROM RecordType WHERE SObjectType='Account' AND Name='Influenciador' LIMIT 1];
		cliente.Industry = 'Alimentos';
		insert cliente;
    }
    

    private static void testarClientesNovosSolicitacao()
    {
    	List<RetornoNovosClientes> retorno = RecepcaoService.ClientesNaoIntegrados();

    	System.assert(retorno.size() > 0);
    	
    	RetornoSolicitacaoCliente ret = RecepcaoService.SolicitarCliente(retorno[0].id);
    	
    	System.assert(ret.DadosMensagem.Sucesso);
    	
    	testarCliente(retorno[0].id);
    }
    
    private static void testarPedido()
    {
    	Pedido ped = new Pedido();
    	
		ped.C5_NUM = '1258';
		ped.C5_CLIENTE = '10';
		ped.C5_EMISSAO = date.newInstance(2016, 2, 2);
		ped.C5_TIPO = 'N';
		ped.C5_CONDPAG = 'À VISTA';
		ped.C5_STTXSTR = 100;
		ped.C5_STTXPTX = 100;
		ped.C5_TPFRETE = 'FOB' ;
		ped.C5_STOBSPV = 'Compra antecipada';
		ped.C5_FILIAL = '01';
		ped.EMPRESA = '01';
		ped.C5_LOJACLI = '01';
		ped.Itens = new List<ItemPedido>();
		ped.C5_TABELA = '';
		for(integer i = 0; i <  2; i++)
		{
			ItemPedido itemPed = new ItemPedido();
			itemPed.C6_PRODUTO  = i + '';
			itemPed.C6_DESCRI = 'Entregar em 10 dias';
			itemPed.C6_QTDVEN = 100;
			itemPed.C6_PRCVEN = 200;
			itemPed.C6_VALOR = 300;
			itemPed.C6_STDESC1 = 50;
			itemPed.C6_ENTREG = date.newInstance(2016, 5, 1);
			itemPed.C6_STDESCC = 'Descrição 1';
			itemPed.C6_NUM = i + '';
			ped.Itens.add(itemPed);
		}
		
		RetornoAtualizacaoDados retorno = RecepcaoService.AtualizarPedido(ped);
		
		for(string msg : retorno.Mensagens)
			system.debug(msg);
			
		System.assert(retorno.Sucesso);
		
    }
    
	public static void testarCliente(string id)
	{
		Cliente clienteAtualizar = new Cliente();
		clienteAtualizar.id = id;
		clienteAtualizar.A1_NOME = 'Juca LTDA';
		clienteAtualizar.A1_STFAZEN = 'Germano Farm';
		clienteAtualizar.A1_COD = '10';
		clienteAtualizar.A1_LOJA = '01';
		clienteAtualizar.EMPRESA = '01';
		clienteAtualizar.A1_HPAGE = 'www.sottelli.com';
		clienteAtualizar.A1_TEL = '(19)9999-9999';
		clienteAtualizar.A1_TIPO = 'F';
		clienteAtualizar.A1_STSITUA =  '1';
		clienteAtualizar.A1_CEP = '13180-470';
		clienteAtualizar.A1_END ='r. são joão batista';
		clienteAtualizar.A1_COMPLEM = 'Jardim santa olivia';
		clienteAtualizar.A1_BAIRRO = 'Matão';
		clienteAtualizar.A1_EST = 'SAO PAULO';
		clienteAtualizar.A1_COD_MUN = '100';
		clienteAtualizar.A1_MUN = 'Sumaré';
		clienteAtualizar.A1_ENDCOB = 'R. Cobrança';
		clienteAtualizar.A1_PAISCOB = 'Brasil';
		clienteAtualizar.A1_PAISENTR = 'Brasil';
		clienteAtualizar.A1_BAIRROC = 'B. Cobrança';
		clienteAtualizar.A1_MUNC = 'Campinas';
		clienteAtualizar.A1_ESTC = 'SAO PAULO';
		clienteAtualizar.A1_CEPC = '13182-589';
		clienteAtualizar.A1_STFONEC = '(19)36983-9636';
		clienteAtualizar.A1_PESSOA = 'J';
		clienteAtualizar.A1_CGC = '28.241.457/0001-07';
		clienteAtualizar.A1_INSCRUR = 'INSC 1';
		clienteAtualizar.A1_INSCR = 'INSC 2';
		clienteAtualizar.A1_INSCRM = 'INSC 3';
		clienteAtualizar.A1_LC = 300.50;
		clienteAtualizar.A1_STORAT = 'RATING 1';
		clienteAtualizar.A1_STOPONT = 'RATING 2';
		clienteAtualizar.A1_STRANK = 100;
		clienteAtualizar.A1_STOEXP = 150;
		clienteAtualizar.A1_STCFIAN = '2';
		clienteAtualizar.A1_STVFIAN = date.newInstance(2017, 1, 1);
		clienteAtualizar.A1_STDOC = 'C';
		clienteAtualizar.A1_STVCAD = date.newInstance(2017, 2, 2);
		clienteAtualizar.A1_PRICOM= date.newInstance(2014, 3, 3);
		clienteAtualizar.A1_ULTCOM= date.newInstance(2015, 4, 4);
		clienteAtualizar.A1_EMAIL = 'renato.germano@sottelli.com';
		clienteAtualizar.A1_STEMCL = 'renato.germano@sottelli.com';
		clienteAtualizar.A1_STOKSER = true;
		clienteAtualizar.A1_STGARAN = true;
		clienteAtualizar.A1_STOBSC = 'OBSERVAÇÃO DO CADASTRO';
		clienteAtualizar.A1_STMAPA1 = true;
		clienteAtualizar.A1_STDTMP1 = date.newInstance(2016, 7, 7);
		clienteAtualizar.A1_STMAPA2 = true;
		clienteAtualizar.A1_STDTMP2 = date.newInstance(2016, 8, 8);
		clienteAtualizar.StatusERP = 'Integrar';
		//testando diversos tipos 
		RetornoAtualizacaoDados retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_TIPO = 'L';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_TIPO = 'R';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_TIPO = 'S';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_TIPO = 'X';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_TIPO = '';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_TIPO = 'X';
		clienteAtualizar.A1_STSITUA = '2';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_PESSOA = 'F';
		clienteAtualizar.A1_CGC = '398.661.928-30';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_STCFIAN = '1';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_STCFIAN = '2';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_STCFIAN = '3';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_STCFIAN = '4';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_STCFIAN = '';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);

		clienteAtualizar.A1_STDOC = 'C';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_STDOC = 'I';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_STDOC = 'V';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_STDOC = 'F';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_STDOC = 'N';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		
		clienteAtualizar.A1_STDOC = '';
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		System.assert(retorno.Sucesso);
		//////////////////////////////
		
		retorno = RecepcaoService.AtualizarCliente(null);
		
		System.assert(!retorno.Sucesso);
		
		clienteAtualizar.id = null;
		
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		
		System.assert(!retorno.Sucesso);
		
		clienteAtualizar.A1_NOME = null;
		
		retorno = RecepcaoService.AtualizarCliente(clienteAtualizar);
		
		System.assert(!retorno.Sucesso);
    } 
}