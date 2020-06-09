/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                          date: 22/09/2018
* 
* Name: SObjectForTest.cls
* 
* Classe que possui os objetos que auxiliam na criação de classes de teste
*
*******************************************************************************/
@isTest
public class SObjectForTest {

    public static Account getAccount() {
        return new Account(
            Name = 'Account for Test',
            NumberOfEmployees = 1
        );
    }

    public static Contact getContact(){
        return new Contact(
            FirstName = 'Name',
            LastName = 'Contact'
        );
    }

    public static VN_GerenciadorMetaParticipanteAF__c getGerenciadorMetaParticipante(){
        return new VN_GerenciadorMetaParticipanteAF__c(
            V_AnoFiscal__c = System.Label.V_AnoFiscal,
            V_PeriodoAF__c = '2018-2019',
            V_Vigente__c = true,
            V_DataInicio__c = Date.newInstance(2018, 4, 01),
            V_DataFim__c = Date.newInstance(2019, 3, 31)
        );
    } 

    public static FieloPLT__Member__c getMember(Id aPrograma){
        return new FieloPLT__Member__c(
            Name ='Name',
            FieloPLT__Email__c = 'Name@test.com',
            V_RegistroParticipante__c ='Name',
            V_Area__c ='VERTICAIS',
            V_Lideranca__c = 'SERVIÇOS FINANCEIROS',
            V_Cargo__c = 'DIRETOR',
            V_Setor__c = 'BANCOS E FINANCEIRAS BR',
            V_CodigoCarteira__c ='Name',
            FieloPLT__Program__c = aPrograma,
            V_PapelYoubet__c = 'GERENTES DE CONTAS',
            V_Ponderar__c = 'Não'
        );
    }

    public static List<FieloPLT__Member__c> getMemberList(Id aPrograma){
        List<FieloPLT__Member__c> lstMember = new List<FieloPLT__Member__c>();
        for(Integer i=0 ;i <10;i++)
        {
            FieloPLT__Member__c lMember = new FieloPLT__Member__c();
            lMember.Name ='Name'+i;
            lMember.V_Ponderar__c = 'Não';
            lMember.FieloPLT__Email__c = 'Name'+i+'@test.com';
            lMember.V_RegistroParticipante__c ='Name'+i;
            lMember.V_Area__c ='VERTICAIS';
            lMember.V_Lideranca__c = 'SERVIÇOS FINANCEIROS';
            lMember.V_Cargo__c = 'DIRETOR';
            lMember.V_Setor__c = 'BANCOS E FINANCEIRAS BR';
            lMember.V_CodigoCarteira__c ='Name'+i;
            lMember.FieloPLT__Program__c = aPrograma;
            lMember.V_PapelYoubet__c = 'GERENTES DE CONTAS';
            lstMember.add(lMember);
        }
        return lstMember;
    }

    public static VN_MetasParticipantes__c getMetas(Id aMember, Id aGerenciadorMetas){
        return new VN_MetasParticipantes__c(
            Name = 'FY19',
            V_Participante__c = aMember,
            V_GerenciadorMetasAF__c = aGerenciadorMetas,
            V_MetaAF__c = 1
        );
    }

    public static VN_MetaParticipante__c getMetasNovaEstrutura(Id aMemberId, Id aGerenciadorMetasId, String aAnoFiscal){
        return new VN_MetaParticipante__c(
		 				Name = aAnoFiscal,
		 				V_AnoFiscal__c  = aGerenciadorMetasId,
		 				V_Participante__c = aMemberId);
    }

    public static List<VN_MetaParticipante__c> getMetasNovaEstruturaLst(List<FieloPLT__Member__c> aMemberLst, Id aGerenciadorMetasId, String aAnoFiscal){
        List<VN_MetaParticipante__c> lstMetas = new List<VN_MetaParticipante__c>();
        for(FieloPLT__Member__c lMember : aMemberLst){
            lstMetas.add(new VN_MetaParticipante__c(Name = aAnoFiscal,
		 				V_AnoFiscal__c  = aGerenciadorMetasId,
		 				V_Participante__c = lMember.Id));
        }
        return lstMetas;
    }

