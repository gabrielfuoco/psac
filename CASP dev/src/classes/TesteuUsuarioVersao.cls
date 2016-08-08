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
private class TesteuUsuarioVersao {

    static testMethod void myUnitTest() {
    	
    	Test.startTest();
    	
    	Database.SaveResult result = null;
        
    	ProjetoWizard__c proj = new ProjetoWizard__c();
        proj.Name = 'proj 1';
        //INSERIR proj
        result =  Database.insert(proj);
        
		VersaoWizard__c versao = new VersaoWizard__c();
        versao.ProjetoWizard__c = proj.id;
        
        result =  Database.insert(versao);
        
		UsuarioVersao__c usuario = new UsuarioVersao__c();
		usuario.name = 'user version';
		usuario.Usuario__c = [select id, name from user limit 1].id;
		usuario.Versao__c = versao.id;
		
		 result = Database.Insert(usuario);
    		
		System.assert(result.isSuccess());
		
        Test.stopTest();
    }
}