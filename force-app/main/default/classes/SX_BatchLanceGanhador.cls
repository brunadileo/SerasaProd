/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 11/09/2018
* 
* 
* Batch para procassar o Lance Ganhador
*
*******************************************************************************/
global class SX_BatchLanceGanhador implements Database.Batchable<sObject>, Database.Stateful, Schedulable {

	global String fMsgErro;

	global void execute(SchedulableContext sc) {
        Database.executeBatch(this, 150);
    }

	
	global SX_BatchLanceGanhador() {

		if(SX_Utils.batchIsProcessing('SX_BatchLanceGanhador')) return;
		fMsgErro = '';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {

		return Database.getQueryLocator([SELECT Id, V_YoubetProcessado__c, (SELECT Id, V_LanceGanhador__c, 
											FieloPLT__Redemption__c FROM FieloPLT__RedemptionItems__r 
													WHERE FieloPLT__Status__c =: Label.V_StatusOpen
													ORDER BY FieloPLT__Quantity__c DESC LIMIT 1)
										 FROM FieloPLT__Reward__c
										 WHERE V_DataHoraFimYoubet__c <: system.now()
										 AND RecordTypeId =: VN_RecType.getID('FieloPLT__Reward__c', Label.V_RecTypeLeiloes)
										 AND V_YoubetProcessado__c = null]);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {

   		if ( scope == null || scope.isEmpty()) return; 
   		List<FieloPLT__Reward__c> lLstReward = ( List<FieloPLT__Reward__c> ) scope; 

   		List<FieloPLT__RedemptionItem__c> lLstRedItem = new List<FieloPLT__RedemptionItem__c>(); 
   		List<FieloPLT__Redemption__c> lLstRedemption = new List<FieloPLT__Redemption__c>(); 

   		for(FieloPLT__Reward__c rew: lLstReward){

   			rew.V_YoubetProcessado__c = system.now();

   			for(FieloPLT__RedemptionItem__c rdi: rew.FieloPLT__RedemptionItems__r){
   				rdi.V_LanceGanhador__c = true;
   				lLstRedItem.add(rdi);
   				lLstRedemption.add(new FieloPLT__Redemption__c(
   						Id = rdi.FieloPLT__Redemption__c, 
   						FieloPLT__Status__c = 'Closed')
   				);
   			}
   		}

   		Savepoint sp = Database.setSavepoint();

   		try{

   			update lLstReward;
   			FieloPLT.SobjectService.enableAdminPermission(true);
   			update lLstRedItem;
   			FieloPLT.SobjectService.enableAdminPermission(false);
   			update lLstRedemption;

   			List<FieloPLT__Redemption__c> lLstRedmpDesqualificado = [SELECT Id, FieloPLT__Status__c
   				FROM FieloPLT__Redemption__c WHERE FieloPLT__Status__c =: Label.V_StatusOpen 
   				AND Id IN (SELECT FieloPLT__Redemption__c FROM FieloPLT__RedemptionItem__c 
   				WHERE FieloPLT__Reward__c =: lLstReward)];

   			for(FieloPLT__Redemption__c redmp: lLstRedmpDesqualificado){
   				redmp.FieloPLT__Status__c = 'Desqualificado';
   			}
   			update lLstRedmpDesqualificado;

		}catch(Exception e){
			Database.rollBack(sp);
			fMsgErro = String.valueOf(e.getMessage());
			throw e;
		}
	}
	
	global void finish(Database.BatchableContext BC) {

		if(String.isNotEmpty(fMsgErro)){
			insert new VN_LogBatch__c(V_Processo__c = 'Lance Ganhador',
				 V_IdBatch__c = BC.getJobId(), V_ErroResultado__c = fMsgErro.left(32768));
		}
	}	
}