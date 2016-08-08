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
private class TesteNotasFiscais {

    static testMethod void myUnitTest() {
		TesteAtualizacaoCliente.testarClienteDummy();
		TesteAtualizacaoCliente.testarProduto();
		
 		InserirNotasFiscais();
    }
    
    public static void InserirNotasFiscais()
    {
    	for(integer i = 0 ; i < 3; i++)
    	{
    		NotaFiscal nf = new NotaFiscal();
    		nf.F2_FILIAL     = '01';
			nf.F2_DOC        = '0000' + i;
			nf.F2_SERIE      = '00' + i;
			nf.F2_EMISSAO    = Date.newInstance(2016, 05 + i, 06 + i);
			nf.F2_CLIENTE    = '10';
			nf.F2_TIPO       = '1';
			nf.VLR_DOLAR     = 10.3;
			nf.VALBRUT_REAL  = 1;
			nf.VALBRUT_DOLAR = 3.5;
			nf.CC2_EST       = '2';
			nf.CC2_MUN       = '3';
			nf.F2_TIPOCLI    = '1';
			nf.F2_VEND1      = 'João Santos';
			nf.F2_MOEDA      = '1';
			nf.F2_STCONTR    = 'TESTE';
			nf.F2_LOJA = '01';
			nf.F2_ZZDTCTB    = Date.newInstance(2016,08,09);
			nf.EMPRESA = '01';
			
			nf.Itens = new List<ItemNotaFiscal>();
			
			for(integer j = 0 ; j < 3; j++)
    		{
    			ItemNotaFiscal itemNf = new ItemNotaFiscal();
    			
    			itemNf.D2_FILIAL    = '';
				itemNf.D2_DOC       = '0000' + i;
				itemNf.D2_SERIE     = '000' + i + j;
				itemNf.D2_LOJA      = 'LOJA 01';
				itemNf.D2_PEDIDO    = '10';
				itemNf.D2_ITEMPV    = '' + j;
				itemNf.D2_COD       = '' + j;
				itemNf.C6_DESCRI    = 'ITEM ' + j;
				itemNf.D2_UM        = '1';
				itemNf.VLR_DOLAR   = 300;
				itemNf.D2_QUANT    = 4;
				itemNf.PRCVEN_REAL = 100;
				itemNf.PRCVEN_DOLAR = 350;
				itemNf.TOTAL_REAL  = 350;
				itemNf.TOTAL_DOLAR = 700;
				itemNf.D2_DESC     = 10;
				itemNf.D2_EMISSAO   = Date.newInstance(2016,5,5);
				itemNf.B1_STDESBI   = 'PRODUTO LEGAL';
				itemNf.Z62_DESC     = 'SUB GRUPO PROD';
				itemNf.Z61_DESCRI   = 'GRUPO PROD';
				itemNf.AH_ZZFATOR  = 10;
				itemNf.D2_ZZCULT    = 'CULTURA';
				itemNf.ZZ8_GRUPO    = '1';
				itemNf.Z62_INOV     = '1';
				itemNf.B1_ZZCLCOM   = '1';
				itemNf.ZB0_UNINEG   = '1';
				itemNf.ZB0_REGIO    = 'REGIONAL';
				itemNf.D2_ZZTERRI   = 'ABC';
				itemNf.ZB0_DTERRI   = 'TERROTORIO';
    			nf.Itens.add(itemNf);
    		}
    		
    		RetornoAtualizacaoDados retorno = RecepcaoService.AtualizarNotaFiscal(nf);
    		
    		for(string msg : retorno.Mensagens)
				system.debug(msg);
			
			System.assert(retorno.Sucesso);
    	}
    }
}