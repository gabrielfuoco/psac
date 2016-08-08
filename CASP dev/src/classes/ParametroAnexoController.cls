public class ParametroAnexoController {
    
    public Parametro__c parametro {get; private set;}
    
    public List<AttachmentFile> allFileList {get; set;}
    
    public string opcaoARemover {get; set;}
    
    public ParametroAnexoController() {
        parametro = [SELECT Id, Name, Pergunta__c, OpcaoPadrao__c, tipo__c FROM Parametro__c 
                     WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        
        List<ParametroOpcao__c> paramOpcoes = [select id, name, sequencia__c from ParametroOpcao__c where parametro__r.id = :parametro.id];
        
        List<Attachment> imagensEmAnexo = [Select id, name, description, parentId, body from Attachment where parentId in :paramOpcoes];
        
        allFileList = new List<AttachmentFile>();
        
        for(ParametroOpcao__c opt: paramOpcoes)
        {
            AttachmentFile file = new AttachmentFile();
            file.ParametroOpcao = opt;
          
            for(Attachment imagem : imagensEmAnexo)
            {
                if(imagem.parentId == opt.id)
                {
                      file.anexo =  imagem;
                }
            }
            
            if(file.anexo ==  null)
                file.anexo = new Attachment();
            
            allFileList.add(file);
        }
		
    }
    
    public PageReference Anexo()
    {
        return null;
    }
    
    public PageReference Salvar() {

        if(parametro.Tipo__c != 'Botão de opção')
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Somente é possível anexar imagens para parâmetros com o Tipo de campo: "Botão de Opção"', ''));
            return null;
        }
        
        List<Attachment> listToInsert = new List<Attachment>() ;  
  
        for(AttachmentFile ab: allFileList)  
        {  
            Attachment a = ab.Anexo;
            List<String> nomeComp = ab.NomeCompletoImagem.Split('\\.');
            String extensao =  nomeComp[nomeComp.size() -1].toUpperCase();
            
            a.name = ab.Nome;
            
            if(ab.Remover != null && ab.Remover)
            {
                delete ab.Anexo;
            }
            
            if(a.name != null && a.name != '' && a.body != null) 
            {
               if(extensao != 'JPG' && extensao != 'PNG' && extensao != 'JPEG' && extensao != 'GIF')
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.FATAL, listToInsert.size() + ' Extensão do arquivo ' + a.Name + ' inválida'));
                    return null;
                }
                
                if(ab.Anexo.id != null && ab.Remover != null && !ab.Remover)
                	delete ab.Anexo;
                    
                listToInsert.add(new Attachment(parentId = ab.ParametroOpcao.Id, 
                                               	name = a.name, 
                                                ContentType = a.ContentType, 
                                                Description = a.name,
                                                body = a.body)) ;  
            }
                
        }  
          
        //Inserting attachments  
        if(listToInsert.size() > 0)  
        {  
            insert listToInsert ;  
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, listToInsert.size() + ' file(s) are uploaded successfully')); 
        }
        
        PageReference send = new PageReference('/' + parametro.Id);
        send.setRedirect(true);
        
        return send;
    }
    
    public PageReference RemoverAnexo()
    {
        List<Attachment> anexo = [select id from Attachment where parentId = :opcaoARemover];
        
        delete anexo;
        
        PageReference send = new PageReference('/' + parametro.Id);
        send.setRedirect(true);
        
        return send;
    }
    
    public PageReference Cancel() {
        
        PageReference send = new PageReference('/' + parametro.Id);
        send.setRedirect(true);
        
        return send;
    }
}