/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                          date: 02/12/2019
* 
* Name: VN_BatchAtualizaPerfilCompativel.cls
* 
* Batch para atualizar lista de perfis compatíveis no prêmio
*******************************************************************************/
global without sharing class VN_BatchAtualizaPerfilCompativel implements Database.Batchable<sObject>, Schedulable{
    Date fData;
    global void execute(SchedulableContext sc) {
        Database.executeBatch(this, 5);
    }

    global VN_BatchAtualizaPerfilCompativel() {
        fData = System.today().addDays(1);
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        //Seleciona leilões que começam amanhã
        return Database.getQueryLocator([SELECT Id, V_PapelYoubet__c, Iniciativa__c, 
                                        (SELECT V_Reward__r.V_PapelYoubet__c, V_Member__r.FieloPLT__Status__c,
                                        V_Member__r.V_PapelYoubet__c FROM ParticipantesPerfiCompativeis__r)   
                                        FROM FieloPLT__Reward__c 
                                        WHERE V_YoubetCompleto__c = true
                                        AND V_DataInicioYoubet__c =: fData]);
    }

    global void execute(Database.BatchableContext BC, List<FieloPLT__Reward__c> scope) {
        if ( scope == null || scope.isEmpty()) return;

        Set<String> lSetPapel = new Set<String>();
        Map<Id, Map<Id, VN_ParticipanteComPerfilCompativel__c>> lMapRewardParticipanteCompativel = new Map<Id, Map<Id, VN_ParticipanteComPerfilCompativel__c>>();
        List<FieloPLT__Reward__c> lstReward = new List<FieloPLT__Reward__c>();
        List<VN_ParticipanteComPerfilCompativel__c> lstParticipanteComPerfilCompativelToDelete = new List<VN_ParticipanteComPerfilCompativel__c>();
        List<VN_ParticipanteComPerfilCompativel__c> lstParticipanteComPerfilCompativelToUpsert = new List<VN_ParticipanteComPerfilCompativel__c>();
        
        // Para cada leilão, pega a lista de Participantes com Perfil Compatível e verifica se o Participante está ativo
        // e se o papel do Participante é igual ao papel do Leilão. Se o Participante não é mais elegível, adiciona o 
        // registro ParticipanteComPerfilCompativel numa lista para deletar; caso contrário adiciona num mapa com
        // Id do Leilão e mapa, Id do Member e ParticipanteComPerfilCompativel
        for(FieloPLT__Reward__c lReward : scope){
            if(lReward.V_PapelYoubet__c != null) {
                lSetPapel.add(lReward.V_PapelYoubet__c);
                lstReward.add(lReward);
                Map<Id, VN_ParticipanteComPerfilCompativel__c> lMapParticipanteComPerfilCompativel = new Map<Id, VN_ParticipanteComPerfilCompativel__c>();

                for(VN_ParticipanteComPerfilCompativel__c lParticipantePerfilCompativel : lReward.ParticipantesPerfiCompativeis__r){
                    if(lParticipantePerfilCompativel.V_Member__r.FieloPLT__Status__c != Label.V_StatusAtivoMember
                            || (lParticipantePerfilCompativel.V_Member__r.V_PapelYoubet__c != lParticipantePerfilCompativel.V_Reward__r.V_PapelYoubet__c)){
                        lstParticipanteComPerfilCompativelToDelete.add(lParticipantePerfilCompativel);
                    } else{
                      lMapParticipanteComPerfilCompativel.put(lParticipantePerfilCompativel.V_Member__c, lParticipantePerfilCompativel);  
                    }
                }
                if(!lMapParticipanteComPerfilCompativel.isEmpty())
                    lMapRewardParticipanteCompativel.put(lReward.Id, lMapParticipanteComPerfilCompativel);
            }
        }

        List<FieloPLT__Member__c> lstMember = [SELECT V_BetcoinsComp__c, FieloPLT__Points__c, V_PapelYoubet__c, V_Area__c, V_Lideranca__c, V_Cargo__c, V_Setor__c
                                FROM FieloPLT__Member__c WHERE V_PapelYoubet__c =: lSetPapel AND FieloPLT__Status__c =: Label.V_StatusAtivoMember];

        // Para cada Leilão, pega o mapa de Id de Participante e registro de ParticipanteComPerfilCompatviel,
        //Itera pela lista de Members, verifica se Papel é o mesmo do Leilão, caso sim, adiciona na lista para upsert.
        for(FieloPLT__Reward__c lReward : lstReward){
            
            Map<Id, VN_ParticipanteComPerfilCompativel__c> lMapParticipanteComPerfilCompativel = new Map<Id, VN_ParticipanteComPerfilCompativel__c>();
            
            if(!lMapRewardParticipanteCompativel.isEmpty() && lMapRewardParticipanteCompativel.containsKey(lReward.Id)){
                lMapParticipanteComPerfilCompativel = lMapRewardParticipanteCompativel.get(lReward.Id);
            }
            for(FieloPLT__Member__c lMember : lstMember){
                if(lReward.V_PapelYoubet__c == lMember.V_PapelYoubet__c){
                    Decimal lSaldoMember = lReward.Iniciativa__c == Label.V_IniciativaComplementar ? lMember.V_BetcoinsComp__c : lMember.FieloPLT__Points__c;
                    
                    VN_ParticipanteComPerfilCompativel__c lParticipantePerfilCompativel = new VN_ParticipanteComPerfilCompativel__c(
                        V_Member__c = lMember.Id,
                        V_Reward__c = lReward.Id,
                        V_Saldo__c = lSaldoMember,
                        V_Area__c = lMember.V_Area__c,
                        V_Lideranca__c = lMember.V_Lideranca__c,
                        V_Cargo__c = lMember.V_Cargo__c,
                        V_Setor__c = lMember.V_Setor__c.left(255)
                    );

                    if(lMapParticipanteComPerfilCompativel.containsKey(lMember.Id))
                        lParticipantePerfilCompativel.Id = lMapParticipanteComPerfilCompativel.get(lMember.Id).Id;
                    
                    lstParticipanteComPerfilCompativelToUpsert.add(lParticipantePerfilCompativel);
                }
            }
        }

        if(!lstParticipanteComPerfilCompativelToDelete.isEmpty())
            delete lstParticipanteComPerfilCompativelToDelete;
        
        if(!lstParticipanteComPerfilCompativelToUpsert.isEmpty())
            upsert lstParticipanteComPerfilCompativelToUpsert;
    }

    global void finish(Database.BatchableContext BC){}
}