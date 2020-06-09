/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 24/09/2018
*
* 
* Name: SX_YoubetsPerfomedControllerTest.cls
* 
* Classe de testes para a classe SX_YoubetsPerfomedController.cls
*******************************************************************************/
@isTest
public with sharing class SX_YoubetsPerfomedControllerTest {
	static testMethod void SX_YoubetsPerfomedControllerTest() {

		User lUser = SObjectForTest.loadUserLoggedMember();

		FieloPLT__Member__c lMember = [select Id from FieloPLT__Member__c where FieloPLT__User__c =: lUser.Id limit 1];

 		Test.startTest();
 		System.runAs(lUser) {
 			FieloPLT__Member__C lMember1 = SX_YoubetsPerfomedController.getMember();
 			List<FieloPLT__Reward__c> lLstRew = SX_YoubetsPerfomedController.getYoubets('2018-01-01', '2018-01-01', 'test', 'elite', lMember.Id);
 		}	
 		Test.stopTest();
	}
}