trigger UpdateLinguagemItemPortugues on Item__c (after update) {
    
    for(integer j = 0 ; j < Trigger.new.size(); j++ )
	{
	    Item__c item = Trigger.new[j];
	        
		List<TraducaoItem__c> traducoes = [select id, name, Linguagem__c 
	                                       from TraducaoItem__c where Item__r.id = :item.id];
	    
	    for(integer i = 0; i< traducoes.size(); i++)
	    {
	        if(traducoes[i].Linguagem__c == 'Português' && traducoes[i].Name != item.Descricao__c)
	        {
	            traducoes[i].Name = item.Descricao__c;
	            
	            update traducoes[i];
	        }
	    }
	}
}