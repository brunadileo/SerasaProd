/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 01/02/2019
* 
* Name: SX_Redemption_Before.cls
* 
* Classe para disparar ações before em FieloPLT__Redemption__c
*
* Ações:
* 1 - associa meta fiscal no resgate
*******************************************************************************/
public with sharing class SX_Redemption_Before {

	public static void execute() {

		VN_TriggerCheck.assert();

		List<FieloPLT__Redemption__c> lTriggerNew = (List<FieloPLT__Redemption__c>) trigger.new;

		Set<Id> lSetMember = new Set<Id>();
		for(FieloPLT__Redemption__c redemption: lTriggerNew){
			lSetMember.add(redemption.FieloPLT__Member__c);
		}

		/*********************  *********************/

		Map<Id, FieloPLT__Member__c> lMapMember = new Map<Id, FieloPLT__Member__c>();
		if(!lSetMember.isEmpty()){
			lMapMember = new Map<Id, FieloPLT__Member__c>([SELECT Id, V_IDAnoFiscalVigente__c FROM FieloPLT__Member__c 
				WHERE Id =:lSetMember AND V_IDAnoFiscalVigente__c != null]);
		}

		/*********************  *********************/

		for(FieloPLT__Redemption__c redemption: lTriggerNew){

			//associa meta fiscal
			if(lMapMember.containsKey(redemption.FieloPLT__Member__c)){
				redemption.V_MetaParticipante__c = lMapMember.get(redemption.FieloPLT__Member__c).V_IDAnoFiscalVigente__c;
			}
		}	
	}
}