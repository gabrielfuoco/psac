trigger DeleteParametro on Parametro__c (before delete) {
	
    List<Id> ids = new List<Id>();
    
    for(Parametro__c item : Trigger.old)
    {
		ids.add(item.id);
    }
    
    Map<Id,Parametro__c> parans = new Map<Id,Parametro__c>([select id, name, Fluxo__r.Versao__r.Situacao__c 
                                                            	from Parametro__c where id in :ids]);
    
    for(Parametro__c item : Trigger.old)
    {
        if(parans.get(item.id).Fluxo__r.Versao__r.Situacao__c != 'Em teste')
        {
            item.addError('Não é possível alterar o registro, pois a versão encontra-se Inativa ou em Produção!');
        }
    }
}