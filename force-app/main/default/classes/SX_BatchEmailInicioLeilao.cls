/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: PV                                   date: 13/08/2019
* 
* Batch para atualizar campo para disparo de email no inicio do leilao
*
* System.schedule('SX_BatchEmailInicioLeilao - Hora','0 0 * * * ? *', new SX_BatchEmailInicioLeilao());
* System.schedule('SX_BatchEmailInicioLeilao - MeiaHora','0 30 * * * ? *', new SX_BatchEmailInicioLeilao());
*******************************************************************************/
global class SX_BatchEmailInicioLeilao implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
    
    global String fMsgErro;

	global void execute(SchedulableContext sc) {
        Database.executeBatch(this, 150);
    }

	global SX_BatchEmailInicioLeilao() {
		if(SX_Utils.batchIsProcessing('SX_BatchEmailInicioLeilao')) return;
		fMsgErro = '';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([
            SELECT Id, V_EnviaEmailInicioLeilao__c
            FROM VN_ParticipanteComPerfilCompativel__c
            WHERE V_EnviaEmailInicioLeilao__c = false
            AND V_Reward__r.V_IsActive__c = true
            AND V_Reward__r.RecordTypeId =: VN_RecType.getID('FieloPLT__Reward__c', Label.V_RecTypeLeiloes)
            AND V_Reward__r.V_YoubetProcessado__c = null
        ]);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		if(scope == null || scope.isEmpty()) return;

   		List<VN_ParticipanteComPerfilCompativel__c> lPPCompativelLst = (List<VN_ParticipanteComPerfilCompativel__c>)scope;

   		for(VN_ParticipanteComPerfilCompativel__c lPPCompativel : lPPCompativelLst){
            lPPCompativel.V_EnviaEmailInicioLeilao__c = true;
   		}

   		try {
            List<Database.SaveResult> lSaveResultLst = Database.update(lPPCompativelLst, false);
   			
            for(Database.SaveResult lSaveResult : lSaveResultLst) {
                if (!lSaveResult.isSuccess()){
                    for(Database.Error err : lSaveResult.getErrors()) {
                        fMsgErro += ' ' + err.getMessage();
                    }
                }  
            } 
		} catch(Exception e){
			fMsgErro = String.valueOf(e.getMessage());
			throw e;
		}
	}
	
	global void finish(Database.BatchableContext BC) {
		if(String.isNotEmpty(fMsgErro)){
			insert new VN_LogBatch__c(V_Processo__c = 'SX_BatchEmailInicioLeilao',
				 V_IdBatch__c = BC.getJobId(), V_ErroResultado__c = fMsgErro.left(32768));
		}
	}
}