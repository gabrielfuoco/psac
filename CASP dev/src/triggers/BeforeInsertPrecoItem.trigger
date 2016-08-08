trigger BeforeInsertPrecoItem on PrecoItem__c (before insert, before update) {
    
    for(integer i = 0 ; i < Trigger.new.size(); i++ )
    {
        PrecoItem__c itemNew = Trigger.new[i];
        
        List<PrecoItem__c> itemDup = [select id, name from PrecoItem__c 
                                      where PrecoItem__c.id != :itemNew.id and 
                                            Item__r.Id = :itemNew.Item__c and
                                            PrecoItem__c.CurrencyIsoCode = :itemNew.CurrencyIsoCode];
         
        if(itemDup.size() > 0)
        {
            itemNew.addError('Não é possível mais de um preço com a mesma data de vigência');
        }
    }
}