trigger BeforeInsertUsuarioVersao on UsuarioVersao__c (before insert) {
	for(integer i = 0 ; i < Trigger.new.size(); i++ )
	{
	    UsuarioVersao__c userVer = Trigger.New[i];
	    
	    List<UsuarioVersao__c> usersVer = [select id, name from UsuarioVersao__c where 
	    								   Usuario__r.id = :userVer.Usuario__c and
	    								   Versao__r.id = :userVer.Versao__c];
	    								   
		if(usersVer.size() > 0)
		{
			userVer.addError('O usuário já esta vinculado a esta versão de testes');
		}
	}					   		
}