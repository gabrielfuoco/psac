global with sharing class RetornoSolicitacaoCliente {
    
    public RetornoSolicitacaoCliente()
    {
    	DadosMensagem = new RetornoAtualizacaoDados();
    }
    
    webservice Cliente cliente {get; set;}
    
    webservice RetornoAtualizacaoDados DadosMensagem {get;set;}
}