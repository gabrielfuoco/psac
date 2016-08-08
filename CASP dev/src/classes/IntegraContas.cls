global with sharing class IntegraContas {
    
    global class ConsultaContasResult {
        webService String Status;
        webService String Mensagem;
        webService List<Conta> Clientes;
        webService List<Contato> Contatos;
        
        public ConsultaContasResult()
        {
            this.Clientes = new List<Conta>();
            this.Contatos = new List<Contato>();

        }        
    }
    
 	global class Conta {     
        webService String IdSf;
        webService String Nome;
        webService String NomeAbrev;
        webService String NomeFantasia;
        webService String CodRepres;
        webService String Representante;
        webService String Phone;
        webService String EnderecoCob;
        webService String BairroDeCobranca;
        webService String CepCob;
        webService String CidadeCob;
        webService String CaixaPostalDeCobranca;
        webService String UFCobCod;
        webService String UFCob;
        webService String PaisCobCod;
        webService String PaisCob;
        webService String EnderecoEntrega;
        webService String BairroDeEntrega;
        webService String CepEntrega;
        webService String CidadeEntrega;
        webService String UFEntregaCod;
        webService String UFEntrega;
        webService String PaisEntregaCod;
        webService String PaisEntrega;
        webService String TipoRegistro;
        webService String CNPJ;
        webService String CPF;
        webService String InscricaoEstadual;
        webService String InscricaoMunicipal;
        webService Boolean ContribuinteICMS;
        webService Boolean RecebeNFe;     
        webservice Boolean ProdutorRural;

        webService List<Contato> Contats;        
    } 
    
    global class Contato {
        webService String Nome;
        webService String Email;
        webService String Phone;
        webService String Fax;
        webService String MobilePhone;  
    }     
    
    webservice static ConsultaContasResult Consultar(){    
    
        ConsultaContasResult  integraContasResultresult = new ConsultaContasResult ();
         
        List<Account> customers = [select id,name,nomeabreviado__c,nomefantasia__c,phone,tiporegistro__c,
                                          cnpj__c,cpf__c,inscricaoestadual__c,inscricaomunicipal__c,
                                          billingstreet,bairrodecobranca__c,billingpostalcode,billingcity,billingstatecode,billingstate,billingcountrycode,billingcountry,                                    
                                          shippingstreet,bairrodeentrega__c,shippingpostalcode,shippingcity,shippingstatecode,shippingstate,shippingcountrycode,shippingcountry,                                    
                                          contribuinteicms__c,recebenfe__c, produtorrural__c from account where altera__c = true];
                
        for(Account a : customers)
        {
            Conta conta = new Conta();
            conta.Contats = new List<Contato>();

            //Informações da Conta 
            conta.IdSf = a.id;
            conta.Nome = a.Name;
            conta.NomeAbrev = a.NomeAbreviado__c;
            conta.NomeFantasia = a.NomeFantasia__c;
            conta.Phone = a.Phone; 
            
            /* Informações Fiscais */
            conta.TipoRegistro = a.TipoRegistro__c;
            
            conta.CNPJ = a.CNPJ__c;
            conta.CPF = a.CPF__c;           
            
            conta.InscricaoEstadual = a.InscricaoEstadual__c;
            conta.InscricaoMunicipal = a.InscricaoMunicipal__c;
            
            conta.ContribuinteICMS = a.ContribuinteICMS__c;
            conta.RecebeNFe = a.RecebeNFe__c;           
            conta.ProdutorRural = a.ProdutorRural__c;
           
		 	/* Cobrança */                        
            conta.EnderecoCob = String.valueof(a.BillingStreet);
            conta.BairroDeCobranca = a.BairroDeCobranca__c;
            conta.cepCob = a.BillingPostalCode;
            conta.cidadeCob =  a.BillingCity;
            conta.UFCobCod = String.valueof(a.BillingStateCode);
            conta.UFCob = a.BillingState;
            conta.paisCobCod = String.valueof(a.BillingCountryCode);
            conta.paisCob = a.BillingCountry;

            /* Entrega */            
            conta.EnderecoEntrega = String.valueof(a.ShippingStreet);
            conta.BairroDeEntrega = a.BairroDeEntrega__c;
            conta.cepEntrega = a.ShippingPostalCode;
            conta.cidadeEntrega = a.ShippingCity;
            conta.UfEntregaCod = a.ShippingStateCode;
            conta.UFEntrega = a.ShippingState;
            conta.PaisEntregaCod = String.valueof(a.ShippingCountryCode);
            conta.PaisEntrega = String.valueof(a.ShippingCountry);
                        
            List<contact> contats = [select account.id,name,email,mobilephone,phone,fax from contact where account.id = :a.id];
       
            for(contact b : contats)
            {
                Contato contato = new Contato();
                
                contato.Nome = b.Name;
                contato.Email = b.Email;
                contato.MobilePhone = b.MobilePhone;
                contato.Phone = b.Phone;
                contato.Fax = b.Fax;                
               
                conta.Contats.add(contato);
            }
        
            integraContasResultresult.Clientes.add(conta);
        }

        return integraContasResultresult ;
    }
    
    webservice static RetornoAtualizacaoDados AtualizaStatus(string IDSf)
    { 
    	RetornoAtualizacaoDados retorno = new RetornoAtualizacaoDados();
        
        List<Account> contas = [select id, name, ativaTriggerConta__c from account where id = :IDSf];

        if(contas.size() > 0)
        {                                             
            try
            {
                Account acc = contas[0];
            	acc.ativaTriggerConta__c = false;
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