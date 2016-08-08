trigger DeleteLead on Lead (before delete) {

    List<PendenciasSincronizacao__c> pendencias = new List<PendenciasSincronizacao__c>();
    
    for (Lead item : Trigger.old)
    {
    	PendenciasSincronizacao__c pendencia = new PendenciasSincronizacao__c();
    
    	pendencia.ChaveId__c = item.Id;
   		pendencia.NomeObjeto__c = 'Lead';
        pendencia.TipoTransacao__c = 'Exclusao';
        
        pendencias.add(pendencia);
	}
    
    insert pendencias;
    
}