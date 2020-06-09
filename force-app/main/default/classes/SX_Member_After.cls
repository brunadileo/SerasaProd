/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 14/09/2018
* 
* Name: SX_Member_After.cls
* 
* Classe para disparar ações after em FieloPLT__Member__c
*******************************************************************************/
public with sharing class SX_Member_After { 

	public static void criarMetas() {

		VN_TriggerCheck.assert();

		List<VN_GerenciadorMetaParticipanteAF__c> lLstGerenciador = [SELECT Id, V_AnoFiscal__c
																	  FROM VN_GerenciadorMetaParticipanteAF__c
																	  WHERE V_Vigente__c = true
																	  AND V_CriarAnoFiscalParticipantes__c = true];
		if(lLstGerenciador.isEmpty()) return;

		Id lIdGerenciador = lLstGerenciador[0].Id;
		String lAnoFiscal = lLstGerenciador[0].V_AnoFiscal__c;

		List<VN_MetaParticipante__c> lLstMetas = new List<VN_MetaParticipante__c>();

		Set<String> lProgramIdSet = new Set<String>();
		for (FieloPLT__Member__c member : (List<FieloPLT__Member__c>) trigger.new) {

			lLstMetas.add(new VN_MetaParticipante__c(
					Name = lAnoFiscal,
					V_AnoFiscal__c = lIdGerenciador,
					V_Participante__c = member.Id
				)
			);
		}
		if(!lLstMetas.isEmpty()) insert lLstMetas;

		SX_BatchCriarMetas.associarMetaNoMember(lLstMetas);
		SX_BatchCriarMetas.gerarSumarizador(lLstMetas, System.now().date());
	} 
}