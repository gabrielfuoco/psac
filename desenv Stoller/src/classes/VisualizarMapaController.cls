public class VisualizarMapaController
{
    public list<mapWrapper> wrapList;
    public string jsonString{get;set;}
    public string accId;
    public RegistroDeLocalizacao__c regLoc {get;set;}
    public boolean allAcc{get;set;}
    public list<SelectOption> userList {get;set;}
    public string selectedUser {get;set;}
    public list<SelectOption> accList {get;set;}
    public String selectedAcc {get;set;}
    public decimal lat {get;set;}
    public decimal lon {get;set;}
    
    public VisualizarMapaController()
    {
        allAcc = false;
        accList = new list<SelectOption>();
        
        regLoc = new RegistroDeLocalizacao__c();
        regLoc.DataHoraDoCheckOut__c = system.now();
        regLoc.DtCheckOut__c =  system.today();
        
        accId = ApexPages.currentPage().getParameters().get('accId');
        userList = new list<SelectOption>();
        selectedUser = userInfo.getUserId();
        for(User usr : [select id, name from user where IsActive=true])
            userList.add(new SelectOption(usr.Id , usr.Name));
        
        accList.add(new SelectOption('.' , '--Selecionar Conta--'));
        //selectedAcc = null;
        /*for(RegistroDeLocalizacao__c regLoc : [SELECT id, name, Conta__r.Name, Conta__c, LocalizacaoGeograficaDoCheckInGeo__c 
        										FROM RegistroDeLocalizacao__c 
        										WHERE CreatedByID =: selectedUser
                                              	AND Conta__c != null])
            accList.add(new SelectOption(regLoc.Conta__c, regLoc.Conta__r.name));	
          */  
	}

    public class mapWrapper{
        public String Name{get;set;}
        public String accountName{get;set;}
        public Decimal lat{get;set;}
        public Date checkInDate {get;set;}
        public Decimal lng{get;set;}
        public String createdBy {get;set;}
    }
    
     public void onUserChange()
    {
        accList = new list<SelectOption>();
        accList.add(new SelectOption('.', '-Selecionar Conta-'));
        selectedAcc = null;
        
        string query = 'select id, name, CreatedBy.Name, DtCheckIn__c, LocalizacaoGeograficaDoCheckInGeo__Longitude__s, Conta__r.Name, LocalizacaoGeograficaDoCheckInGeo__Latitude__s, Conta__c, LocalizacaoGeograficaDoCheckInGeo__c from RegistroDeLocalizacao__c Where CreatedById =: selectedUser AND ';
                
        Date inDate;
        if(regLoc.DtCheckIn__c != NULL)
            inDate = date.newinstance(regLoc.DtCheckIn__c.year(), regLoc.DtCheckIn__c.month(), regLoc.DtCheckIn__c.day());
        
        if(inDate != NULL)
            query = query + ' DtCheckIn__c >=: inDate AND ';
        
      //  if(regLoc.DataHoraDoCheckOut__c == NULL)
        //    regLoc.DataHoraDoCheckOut__c = system.now();
            
        Date outDate = date.newinstance(regLoc.DataHoraDoCheckOut__c.year(), regLoc.DataHoraDoCheckOut__c.month(), regLoc.DataHoraDoCheckOut__c.day());
        
        if(outDate != NULL)
            query = query + ' DtCheckOut__c <=: outDate AND ';
        
        if(query.endsWith('AND '))
            query = query.removeEnd('AND ');
            
        for(RegistroDeLocalizacao__c regLoc : database.query(query))
            accList.add(new SelectOption(regLoc.Conta__c, regLoc.Conta__r.name));
    }
    
    public void onSearchClick()
    {
    	lat = 0;
        lon = 0;
    	wrapList = new list<mapWrapper>();
        string query = 'select id, name, CreatedBy.Name, DtCheckIn__c, LocalizacaoGeograficaDoCheckInGeo__Longitude__s, Conta__r.Name, LocalizacaoGeograficaDoCheckInGeo__Latitude__s, Conta__c, LocalizacaoGeograficaDoCheckInGeo__c from RegistroDeLocalizacao__c WHERE CreatedByID =: selectedUser AND ';
        
        Date inDate;
        if(regLoc.DtCheckIn__c != NULL)
            inDate = date.newinstance(regLoc.DtCheckIn__c.year(), regLoc.DtCheckIn__c.month(), regLoc.DtCheckIn__c.day());
        
        if(inDate != NULL)
            query = query + ' DtCheckIn__c >=: inDate AND ';
        
        if(regLoc.DataHoraDoCheckOut__c == NULL)
            regLoc.DataHoraDoCheckOut__c = system.now();
        
        Date outDate = date.newinstance(regLoc.DataHoraDoCheckOut__c.year(), regLoc.DataHoraDoCheckOut__c.month(), regLoc.DataHoraDoCheckOut__c.day());
		
        if(outDate != NULL)
            query = query + ' DtCheckOut__c <=: outDate AND ';
            
        if(allAcc == false && selectedAcc != 'Lead Empresa')
            query = query + ' Conta__c =: selectedAcc';
        
        if(query.endsWith('AND '))
            query = query.removeEnd('AND ');
                
        for(RegistroDeLocalizacao__c regLoc : database.query(query))
        {
            system.debug('+++++loop');
            mapWrapper mpWrap = new mapWrapper();
            mpWrap.Name = regLoc.name;
            mpWrap.accountName = regLoc.Conta__r.Name;
            mpWrap.lat = regLoc.LocalizacaoGeograficaDoCheckInGeo__Latitude__s;
            mpWrap.lng = regLoc.LocalizacaoGeograficaDoCheckInGeo__Longitude__s;
            mpWrap.checkInDate = regLoc.DtCheckIn__c;
            mpWrap.createdBy = regLoc.CreatedBy.Name;
            wrapList.add(mpWrap);
            
          if(lat == 0 || lat < regLoc.LocalizacaoGeograficaDoCheckInGeo__Latitude__s)
          	      lat = regLoc.LocalizacaoGeograficaDoCheckInGeo__Latitude__s;
           
          if(lon == 0 || lon < regLoc.LocalizacaoGeograficaDoCheckInGeo__Longitude__s)
                lon = regLoc.LocalizacaoGeograficaDoCheckInGeo__Longitude__s;
        }
        
        system.debug('lat: '+lat);
        system.debug('lon: '+lon);
        system.debug('separador ~~~~~~~~ separador ~~~~~~');
        
        jsonString = json.serialize(wrapList);
        
        system.debug('wraplist: '+wrapList);
    }
}