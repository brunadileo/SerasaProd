/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                date: 31/10/2018
*
* 
* Name: SX_SpyTeamPerformanceControllerTest.cls
* 
* Classe de testes para a classe SX_SpyTeamPerformanceController.cls
*******************************************************************************/
@isTest
public with sharing class SX_SpyTeamPerformanceControllerTest {
	static testMethod void SX_SpyTeamPerformanceControllerTest() {

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

 			FieloPLT__Member__C lMember1 = SX_SpyTeamPerformanceController.getMember();
 			List<Map<String, String>> lLstBadges = SX_SpyTeamPerformanceController.getBadges();
 			List<Map<String, String>> lLstArea = SX_SpyTeamPerformanceController.getArea(lMember.Id);
   			List<Map<String, String>> lLstSubArea = SX_SpyTeamPerformanceController.getSubArea(lMember.Id);
   			List<SX_SpyTeamPerformanceController.Badge> lLstPos = SX_SpyTeamPerformanceController.getBadgesPerformance(null, null,null, 'test', lMember.id);
   			SX_SpyTeamPerformanceController.Badge lBadge1 = new SX_SpyTeamPerformanceController.Badge();
 		}	
 		Test.stopTest();
	}
}