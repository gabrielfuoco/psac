global with sharing class ProcessarCliente {
	
	private static string CodCliente(Cliente cli)
	{
		return cli.Empresa.trim() + cli.A1_COD.trim() + cli.A1_LOJA.trim();
	}
	
    public static RetornoAtualizacaoDados Executar(Cliente cliente)
    {
    	RetornoAtualizacaoDados retorno = new RetornoAtualizacaoDados();
    	
    	if(cliente == null)
    	{
    		 retorno.AdicionarMenasgem('É necessário informar o cliente', false);
    		 return retorno;
    	}

		if(cliente.EMPRESA == null || cliente.EMPRESA == '')
		{			
			retorno.AdicionarMenasgem('Campo EMPRESA é obrigatório', false);
			return retorno;
		}
    	
    	List<Account> conta = [select id, AccountNumber, name,NomeFantasia__c, NomeFazenda__c,CodigoLoja__c,Website, Phone, TipoFiscal__c,
    	SituacaoFaturamento__c, ShippingPostalCode, ShippingStreet, ComplementoEntrega__c, BairroEntrega__c,
    	ShippingState, CodIBGE__c,ShippingCity, BillingStreet, BairroCobranca__c, BillingCity, BillingState,
    	BillingPostalCode, TelefoneCobranca__c, PessoaFisicaJuridica__c, CNPJ__c, CpfCnpj__c, InscricaoProdutorRural__c,
    	InscricaoRuralEstadual__c, InscricaoMunicipal__c, LimiteCredito__c, RatingCapacidadePgtoLastro__c,
    	RatingRiscoClimatico__c, RatingFinalCredito__c, RatingExperienciaPgto__c, CartaFianca__c, Documentacao__c,
    	ValidadeCadastro__c, DataPrimeiraCompraCliente__c, DataUltimaCompraCliente__c, Email__c, EmailEnvioNFE__c,
    	OkSerasa__c, UsaGarantia__c, ObservacaoCadastro__c, RegMapaAgrotoxico__c, VenctoRegAgrotoxico__c, 
    	RegMapaFertInocul__c, Empresa__c, VenctoRegFertInocul__c, StatusERP__c, ValidadaFianca__c, ShippingCountry, BillingCountry from account where id = :cliente.id ];	
    		
    	if(conta.size() == 0)
    	{
    		 retorno.AdicionarMenasgem('Cliente não encontrado', false);
    		 return retorno;
    	}
		
		try
		{
			update ConverterClienteParaAccount(conta[0], cliente);
		}
		catch(Exception ex)
		{
			retorno.AdicionarMenasgem(ex.getMessage(), false);
			
			return retorno;
		}
		
		retorno.AdicionarMenasgem('Cliente atualizado com sucesso!', true);

		return retorno;
    }
    
    private static Account ConverterClienteParaAccount(Account account, Cliente cliente)
    {
		account.name = cliente.A1_NOME;
		account.AccountNumber = CodCliente(cliente);
    	account.NomeFantasia__c = cliente.A1_NREDUZ;
    	account.NomeFazenda__c = cliente.A1_STFAZEN;
		account.CodigoLoja__c = cliente.A1_LOJA;
		account.Website = cliente.A1_HPAGE;
		account.Phone = cliente.A1_TEL;
		account.IsIntegracao__c = true;
		account.Empresa__c = cliente.EMPRESA.trim();
		if(cliente.A1_TIPO.toUpperCase() == 'F')
			account.TipoFiscal__c = 'Cons. Final';
		else if(cliente.A1_TIPO.toUpperCase() == 'L')
			account.TipoFiscal__c = 'Produtor Rural';
		else if(cliente.A1_TIPO.toUpperCase() == 'R')
			account.TipoFiscal__c = 'Revendedor';
		else if(cliente.A1_TIPO.toUpperCase() == 'S')
			account.TipoFiscal__c = 'Solidário';
		else if(cliente.A1_TIPO.toUpperCase() == 'X')
			account.TipoFiscal__c = 'Exportação';
		else
			account.TipoFiscal__c = '';
		
		if(cliente.A1_STSITUA == '1')
			account.SituacaoFaturamento__c = 'Operacional';
		else
			account.SituacaoFaturamento__c = 'Não Operacional';

		account.ShippingPostalCode = cliente.A1_CEP;
		account.ShippingStreet = cliente.A1_END;
		account.ComplementoEntrega__c = cliente.A1_COMPLEM;
		account.BairroEntrega__c = cliente.A1_BAIRRO;
		account.ShippingState = cliente.A1_EST;
		account.CodIBGE__c = cliente.A1_COD_MUN;
		account.ShippingCity = cliente.A1_MUN;
		account.BillingStreet = cliente.A1_ENDCOB;
		account.BairroCobranca__c = cliente.A1_BAIRROC;
		account.BillingCity = cliente.A1_MUNC;
		account.BillingState = cliente.A1_ESTC;
		account.BillingPostalCode = cliente.A1_CEPC;
		account.TelefoneCobranca__c = cliente.A1_STFONEC;
		account.ValidadaFianca__c = DateExtension.ParaSalesforceDate(cliente.A1_STVFIAN);
		
		account.ShippingCountry = cliente.A1_PAISCOB;
		account.BillingCountry = cliente.A1_PAISENTR;
		
		if(cliente.A1_PESSOA.toUpperCase() == 'F')
		{
			account.PessoaFisicaJuridica__c = 'Pessoa Física';
		}
		else
		{
			account.PessoaFisicaJuridica__c = 'Pessoa Jurídica';
			account.CNPJ__c =  cliente.A1_CGC;
		}

		account.CpfCnpj__c = cliente.A1_CGC;
		account.InscricaoProdutorRural__c = cliente.A1_INSCRUR;
		account.InscricaoRuralEstadual__c = cliente.A1_INSCR;
		account.InscricaoMunicipal__c = cliente.A1_INSCRM;
		account.LimiteCredito__c = cliente.A1_LC;
		account.RatingCapacidadePgtoLastro__c = cliente.A1_STORAT;
		account.RatingRiscoClimatico__c = cliente.A1_STOPONT;
		account.RatingFinalCredito__c = cliente.A1_STRANK;
		account.RatingExperienciaPgto__c = cliente.A1_STOEXP;

		if(cliente.A1_STCFIAN == '1')
			account.CartaFianca__c = 'Não Fornece';
		else if(cliente.A1_STCFIAN == '2')
			account.CartaFianca__c = 'Fornece';
		else if(cliente.A1_STCFIAN == '3')
			account.CartaFianca__c = 'Pendente';
		else if(cliente.A1_STCFIAN == '4')
			account.CartaFianca__c = 'Vencida';
		else
			account.CartaFianca__c = '';

		if(cliente.A1_STDOC.toUpperCase() == 'C')
			account.Documentacao__c = 'Completa';
		else if(cliente.A1_STDOC.toUpperCase() == 'I')
			account.Documentacao__c = 'Incompleta';
		else if(cliente.A1_STDOC.toUpperCase() == 'V')
			account.Documentacao__c = 'Vencido';
		else if(cliente.A1_STDOC.toUpperCase() == 'F')
			account.Documentacao__c = 'Faltando';
		else if(cliente.A1_STDOC.toUpperCase() == 'N')
			account.Documentacao__c = 'Não Fornece';
		else
			account.Documentacao__c = '';

		account.ValidadeCadastro__c = DateExtension.ParaSalesforceDate(cliente.A1_STVCAD);
		account.DataPrimeiraCompraCliente__c = DateExtension.ParaSalesforceDate(cliente.A1_PRICOM);
		account.DataUltimaCompraCliente__c = DateExtension.ParaSalesforceDate(cliente.A1_ULTCOM);
		account.Email__c = cliente.A1_EMAIL;
		account.EmailEnvioNFE__c = cliente.A1_STEMCL;
		account.OkSerasa__c = cliente.A1_STOKSER;
		account.UsaGarantia__c = cliente.A1_STGARAN;
		account.ObservacaoCadastro__c = cliente.A1_STOBSC;
		account.RegMapaAgrotoxico__c = cliente.A1_STMAPA1;
		account.VenctoRegAgrotoxico__c = DateExtension.ParaSalesforceDate(cliente.A1_STDTMP1);
		account.RegMapaFertInocul__c = cliente.A1_STMAPA2;
		account.VenctoRegFertInocul__c = DateExtension.ParaSalesforceDate(cliente.A1_STDTMP2);
		account.StatusERP__c = cliente.StatusERP;
		
    	return account;
    }

}