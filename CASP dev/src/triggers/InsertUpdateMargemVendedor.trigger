trigger InsertUpdateMargemVendedor on MargemVendedor__c (before insert, before update) {
	if(Trigger.new.size() > 1)
    {
        List<id> ids = new List<id>();
        for(integer i = 0; i< Trigger.new.size(); i++)
        {
            if(Trigger.new[i].id != null)
                ids.add(Trigger.new[i].id);
        }
        List<MargemVendedor__c> MargemsVend = [select id, name, Item__r.Id, Vendedor__c
                                               from MargemVendedor__c where id not in :ids];

        for(MargemVendedor__c itemNew : Trigger.new)
        {   
            for(MargemVendedor__c itemOld : MargemsVend)
            {
                if(itemOld.id != itemNew.id && 
                   itemOld.Item__r.id == itemNew.Item__c && 
                   itemOld.Vendedor__c == itemNew.Vendedor__c)
                {
                    itemNew.addError('Não é possível cadastrar mais de um Margem do vendedor para este item');
                }
            }
        }
    }
    else
    {
        for(integer i = 0 ; i < Trigger.new.size(); i++ )
        {
            MargemVendedor__c itemNew = Trigger.new[i];
            
            List<MargemVendedor__c> itemDup = [select id, name from MargemVendedor__c 
                                          where id != :itemNew.id and 
                                                Item__r.Id = :itemNew.Item__c and
                                                Vendedor__c = :itemNew.Vendedor__c];
             
            if(itemDup.size() > 0)
            {
                itemNew.addError('Não é possível cadastrar mais de um Margem do vendedor para este item');
            }
        }
    }
}