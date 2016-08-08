@isTest
public class TesteLinguagemItens {
	@isTest static void ExecutarTesteItens() 
    {
        Database.SaveResult result = null;
        Database.DeleteResult deleteresult = null;
        
        Item__c item = new Item__c();
        item.Name = 'Item 1';
        item.Descricao__c = 'Item 1 descrição';
        
        Test.startTest();
		//INSERIR ITEM 1
        result =  Database.insert(item);
        System.assert(result.isSuccess());
        
        TraducaoItem__c tradItem = [select id, name, Linguagem__c 
                                     from TraducaoItem__c where Item__r.id = :item.id and linguagem__c = 'Português'];

        //INSERIR TRADUÇÃO Inglês
        TraducaoItem__c tradItemIng = new TraducaoItem__c();
        tradItemIng.Item__c = item.id;
        tradItemIng.Name = 'Item 2';
        tradItemIng.Linguagem__c = 'Inglês';
        insert tradItemIng;
        
        //ATUALIZAR ITEM 1 PARA ITEM 2 xD
        item.Name = 'Item 2';
        result =  Database.update(item);
        System.assert(result.isSuccess());
        
         //ATUALIZAR TIPO DE descrição
        tradItem.Name = 'Descrição legal';
        result =  Database.update(tradItem);
        System.assert(result.isSuccess());
        
        try
        {
       		//ATUALIZAR TIPO DE TRADUÇÃO
            tradItem.Linguagem__c = 'Inglês';
            result =  Database.update(tradItem);
            
        }catch(Exception ex)
        {
            System.assert(true);
        }
        
        try
        {
            //Excluir item em portugues
            tradItem.Linguagem__c = 'Português';
            deleteresult =  Database.delete(tradItem.Id);
            System.assert(!result.isSuccess());
        }catch(Exception ex)
        {
            System.assert(true);
        }
         
        //Excluir item em InglÊs
        deleteresult =  Database.delete(tradItemIng.Id);
        System.assert(deleteresult.isSuccess());
        
        //INSERIR TRADUÇÃO portugues (Duplicado)
        //
        try
        {
            TraducaoItem__c tradItemdup = new TraducaoItem__c();
            tradItemdup.Item__c = item.id;
            tradItemdup.Name = 'Item 3';
            tradItemdup.Linguagem__c = 'Português';
            insert tradItemdup;    
            System.assert(!result.isSuccess());
        }catch(Exception ex)
        {
            System.assert(true);
        }
        
        Test.stopTest();
        
    }
}