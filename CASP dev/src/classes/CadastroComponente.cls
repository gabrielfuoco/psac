public class CadastroComponente {
    
    public CadastroComponente()
    {
        Colunas = new List<ItemCadastroComponente>();
        Linha = new MatrizLinha__c();
    }
    
    public MatrizLinha__c Linha {get; set;} 
    public List<ItemCadastroComponente> Colunas {get; set;}
}