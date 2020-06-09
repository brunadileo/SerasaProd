/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 15/07/2019
*
* 
* Name: SX_RankingController.cls
* 
* Classe para o componente SX_Ranking_Cmp.cmp
*******************************************************************************/
public with sharing class SX_RankingController {

    @AuraEnabled
    public static FieloPLT__Member__c getMember() {
        List<FieloPLT__Member__c> lMemberLst = [SELECT Id, V_PapelElite__c, V_MetasAnoFiscalVigenteNovo__c,
                    V_MetasAnoFiscalVigenteNovo__r.V_UltimoMesAtualizado__c, V_MetasAnoFiscalVigenteNovo__r.V_AnoFiscal__r.V_PeriodoAF__c
	                FROM FieloPLT__Member__c
	                WHERE FieloPLT__User__c =: UserInfo.getUserId()];

	    return lMemberLst.isEmpty() ? null : lMemberLst[0];         
    }

    private static String loadAnoFiscalVigente(){

		List<VN_GerenciadorMetaParticipanteAF__c> lLstGeren = [SELECT V_AnoFiscal__c 
																FROM VN_GerenciadorMetaParticipanteAF__c
																WHERE V_Vigente__c = true];
		return lLstGeren.isEmpty() ? '' : lLstGeren[0].V_AnoFiscal__c;
	}  

    @AuraEnabled
    public static Map<Integer,List<Ranking>> getRanking(String aPapelElite){

        String lAnoFiscal = loadAnoFiscalVigente();
        if(String.isEmpty(lAnoFiscal)) return null;

        Integer lQuantidadeVagas = VN_MemberService.getQuantidadeVagas(aPapelElite);
        Integer lQuantidadeRanking = lQuantidadeVagas + 5;
        Map<Integer, List<Ranking>> lMapRanking = new Map<Integer, List<Ranking>>();
        List<Ranking> lstRanking = new List<Ranking>();
        List<Ranking> lstRankingQuaseLa = new List<Ranking>();

        List<VN_MetaParticipante__c> lstMetaParticipante = [SELECT V_Participante__c, V_ParticRankingElite__c,
                                                    V_Participante__r.Name, V_ScoreElite__c, V_ElegivelAoElite__c, V_PercentualMetaYTD__c
                                                    FROM VN_MetaParticipante__c
                                                    WHERE V_PapelElite__c =: aPapelElite AND Name =: lAnoFiscal 
                                                    AND V_Participante__r.V_NovoContratado__c = 'Não'
                                                    AND V_Participante__r.FieloPLT__Status__c = 'Active'
                                                    AND (NOT V_Participante__r.Name like '%Teste%')
                                                    AND (NOT V_Participante__r.Name like '%VAGO_%') // add 10/10 task #17343
                                                    AND (NOT V_Participante__r.Name like '%CARTEIRA_AFASTADO_%') // add 30/10 task #17394
                                                    ORDER BY V_ScoreElite__c DESC, V_PercentualMetaYTD__c DESC, V_TotalVendasYTD__c DESC,
                                                    V_Participante__r.Name ASC
                                                    LIMIT : lQuantidadeRanking];
        
        if(!lstMetaParticipante.isEmpty()){
            Integer lPosicao = 1;
            for(VN_MetaParticipante__c lMetaParticipante : lstMetaParticipante){
                Ranking lRanking = new Ranking();
                lRanking.wPosicao = lPosicao;
                lRanking.wNome = lMetaParticipante.V_Participante__r.Name;
                lRanking.wScore = Integer.valueOf(lMetaParticipante.V_ScoreElite__c);
                lRanking.wElegivel = lMetaParticipante.V_PercentualMetaYTD__c >= 100 ? 'Sim' : 'Não';
                if(lPosicao <= lQuantidadeVagas)
                    lstRanking.add(lRanking);
                else
                    lstRankingQuaseLa.add(lRanking);
                lPosicao ++;    
            }
            lMapRanking.put(0, lstRanking);
            if(!lstRankingQuaseLa.isEmpty())
                lMapRanking.put(1, lstRankingQuaseLa);
            else
                lMapRanking.put(1, null);
    
            return lMapRanking;
        }
        return null;
    }

    public class Ranking {
        @AuraEnabled public Integer wPosicao {get; set;}
        @AuraEnabled public String wNome {get; set;}
        @AuraEnabled public Integer wScore {get; set;}
        @AuraEnabled public String wElegivel {get; set;}
    }
}