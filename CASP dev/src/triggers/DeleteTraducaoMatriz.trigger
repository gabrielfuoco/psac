trigger DeleteTraducaoMatriz on TraducaoMatriz__c (before delete) {
	if(Trigger.isDelete)
    {
        List<id> ids = new List<id>();
        for(TraducaoMatriz__c item : Trigger.old)
        {
            ids.add(item.id);
        }
        
        map<id, TraducaoMatriz__c> mapItem = new map<id, TraducaoMatriz__c>([select id, name, MatrizLinha__r.Fluxo__r.Versao__r.Situacao__c 
                                                                             from TraducaoMatriz__c where id in :ids]);
        
        for(TraducaoMatriz__c item : Trigger.old)
        {
            TraducaoMatriz__c itMap = mapItem.get(item.Id);
            
            if(itMap.MatrizLinha__r.Fluxo__r.Versao__r.Situacao__c != 'Em teste')
            {
                item.addError('Não é possível alterar o registro, pois a versão encontra-se Inativa ou em Produção!');
            }
        }
    }
}