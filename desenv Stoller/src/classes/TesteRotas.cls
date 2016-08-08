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
public class TesteRotas {
	
    static testMethod void listarCompromissos() {
    	
        Test.startTest();
        
        Profile perfil = [SELECT Id FROM Profile WHERE Name='Administrador do sistema']; 
      	User usuario = new User(Alias = 'rotas', Email='testerotas@testerotas.com', 
      						EmailEncodingKey='ISO-8859-1', LastName='Rotas', LanguageLocaleKey='pt_BR', 
      						LocaleSidKey='pt_BR', ProfileId = perfil.Id, 
      						TimeZoneSidKey='America/Sao_Paulo', UserName='testerotas@testerotas.com');
        insert usuario;
        
        Account conta = new Account();
        conta.Name = 'Teste Conta';
        conta.ShippingStreet = 'R. Visc. de Taunay, 421';
        conta.ShippingCity = 'Campinas';
        conta.ShippingState = 'SAO PAULO';
        conta.ShippingPostalCode = '13023-200';
        insert conta;

        Event compromisso = new Event();
        compromisso.Subject = 'Teste Visitia';
        compromisso.WhatId = conta.Id;
        compromisso.OwnerId = usuario.Id;
        compromisso.ActivityDateTime = datetime.newInstance(2016, 01, 01);
        compromisso.ActivityDate = date.newInstance(2016, 01, 01);
        compromisso.Type = 'Visita';
        compromisso.DurationInMinutes = 60;
        insert compromisso;
        
        System.runAs(usuario) {
            System.debug('Current User ID: ' + UserInfo.getUserId()); 
         	System.debug('Current User: ' + UserInfo.getUserName()); 
            
            RotasController rotaTeste01 = New RotasController(2016, 01, 01);
        	rotaTeste01.listarCompromissos();
            
            RotasController rotaTeste02 = New RotasController(2015, 01, 01);
        	rotaTeste02.listarCompromissos();
            
            RotasController rotaTeste03 = New RotasController();
      	}
        
        Test.stopTest();
    }
}