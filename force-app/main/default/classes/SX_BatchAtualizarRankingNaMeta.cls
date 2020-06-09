/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 09/08/2019
* 
* Name: SX_BatchAtualizarRankingNaMeta.cls
* 
* Batch para atualizar o campo V_PosicaoRankingElite__c na VN_MetaParticipante__c
*******************************************************************************/
global class SX_BatchAtualizarRankingNaMeta implements Database.Batchable<sObject>, Database.Stateful,Schedulable {
    
    global Set<String> fSetAnoFiscal;
    global String DIRETOR = 'DIRETORES'; 
    global String LIDER = 'LÍDERES'; 
    global String GERENTE = 'GERENTES DE CONTAS'; 
    global String COORD_GER_REGIONAL = 'LÍDERES (COORDENADORES) E GERENTE REGIONAIS'; 
    global Integer lPosicaoDiretor;
    global Integer lPosicaoLider;
    global Integer lPosicaoGerente;
    global Integer lPosicaoCoordGerenteReg;
    global Integer lPosicaoRanking;

    global void execute(SchedulableContext sc) {
        Database.executeBatch(this, 200);
    }
    
    global SX_BatchAtualizarRankingNaMeta(Set<String> aSetAnoFiscal) {

        if(SX_Utils.batchIsProcessing('SX_BatchAtualizarRankingNaMeta')) return;
        fSetAnoFiscal = aSetAnoFiscal;
        lPosicaoDiretor = 1;
		lPosicaoLider = 1;
		lPosicaoGerente = 1;
		lPosicaoCoordGerenteReg = 1;
        lPosicaoRanking = 0;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {

        // critério de desempate alterado 06/08/19 - #task 16632
        return Database.getQueryLocator([SELECT Id, V_Participante__r.V_NovoContratado__c, V_PosicaoRankingElite__c,
                                         V_ParticRankingElite__c, V_PapelElite__c
                                        FROM VN_MetaParticipante__c
                                        WHERE  Name =: fSetAnoFiscal
										AND (NOT V_Participante__r.Name like '%VAGO_%') // add 10/10 task #17343
										AND (NOT V_Participante__r.Name like '%CARTEIRA_AFASTADO_%') // add 30/10 task #17394
                                        ORDER BY V_ScoreElite__c DESC, V_PercentualMetaYTD__c DESC, V_TotalVendasYTD__c DESC, V_Participante__r.Name ASC]);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {

		if ( scope == null || scope.isEmpty()) return;
		List<VN_MetaParticipante__c> lLstMetaToUpdate = new List<VN_MetaParticipante__c>();

		for(VN_MetaParticipante__c meta: (List<VN_MetaParticipante__c>) scope){

			if( !meta.V_ParticRankingElite__c || meta.V_Participante__r.V_NovoContratado__c == 'Sim' 
				|| meta.V_PapelElite__c == 'NÃO ELEGÍVEL') {

		        lPosicaoRanking = 0;

			} else {

				if(meta.V_PapelElite__c == DIRETOR){

					lPosicaoRanking = lPosicaoDiretor;
					lPosicaoDiretor ++;

				} else if(meta.V_PapelElite__c == LIDER){

					lPosicaoRanking = lPosicaoLider;
					lPosicaoLider ++;

				} else if(meta.V_PapelElite__c == GERENTE){

					lPosicaoRanking = lPosicaoGerente;
					lPosicaoGerente ++;

				} else if(meta.V_PapelElite__c == COORD_GER_REGIONAL){

					lPosicaoRanking = lPosicaoCoordGerenteReg;
					lPosicaoCoordGerenteReg ++;
				}
			}

			if(lPosicaoRanking != null){
				lLstMetaToUpdate.add(
                    new VN_MetaParticipante__c(
						Id = meta.Id,
						V_PosicaoRankingElite__c = lPosicaoRanking
					)
				);
			}
		}

		if(!lLstMetaToUpdate.isEmpty()) update lLstMetaToUpdate;      
    }
    
    global void finish(Database.BatchableContext BC) {
    }

}