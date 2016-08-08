trigger DeleteContact on Contact (before delete) {
	
    List<PendenciasSincronizacao__c> pendencias = new List<PendenciasSincronizacao__c>();
    
    for (Contact item : Trigger.old)
    {
    	PendenciasSincronizacao__c pendencia = new PendenciasSincronizacao__c();
    
    	pendencia.ChaveId__c = item.Id;
   		pendencia.NomeObjeto__c = 'Contato';
        pendencia.TipoTransacao__c = 'Exclusao';
        
        pendencias.add(pendencia);
	}
    
    insert pendencias;
    
}