trigger AfterUpdateLinguaProjetoWizardPortugues on TraducaoProjetoWizard__c (after update, before delete, before update, before insert) {
    
    if(Trigger.isAfter)
    {
    	for(integer i = 0; i< Trigger.new.size(); i++)
    	{
	    	TraducaoProjetoWizard__c itemNew = Trigger.new[i];
	    	
		    if(itemNew.Linguagem__c == 'Português')
		    {
		        ProjetoWizard__c item = [select id, name from ProjetoWizard__c where id = :itemNew.ProjetoWizard__c];
		        
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
	    	for(integer i = 0; i< Trigger.old.size(); i++)
    		{
		        TraducaoProjetoWizard__c itemOld = Trigger.old[0];
		        
		        if(itemOld.Linguagem__c == 'Português')
		        {
		             itemOld.addError('Não é possível excluir a tradução em português!');
		        }
    		}
	    } 
	    else
	    {
	    	for(integer i = 0; i< Trigger.new.size(); i++)
    		{
		        TraducaoProjetoWizard__c itemNew = Trigger.new[i];
		        
		        if(Trigger.isUpdate)
		        {
		            TraducaoProjetoWizard__c itemOld = Trigger.old[i];
		            
		            if(itemOld.Linguagem__c == 'Português' && itemNew.Linguagem__c != 'Português')
		            {
		                itemNew.addError('Não é possível alterar o tipo da linguagem português!');
		            }
		            
		        } else if(Trigger.isInsert)
		        {
		            List<TraducaoProjetoWizard__c> traducoes = [select id, name, Linguagem__c 
		                                                 from TraducaoProjetoWizard__c where ProjetoWizard__r.id = :itemNew.ProjetoWizard__c];
		            
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