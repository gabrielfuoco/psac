trigger BeforeInsertUptateTraducaoMatriz on TraducaoMatriz__c (after update, before delete, before insert, before update) {
	if(Trigger.isAfter)
    {
    	for(integer i = 0; i < Trigger.new.size(); i++)
	    {
	    	TraducaoMatriz__c itemNew = Trigger.new[i];
	    	
		    if(itemNew.Linguagem__c == 'Português')
		    {
		        MatrizLinha__c item = [select id, name, DescricaoComponentePeca__c, DescricaoEquipamento__c from MatrizLinha__c where id = :itemNew.MatrizLinha__c];
		        
		        if(item.DescricaoComponentePeca__c != itemNew.Name)
		        {
		            item.DescricaoComponentePeca__c = itemNew.Name;
                    item.DescricaoEquipamento__c = itemNew.DescricaoEquipamento__c;
		            
		            update item;
		        }
		    }
    	}
    }else{
	    if(Trigger.isDelete)
	    {
	    	for(integer i = 0; i < Trigger.old.size(); i++)
	    	{
		        TraducaoMatriz__c itemOld = Trigger.old[i];
		        
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
		        TraducaoMatriz__c itemNew = Trigger.new[i];
		        
		        if(Trigger.isUpdate)
		        {
		            TraducaoMatriz__c itemOld = Trigger.old[i];
		            
		            if(itemOld.Linguagem__c == 'Português' && itemNew.Linguagem__c != 'Português')
		            {
		                itemNew.addError('Não é possível alterar o tipo da linguagem português!');
		            }
		            
		        } else if(Trigger.isInsert)
		        {
		            List<TraducaoMatriz__c> traducoes = [select id, name, Linguagem__c 
		                                                 from TraducaoMatriz__c where MatrizLinha__r.id = :itemNew.MatrizLinha__c];
		            
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