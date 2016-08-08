@isTest
public class TesteIntegracaoConta {
	@isTest
    public static void ExecutarTeste()
    {
        Account conta = new Account();
        conta.Name = 'Nome conta';
        conta.altera__c = true;
        conta.CNPJ__c = '54.278.443/0001-78';
        conta.BillingCountry = 'Brasil';
        conta.BillingStreet ='R TESTE';
        conta.BillingCity ='Sumaré';
        conta.BillingPostalCode = '13180-585';
        conta.BillingState = 'Acre';
        conta.BairroDeCobranca__c = 'JD AMANDA';
       
        conta.ShippingCountry = 'Brasil';
        conta.ShippingStreet ='R TESTE';
        conta.ShippingCity ='Sumaré';
        conta.ShippingPostalCode = '13180-585';
        conta.ShippingState = 'Acre';
        conta.BairroDeEntrega__c = 'JD AMANDA';
        
        
        insert conta;
        
        Contact contato = new Contact();
        contato.LastName = 'Sobrenome conta';
        contato.FirstName = 'nome conta';
        contato.AccountId = conta.Id;
        insert contato;
        
        IntegraContas servico = new IntegraContas();
        IntegraContas.ConsultaContasResult contas =  IntegraContas.Consultar();
        
        for(IntegraContas.Conta contasf : contas.Clientes)
        {
        	IntegraContas.AtualizaStatus(contasf.IdSf);
            Sincronizacao.AtualizarConta(contasf.IdSf,'10');
            Sincronizacao.AtualizarConta(contasf.IdSf,'ausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausiausihdausi');
        }
        
        IntegraContas.AtualizaStatus('ContaInvalida');
        
        Sincronizacao.AtualizarConta('XPTO','10');
        
    }
}