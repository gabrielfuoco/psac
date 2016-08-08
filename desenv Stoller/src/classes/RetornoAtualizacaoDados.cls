global with sharing class RetornoAtualizacaoDados {
	
	public RetornoAtualizacaoDados()
	{
		Mensagens = new List<string>();
	}
	
    webservice boolean Sucesso {get; set;}
    
    webservice List<string> Mensagens {get; set;}
    
    public void AdicionarMenasgem(string mensagem, boolean sucessoo)
    {
    	Sucesso = sucessoo;
    	Mensagens.add(mensagem);
    }
}