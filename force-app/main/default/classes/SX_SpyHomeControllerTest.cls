/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                date: 31/10/2018
*
* 
* Name: SX_SpyHomeControllerTest.cls
* 
* Classe de testes para a classe SX_SpyHomeController.cls
*******************************************************************************/
@isTest
public with sharing class SX_SpyHomeControllerTest {
	static testMethod void SX_SpyHomeControllerTest() {

		User lUser = SObjectForTest.loadUserLoggedMember();

		String lCargo = 'LÍDER';
		String lTipo = 'Engajamento';

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
 		lBadge.V_Classificacao__c = lTipo;
 		lBadge.V_Ordem__c = 1;
 		insert lBadge;

 		FieloPLT__BadgeMember__c lBadgeMember = SObjectForTest.getBadgeMember(lBadge.id, lMember.Id);
 		insert lBadgeMember;

 		Test.startTest();
 		System.runAs(lUser) {

 			FieloPLT__Member__C lMember1 = SX_SpyHomeController.getMember();
 			List<SX_SpyHomeController.Badge> lBadges1 = SX_SpyHomeController.getBadges(lMember.Id, lTipo,'LÍDER');
 			String lMyBadges = SX_SpyHomeController.getMyBadges(lMember.Id, lTipo);
 		}	
 		Test.stopTest();
	}
}