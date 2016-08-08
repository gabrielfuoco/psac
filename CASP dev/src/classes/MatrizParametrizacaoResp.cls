public class MatrizParametrizacaoResp {
    
    public MatrizParametrizacaoResp()
    {
        Colunas = new List<MatrizColuna__c>();
        Linhas = new List<MatrizLinha__c>();
        Respostas = new List<MatrizResposta__c>();
    }
    
    public List<MatrizColuna__c> Colunas {get; set;}
    public List<MatrizLinha__c> Linhas {get; set;}
    public List<MatrizResposta__c> Respostas {get; set;}
}