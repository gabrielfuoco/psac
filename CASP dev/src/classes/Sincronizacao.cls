global with sharing class Sincronizacao {      
    	
    webservice static RetornoAtualizacaoDados AtualizarConta(string IDSf, string CodigoERP)
    { 
    	RetornoAtualizacaoDados retorno = new RetornoAtualizacaoDados();
        
        List<Account> contas = [select id, name, accountNumber from account where id = :IDSf];

        if(contas.size() > 0)
        {                                             
            try
            {
                Account acc = contas[0];
            	acc.AccountNumber = CodigoERP;
                update acc;     
            }
            catch(Exception ex)
            {
                retorno.AdicionarMenasgem(ex.getMessage(), false);
                
                return retorno;
            }
            
            retorno.AdicionarMenasgem('Conta Sincronizada!', true);    
        } 
        else  retorno.AdicionarMenasgem('Conta não encontrada!', false);    
        
        return retorno;
    }               
}