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
private class TesteDescontoRepresentante {

    static testMethod void myUnitTest() {
      Database.SaveResult result = null;
        
        Test.startTest();
        
        Item__c item = new Item__c();
        item.name = 'Item LegalL';
        item.Descricao__c = 'Descrição do item legalL';
        item.RecordTypeId = [select Id from RecordType where Name = 'Equipamento' and SobjectType = 'Item__c'].Id;
        
        Database.Insert(item);
        
        DescontoVendedor__c item1 = new DescontoVendedor__c();
        
        item1.Item__c = item.Id;
        item1.CurrencyIsoCode  = 'BRL';
        
        item1.DescontoMaximo__c = 0;
        item1.Vendedor__c = '00561000001QZMYAA4';
        
        result = Database.Insert(item1);
        
        System.assert(result.isSuccess());
        
        try
        {
            DescontoVendedor__c item2 = new DescontoVendedor__c();
        
            item2.Item__c = item.Id;
            item2.CurrencyIsoCode  = 'BRL';
            item2.DescontoMaximo__c = 0;
            item2.Vendedor__c = '00561000001QZMYAA4';
            
            result = Database.Insert(item2);
            
            System.assert(!result.isSuccess());
        
        }catch(Exception ex)
        {
            System.assert(true);
        }
        
        Test.stopTest();
        
        
    }
}