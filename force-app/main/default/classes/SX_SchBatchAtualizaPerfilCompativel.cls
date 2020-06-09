/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: PT                                                    date: 13/03/2019
* 
* Name: SX_SchBatchAtualizaPerfilCompativel.cls
* 
* Schedule pra atualizar os dados do perfil compatível antes do inicio do Leilão
* 
* System.schedule('Atualiza Perfil Compativel - Meia Hora','0 30 * * * ? *', new SX_SchBatchAtualizaPerfilCompativel());
*******************************************************************************/
global with sharing class SX_SchBatchAtualizaPerfilCompativel implements Database.Batchable<sObject>, System.Schedulable {
    
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new SX_SchBatchAtualizaPerfilCompativel(), 200);
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT V_Saldo__c, V_Reward__r.Iniciativa__c,
                V_Member__r.FieloPLT__Points__c, V_Member__r.V_BetcoinsComp__c
                FROM VN_ParticipanteComPerfilCompativel__c WHERE V_Reward__r.V_DataHoraInicioYoubet__c >: system.now()
                AND V_Reward__r.V_DataHoraInicioYoubet__c <: system.now().addHours(1)]);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<VN_ParticipanteComPerfilCompativel__c> lstPerfilCompativel = (List<VN_ParticipanteComPerfilCompativel__c>) scope;
        for (VN_ParticipanteComPerfilCompativel__c lPerfilCompativel : lstPerfilCompativel) {
            if (lPerfilCompativel.V_Reward__r.Iniciativa__c == Label.V_IniciativaComplementar) {
                lPerfilCompativel.V_Saldo__c = lPerfilCompativel.V_Member__r.V_BetcoinsComp__c;
            } else {
                lPerfilCompativel.V_Saldo__c = lPerfilCompativel.V_Member__r.FieloPLT__Points__c;
            }
        }
        if (!lstPerfilCompativel.isEmpty()) {
            update lstPerfilCompativel;
        }
    }

    global void finish(Database.BatchableContext BC) {
    
    }

}