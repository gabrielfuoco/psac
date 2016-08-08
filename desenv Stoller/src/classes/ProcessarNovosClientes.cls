global with sharing class ProcessarNovosClientes {
    
    public static List<RetornoNovosClientes> Executar()
    {
    	List<RetornoNovosClientes> ret = new  List<RetornoNovosClientes>();
    	
    	List<Account> contas = [select id, name from Account where StatusERP__c = 'Integrar'];
		
		for(Account conta : contas)
		{
			RetornoNovosClientes item = new RetornoNovosClientes();
			item.id = conta.id;
			item.Nome = conta.name;
			ret.add(item);
		}
		
		return ret;
    }
    
}