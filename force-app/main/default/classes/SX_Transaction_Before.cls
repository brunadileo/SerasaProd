/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 01/02/2019
* 
* Name: SX_Transaction_Before.cls
* 
* Classe para disparar ações before em FieloPLT__Transaction__c
*
* Ações:
* 1 - associa meta fiscal na transação
*******************************************************************************/
public with sharing class SX_Transaction_Before {

	public static void execute() {

		VN_TriggerCheck.assert();

		List<FieloPLT__Transaction__c> lTriggerNew = (List<FieloPLT__Transaction__c>) trigger.new;

		Set<Id> lSetMember = new Set<Id>();
		for(FieloPLT__Transaction__c trans: lTriggerNew){
			lSetMember.add(trans.FieloPLT__Member__c);
		}

		/*********************  *********************/

		Map<Id, FieloPLT__Member__c> lMapMember = new Map<Id, FieloPLT__Member__c>();
		if(!lSetMember.isEmpty()){
			lMapMember = new Map<Id, FieloPLT__Member__c>([SELECT Id, V_MetasAnoFiscalVigenteNovo__c FROM FieloPLT__Member__c 
				WHERE Id =:lSetMember AND V_MetasAnoFiscalVigenteNovo__c != null]);
		}

		/*********************  *********************/

		for(FieloPLT__Transaction__c trans: lTriggerNew){

			//associa meta fiscal
			if(lMapMember.containsKey(trans.FieloPLT__Member__c)){
				trans.V_MetaDoParticipante__c = lMapMember.get(trans.FieloPLT__Member__c).V_MetasAnoFiscalVigenteNovo__c;
			}
		}	
	}
}