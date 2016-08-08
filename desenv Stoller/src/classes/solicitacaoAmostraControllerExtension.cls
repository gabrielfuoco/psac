global with sharing class solicitacaoAmostraControllerExtension  {

    public Amostra__c amostra;

    public solicitacaoAmostraControllerExtension(ApexPages.StandardController stdController) 
    {
        this.amostra = (Amostra__c)stdController.getRecord();
    }
    
    public PageReference aprovar()
    {
        amostra.Status__c = 'Aprovado';
        update amostra;
        
        ProcessInstance piSA = [Select ID, Status FROM ProcessInstance WHERE TargetObjectID = :amostra.Id AND Status = 'Pending'];
            
        if(piSA != Null)
        {
            ProcessInstanceWorkitem piwiSA = [select Id,OriginalActorId from ProcessInstanceWorkitem where ProcessInstanceId= :piSA.Id LIMIT 1];
            Approval.ProcessWorkitemRequest prWkItem = new Approval.ProcessWorkitemRequest();
            prWkItem.setWorkItemID(piwiSA.id);
            prWkItem.setComments('Solicitação Aprovada.');
            prWkItem.setAction('Approve');
            Approval.ProcessResult appResult = Approval.process(prWkItem);
        }
                
        PageReference amostraPage = new ApexPages.StandardController(amostra).view();
        amostraPage.setRedirect(true);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Amostra aprovada com sucesso!'));

        return amostraPage;
    }
    
    public String reprovar(id amostraId) 
    {
        Amostra__c amostra = [SELECT ID, Status__C, ValorAmostra__c, DataEntrega__c FROM Amostra__C WHERE ID = :amostraId];

        amostra.Status__c = 'Reprovado';
        amostra.ValorAmostra__c = 0;
        amostra.DataEntrega__c = null;
        amostra.SolicitarAprovacao__c = true;
        amostra.PermiteExclusao__c = true;
        amostra.UltimaAprovacao__c = false;
        update amostra;
        
        ProcessInstance piSA = [Select ID, Status FROM ProcessInstance WHERE TargetObjectID = :amostra.Id AND Status = 'Pending'];
            
        if(piSA != Null)
        {
            ProcessInstanceWorkitem piwiSA = [select Id,OriginalActorId from ProcessInstanceWorkitem where ProcessInstanceId= :piSA.Id LIMIT 1];
            Approval.ProcessWorkitemRequest prWkItem = new Approval.ProcessWorkitemRequest();
            prWkItem.setWorkItemID(piwiSA.id);
            prWkItem.setComments('Solicitação Reprovada.');
            prWkItem.setAction('Reject');
            Approval.ProcessResult appResult = Approval.process(prWkItem);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Amostra rejeitada!'));
        }

        return 'Solicitação de amostra REPROVADA.';
    }
    
    public PageReference cancelar()
    {
        PageReference amostraPage = new ApexPages.StandardController(amostra).view();
        amostraPage.setRedirect(true);
        return amostraPage;
    }
    
	public PageReference solicitarAmostra()
	{         
        if(amostra.Id != null)
        {
			amostra.EnviadoParaAprovacao__c = true;
        	amostra.SolicitarAprovacao__c = false;
            amostra.UltimaAprovacao__c = false;
            amostra.PermiteExclusao__c = false;
            update amostra; 
        }
          
		try
        {
			Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
           	req.setObjectId(amostra.Id);
            Approval.ProcessResult result = Approval.process(req);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Solicitação de Amostra enviada com sucesso!'));
		}
		catch (Exception ex)
       	{
			System.debug('Erro: ' + ex);
		}
		
        PageReference amostraPage = new ApexPages.StandardController(amostra).view();
        amostraPage.setRedirect(true);
        return amostraPage;
	}
}