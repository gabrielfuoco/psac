trigger DeleteCodigoFonte on CodigoFonte__c (before delete) {
    
    
	if(Trigger.isDelete)
    {
        List<id> idsParametros = new List<id>();
    	List<id> idsFluxos = new List<id>();
        
        for(CodigoFonte__c cf : Trigger.old)
        {
            if(cf.Fluxo__c != null)
                idsFluxos.add(cf.Fluxo__c);
            else
                idsParametros.add(cf.Parametro__c);
        }
        
        Map<Id,CodigoFonte__c> cfs = new Map<Id,CodigoFonte__c>([select id, Fluxo__r.Versao__r.Situacao__c,
                                                            			Parametro__r.Fluxo__r.Versao__r.Situacao__c
                                                             from CodigoFonte__c 
                                                              where Fluxo__r.id in :idsFluxos or
                                                           			Parametro__r.id in :idsParametros]);
      
        for(CodigoFonte__c cf : Trigger.old)
        {
            CodigoFonte__c cfMap = cfs.get(cf.Id);
            
            if((cfMap.Fluxo__c != null && cfMap.Fluxo__r.Versao__r.Situacao__c != 'Em teste') ||
               (cfMap.Parametro__c != null && cfMap.Parametro__r.Fluxo__r.Versao__r.Situacao__c != 'Em teste'))
            {
                cf.addError('Não é possível alterar o registro, pois a versão encontra-se Inativa ou em Produção!');
            }
        }
    }
}