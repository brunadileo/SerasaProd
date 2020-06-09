/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 14/09/2018
* 
* Name: SX_GerenciadorMetaParticipanteAF_After.cls
* 
* Classe manipuladora da trigger after de VN_GerenciadorMetaParticipanteAF__c
*******************************************************************************/
public with sharing class SX_GerenciadorMetaParticipanteAF_After {

	public static void criarMetas() {
		
		VN_TriggerCheck.assert();

		Map<Id, VN_GerenciadorMetaParticipanteAF__c> lMapGerenciador = new Map<Id, VN_GerenciadorMetaParticipanteAF__c>();
	  	for (VN_GerenciadorMetaParticipanteAF__c gerenciador : (List<VN_GerenciadorMetaParticipanteAF__c>) trigger.new) {

	  		if(VN_TriggerCheck.isChangedTo(gerenciador, VN_GerenciadorMetaParticipanteAF__c.V_CriarAnoFiscalParticipantes__c, true)){
	  			lMapGerenciador.put(gerenciador.Id, gerenciador);
	  		}
	  	}
	  	if(lMapGerenciador.isEmpty()) return;

	  	Database.executeBatch(new SX_BatchCriarMetas(lMapGerenciador), 200);
	}
}