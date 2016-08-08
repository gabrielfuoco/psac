global with sharing class Pedido {
	webservice string C5_NUM {get; set;}
	webservice string C5_CLIENTE {get; set;}
	webservice string C5_FILIAL {get; set;}
	webservice string EMPRESA {get; set;}
	webservice Date C5_EMISSAO {get; set;}
	webservice string C5_TIPO {get; set;}
	webservice string C5_CONDPAG {get; set;}
	webservice double C5_STTXSTR {get; set;}
	webservice double C5_STTXPTX {get; set;}
	webservice string C5_TPFRETE {get; set;}
	webservice string C5_STOBSPV {get; set;}
	webservice string C5_LOJACLI {get; set;}
	webservice string C5_TABELA {get; set;}
    webservice List<ItemPedido> Itens {get; set;}
}