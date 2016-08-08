global with sharing class CatalogoPreco {
	webservice string DA0_ATIVO {get; set;} 
	webservice string DA0_DESCRI {get; set;} 
	webservice string DA0_CODTAB {get; set;} 
	webservice Datetime DA0_DATDE {get; set;} 
	webservice Datetime DA0_DATATE {get; set;} 
	webservice string DA0_TPHORA {get; set;} 
	webservice string DA0_ZZEST {get; set;} 
	webservice string EMPRESA {get; set;} 
    
    webservice List<ItemCatalogoPreco> Itens {get; set;} 
}