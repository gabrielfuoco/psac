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
private class TesteTriggerPrecoItem {

    static testMethod void myUnitTest() {
        Database.SaveResult result = null;
        
        Item__c item = new Item__c();
        item.name = 'Item Legal';
        item.Descricao__c = 'Descrição do item legal';
        Database.Insert(item);

        Test.startTest();
        
        PrecoItem__c item1 = new PrecoItem__c();
        
        item1.Item__c = item.Id;
        item1.CurrencyIsoCode  = 'BRL';
        item1.Vigencia__c = Date.today();
        item1.Preco__c = 0;
        
        result = Database.Insert(item1);
        
        System.assert(result.isSuccess());
        try
        {
            
            TraducaoItem__c trads =  [select id from TraducaoItem__c where Item__c = :item.id and Linguagem__c = 'Português'];
            
            Database.DeleteResult res =  Database.Delete(trads);
        }
        catch(Exception ex)
        {
            System.assert(true);
        }
        
        try
        {
             PrecoItem__c item2 = new PrecoItem__c();
        
            item2.Item__c = item.Id;
            item2.CurrencyIsoCode  = 'BRL';
            
            item2.Preco__c = 0;
            
            result = Database.Insert(item2);
            
            System.assert(!result.isSuccess());
            
        }catch(Exception ex)
        {
            System.assert(true);
        }
        
        Test.stopTest();
        
        
        
    }
}