trigger AfterUpdateLinguaItemPortugues on TraducaoItem__c (after update) {
	TraducaoItem__c itemNew = Trigger.new[0];
    
    if(itemNew.Linguagem__c == 'Português')
    {
        Item__c item = [select id, name, descricao__c from Item__c where id = :itemNew.Item__c];
        
        if(item.Descricao__c != itemNew.Name)
        {
            item.Descricao__c = itemNew.Name;
            
            update item;
        }
    }
}