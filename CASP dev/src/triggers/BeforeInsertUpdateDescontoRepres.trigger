trigger BeforeInsertUpdateDescontoRepres on DescontoVendedor__c (before insert, before update) {
    
    if(Trigger.new.size() > 1)
    {
        List<DescontoVendedor__c> descontosVend = [select id, name, Item__r.Id, Vendedor__c
                                               from DescontoVendedor__c where id not in :trigger.newMap.keySet()];
        
        for(DescontoVendedor__c itemNew: Trigger.new)
        {
            for(DescontoVendedor__c itemOld : descontosVend)
            {
                if(itemOld.id != itemNew.id && 
                   itemOld.Item__r.id == itemNew.Item__c && 
                   itemOld.Vendedor__c == itemNew.Vendedor__c)
                {
                    itemNew.addError('Não é possível cadastrar mais de um desconto do vendedor para este item');
                }
            }
        }
    }
    else
    {
        for(integer i = 0 ; i < Trigger.new.size(); i++ )
        {
            DescontoVendedor__c itemNew = Trigger.new[i];
            
            List<DescontoVendedor__c> itemDup = [select id, name from DescontoVendedor__c 
                                          where id != :itemNew.id and 
                                                Item__r.Id = :itemNew.Item__c and
                                                Vendedor__c = :itemNew.Vendedor__c];
             
            if(itemDup.size() > 0)
            {
                itemNew.addError('Não é possível cadastrar mais de um desconto do vendedor para este item');
            }
        }
    }
}