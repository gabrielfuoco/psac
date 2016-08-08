trigger DeleteAccount on Account (before delete) {
    
    List<PendenciasSincronizacao__c> pendencias = new List<PendenciasSincronizacao__c>();
    
    for (Account item : Trigger.old)
    {
    	PendenciasSincronizacao__c pendencia = new PendenciasSincronizacao__c();
    
    	pendencia.ChaveId__c = item.Id;
   		pendencia.NomeObjeto__c = 'Conta';
        pendencia.TipoTransacao__c = 'Exclusao';
        
        pendencias.add(pendencia);
	}
    
    insert pendencias;

}