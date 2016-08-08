trigger BeforeInsertVersaoWizard on VersaoWizard__c (before insert, before delete) {
	
    if(Trigger.isDelete) 
    {
		for(integer i = 0 ; i < Trigger.old.size(); i++ )
        {
            if(Trigger.old[i].Situacao__c != 'Em teste')
            {
                Trigger.old[i].addError('Não é possível excluir o registro, pois a versão encontra-se Inativa ou em Produção!');
            }
        }
    }
    else
    {
        for(integer i = 0 ; i < Trigger.new.size(); i++ )
        {
           VersaoWizard__c versaoWizard = Trigger.new[i];
           
           AggregateResult[] versoes = [select max( versao__c) from VersaoWizard__c
                                            where VersaoWizard__c.ProjetoWizard__r.id = :versaoWizard.ProjetoWizard__c];
                                            
           if((Decimal)versoes[0].get('expr0') > 0)
           {
                versaoWizard.Versao__c = (Decimal)versoes[0].get('expr0') + 1;
           }
           else
           {
                versaoWizard.Versao__c = 1;
           }
        }
    }
}