/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                          date: 26/11/2019
* 
* Name: SX_BatchAtualizaSuperacaoMeta.cls
* 
* Batch para atualizar Superação na Meta
*******************************************************************************/
global with sharing class SX_BatchAtualizaSuperacaoMeta implements Database.Batchable<sObject>, Schedulable {
    global VN_MetaParticipante__c fMetaSerasa;
    global Boolean fVerificarTrimestre2;
	global Boolean fVerificarTrimestre3;
	global Boolean fVerificarTrimestre4;
	global Boolean fVerificarSemestre1;
	global Boolean fVerificarSemestre2;

    global void execute(SchedulableContext sc) {
        Database.executeBatch(this, 50);
    }

    global SX_BatchAtualizaSuperacaoMeta() {
        fVerificarTrimestre2 = false;
	    fVerificarTrimestre3 = false;
	    fVerificarTrimestre4 = false;
	    fVerificarSemestre1 = false;
	    fVerificarSemestre2 = false;
        fMetaSerasa = new VN_MetaParticipante__c();
		List<VN_MetaParticipante__c> lstMetaSerasa = new List<VN_MetaParticipante__c>();
		//Busca Meta Principal da Serasa
		lstMetaSerasa = [SELECT Id, V_PercentualAM2Trimestre__c, V_PercentualAM3Trimestre__c, V_PercentualAM4Trimestre__c, 
					V_PercentualAM1Semestre__c, V_PercentualAM2Semestre__c 
                    FROM VN_MetaParticipante__c WHERE V_CodParticipante__c = 'SSK3473' AND V_Vigente__c = true];

		if(!lstMetaSerasa.isEmpty()){
			fMetaSerasa = lstMetaSerasa[0];
            
            if(fMetaSerasa.V_PercentualAM2Trimestre__c > 101)
			    fVerificarTrimestre2 = true;
            if(fMetaSerasa.V_PercentualAM3Trimestre__c > 101)
                fVerificarTrimestre3 = true;
            if(fMetaSerasa.V_PercentualAM4Trimestre__c > 101)
                fVerificarTrimestre4 = true;
            if(fMetaSerasa.V_PercentualAM1Semestre__c > 102)
                fVerificarSemestre1 = true;
            if(fMetaSerasa.V_PercentualAM2Semestre__c > 102)
                fVerificarSemestre2 = true;
            
            if(!(fVerificarTrimestre2 || fVerificarTrimestre3 || fVerificarTrimestre4 
                    || fVerificarSemestre1 || fVerificarSemestre2)){
                fMetaSerasa = new VN_MetaParticipante__c();
            }
        }
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        if(fMetaSerasa == null)
            return null;

        return Database.getQueryLocator([SELECT V_SuperacaoQ2__c, V_PercentualAM2Trimestre__c, V_QtdMesesComMetaRes2Trimestre__c, 
                V_SuperacaoQ3__c, V_PercentualAM3Trimestre__c, V_QtdMesesComMetaRes3Trimestre__c, 
                V_SuperacaoQ4__c, V_PercentualAM4Trimestre__c, V_QtdMesesComMetaRes4Trimestre__c, 
                V_SuperacaoH1__c, V_PercentualAM1Semestre__c, V_QtdMesesComMetaRes1Semestre__c, 
                V_SuperacaoH2__c, V_PercentualAM2Semestre__c, V_QtdMesesComMetaRes2Semestre__c
                FROM VN_MetaParticipante__c WHERE V_Vigente__c = true]);
    }

    global void execute(Database.BatchableContext BC, List<VN_MetaParticipante__c> aLstMetaScope) {

   		if (aLstMetaScope == null || aLstMetaScope.isEmpty()) 
            return;

        List<VN_MetaParticipante__c> lstMetaToUpdate = new List<VN_MetaParticipante__c>();
        for(VN_MetaParticipante__c lMeta : aLstMetaScope){
            Boolean lUpdateMeta = false;
				
            //Se Meta Serasa 2º Trimestre foi superada
            //Se Meta do 2º Trimestre do Participante foi Superada
            // E se o campo V_SuperacaoQ2__c está falso
            if(fVerificarTrimestre2 && !lMeta.V_SuperacaoQ2__c
                    && lMeta.V_PercentualAM2Trimestre__c > 101 && lMeta.V_QtdMesesComMetaRes2Trimestre__c == 3){
                
                lMeta.V_SuperacaoQ2__c = true;
                lUpdateMeta = true;
            }
            
            //Se Meta Serasa 3º Trimestre foi superada
            //Se Meta do 3º Trimestre do Participante foi Superada
            // E se o campo V_SuperacaoQ3__c está falso
            if(fVerificarTrimestre3 && !lMeta.V_SuperacaoQ3__c 
                    && lMeta.V_PercentualAM3Trimestre__c > 101 && lMeta.V_QtdMesesComMetaRes3Trimestre__c == 3){
                lMeta.V_SuperacaoQ3__c = true;
                lUpdateMeta = true;
            }

            //Se Meta Serasa 4º Trimestre foi superada
            //Se Meta do 4º Trimestre do Participante foi Superada
            // E se o campo V_SuperacaoQ4__c está falso
            if(fVerificarTrimestre4 && !lMeta.V_SuperacaoQ4__c 
                    && lMeta.V_PercentualAM4Trimestre__c > 101 && lMeta.V_QtdMesesComMetaRes4Trimestre__c == 3){
                lMeta.V_SuperacaoQ4__c = true;
                lUpdateMeta = true;
            }

            //Se Meta Serasa 1º Semestre foi superada
            //Se Meta do 1º Semestre do Participante foi Superada
            // E se o campo V_SuperacaoH1__c está falso
            if(fVerificarSemestre1 && !lMeta.V_SuperacaoH1__c 
                    && lMeta.V_PercentualAM1Semestre__c > 102 && lMeta.V_QtdMesesComMetaRes1Semestre__c == 6){
                lMeta.V_SuperacaoH1__c = true;
                lUpdateMeta = true;
            }

            //Se Meta Serasa 2º Semestre foi superada
            //Se Meta do 2º Semestre do Participante foi Superada
            // E se o campo V_SuperacaoH2__c está falso
            if(fVerificarSemestre2 && !lMeta.V_SuperacaoH2__c 
                    && lMeta.V_PercentualAM2Semestre__c > 102 && lMeta.V_QtdMesesComMetaRes2Semestre__c == 6){
                lMeta.V_SuperacaoH2__c = true;
                lUpdateMeta = true;
            }

            if(lUpdateMeta)
            	lstMetaToUpdate.add(lMeta);
        }

		if(!lstMetaToUpdate.isEmpty())
		    update lstMetaToUpdate;
    }

    global void finish(Database.BatchableContext BC) {}
}