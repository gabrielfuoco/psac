trigger UpdateInsertLinguagemIFluxoPortugues on Fluxo__c (before delete, before insert, after insert, after update) {
    
    if(Trigger.isDelete)
    {
        Map<id, Fluxo__c> fluxos = new Map<id, Fluxo__c>([select id, name, Versao__r.id, versao__r.Situacao__c from Fluxo__c where id in :Trigger.oldMap.keySet()]);
	    
        for(Fluxo__c fx : Trigger.old )
        {
        	if(fluxos.get(fx.id).versao__r.Situacao__c != 'Em teste')
            {
                fx.addError('Não é possível excluir o registro, pois a versão encontra-se Inativa ou em Produção!');
            }
        }
    }
    else
    {
        List<Id> versoes = new List<Id>();
    	List<Id> idsNew = new List<Id>();
        for(integer i = 0 ; i < Trigger.new.size(); i++ )
        {
            versoes.add(Trigger.new[i].Versao__c);
        }
        
        List<Fluxo__c> fluxos = [select id, name, versao__r.id from Fluxo__c 
                                 where versao__r.id in :versoes];
        
        Map<id, Fluxo__c> duplicados = new Map<id, Fluxo__c>();
        for(integer i = 0 ; i < Trigger.new.size(); i++ )
        {
            Fluxo__c item = Trigger.new[i];
            idsNew.add(Trigger.new[i].id);
            Fluxo__c itemDup = null;
            for(Fluxo__c fx : fluxos)
            {
                if(fx.Name == item.Name && item.Id != fx.Id && fx.Versao__r.id == item.Versao__c)
                {
                    itemDup = fx;
                }
            }
            
            if(itemDup != null)
            {
                item.addError('O nome já esta sendo utilizado para outro fluxo nesta mesma versão!');
                duplicados.put(item.Id, item);
            }
            else
            {
                if(Trigger.isInsert && Trigger.isAfter)
                {
                    TraducaoFluxo__c traducao = new TraducaoFluxo__c();
                    traducao.name = item.name;
                    traducao.Linguagem__c = 'Português';
                    traducao.Fluxo__c = item.id;
                    
                    insert traducao;
                }
            }
        } 
        
        List<TraducaoFluxo__c> updtTrad = new List<TraducaoFluxo__c>();
        
        if(!(Trigger.isInsert && Trigger.isAfter))
        {
            List<TraducaoFluxo__c> traducoes = [select id, name, Linguagem__c, Fluxo__c
                                            from TraducaoFluxo__c where Fluxo__r.id = :idsNew];
            
            for(integer i = 0 ; i < Trigger.new.size(); i++ )
            {
                if(duplicados.get(Trigger.new[i].id) != null)
                    continue;
                
                for(integer j = 0; j< traducoes.size(); j++)
                {
                    if(traducoes[j].Linguagem__c == 'Português' && 
                       traducoes[j].Name != Trigger.new[i].name && 
                       traducoes[j].Fluxo__c == Trigger.new[i].Id)
                    {
                        traducoes[j].Name = Trigger.new[i].name;
                        updtTrad.add(traducoes[j]);
                    }
                }
            }
        }
        
        if(updtTrad.size() > 0)
        {
            update updtTrad;
        }
    }
}