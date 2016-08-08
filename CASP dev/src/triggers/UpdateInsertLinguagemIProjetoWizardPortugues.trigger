trigger UpdateInsertLinguagemIProjetoWizardPortugues on ProjetoWizard__c (after insert, after update) {
    for(integer i = 0 ; i < Trigger.new.size(); i++ )
	{
	    ProjetoWizard__c item = Trigger.new[i];
	    
	    if(Trigger.isInsert)
	    {
	    	TraducaoProjetoWizard__c traducao = new TraducaoProjetoWizard__c();
	    	traducao.name = item.name;
	    	traducao.Linguagem__c = 'Português';
	    	traducao.ProjetoWizard__c = item.id;
	    	
	    	insert traducao;
	    }else{
			List<TraducaoProjetoWizard__c> traducoes = [select id, name, Linguagem__c 
		                                       from TraducaoProjetoWizard__c where ProjetoWizard__r.id = :item.id];
		    
		    for(integer j = 0; j< traducoes.size(); j++)
		    {
		        if(traducoes[j].Linguagem__c == 'Português' && traducoes[j].Name != item.name)
		        {
		            traducoes[j].Name = item.name;
		            
		            update traducoes[j];
		        }
		    }
	    }
    }
}