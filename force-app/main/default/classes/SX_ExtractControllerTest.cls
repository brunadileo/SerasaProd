/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 24/09/2018
*
* 
* Name: SX_ExtractControllerTest.cls
* 
* Classe de testes para a classe SX_YoubetBetsController.cls
*******************************************************************************/
@isTest
public with sharing class SX_ExtractControllerTest {
	static testMethod void SX_ExtractControllerTest() {

		User lUser = SObjectForTest.loadUserLoggedMember();

		FieloPLT__Member__c lMember = [select Id from FieloPLT__Member__c where FieloPLT__User__c =: lUser.Id limit 1];
		lMember.V_Setor__c = 'BANCOS E FINANCEIRAS SP';
 		lMember.V_Area__c = 'VERTICAIS';
 		lMember.V_Lideranca__c = 'SERVIÇOS FINANCEIROS';
 		lMember.V_Cargo__c = 'DIRETOR';
 		lMember.FieloPLT__Status__c = Label.V_StatusAtivoMember;
 		update lMember;	

 		Test.startTest();
 		System.runAs(lUser) {
 			FieloPLT__Member__c lMember1 = SX_ExtractController.getMember();
 			List<FieloPLT__Point__c>  lLstPoints = SX_ExtractController.getPoints(null, null, 'test', 'youbet', lMember.Id);
 		}
 	
 		Test.stopTest();
	}
}