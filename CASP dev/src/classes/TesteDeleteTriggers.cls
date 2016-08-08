@isTest
public class TesteDeleteTriggers {
	@isTest
    public static void Executar()
    {
        TestMatrizParametrizacaoController.TestarParametrizacao();
        
       // List<TraducaoMatriz__c> itens = [select id from TraducaoMatriz__c];
        TraducaoMatriz__c itens = new TraducaoMatriz__c(name = 'oi', Linguagem__c ='Espanhol'); insert itens;
        try
        {
        	delete itens;
        }catch(Exception ex)
        {}
        
        Parametro__c param = [select id from Parametro__c limit 1];
        
        CodigoFonte__c cod = new CodigoFonte__c();
        cod.Codigo__c = 'asdsaddsa';
        cod.Parametro__c = param.id;
        cod.Name = 'name';
        
        insert cod;
        
        cod = [select id from CodigoFonte__c where id = :cod.Id ];
        try
        {
        delete cod;
        }catch(Exception ex)
        {}
         try
        {
        delete param;
        }catch(Exception ex)
        {}
    }
}