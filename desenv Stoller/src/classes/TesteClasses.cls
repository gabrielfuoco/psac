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
@isTest(seealldata=true)
private class TesteClasses {

    static testMethod void myUnitTest() {
    	
		testarProduto();
		testarTabelaPreco();
    }
    
    private static  void testarTabelaPreco()
    {
    	for(integer i = 0; i < 1; i++)
    	{
    		CatalogoPreco catalogo = new CatalogoPreco();
    		catalogo.DA0_ATIVO  = '1';
			catalogo.DA0_DESCRI = 'O item acompanha embalagem';
			catalogo.DA0_CODTAB = i + '';
			catalogo.DA0_DATDE  = Datetime.newInstance(2016 - i, 2 - i, 17 - i);
			catalogo.DA0_DATATE = Datetime.newInstance(2017 + i, 2 + i, 17 + i);
			catalogo.DA0_TPHORA = 'GMT';
			catalogo.DA0_ZZEST  = 'Acre';
			catalogo.Itens = new List<ItemCatalogoPreco>();
			catalogo.EMPRESA = '01';
			
			for(integer j = 0; j < 1; j++)
    		{
    			ItemCatalogoPreco item = new ItemCatalogoPreco();
    			item.DA1_ATIVO = '1' ;
				item.DA1_CODPRO= j + '';
				item.DA1_MOEDA = '1';
				item.DA1_PRCVEN= 100.23;
				item.DA1_ITEM  = 'prod' + j;
				item.DA1_CODTAB= i + '';
				item.DA1_TPOPER= j + '';
				item.DA1_DATVIG = Date.newInstance(2017 + j, 2 + j, 17 + j);
				catalogo.Itens.add(item);
    		}
    		
    		RetornoAtualizacaoDados retorno = RecepcaoService.AtualizarCatalogoPreco(catalogo);
    		
    		for(string msg : retorno.Mensagens)
				system.debug(msg);
			
    		System.assert(retorno.Sucesso);
    	}
    }
    
    private static void testarProduto()
    {
    	List<Product2> produtos = new List<Product2>();
    	
    	for(integer i = 0; i < 6; i++)
    	{	
    		Product2 prod = new Product2();
			prod.name =  '01prod'+ i;
			prod.productcode = '01' + i + '';
			
			produtos.add(prod);
    	}
    	
    	insert produtos;
    }
}