    public static List<VN_MetasParticipantes__c> getMetasList(List<FieloPLT__Member__c> aMemberLst, Id aGerenciadorMetas){
        List<VN_MetasParticipantes__c> lstMetasParticipantes = new List<VN_MetasParticipantes__c>();
        for(FieloPLT__Member__c lMember : aMemberLst){
            VN_MetasParticipantes__c lMetasParticipantes = new VN_MetasParticipantes__c(Name = System.Label.V_AnoFiscal,
                    V_Participante__c = lMember.Id, V_GerenciadorMetasAF__c = aGerenciadorMetas);
            lstMetasParticipantes.add(lMetasParticipantes);
            System.debug('METAS: ' + lMetasParticipantes);
        }
        return lstMetasParticipantes;
    }

    public static FieloPLT__Program__c getProgram(String aName) {
        return new FieloPLT__Program__c(
            Name = aName,
            FieloPLT__OnlineTransactionProcessing__c = true
         );
    }
 
    public static FieloPLT__Reward__c getReward(Id aProgram, String aTipodeRegistro, String aIniciativa){
        return new FieloPLT__Reward__c(
            Name = 'Test',
            FieloPLT__Program__c = aProgram,
            Iniciativa__c = aIniciativa,
            FieloPLT__StockManagement__c = 'Unlimited',
            FieloPLT__Points__c = 150,
            RecordTypeId =  VN_RecType.getID('FieloPLT__Reward__c', aTipodeRegistro),
            V_PapelYoubet__c = 'GERENTES DE CONTAS'
        );
    }

    public static FieloPLT__RedemptionItem__c getRedemptionItem(Id aReward, Id aRedemption){
        return new FieloPLT__RedemptionItem__c(
            FieloPLT__Status__c = Label.V_StatusReady,
            FieloPLT__Quantity__c = 3,
            FieloPLT__Reward__c = aReward,
            FieloPLT__Redemption__c = aRedemption
        );
    }

    public static List<FieloPLT__RedemptionItem__c> getRedemptionItemList(Id aReward, List<FieloPLT__Redemption__c> aRedemptionLst){
        List<FieloPLT__RedemptionItem__c> lstRedemptionItem = new List<FieloPLT__RedemptionItem__c>();
        Integer lQtdItens = 1;
        for(FieloPLT__Redemption__c lRedemption : aRedemptionLst){
            FieloPLT__RedemptionItem__c lRedemptionItem = new FieloPLT__RedemptionItem__c(
                FieloPLT__Status__c = Label.V_StatusOpen,
                FieloPLT__Quantity__c = lQtdItens,
                FieloPLT__Reward__c = aReward,
                FieloPLT__Redemption__c = lRedemption.Id);
            lQtdItens++;
            lstRedemptionItem.add(lRedemptionItem);
        }
        return lstRedemptionItem;
    }

    public static FieloPLT__Redemption__c getRedemption(Id aMember){
        return new FieloPLT__Redemption__c(
            FieloPLT__Member__c = aMember,
            FieloPLT__Status__c = 'Closed'
        );
    }   

    public static List<FieloPLT__Redemption__c> getRedemptionList (List<FieloPLT__Member__c> aMemberLst){
        List<FieloPLT__Redemption__c> lstRedemptions = new List<FieloPLT__Redemption__c>();
        for(FieloPLT__Member__c lMember : aMemberLst){
            FieloPLT__Redemption__c lRedemption = new FieloPLT__Redemption__c(
                FieloPLT__Member__c = lMember.Id,
                FieloPLT__Status__c = 'Closed');
            lstRedemptions.add(lRedemption);
        }
        return lstRedemptions;
    }

     public static Profile getProfile( String aProfileName){
        return [ Select Id From Profile Where Name=:aProfileName Limit 1 ];
    }

    public static User getUser(Id aProfile){
        return new User(
            Username = 'usuarioteste@valuenet.com.br',
            Email = 'nome@empresa.com',
            LastName = 'Sobrenome',
            Alias = 'VN',
            CommunityNickname = 'vnscteste',
            EmailEncodingKey = 'ISO-8859-1',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'pt_BR',
            LanguageLocaleKey = 'pt_BR',
            ProfileId = aProfile
        );
    }

