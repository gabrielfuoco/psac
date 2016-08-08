trigger UpdateAccountSourceAndUnidade on Account (before insert) {
	for(integer i = 0 ; i < Trigger.new.size(); i++ )
	{
		Account a = Trigger.New[i];
	    
	    if(a.IsLeadAcc__c)
	    {
	        a.AccountSource = a.OrigemLeadHidden__c;
	        a.UnidadeDeNegocio__c = a.UnidadeNegocioHidden__c;
	    }
	}
}