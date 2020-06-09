/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: FM                           date: 18/10/2019
* 
* Name: SX_BatchAtualizarPercentualMetaEquipe.cls
* 
* Batch para criar e metas nos Members
*******************************************************************************/
global class SX_BatchAtualizarPercentualMetaEquipe implements Database.Batchable<sObject>, Database.Stateful, Schedulable {

    global String fSetAnoFiscal;

    global void execute(SchedulableContext sc) {
        Database.executeBatch(this, 30);
    }
    
    global SX_BatchAtualizarPercentualMetaEquipe() {

        if(SX_Utils.batchIsProcessing('SX_BatchAtualizarPercentualMetaEquipe')) return;
        List <VN_GerenciadorMetaParticipanteAF__c> lAnoFiscalVigente = [SELECT V_AnoFiscal__c FROM VN_GerenciadorMetaParticipanteAF__c WHERE V_Vigente__c = true];
        fSetAnoFiscal = lAnoFiscalVigente[0].V_AnoFiscal__c;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {

		return Database.getQueryLocator([SELECT V_LiderImediato__c FROM FieloPLT__Member__c
										WHERE V_LiderImediato__c != null AND V_MetasAnoFiscalVigenteNovo__r.Name =: fSetAnoFiscal]);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {

    	if ( scope == null || scope.isEmpty()) return;
        List<FieloPLT__Member__c> lListMember = ( List<FieloPLT__Member__c> ) scope;
        Set<Id> lSetMember = new Set<Id>();
        for(FieloPLT__Member__c member: lListMember){
            if(!lSetMember.contains(member.V_LiderImediato__c))
                lSetMember.add(member.V_LiderImediato__c);
        }

        List<VN_MetaParticipante__c> lLstMetaToUpdate = new List<VN_MetaParticipante__c>();
        Map<Id, List<VN_MetaParticipante__c>> lMapMemberMeta = new Map<Id, List<VN_MetaParticipante__c>>();


        for(VN_MetaParticipante__c lMeta: [ SELECT Id, V_AMYTD__c, V_PercentialAtingimentoEquipe__c, V_Participante__r.V_LiderImediato__c
                                             FROM VN_MetaParticipante__c WHERE V_Participante__r.V_LiderImediato__c =: lSetMember AND Name =: fSetAnoFiscal]){
            if(!lMapMemberMeta.containsKey(lMeta.V_Participante__r.V_LiderImediato__c))
                lMapMemberMeta.put(lMeta.V_Participante__r.V_LiderImediato__c, new List<VN_MetaParticipante__c>());
            lMapMemberMeta.get(lMeta.V_Participante__r.V_LiderImediato__c).add(lMeta);
        }

        for(Id lMember : lSetMember){
            Decimal amytd = 0;
            Decimal percentualAtingimentoEquipe;
            Decimal tamanhoEquipe;

            if(lMapMemberMeta.containsKey(lMember)){
                List<VN_MetaParticipante__c> lMemberMeta =  lMapMemberMeta.get(lMember);
                tamanhoEquipe = lMemberMeta.size();
                for(VN_MetaParticipante__c meta : lMemberMeta){
                    if(meta.V_AMYTD__c > = 100) amytd ++;
                }

                percentualAtingimentoEquipe = 100 / tamanhoEquipe;
                percentualAtingimentoEquipe = percentualAtingimentoEquipe * amytd;

                for(VN_MetaParticipante__c metaAtualizar: lMemberMeta){
                    metaAtualizar.V_PercentialAtingimentoEquipe__c = percentualAtingimentoEquipe;
                    lLstMetaToUpdate.add(metaAtualizar);
                }

                if (!lLstMetaToUpdate.isEmpty()) update lLstMetaToUpdate;
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}