    public static FieloPLT__Agreement__c getAgreement( String aProgramId )
    {
        return new FieloPLT__Agreement__c(
            FieloPLT__Program__c = aProgramId,
            FieloPLT__Agreement__c = 'Qualquer texto **Destaque** outro texto'
        );
    }

      public static void setPublicSettings() {
        FieloPLT__PublicSettings__c lPublicSettings = new FieloPLT__PublicSettings__c(
                FieloPLT__ContactRelationshipClass__c = 'VN_ContactRelationshipDefault');
        insert lPublicSettings;
    }
    
     //FIELO OBJECTS
  public static FieloPLT__Member__c getMember(String aName, Id aPrg){

    return new FieloPLT__Member__c(
       Name = aName,
       FieloPLT__Email__c = aName.deleteWhitespace() + Datetime.now().getTime() + '@vn.com',
       FieloPLT__Program__c = aPrg,
       FieloPLT__Points__c = 0,
       FieloPLT__Type__c = 'Individual Account',
       V_PapelYoubet__c = 'GERENTES DE CONTAS'
    );
  }

  public static FieloPLT__Transaction__c getTransaction(Id aMemberId){
      return new FieloPLT__Transaction__c(        
       FieloPLT__Member__c = aMemberId,
       FieloPLT__Points__c = 10,
       FieloPLT__Value__c = 500
      );
    }
  
  public static FieloPLT__Reward__c getReward(Id aProgramId, Id aAccId) {
    return new FieloPLT__Reward__c(
      FieloPLT__Program__c = aProgramId,
      FieloPLT__Points__c = 0,
      Name = 'Serviço teste ' + Datetime.now().getTime(),
      FieloPLT__Stock__c = 10000,
      FieloPLT__UniqueVoucher__c = true,
      FieloPLT__Image__c = 'imagemTeste',
      FieloPLT__ExpirationDate__c = system.today().addDays(100),
      FieloPLT__Provider__c = aAccId
    );
  }

  public static VN_Resultado__c getResultado(String aIdMeta, String aAnoFiscal, String aMember){

    return new VN_Resultado__c(
        V_MetaParticipante__c = aIdMeta,
        V_Valor__c = 100,
        V_AnoFiscal__c = aAnoFiscal,
        Meta__c = null,
        V_Participante__c = aMember
    );

  } 

    public static FieloPLT__BadgeMember__c getBadgeMember(String aIdBadge, String aIdMember){

        return new FieloPLT__BadgeMember__c(
            FieloPLT__Badge__c = aIdBadge,
            FieloPLT__Member__c = aIdMember
        );
    } 

    public static FieloPLT__Badge__c getBadge(String aIdPrg){

        return new FieloPLT__Badge__c(
            Name = 'Test',
            FieloPLT__Program__c = aIdPrg
        );
    }
    public static Id  getPointType(){

        FieloPLT__PointType__c lPointType = [SELECT Id FROM FieloPLT__PointType__c LIMIT 1];

         return lPointType != null ? lPointType.id: null;
    }

    public static FieloPLT__PointType__c getPointType(String aName){ 
        return new FieloPLT__PointType__c(
            Name = aName,
            FieloPLT__MemberBalanceField__c = 'FieloPLT__Points__c',
            FieloPLT__TransactionBalanceField__c = 'FieloPLT__Points__c',
            FieloPLT__RedemptionBalanceField__c = 'FieloPLT__Points__c',
            FieloPLT__RedemptionItemBalanceField__c = 'FieloPLT__Points__c',
            FieloPLT__RewardBalanceField__c = 'FieloPLT__Points__c',
            FieloPLT__ConversionModeField__c = 'FieloPLT__PointConversionMode__c',
            FieloPLT__ConversionValueField__c  = 'FieloPLT__ConversionValue__c',
            FieloPLT__MonthsUntilExpirationField__c = 'FieloPLT__MonthsUntilExpiration__c',
            FieloPLT__RecordFieldNameField__c = 'FieloPLT__RecordFieldName__c',
            FieloPLT__PointExpirationDateField__c = 'FieloPLT__PointExpirationDate__c',
            FieloPLT__PointExpirationModeField__c = 'FieloPLT__PointExpirationMode__c',
            FieloPLT__PointReflectionField__c = 'FieloPLT__PointReflection__c'
        );
    }

