trigger AfterUpdateLinguaFluxoPortugues on TraducaoFluxo__c (after update, before delete, before insert, before update) {
    if(Trigger.isAfter)
    {
    	for(integer i = 0; i < Trigger.new.size(); i++)
	    {
	    	TraducaoFluxo__c itemNew = Trigger.new[i];
	    	
		    if(itemNew.Linguagem__c == 'Português')
		    {
		        Fluxo__c item = [select id, name from Fluxo__c where id = :itemNew.Fluxo__c];
		        
		        if(item.Name != itemNew.Name)
		        {
		            item.Name = itemNew.Name;
		            
		            update item;
		        }
		    }
    	}
    }else{
	    if(Trigger.isDelete)
	    {
            List<Id> ids = new List<Id>();
            for(integer i = 0; i < Trigger.old.size(); i++)
	    	{
                ids.add(Trigger.old[i].Fluxo__c);
            }
            
            Map<id, Fluxo__c> fluxos = new Map<id, Fluxo__c>([select id, name, Versao__r.id, versao__r.Situacao__c from Fluxo__c where id in :ids]);
	    	
            for(integer i = 0; i < Trigger.old.size(); i++)
	    	{
                TraducaoFluxo__c itemOld = Trigger.old[i];
                Fluxo__c fx = fluxos.get(itemOld.Fluxo__c);
                
                if(fx.Versao__r.Situacao__c != 'Em teste')
                {
                    itemOld.addError('Não é possível excluir o registro, pois a versão encontra-se Inativa ou em Produção!');
                }
                
		        if(itemOld.Linguagem__c == 'Português')
		        {
		             itemOld.addError('Não é possível excluir a tradução em português!');
		        }
	    	}
            

	    } 
	    else
	    {
	    	for(integer i = 0; i < Trigger.new.size(); i++)
	    	{
		        TraducaoFluxo__c itemNew = Trigger.new[i];
		        
		        if(Trigger.isUpdate)
		        {
		            TraducaoFluxo__c itemOld = Trigger.old[i];
		            
		            if(itemOld.Linguagem__c == 'Português' && itemNew.Linguagem__c != 'Português')
		            {
		                itemNew.addError('Não é possível alterar o tipo da linguagem português!');
		            }
		            
		        } else if(Trigger.isInsert)
		        {
		            List<TraducaoFluxo__c> traducoes = [select id, name, Linguagem__c 
		                                                 from TraducaoFluxo__c where Fluxo__r.id = :itemNew.Fluxo__c];
		            
		            for(Integer j = 0; j< traducoes.size(); j++)
		            {
		                if(traducoes[j].Linguagem__c == itemNew.Linguagem__c)
		                {
		                    itemNew.addError('Não é possível cadastrar uma tradução com uma linguagem já existente');
		                }
		            }
		        }
	    	}
	    }
    }
}