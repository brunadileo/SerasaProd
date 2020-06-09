/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 24/09/2018
*
* 
* Name: SX_HomeThemeControllerTest.cls
* 
* Classe de testes para a classe SX_HomeThemeController.cls
*******************************************************************************/
@isTest
public with sharing class SX_HomeThemeControllerTest {
	static testMethod void SX_HomeThemeControllerTest() {

		User lUser = SObjectForTest.loadUserLoggedMember();
		FieloPLT__Member__c lMember = [select Id from FieloPLT__Member__c where FieloPLT__User__c =: lUser.Id limit 1];
		FieloPLT__Program__c lProgram = [select Id, Name from FieloPLT__Program__c limit 1];

 		Test.startTest();
 		System.runAs(lUser) {
 			System.assertNotEquals(null, SX_HomeThemeController.getMember());
 			System.assertNotEquals(null, SX_HomeThemeController.getMembers());
 			System.assertEquals(false, SX_HomeThemeController.isAdmin());
			SX_HomeThemeController.getAgreement(lProgram.Id);
			SX_HomeThemeController.aceitarRegulamento(lMember.Id);
 		}	
 		Test.stopTest();
	}
}