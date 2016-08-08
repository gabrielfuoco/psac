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
private class TesteVersaoWizard {

    static testMethod void myUnitTest() {
    	
    	Database.SaveResult result = null;
        Database.DeleteResult deleteresult = null;
        
		ProjetoWizard__c projeto = new ProjetoWizard__c();
		projeto.Name = 'My project';
		
		insert projeto;
		
		VersaoWizard__c versao1 = new VersaoWizard__c();
		versao1.ProjetoWizard__c = projeto.Id;
		
		insert versao1;
		
		VersaoWizard__c versao2 = new VersaoWizard__c();
		versao2.ProjetoWizard__c = projeto.Id;
		EnviarParaVersaoProducao.enviarProducao(versao1.id);
        EnviarParaVersaoProducao.enviarProducao(versao1.id);
        
		result = Database.insert(versao2);
		
      	System.assert(result.isSuccess());
		
    }
}