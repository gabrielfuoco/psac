global with sharing class ProcessarSolicitacaoCliente {
    public static RetornoSolicitacaoCliente Executar(string id)
    {
    	RetornoSolicitacaoCliente retorno = new RetornoSolicitacaoCliente();
    	
    	if(id == null)
    		retorno.DadosMensagem.AdicionarMenasgem('É necessário informar o Id do Cliente', false);
    		
    	List<Account> conta = [select id,AccountNumber, name,NomeFantasia__c, NomeFazenda__c,CodigoLoja__c,Website, Phone, TipoFiscal__c,
    	SituacaoFaturamento__c, ShippingPostalCode, ShippingStreet, ComplementoEntrega__c, BairroEntrega__c,
    	ShippingState, CodIBGE__c,ShippingCity, BillingStreet, BairroCobranca__c, BillingCity, BillingState,
    	BillingPostalCode, TelefoneCobranca__c, PessoaFisicaJuridica__c, CNPJ__c, CpfCnpj__c, InscricaoProdutorRural__c,
    	InscricaoRuralEstadual__c, InscricaoMunicipal__c, LimiteCredito__c, RatingCapacidadePgtoLastro__c,
    	RatingRiscoClimatico__c, RatingFinalCredito__c, RatingExperienciaPgto__c, CartaFianca__c, Documentacao__c,
    	ValidadeCadastro__c, DataPrimeiraCompraCliente__c, DataUltimaCompraCliente__c, Email__c, EmailEnvioNFE__c,
    	OkSerasa__c, UsaGarantia__c, ObservacaoCadastro__c, RegMapaAgrotoxico__c, VenctoRegAgrotoxico__c, 
    	RegMapaFertInocul__c, VenctoRegFertInocul__c, Empresa__c, ValidadaFianca__c, ShippingCountry, BillingCountry from account where id = :id];
    	
    	if(conta.size() == 0)
    	{
    		 retorno.DadosMensagem.AdicionarMenasgem('Cliente não encontrado', false);
    		 return retorno;
    	}
    	
		try
		{
    		retorno.Cliente = PreencherRetorno(conta[0]);
    		retorno.DadosMensagem.AdicionarMenasgem('Cliente encontrado com sucesso!', true);
		}
		catch(Exception ex)
		{
			retorno.DadosMensagem.AdicionarMenasgem(ex.getMessage(), false);
		}
		
		return retorno;
    }
    
    private static Cliente PreencherRetorno (Account account)
    {
    	Cliente cliente = new Cliente();
    	
    	cliente.EMPRESA = account.Empresa__c;
    	cliente.A1_NOME = account.name;
    	cliente.A1_NREDUZ = account.NomeFantasia__c;
    	cliente.A1_STFAZEN = account.NomeFazenda__c ;
		cliente.A1_LOJA = account.CodigoLoja__c;
		cliente.A1_HPAGE = account.Website;
		cliente.A1_TEL = account.Phone;
		cliente.A1_STVFIAN = account.ValidadaFianca__c;
		cliente.A1_COD =  account.AccountNumber;
		if(account.TipoFiscal__c == 'Cons. Final')
			cliente.A1_TIPO = 'F';
		else if(account.TipoFiscal__c == 'Produtor Rural')
			cliente.A1_TIPO = 'L';
		else if(account.TipoFiscal__c == 'Revendedor')
			cliente.A1_TIPO = 'R';
		else if(account.TipoFiscal__c == 'Solidário')
			cliente.A1_TIPO = 'S';
		else if(account.TipoFiscal__c == 'Exportação')
			cliente.A1_TIPO = 'X';
		else
			cliente.A1_TIPO = '';
		
		if(account.SituacaoFaturamento__c == 'Operacional')
			cliente.A1_STSITUA = '1';
		else
			cliente.A1_STSITUA = '2';

		cliente.A1_PAISCOB = account.ShippingCountry;
		cliente.A1_PAISENTR = account.BillingCountry;
		
		cliente.A1_CEP = account.ShippingPostalCode;
		cliente.A1_END = account.ShippingStreet;
		cliente.A1_COMPLEM = account.ComplementoEntrega__c;
		cliente.A1_BAIRRO = account.BairroEntrega__c;
		cliente.A1_EST = account.ShippingState;
		cliente.A1_COD_MUN = account.CodIBGE__c;
		cliente.A1_MUN = account.ShippingCity;
		cliente.A1_ENDCOB = account.BillingStreet;
		cliente.A1_BAIRROC = account.BairroCobranca__c;
		cliente.A1_MUNC = account.BillingCity;
		cliente.A1_ESTC = account.BillingState;
		cliente.A1_CEPC = account.BillingPostalCode;
		cliente.A1_STFONEC = account.TelefoneCobranca__c;
		
		if(account.PessoaFisicaJuridica__c == 'Pessoa Física')
		{
			cliente.A1_PESSOA = 'F';
		}
		else
		{
			cliente.A1_CGC = account.CNPJ__c;
			cliente.A1_PESSOA = 'J';
		}

		cliente.A1_CGC = account.CpfCnpj__c;
		cliente.A1_INSCRUR = account.InscricaoProdutorRural__c;
		cliente.A1_INSCR = account.InscricaoRuralEstadual__c;
		cliente.A1_INSCRM = account.InscricaoMunicipal__c;
		cliente.A1_LC = account.LimiteCredito__c;
		cliente.A1_STORAT = account.RatingCapacidadePgtoLastro__c;
		cliente.A1_STOPONT = account.RatingRiscoClimatico__c;
		cliente.A1_STRANK = account.RatingFinalCredito__c;
		cliente.A1_STOEXP = account.RatingExperienciaPgto__c;

		if(account.CartaFianca__c == 'Não Fornece')
			cliente.A1_STCFIAN = '1';
		else if(account.CartaFianca__c == 'Fornece')
			cliente.A1_STCFIAN = '2';
		else if(account.CartaFianca__c =='Pendente')
			cliente.A1_STCFIAN = '3';
		else if(account.CartaFianca__c == 'Vencida')
			cliente.A1_STCFIAN = '4';
		else
			cliente.A1_STCFIAN = '';

		if(account.Documentacao__c == 'Completa')
			cliente.A1_STDOC = 'C';
		else if(account.Documentacao__c == 'Incompleta')
			cliente.A1_STDOC = 'I';
		else if(account.Documentacao__c == 'Vencido')
			cliente.A1_STDOC = 'V';
		else if(account.Documentacao__c == 'Faltando')
			cliente.A1_STDOC = 'F';
		else if(account.Documentacao__c == 'Não Fornece')
			cliente.A1_STDOC = 'N';
		else
			cliente.A1_STDOC = '';

		cliente.A1_STVCAD = account.ValidadeCadastro__c ;
		cliente.A1_PRICOM = account.DataPrimeiraCompraCliente__c;
		cliente.A1_ULTCOM = account.DataUltimaCompraCliente__c;
		cliente.A1_EMAIL = account.Email__c;
		cliente.A1_STEMCL = account.EmailEnvioNFE__c;
		cliente.A1_STOKSER = account.OkSerasa__c;
		cliente.A1_STGARAN = account.UsaGarantia__c;
		cliente.A1_STOBSC = account.ObservacaoCadastro__c;
		cliente.A1_STMAPA1 = account.RegMapaAgrotoxico__c;
		cliente.A1_STDTMP1 = account.VenctoRegAgrotoxico__c;
		cliente.A1_STMAPA2 = account.RegMapaFertInocul__c;
		cliente.A1_STDTMP2 = account.VenctoRegFertInocul__c;
		
    	return cliente;
    }
}