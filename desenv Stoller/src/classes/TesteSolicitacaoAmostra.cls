@isTest
public class TesteSolicitacaoAmostra {
	
    static testMethod void solicitarAmostra() {

        Test.startTest();
        
        Amostra__c amostraAprovada = new Amostra__c();
        insert amostraAprovada;
        
        Amostra__c amostraReprovada = new Amostra__c();
        insert amostraReprovada;
        
        
        // APROVAR
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setObjectId(amostraAprovada.id);
        
        Approval.ProcessResult result01 = Approval.process(req1);
        System.assert(result01.isSuccess());
        System.assertEquals('Pending', result01.getInstanceStatus(), 'Instance Status'+result01.getInstanceStatus());
        
        ApexPages.StandardController stdCtlr01 = new ApexPages.StandardController(amostraAprovada);
        solicitacaoAmostraControllerExtension solicAmostraAprovar = new solicitacaoAmostraControllerExtension(stdCtlr01);
        solicAmostraAprovar.aprovar();
        
        
		// REPROVAR
        Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
        req2.setObjectId(amostraReprovada.id);
        
        Approval.ProcessResult result02 = Approval.process(req2);
        System.assert(result02.isSuccess());
        System.assertEquals('Pending', result02.getInstanceStatus(), 'Instance Status'+result02.getInstanceStatus());
        
        ApexPages.StandardController stdCtlr02 = new ApexPages.StandardController(amostraReprovada);
        solicitacaoAmostraControllerExtension solicAmostraReprovar = new solicitacaoAmostraControllerExtension(stdCtlr02);
        
        String msg01 = 'Solicitação de amostra REPROVADA.';
        String info01 = solicitacaoAmostraControllerExtension.reprovar(amostraReprovada.id);
		System.assertEquals(msg01, info01);
        
        solicAmostraReprovar.cancelar();
        
        Test.stopTest();
    }
}