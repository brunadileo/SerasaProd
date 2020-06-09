/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: PT                                                    date: 13/03/2019
* 
* Name: SX_BatchSnapshotMember.cls
* 
* Batch pra criar um snapshot com os dados do member
*******************************************************************************/
global with sharing class SX_BatchSnapshotMember implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT V_Cargo__c FROM FieloPLT__Member__c]);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<FieloPLT__Member__c> lstMeember = (List<FieloPLT__Member__c>) scope;
        for (FieloPLT__Member__c lMember : lstMeember) {
            VN_MetaParticipante__c lMeta = SX_HomeCardController.getMetaScore(lMember.Id);
           lMember.V_MetaScoreEliteAFCongelado__c = lMeta.V_ScoreElite__c; //Score Atual
           lMember.V_MetaScoreEliteAFProjetadoCongelado__c = lMeta.V_ScoreEliteAFProjetado__c; //Score Projetado
           lMember.V_PosicaoRankingCongelado__c = Decimal.valueOf(SX_HomeCardController.getRanking(lMember.Id, lMember.V_Cargo__c)); //Posição no ranking
           SX_HomeCardController.Badge lBadge = SX_HomeCardController.getNumBadges(lMember.Id);
           lMember.V_BadgeEliteCongelado__c = Decimal.valueOf(lBadge.wBadgeElite);
           lMember.V_BadgeYoubetCongelado__c = Decimal.valueOf(lBadge.wBadgeYoubet);
           lMember.V_BadgeEngajamentoCongelado__c = Decimal.valueOf(lBadge.wBadgeEngajamento);
        }
        update lstMeember;
    }
    
    global void finish(Database.BatchableContext BC) {

    }
}