/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                date: 31/10/2018
*
* 
* Name: SX_EliteTeamPerfomanceControllerTest.cls
* 
* Classe de testes para a classe SX_EliteTeamPerfomanceController.cls
*******************************************************************************/
@isTest
public with sharing class SX_EliteTeamPerfomanceControllerTest {
	static testMethod void SX_EliteTeamPerfomanceControllerTest() {

		User lUser = SObjectForTest.loadUserLoggedMember();

		FieloPLT__Member__c lMember = [select Id from FieloPLT__Member__c where FieloPLT__User__c =: lUser.Id limit 1];

		VN_GerenciadorMetaParticipanteAF__c lGerenciador = SObjectForTest.getGerenciadorMetaParticipante();
		insert lGerenciador;

 		Test.startTest();
 		System.runAs(lUser) {
 			FieloPLT__Member__C lMember1 = SX_EliteTeamPerfomanceController.getMember();
 			List<Map<String, String>> lLstArea = SX_EliteTeamPerfomanceController.getArea(lMember.Id);
 			List<Map<String, String>> lLstSubArea = SX_EliteTeamPerfomanceController.getSubArea(lMember.Id);
 			List<Map<String, String>> lLstCargo = SX_EliteTeamPerfomanceController.getCargo(lMember.Id);
 			List<VN_MetaParticipante__c> lMetas = SX_EliteTeamPerfomanceController.getMetas('Test', 'Test', 'Test', lMember.Id, 'Test');
 			List<SX_EliteTeamPerfomanceController.Posicao> lLisPos = SX_EliteTeamPerfomanceController.getRanking('Test', 'Test', 'Test', 'Test', 'Test');
 		}	
 		Test.stopTest();
	}
}