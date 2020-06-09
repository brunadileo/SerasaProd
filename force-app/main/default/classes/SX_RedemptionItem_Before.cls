/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 13/09/2018
* 
* Name: SX_RedemptionItem_Before.cls
* 
* Classe para disparar ações before em FieloPLT__RedemptionItem__c
*******************************************************************************/
public with sharing class SX_RedemptionItem_Before {
	

	public static void verificarUnicoLanceGanhador() {

		VN_TriggerCheck.assert();

		List<FieloPLT__RedemptionItem__c> lLstRdi = new List<FieloPLT__RedemptionItem__c>();
		Set<Id> lSetReward = new Set<Id>();
		for(FieloPLT__RedemptionItem__c rdi: (List<FieloPLT__RedemptionItem__c>) trigger.new){

			if(VN_TriggerCheck.isChangedTo(rdi, FieloPLT__RedemptionItem__c.V_LanceGanhador__c, true)){

				lSetReward.add(rdi.FieloPLT__Reward__c);
				lLstRdi.add(rdi);
			}
		}
		if(lLstRdi.isEmpty()) return;

		Map<Id, FieloPLT__Reward__c> lMapReward = 
	  		new Map<Id, FieloPLT__Reward__c>([SELECT Id, (SELECT Id FROM FieloPLT__RedemptionItems__r WHERE V_LanceGanhador__c = true AND Id !=: lLstRdi)
		  										FROM FieloPLT__Reward__c
		  										WHERE Id =: lSetReward]);

	  	for(FieloPLT__RedemptionItem__c rdi: lLstRdi){

	  		FieloPLT__Reward__c lReward = lMapReward.get(rdi.FieloPLT__Reward__c);
	  		if(lReward == null) continue;

	  		if(lReward.FieloPLT__RedemptionItems__r.size() > 0){
	  			rdi.addError('Não é possível atualizar o lance ganhador desse Youbet por já haver lance ganhador assinalado. Por favor, verificar.');
	  		}
	  	}
	}
}