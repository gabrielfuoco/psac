global with sharing class RetornoAtualizarCliente {
	
	public RetornoAtualizarCliente()
	{
		Mensagens = new List<string>();
	}
	
    webservice boolean Sucesso {get; set;}
    webservice List<string> Mensagens {get; set;}
}