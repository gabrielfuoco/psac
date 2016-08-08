global class BotoesCampoDemonstrativo
{
    //
    //Classe BotoesCampoDemonstrativo
    //Desenvolvida por: Sottelli Intelligent IT
    //Agosto/2016
    //Sprint IV - Projeto Salesforce Stoller
    //
    //Funcionalidade: Métodos para execução de botões e ações customizados no objeto Campos Demonstrativos
    // 
    
    /* Método para o botão Colher Campo Demonstrativo */
    webservice static string colherCampo(ID campoID){
        string mensagem;
        List<Tratamento__c> listTratamentos = [	SELECT ID, Campo_Demonstrativo__c, Resultado__c
                                               	FROM Tratamento__c
                                               	WHERE Campo_Demonstrativo__c =: campoID];
        List<Campos_Demonstrativos__c> campoDemonstrativo = [	SELECT ID, Status__c, Autoriza_Divulgacao__c
                                                            	FROM Campos_Demonstrativos__c
                                                            	WHERE ID =: campoID];
        try{
            for (Tratamento__c tratamento : listTratamentos){
            if (tratamento.Resultado__c != null){
                for (Campos_Demonstrativos__c campo : campoDemonstrativo){
                    campo.Status__c = 'Colhido';                 
                    if(campo.Autoriza_Divulgacao__c = true)
						update campo;
                        mensagem = 'Favor anexar autoriazação de uso de imagem e uma foto do produtor em Anexos';                   
                }
            }else{
                		mensagem = 'Preencher o resultado de todos os tratamentos relacionados!';
            }
            }
        }catch (DMLException Ex){
            mensagem = Ex.getDmlMessage(0);  
        }
    		return mensagem;
    }
    
    /* Método para o botão Cancelar Campo Demonstrativo */   
    webservice static string cancelarCampo(ID campoID){
        string mensagem;
        List<Campos_Demonstrativos__c> campoDemonstrativo = [	SELECT ID, Justificativa__C, Status__c
                                                            	FROM Campos_Demonstrativos__c
                                                            	WHERE ID =: campoID];
	try{        
        for (Campos_Demonstrativos__c campo : campoDemonstrativo){
            
            if(campo.Justificativa__c == null){
			                
            campo.Status__c = 'Cancelado';

            update campo;
        }else {
            	mensagem = 'Para informar cancelamento, por favor preencha o campo Justificativa!';
        		}
       	 }
    }	catch (DMLException Ex){
		mensagem = Ex.getDMLMessage(0);	
    	}
       	return mensagem;
    }

    /* Método para o botão Cancelar Campo Demonstrativo */
    webservice static string informarPerda (ID campoID){
        string mensagem;
        List<Campos_Demonstrativos__c> campoDemonstrativo = [	SELECT ID, Justificativa__c, Status__c
                                                            	FROM Campos_Demonstrativos__c
                                                            	WHERE ID =: campoID];
        try{
            for (Campos_Demonstrativos__c campo : campoDemonstrativo){
            
            if(campo.Justificativa__c == null){
                
                campo.Status__c = 'Instalado e Perdido';
                
                update campo;
            }else{
                
          		mensagem = 'Para informar perda, por favor preencha o campo Justificativa!';
				}
       		 }
        }catch (DMLException Ex){
			mensagem = Ex.getDMLMessage(0);	
			system.debug(mensagem);
      	  }
      return mensagem;
    }
}