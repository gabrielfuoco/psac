trigger DeleteItem on Item__c (before delete) {

    List<PendenciasSincronizacao__c> pendencias = new List<PendenciasSincronizacao__c>();
    
    for (Item__c item : Trigger.old)
    {
    	PendenciasSincronizacao__c pendencia = new PendenciasSincronizacao__c();
    
    	pendencia.ChaveId__c = item.Id;
   		pendencia.NomeObjeto__c = 'Item';
        pendencia.TipoTransacao__c = 'Exclusao';
        
        pendencias.add(pendencia);
	}
    
    insert pendencias;
    
}