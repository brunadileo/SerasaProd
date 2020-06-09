/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                date: 31/10/2018
*
* 
* Name: SX_EliteHomeControllerTest.cls
* 
* Classe de testes para a classe SX_EliteHomeController.cls
*******************************************************************************/
@isTest
public with sharing class SX_EliteHomeControllerTest {
	static testMethod void SX_EliteHomeControllerTest() {

		User lUser = SObjectForTest.loadUserLoggedMember();

		String lCargo = 'LÍDER';
		FieloPLT__Member__c lMember = [select Id from FieloPLT__Member__c where FieloPLT__User__c =: lUser.Id limit 1];
		lMember.V_Cargo__c = lCargo;
		lMember.V_PapelElite__c = 'LÍDERES';
		lMember.FieloPLT__Status__c = 'Active';
		lMember.V_NovoContratado__c = 'Não';
		update lMember;

		VN_GerenciadorMetaParticipanteAF__c lGerenciador = SObjectForTest.getGerenciadorMetaParticipante();
 		lGerenciador.V_CriarAnoFiscalParticipantes__c = true;
		insert lGerenciador;

		insert new VN_MetaParticipante__c(
		 				Name = lGerenciador.V_AnoFiscal__c,
		 				V_AnoFiscal__c = lGerenciador.Id,
		 				V_Participante__c = lMember.Id,
						V_ScoreAtingimentoFY__c = 3,
						V_ScoreSuperacaoFY__c = 3,
						V_ScoreSuperacaoQ1__c = 3, 
						V_ScorePotencialCarteira__c = 3);

 		FieloPLT__Program__c lProgram = [select Id, Name from FieloPLT__Program__c limit 1];

 		FieloPLT__Reward__c lReward = SObjectForTest.getReward(lProgram.Id, Label.V_RecTypeLeiloes, 'Elite');
 		lReward.V_YoubetCompleto__c = true;
 		insert lReward;

 		FieloPLT__Badge__c lBadge = SObjectForTest.getBadge(lProgram.Id);
 		insert lBadge;

 		FieloPLT__BadgeMember__c lBadgeMember = SObjectForTest.getBadgeMember(lBadge.id, lMember.Id);
 		insert lBadgeMember;
 		
		FieloPLT__Member__C lMember1 = new FieloPLT__Member__C();
		VN_MetaParticipante__c lMetaParticipante = new VN_MetaParticipante__c();
		Integer lRanking = 0;

		Test.startTest();	
 			System.runAs(lUser) {
 				lMember1 = SX_EliteHomeController.getMember();
				lMetaParticipante = SX_EliteHomeController.getMetaParticipante(lMember.Id);
				lRanking = SX_EliteHomeController.getPosicaoRanking(lMember.Id, lMember.V_PapelElite__c);
				SX_EliteHomeController.getVagasNovaEstrutura(lMember.Id, lCargo);
				SX_EliteHomeController.getRankingNovaEstrutura(lMember.Id, lMember.V_PapelElite__c);

				lMember.V_PapelElite__c = 'GERENTES DE CONTAS';
				update lMember;
				SX_EliteHomeController.getRankingNovaEstrutura(lMember.Id, lMember.V_PapelElite__c);
 			}
		Test.stopTest();
		// System.assertNotEquals(null, lMetaParticipante);
		// System.assertEquals(10, lMetaParticipante.V_ScoreElite__c);
		// System.assertEquals(1, lRanking);
	}
}