/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 24/09/2018
*
* 
* Name: SX_TeamPerformanceControllerTest.cls
* 
* Classe de testes para a classe SX_TeamPerformanceController.cls
*******************************************************************************/
@isTest
public with sharing class SX_TeamPerformanceControllerTest {
	static testMethod void SX_TeamPerformanceControllerTest() {

		User lUser = SObjectForTest.loadUserLoggedMember();

		FieloPLT__Member__c lMember = [select Id from FieloPLT__Member__c where FieloPLT__User__c =: lUser.Id limit 1];

 		Test.startTest();
 		System.runAs(lUser) {
 			FieloPLT__Member__C lMember1 = SX_TeamPerformanceController.getMember();
 			List<Map<String, String>> lLstArea = SX_TeamPerformanceController.getArea(lMember.Id);
 			List<Map<String, String>> lLstSubArea = SX_TeamPerformanceController.getSubArea(lMember.Id);
 			List<Map<String, String>> lLstCargo = SX_TeamPerformanceController.getCargo(lMember.Id);
 			List<FieloPLT__RedemptionItem__c> lLances = SX_TeamPerformanceController.getLances('Test', 'Test', 'Test', 'Test', 'youbet', lMember.Id);
 		}	
 		Test.stopTest();
	}
}