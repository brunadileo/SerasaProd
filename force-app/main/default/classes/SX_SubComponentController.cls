public without sharing class SX_SubComponentController {

	@AuraEnabled
    public static  List<FieloPLT__Member__c> getMembers() {
        return [SELECT Id, Name, FieloPLT__Program__c, FieloPLT__User__c, V_Cargo__c, V_PapelElite__c,V_NomeTratamento__c,
	                V_PapelYoubet__c,V_PapelSalesPersonYear__c FROM FieloPLT__Member__c
	                WHERE FieloPLT__User__c =: UserInfo.getUserId()];
 
    }

    @AuraEnabled
    public static FieloPLT__Member__c getMember() {
        return [SELECT Name, V_NomeTratamento__c, V_Cargo__c, V_PapelElite__c,V_PapelYoubet__c,V_PapelSalesPersonYear__c,
             FieloPLT__Program__c, FieloPLT__User__c,FieloPLT__Points__c, V_BetcoinsComp__c, V_MetaScoreEliteAFCongelado__c, 
                V_PosicaoRankingCongelado__c FROM FieloPLT__Member__c
	            WHERE FieloPLT__User__c =: UserInfo.getUserId()];
 
    }

    @AuraEnabled
    public static String getScore(String aIdMember) {

        String lAnoFiscal = loadAnoFiscalVigente();
        if(String.isEmpty(lAnoFiscal)) return null;

        List<VN_MetaParticipante__c> lLstMeta = [SELECT Id, V_ScoreElite__c
                                                    FROM VN_MetaParticipante__c
                                                    WHERE V_Participante__c =: aIdMember
                                                    AND Name =: lAnoFiscal];

        Decimal lScore =  lLstMeta.isEmpty() || lLstMeta[0].V_ScoreElite__c == null ? 0 : lLstMeta[0].V_ScoreElite__c;
        return lScore < 10 ? '0' + String.valueOf(lScore) : String.valueOf(lScore);        
    }

    @AuraEnabled
    public static String getRanking(String aIdMember, String aCargo) {


        String lAnoFiscal = loadAnoFiscalVigente();
        if(String.isEmpty(lAnoFiscal)) return null;

         return SX_HomeCardController.getRanking(aIdMember, aCargo);
    }   


    private static String loadAnoFiscalVigente(){

        List<VN_GerenciadorMetaParticipanteAF__c> lLstGeren = [SELECT V_AnoFiscal__c 
                                                                FROM VN_GerenciadorMetaParticipanteAF__c
                                                                WHERE V_Vigente__c = true];
        return lLstGeren.isEmpty() ? '' : lLstGeren[0].V_AnoFiscal__c;
    } 
}