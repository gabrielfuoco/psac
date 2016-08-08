public with sharing class RotasController {
    
    public String jsonData {get; set;}
    public String message {get; set;}
    public Integer ano {get; set;}
    public Integer mes {get; set;}
    public Integer dia {get; set;}
    
    public RotasController(){}
    
    public RotasController (Integer anoComp, Integer mesComp, Integer diaComp)
    {
        ano = anoComp;
        mes = mesComp;
        dia = diaComp;
    }
    
    public void listarCompromissos()
    { 
        date dataCompromisso = date.newInstance(ano, mes, dia);
        String userID = UserInfo.getUserId();
        
        List<RotasDados> dadosRotas = new List<RotasDados>();
        
        List<Event> eventos = [SELECT Id, WhatId, ActivityDate, ActivityDateTime, StartDateTime, EndDateTime, AccountId, OwnerId, Type
                                 FROM Event
                                 Where OwnerId = :userID
                                 AND ActivityDate = :dataCompromisso
                                 AND Type = 'Visita'
                                 ORDER BY StartDateTime ASC];
        
        if (!eventos.isEmpty()) 
        {
            for(Event compromisso : eventos)
            {
                dadosRotas.add(new RotasDados(compromisso));  
            }
             
            jsonData = JSON.serialize(dadosRotas);
            message = '';
        }
        else
        {
            message = 'Nenhuma Visita Agendada Para Esta Data.';
            jsonData = JSON.serialize(dadosRotas);
        }
    }
    
    //json com somente os atributos necessários
    public class RotasDados {
        
        public string ID {get; set;}
        public string contaNome {get; set;}
        public string endRua {get; set;}
        public string endCidade {get; set;}
        public string endEstado {get; set;}
        public string endCep {get; set;}
        public string dataHora {get; set;}
    
        public RotasDados(Event compromisso)
        {            
            ID = compromisso.ID;
            contaNome = [SELECT Name FROM ACCOUNT WHERE ID = :compromisso.AccountId].Name;
            endRua = [SELECT ShippingStreet FROM ACCOUNT WHERE ID = :compromisso.AccountId].ShippingStreet;
            endCidade = [SELECT ShippingCity FROM ACCOUNT WHERE ID = :compromisso.AccountId].ShippingCity;
            endEstado = [SELECT ShippingState FROM ACCOUNT WHERE ID = :compromisso.AccountId].ShippingState;
            endCep = [SELECT ShippingPostalCode FROM ACCOUNT WHERE ID = :compromisso.AccountId].ShippingPostalCode;
            dataHora = string.valueofGmt(compromisso.StartDateTime).substring(11, 16);
        }
    }
}