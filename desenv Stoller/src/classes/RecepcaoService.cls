global with sharing class RecepcaoService {
    webservice static RetornoAtualizacaoDados AtualizarCliente(Cliente cliente) {
    	return ProcessarCliente.Executar(cliente);
    }
    
    webservice static List<RetornoAtualizacaoDados> AtualizarProduto(List<Produto> prods) {
    	return ProcessarProduto.Executar(prods);
    }
    
    webservice static RetornoAtualizacaoDados AtualizarPedido(Pedido pedido) {
    	return ProcessarPedido.Executar(pedido);
    }
    
    webservice static List<RetornoNovosClientes> ClientesNaoIntegrados()
    {
    	return ProcessarNovosClientes.Executar();
    }
    
    webservice static RetornoSolicitacaoCliente SolicitarCliente(string id)
    {
		return ProcessarSolicitacaoCliente.Executar(id);
    }
    
    webservice static RetornoAtualizacaoDados AtualizarCatalogoPreco(CatalogoPreco catalogoPreco) {
    	return ProcessarCatalogoPreco.Executar(catalogoPreco);
    }
    
    webservice static RetornoAtualizacaoDados AtualizarNotaFiscal(NotaFiscal notaFiscal) {
    	return ProcessarNotaFiscal.Executar(notaFiscal);
    }
}