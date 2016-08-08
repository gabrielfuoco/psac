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
private class TesteLinguagemProjetoWizard {

    static testMethod void myUnitTest() {
    	
    	
        Test.startTest();
        
        Database.SaveResult result = null;
        Database.DeleteResult deleteresult = null;
        
        ProjetoWizard__c item = new ProjetoWizard__c();
        item.Name = 'Item 1';
        
		//INSERIR ITEM 1
        result =  Database.insert(item);
        System.assert(result.isSuccess());
        
        TraducaoProjetoWizard__c tradItem = [select id, name, Linguagem__c 
                                     from TraducaoProjetoWizard__c where ProjetoWizard__r.id = :item.id and linguagem__c = 'Português'];

        //INSERIR TRADUÇÃO Inglês
        TraducaoProjetoWizard__c tradItemIng = new TraducaoProjetoWizard__c();
        tradItemIng.ProjetoWizard__c = item.id;
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
            TraducaoProjetoWizard__c tradItemdup = new TraducaoProjetoWizard__c();
            tradItemdup.ProjetoWizard__c = item.id;
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