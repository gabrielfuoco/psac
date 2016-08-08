trigger DeleteCampaign on Campaign (before delete) {

    List<PendenciasSincronizacao__c> pendencias = new List<PendenciasSincronizacao__c>();
    
    for (Campaign item : Trigger.old)
    {
    	PendenciasSincronizacao__c pendencia = new PendenciasSincronizacao__c();
    
    	pendencia.ChaveId__c = item.Id;
   		pendencia.NomeObjeto__c = 'Campanha';
        pendencia.TipoTransacao__c = 'Exclusao';
        
        pendencias.add(pendencia);
	}
    
    insert pendencias;
    
}