    public static FieloPLT__Point__c getPoint(Id aMemberId, Id aRuleId){
      return new FieloPLT__Point__c(
       FieloPLT__Member__c = aMemberId,
       FieloPLT__TotalPoints__c = 10,
       FieloPLT__Rule__c = aRuleId,
       FieloPLT__PointType__c = getPointType()

      );
    
    }
    
    public static FieloPLT__Point__c getPoint(Id aMemberId){
      return new FieloPLT__Point__c(
       FieloPLT__Member__c = aMemberId,
       FieloPLT__TotalPoints__c = 10,
       FieloPLT__PointType__c = getPointType()  

      );
    
    }
    public static FieloPLT__Promotion__c getPromotion(Id aIdPrg){
        return new FieloPLT__Promotion__c(
             Name = 'Teste',
             FieloPLT__Program__c = aIdPrg
        );
    }

    public static FieloPLT__RuleTrigger__c getRuleTrigger(){
        return new FieloPLT__RuleTrigger__c(
            Name = 'Teste',
            FieloPLT__Object__c = 'FieloPLT__Event__c',
            FieloPLT__LookupFromTransaction__c = 'FieloPLT__Event__c'
        );
    }

    public static FieloPLT__Action__c getAction(String aRuleTrigger){
        return new FieloPLT__Action__c(
            FieloPLT__RuleTrigger__c = aRuleTrigger,
            name = 'teste2',
            FieloPLT__TargetMember__c = 'FieloPLT__Member__c'
        );
    }

    public static FieloPLT__Rule__c getRule(String aName, Id aPromo, Id aIdAction){
        return new FieloPLT__Rule__c(
             Name = aName,
             FieloPLT__Promotion__c = aPromo,
             FieloPLT__ConversionValue__c = 2.0,
             FieloPLT__PointConversionMode__c = 'Multiplier',
             FieloPLT__RecordFieldName__c = 'Name',
             FieloPLT__Action__c = aIdAction

        );
    }

    public static User loadUserLoggedMember (){                          
        FieloPLT__Program__c lProgram = getProgram('programName'); 
        insert lProgram;  
                
        Profile lPerfil = getProfile('Fielo Partner Community');
                                
        Account lAccount = getAccount();
        insert lAccount;
        
        Contact lContact = getContact();
        lContact.AccountId = lAccount.Id;
        insert lContact;
        
        User lUser = getUser(lPerfil.Id);
        lUser.ContactId = lContact.Id;
        insert lUser;

        FieloPLT__Member__c lMember = getMember(lProgram.Id); 
        lMember.FieloPLT__User__c = lUser.Id;
        insert lMember; 
                                                                            
        return lUser;
    }

    public static VN_ResumoCargasDadosTemp__c getResumoCargaDadosTemp(){
        return new VN_ResumoCargasDadosTemp__c(
            V_NomeArquivo__c = 'arq-test.csv',
            V_DataCarga__c = Date.today(),
            V_StatusPDI__c	= 'Carregado'
        );
    }

    public static List<VN_CargasDadosTemp__c> getCargaDadosTempList(Id aResumoCargasDadosTemp, String aCodigoLideranca, String aCodigoCoordenadorVenda1){
        List<VN_CargasDadosTemp__c> lCargaDadosTempLst = new List<VN_CargasDadosTemp__c>();
        for(Integer i=1; i <= 10; i++) {
            lCargaDadosTempLst.add(new VN_CargasDadosTemp__c(
                V_NoResumoCargas__c	= aResumoCargasDadosTemp,
                V_ChaveExclusiva__c	= 'B'+i,
                V_CodigoSetor__c = '37',
                V_CodigoLideranca__c = aCodigoLideranca,
                V_CodigoCoordenadorVenda1__c = aCodigoCoordenadorVenda1,
                V_Meta__c = String.valueOf(i),
                V_ResultadoTotal__c = String.valueOf(i*2),
                V_ProdutosEstrategicos__c = String.valueOf(i*3),
                V_Mes__c = '01/04/2018'
            ));
        }
        return lCargaDadosTempLst;
    }
}