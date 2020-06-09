public with sharing class SX_AboutController {
    @AuraEnabled
    public static FieloPLT__Member__c getMember() {
        List<FieloPLT__Member__c> lMemberLst = [SELECT Id, Name, V_Cargo__c, FieloPLT__Program__c, V_PosicaoRankingCongelado__c,
                        V_PapelElite__c, V_PapelSalesPersonYear__c, V_PapelYoubet__c,
                        V_MetaScoreEliteAFCongelado__c, V_MetaScoreEliteAFProjetadoCongelado__c,V_BadgeEliteCongelado__c,
                        V_BadgeYouBetCongelado__c, V_BadgeEngajamentoCongelado__c,
                     FieloPLT__User__c, FieloPLT__Points__c, V_BetcoinsComp__c, FieloPLT__Agreement__c
	                FROM FieloPLT__Member__c
	                WHERE FieloPLT__User__c =: UserInfo.getUserId()];
        if(lMemberLst.isEmpty())
            return null;
        else    
            return lMemberLst[0];           
    }
}