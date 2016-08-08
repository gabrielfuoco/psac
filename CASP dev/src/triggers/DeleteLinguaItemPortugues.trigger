trigger DeleteLinguaItemPortugues on TraducaoItem__c (before delete, before update, before insert) {
	
    if(Trigger.isDelete)
    {
    	for(integer i = 0 ; i < Trigger.old.size(); i++ )
		{
	        TraducaoItem__c itemOld = Trigger.old[i];
	        
	        if(itemOld.Linguagem__c == 'Português')
	        {
	             itemOld.addError('Não é possível excluir a tradução em português!');
	        }
		}
    } 
    else
    {
    	for(integer i = 0 ; i < Trigger.new.size(); i++ )
		{
	        TraducaoItem__c itemNew = Trigger.new[i];
	        
	        if(Trigger.isUpdate)
	        {
	            TraducaoItem__c itemOld = Trigger.old[i];
	            
	            if(itemOld.Linguagem__c == 'Português' && itemNew.Linguagem__c != 'Português')
	            {
	                itemNew.addError('Não é possível alterar o tipo da linguagem português!');
	            }
	            
	        } else if(Trigger.isInsert)
	        {
	            List<TraducaoItem__c> traducoes = [select id, name, Linguagem__c 
	                                                 from TraducaoItem__c where Item__r.id = :itemNew.Item__c];
	            
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