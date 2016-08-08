@isTest(SeeAllData=true)
public class TesteInsertUpdateMargem {
	
    @isTest
    public static void Executar()
    {
        Item__c item = new Item__c();
        item.name = 'Item Legal :D';
        item.Descricao__c = 'Descrição do item legal :D';
        Database.Insert(item);
         
        User user = [select id from user LIMIT 1];
        
        MargemVendedor__c margem1 = null;
        try
        {
            
            
            for(integer i = 0 ; i < 2 ; i++)
            {
                margem1 = new MargemVendedor__c();
                margem1.Vendedor__c = user.Id;
                margem1.Item__c = item.id;
                margem1.Margem__c = 50;
                
                insert margem1;
            }
        }
        catch(Exception ex)
        {
            
        }
        
        try
        {
            for(integer i = 0 ; i < 1 ; i++)
            {
                List<MargemVendedor__c> itens = new List<MargemVendedor__c>();
                itens.add(margem1);
                
                for(integer y = 0; y< 2 ; y++)
                {
                    MargemVendedor__c margem = new MargemVendedor__c();
                    margem.Vendedor__c = user.Id;
                    margem.Item__c = item.id;
                    margem.Margem__c = 50;
                    itens.add(margem);
                }
                upsert itens;
            } 
        }catch(Exception ex)
        {
            
        }
        
    }
}