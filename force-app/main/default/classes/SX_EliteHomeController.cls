/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 16/10/2018
* 
* Name: SX_EliteHomeController.cls
* 
* Controller da home Elite
*******************************************************************************/
public with sharing class SX_EliteHomeController {  

    @AuraEnabled
    public static FieloPLT__Member__c getMember() {
        List<FieloPLT__Member__c> lMemberLst = [SELECT Id, V_Cargo__c, V_PapelElite__c, FieloPLT__Program__r.V_RegulamentoElite__c
                    FROM FieloPLT__Member__c
                    WHERE FieloPLT__User__c =: UserInfo.getUserId()];

        return lMemberLst.isEmpty() ? null : lMemberLst[0];         
    }

    // @AuraEnabled
    // public static VN_MetasParticipantes__c getMeta(String aIdMember) {

    //  String lAnoFiscal = loadAnoFiscalVigente();
    //  if(String.isEmpty(lAnoFiscal)) return null;

    //  List<VN_MetasParticipantes__c> lLstMeta = [SELECT Id, V_ScoreEliteAF__c, V_ScorePotencialCarteira__c,
    //                                              V_ScoreAMH1EliteSemestre1AF__c, V_ScoreAMEliteAF__c, V_ScoreSMEliteAF__c,
    //                                              V_ScoreEliteHoje__c, V_Participante__r.V_NovoContratado__c
    //                                              FROM VN_MetasParticipantes__c
    //                                              WHERE V_Participante__c =: aIdMember
    //                                              AND Name =: lAnoFiscal];

    //  return lLstMeta.isEmpty() ? null : lLstMeta[0];         
    // }

    // Nova estrutura buscar Metas Participante
    @AuraEnabled
    public static VN_MetaParticipante__c getMetaParticipante(String aIdMember){

        String lAnoFiscal = loadAnoFiscalVigente();
        if(String.isEmpty(lAnoFiscal)) return null;

        List<VN_MetaParticipante__c> lLstMeta = [SELECT Id, V_ScoreSuperacaoQ1__c, V_PotencialCarteira__c, V_ScoreAtingimentoFY__c,
                V_ScoreSuperacaoFY__c, V_ScoreElite__c, V_ScorePotencialCarteira__c, V_UltimoMesAtualizado__c,
                V_TotalMetas1Semestre__c, V_Participante__r.V_NovoContratado__c, V_Ano__c, V_AnoFiscal__r.V_PeriodoAF__c
                FROM VN_MetaParticipante__c 
                WHERE V_Participante__c =: aIdMember 
                AND Name =:lAnoFiscal];

        return lLstMeta.isEmpty() ? null : lLstMeta[0]; 
    }
    
    // @AuraEnabled
    // public static List<Posicao> getRanking(String aIdMember, String aCargo) {

    //  String lAnoFiscal = loadAnoFiscalVigente();
    //  if(String.isEmpty(lAnoFiscal)) return null;

    //  List<String> lLstRanking = new List<String>();

    //  Integer lTotalRanking = aCargo == 'DIRETOR' ? Integer.valueOf(Label.V_RankingDiretor)
    //                          : aCargo == 'LÍDER' ? Integer.valueOf(Label.V_RankingLider)
    //                          : aCargo == 'GERENTE DE CONTAS' ? Integer.valueOf(Label.V_RankingGerenteDeContas)
    //                          : Integer.valueOf(Label.V_RankingCoordenador_GerenteRegional); 

    //  Map<Integer, Integer> lMapRanking = new Map<Integer, Integer>();
    //  for(Integer i = lTotalRanking; i > 0; i--){
    //      lMapRanking.put(i, 0);
    //  }

    //  Integer lTamanhoCarteira = 9999;
    //  for(VN_MetasParticipantes__c metas: [SELECT V_Participante__c, V_ScoreEliteAF__c, V_ScorePotencialCarteira__c, V_Participante__r.V_NovoContratado__c,
    //                                       V_ScoreEliteHoje__c, V_Participante__r.V_Cargo__c, V_ParticRankingElite__c 
    //                                          FROM VN_MetasParticipantes__c
    //                                          WHERE V_Participante__r.V_Cargo__c =: aCargo
    //                                          //AND V_ParticRankingElite__c = true
    //                                          AND Name =: lAnoFiscal]){

    //      if(metas.V_Participante__c == aIdMember){
    //          lTamanhoCarteira = calculateElegivel(Integer.valueOf(metas.V_ScorePotencialCarteira__c), aCargo);
    //      }

    //      if(!metas.V_ParticRankingElite__c || metas.V_Participante__r.V_NovoContratado__c == 'Sim') continue; // incluido 23/11/2018 (pedido do atendimento)

    //      Integer lScore = Integer.valueOf(metas.V_ScoreEliteHoje__c);

    //      Integer lTotalMembers = lMapRanking.get(lScore); 
    //      if(lTotalMembers == null) continue;

    //      lTotalMembers ++;
    //      lMapRanking.put(lScore, lTotalMembers);
    //  }

    //  List<Posicao> lLstPos = new List<Posicao>();
    //  for(Integer lKey: lMapRanking.keySet()){

    //      Integer lTotal = lMapRanking.get(lKey);
    //      if(lTotal == null) continue;

    //      Posicao lPos = new Posicao();
    //      lPos.wScore = lKey;
    //      lPos.wTotalMembers = lTotal;

    //      String lKeyStr = lKey < 10 ? '0'+String.valueOf(lKey) : String.valueOf(lKey);
    //      lPos.wScoreStr = lKeyStr;

    //      lPos.wPosicaoElegivel = lTamanhoCarteira == lKey;

    //      lLstPos.add(lPos);
    //  }
    //  return lLstPos;         
    // }

    @AuraEnabled
    public static List<Posicao> getRankingNovaEstrutura(String aIdMember, String aCargo) {

        String lAnoFiscal = loadAnoFiscalVigente();
        if(String.isEmpty(lAnoFiscal)) return null;

        List<String> lLstRanking = new List<String>();

        Integer lTotalRanking = aCargo == 'DIRETORES' ? Integer.valueOf(Label.V_RankingDiretor)
                                : aCargo == 'LÍDERES' ? Integer.valueOf(Label.V_RankingLider)
                                : aCargo == 'GERENTES DE CONTAS' ? Integer.valueOf(Label.V_RankingGerenteDeContas)
                                : Integer.valueOf(Label.V_RankingCoordenador_GerenteRegional); 

        Map<Integer, Integer> lMapRanking = new Map<Integer, Integer>();
        for(Integer i = lTotalRanking; i > 0; i--){
            lMapRanking.put(i, 0);
        }

        Integer lTamanhoCarteira = 9999;
        for(VN_MetaParticipante__c metas: [SELECT V_Participante__c, V_ScorePotencialCarteira__c, V_Participante__r.V_NovoContratado__c,
                                             V_ScoreElite__c, V_PapelElite__c, V_ParticRankingElite__c
                                                FROM VN_MetaParticipante__c
                                                WHERE V_PapelElite__c =: aCargo
                                                AND (NOT V_Participante__r.Name like '%VAGO_%')
                                                AND (NOT V_Participante__r.Name like '%CARTEIRA_AFASTADO_%') // add 30/10 task #17394
                                                AND V_ParticRankingElite__c = true
                                                AND Name =: lAnoFiscal]){

            if(metas.V_Participante__c == aIdMember){
                lTamanhoCarteira = calculateElegivel(Integer.valueOf(metas.V_ScorePotencialCarteira__c), aCargo);
            }

            if(!metas.V_ParticRankingElite__c || metas.V_Participante__r.V_NovoContratado__c == 'Sim') continue; // incluido 23/11/2018 (pedido do atendimento)

            Integer lScore = Integer.valueOf(metas.V_ScoreElite__c);

            Integer lTotalMembers = lMapRanking.get(lScore); 
            if(lTotalMembers == null) continue;

            lTotalMembers ++;
            lMapRanking.put(lScore, lTotalMembers);
        }

        List<Posicao> lLstPos = new List<Posicao>();
        for(Integer lKey: lMapRanking.keySet()){

            Integer lTotal = lMapRanking.get(lKey);
            if(lTotal == null) continue;

            Posicao lPos = new Posicao();
            lPos.wScore = lKey;
            lPos.wTotalMembers = lTotal;

            String lKeyStr = lKey < 10 ? '0'+String.valueOf(lKey) : String.valueOf(lKey);
            lPos.wScoreStr = lKeyStr;

            lPos.wPosicaoElegivel = lTamanhoCarteira == lKey;

            lLstPos.add(lPos);
        }
        System.debug(lLstPos);
        return lLstPos;         
    } 


    // @AuraEnabled
    // public static String getVagas(String aIdMember, String aCargo) {

    //  String lAnoFiscal = loadAnoFiscalVigente();
    //  if(String.isEmpty(lAnoFiscal)) return null;

    //  Integer lTotalVagas = aCargo == 'DIRETOR' ? Integer.valueOf(Label.V_VagasDiretor)
    //                          : aCargo == 'LÍDER' ? Integer.valueOf(Label.V_VagasLider)
    //                          : aCargo == 'GERENTE DE CONTAS' ? Integer.valueOf(Label.V_VagasGerenteDeContas)
    //                          : Integer.valueOf(Label.V_VagasCordenador_GerenteRegional); 

    //  system.debug('##lTotalVagas ' + lTotalVagas);

    //  List<AggregateResult> lLstAgg = [SELECT COUNT(Id)total FROM VN_MetasParticipantes__c
    //          WHERE V_Participante__r.V_Cargo__c =: aCargo AND Name =: lAnoFiscal AND V_ElegivelAoElite__c = true];

    //  Integer lTotalMembers = !lLstAgg.isEmpty() ? Integer.valueOf(lLstAgg[0].get('total')) : 0;
    //  system.debug('##lTotalMembers ' + lTotalMembers);

    //  Integer lVagas = lTotalMembers >= lTotalVagas ? 0 : (lTotalVagas - lTotalMembers); 

    //  system.debug('##lVagas ' + lVagas);

    //  //return lVagas < 10 ? '0'+String.valueOf(lVagas) : String.valueOf(lVagas);
    //  return lTotalVagas < 10 ? '0'+String.valueOf(lTotalVagas) : String.valueOf(lTotalVagas);
    // }

    @AuraEnabled
    public static String getVagasNovaEstrutura(String aIdMember, String aCargo) {

        String lAnoFiscal = loadAnoFiscalVigente();
        if(String.isEmpty(lAnoFiscal)) return null;

        Integer lTotalVagas = aCargo == 'NÃO ELEGÍVEL' ? 0
                                : aCargo == 'DIRETORES' ? Integer.valueOf(Label.V_VagasDiretor)
                                : aCargo == 'LÍDERES' ? Integer.valueOf(Label.V_VagasLider)
                                : aCargo == 'GERENTES DE CONTAS' ? Integer.valueOf(Label.V_VagasGerenteDeContas)
                                : Integer.valueOf(Label.V_VagasCordenador_GerenteRegional); 

        system.debug('##lTotalVagas ' + lTotalVagas);

        return lTotalVagas < 10 ? '0'+String.valueOf(lTotalVagas) : String.valueOf(lTotalVagas);
    }

    @AuraEnabled
    public static Integer getPosicaoRanking(String aIdMember, String aCargo){

        String lAnoFiscal = loadAnoFiscalVigente();
        if(String.isEmpty(lAnoFiscal)) return null;

    // critério de desempate alterado 06/08/19 - #task 16632
         return Integer.valueOf(SX_HomeCardController.getRanking(aIdMember, aCargo));
        
        // List<VN_MetaParticipante__c> lstMetas = new List<VN_MetaParticipante__c>();
        // lstMetas = [SELECT V_Participante__c, V_Nome__c, V_ScoreElite__c 
        //         FROM VN_MetaParticipante__c 
        //         WHERE Name =: lAnoFiscal 
        //         AND V_Participante__r.V_PapelElite__c =: aCargo
        //         AND V_ParticRankingElite__c = true
        //         ORDER BY V_ScoreElite__c DESC,  V_ScoreSuperacaoFY__c DESC];

        // if(!lstMetas.isEmpty()){
        //     Integer lPosicao = 1;
        //     for(VN_MetaParticipante__c lMeta : lstMetas){
        //         System.debug('*** '+lMeta.V_Participante__c);
        //         if(lMeta.V_Participante__c == aIdMember)
        //             return lPosicao;
        //         lPosicao++; 
        //     }
        // }

        // return 0;
    }

    private static String loadAnoFiscalVigente(){

        List<VN_GerenciadorMetaParticipanteAF__c> lLstGeren = [SELECT V_AnoFiscal__c 
                                                                FROM VN_GerenciadorMetaParticipanteAF__c
                                                                WHERE V_Vigente__c = true];
        return lLstGeren.isEmpty() ? '' : lLstGeren[0].V_AnoFiscal__c;
    }   

    public class Posicao{

        @AuraEnabled public Integer wScore {get; set;}
        @AuraEnabled public String wScoreStr {get; set;}
        @AuraEnabled public Integer wTotalMembers {get; set;}
        @AuraEnabled public Integer wTotalEquipe {get; set;}
        @AuraEnabled public Boolean wPosicaoElegivel {get; set;}
    }

    private static Integer calculateElegivel(Integer lTamanhoCarteira, String aCargo){

        Integer lNumElegivel = 9999;

        //Gerentes de Conta - Carteira 1: Elegibilidade 7
        //Gerentes de Conta - Carteira 2: Elegibilidade 8
        //Gerentes de Conta - Carteira 3: Elegibilidade 9
        //Líder - Carteira 1: Elegibilidade 7 
        //Líder - Carteira 2: Elegibilidade 8
        //Diretor: Elegibilidade 7
        //Coordenador | Gerente Regional VIP: Elegibilidade 7
        if(aCargo == 'GERENTE DE CONTAS'){

            lNumElegivel = lTamanhoCarteira == 1 ? 7
                           : lTamanhoCarteira == 2 ? 8
                           : lTamanhoCarteira == 3 ? 9
                           : 9999;

        }else if(aCargo == 'LÍDER'){

            lNumElegivel = lTamanhoCarteira == 1 ? 7
                           : lTamanhoCarteira == 2 ? 8
                           : 9999;

        } else if(aCargo == 'DIRETOR'){
            lNumElegivel = 7;
        } else {
            lNumElegivel = 7;
        }

        return lNumElegivel;
    }

}