global with sharing class NotaFiscal {
	webservice string F2_FILIAL     {get; set;}
	webservice string EMPRESA     {get; set;}
	webservice string F2_LOJA       {get; set;}
	webservice string F2_DOC        {get; set;}
	webservice string F2_SERIE      {get; set;}
	webservice Date F2_EMISSAO    {get; set;}
	webservice string F2_CLIENTE    {get; set;}
	webservice string F2_TIPO       {get; set;}
	webservice Decimal VLR_DOLAR     {get; set;}
	webservice Decimal VALBRUT_REAL  {get; set;}
	webservice Decimal VALBRUT_DOLAR {get; set;}
	webservice string CC2_EST       {get; set;}
	webservice string CC2_MUN       {get; set;}
	webservice string F2_TIPOCLI    {get; set;}
	webservice string F2_VEND1      {get; set;}
	webservice string F2_MOEDA      {get; set;}
	webservice string F2_STCONTR    {get; set;}
	webservice Date F2_ZZDTCTB    {get; set;}
	
    webservice List<ItemNotaFiscal> Itens {get; set;}
}