/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                date: 31/10/2018
*
* 
* Name: SX_SubComponentControllerTest.cls
* 
* Classe de testes para a classe SX_SubComponentController.cls
*******************************************************************************/
@isTest
public with sharing class SX_SubComponentControllerTest {
	static testMethod void SX_SubComponentControllerTest() {

		User lUser = SObjectForTest.loadUserLoggedMember();

		String lCargo = 'LÍDER';

		FieloPLT__Member__c lMember = [select Id from FieloPLT__Member__c where FieloPLT__User__c =: lUser.Id limit 1];
		lMember.V_Cargo__c = lCargo;
		update lMember;

 		FieloPLT__Program__c lProgram = [select Id, Name from FieloPLT__Program__c limit 1];

 		FieloPLT__Reward__c lReward = SObjectForTest.getReward(lProgram.Id, Label.V_RecTypeLeiloes, 'Elite');
 		lReward.V_YoubetCompleto__c = true;
 		insert lReward;

 		VN_GerenciadorMetaParticipanteAF__c lGerenciador = SObjectForTest.getGerenciadorMetaParticipante();
 		insert lGerenciador;

 		// VN_MetasParticipantes__c lMeta = SObjectForTest.getMetas(lMember.Id, lGerenciador.Id);
 		// lMeta.Name = lGerenciador.V_AnoFiscal__c;
 		// insert lMeta;

 		FieloPLT__Badge__c lBadge = SObjectForTest.getBadge(lProgram.Id);
 		lBadge.FieloPLT__Status__c = 'Active';
 		insert lBadge;

 		FieloPLT__BadgeMember__c lBadgeMember = SObjectForTest.getBadgeMember(lBadge.id, lMember.Id);
 		insert lBadgeMember;

 		Test.startTest();
 		System.runAs(lUser) {

 			FieloPLT__Member__C lMember1 = SX_SubComponentController.getMember();
 			List<FieloPLT__Member__c> lMember2 = SX_SubComponentController.getMembers();
 			String lScore =SX_SubComponentController.getScore(lMember.Id);
 			String lRanking = SX_SubComponentController.getRanking(lMember.Id, lCargo);
 		}	
 		Test.stopTest();
	}
}