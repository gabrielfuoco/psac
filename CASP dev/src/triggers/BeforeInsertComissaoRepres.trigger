trigger BeforeInsertComissaoRepres on ComissaoVendedor__c (before insert, before update) {
	
	for(integer i = 0 ; i < Trigger.new.size(); i++ )
	{
	    ComissaoVendedor__c itemNew = Trigger.new[i];
	    
	    List<ComissaoVendedor__c> itemDup = [select id, name from ComissaoVendedor__c 
	    							  where ComissaoVendedor__c.id != :itemNew.id and 
	    							  		Item__r.Id = :itemNew.Item__c and
	    							  		Vendedor__c = :itemNew.Vendedor__c];
	     
	    if(itemDup.size() > 0)
	    {
			itemNew.addError('Não é possível cadastrar mais de uma comissão do vendedor para este item');
	    }
	}
}