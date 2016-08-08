trigger BeforeDeleteTraducaoParametro on TraducoesParametro__c (before delete) {
    
    List<Id> itens = new List<Id>();
    
    for(TraducoesParametro__c item : Trigger.old)
    {
        itens.add(item.Parametro__c);
    }
    
    Map<Id,Parametro__c> versoes = new Map<Id,Parametro__c>([select id, Fluxo__r.Versao__r.Situacao__c from Parametro__c where id in :itens]);
    
    for(TraducoesParametro__c item : Trigger.old)
    {
        Parametro__c param =  versoes.get(item.Parametro__c);
        
        if(param.Fluxo__r.Versao__r.Situacao__c != 'Em teste')
        {
            item.addError('Não é possível alterar o registro, pois a versão encontra-se Inativa ou em Produção!');
        }
        
        if(item.Linguagem__c == 'Português') 
            item.addError('Não é possível excluir a tradução em português!');
    }
}