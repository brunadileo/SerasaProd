/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 24/09/2018
*
* 
* Name: SX_HomeCardControllerTest.cls
* 
* Classe de testes para a classe SX_HomeCardController.cls
*******************************************************************************/
@isTest
public with sharing class SX_HomeCardControllerTest {
	static testMethod void SX_HomeCardControllerTest() {

		User lUser = SObjectForTest.loadUserLoggedMember();

		FieloPLT__Member__c lMember = [select Id from FieloPLT__Member__c where FieloPLT__User__c =: lUser.Id limit 1];
		lMember.FieloPLT__Status__c = 'Active';
		lMember.V_PapelElite__c = 'LÍDERES';
		update lMember;

 		FieloPLT__Program__c lProgram = [select Id, Name from FieloPLT__Program__c limit 1];

 		FieloPLT__Reward__c lReward = SObjectForTest.getReward(lProgram.Id, Label.V_RecTypeLeiloes, 'Elite');
 		lReward.V_YoubetCompleto__c = true;
 		insert lReward;

 		VN_GerenciadorMetaParticipanteAF__c lGerenciador = SObjectForTest.getGerenciadorMetaParticipante();
 		insert lGerenciador;

 		// VN_MetasParticipantes__c lMeta = SObjectForTest.getMetas(lMember.Id, lGerenciador.Id);
 		// insert lMeta;

		insert new VN_MetaParticipante__c(
		 				Name = lGerenciador.V_AnoFiscal__c,
		 				V_AnoFiscal__c  = lGerenciador.Id,
		 				V_Participante__c = lMember.Id,
						V_ScoreAtingimentoFY__c = 3,
						V_ScoreSuperacaoFY__c = 3,
						V_ScoreSuperacaoQ1__c = 3, 
						V_ScorePotencialCarteira__c = 3);

 		FieloPLT__Badge__c lBadge = SObjectForTest.getBadge(lProgram.Id);
 		insert lBadge;

 		FieloPLT__BadgeMember__c lBadgeMember = SObjectForTest.getBadgeMember(lBadge.id, lMember.Id);
 		insert lBadgeMember;

 		Test.startTest();
 		System.runAs(lUser) {
 			//FieloPLT__Member__C lMember1 = SX_HomeCardController.getMember();
 			VN_MetaParticipante__c lMeta = SX_HomeCardController.getMeta();
 		}

 		String lCargo = 'LÍDERES';
 		FieloPLT__Reward__c lReward1 = SX_HomeCardController.getReward(lMember.Id);
 		List<FieloPLT__Reward__c> lLstRew = SX_HomeCardController.getRewards();
 		VN_MetaParticipante__c lMetaScore1 = SX_HomeCardController.getMetaScore(lMember.Id);
		//VN_MetaParticipante__c lMeta = SX_HomeCardController.getMeta();
 		SX_HomeCardController.Badge lBadges = SX_HomeCardController.getNumBadges(lMember.Id);

 		String lCargo1 = SX_HomeCardController.getRanking(lMember.Id, lCargo);
 		String lVagas = SX_HomeCardController.getVagas(lMember.Id, lCargo);
 		Boolean lAgree =  SX_HomeCardController.getAgreed();

 		Test.stopTest();
		System.debug([SELECT V_ScoreElite__c, V_ParticRankingElite__c
					FROM VN_MetaParticipante__c]);
	//	System.assertEquals('1', lCargo1);
	//	System.assertEquals(10, lMetaScore1.V_ScoreElite__c);
	}
}