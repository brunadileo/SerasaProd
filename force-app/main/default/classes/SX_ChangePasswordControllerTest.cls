/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 24/09/2018
*
* 
* Name: SX_ChangePasswordControllerTest.cls
* 
* Classe de testes para a classe SX_ChangePasswordController.cls
*******************************************************************************/
@isTest
public with sharing class SX_ChangePasswordControllerTest {
	static testMethod void SX_ChangePasswordControllerTest() {

		User lUser = SObjectForTest.loadUserLoggedMember();

		FieloPLT__Member__c lMember = [select Id from FieloPLT__Member__c where FieloPLT__User__c =: lUser.Id limit 1];
		lMember.V_FirstAccess__c = true;
 		update lMember;	

 		Test.startTest();
 		System.runAs(lUser) {
 			SX_ChangePasswordController lCtrl = new SX_ChangePasswordController();
 			lCtrl.doChangePassword();
 			lCtrl.fFirstAccess = false;
 			lCtrl.doChangePassword();
 			lCtrl.fPassword = 'xx';
 			lCtrl.fConfirmPassword = '123';
 			lCtrl.doChangePassword();
 			lCtrl.fPassword = 'aaaaaaaa';
 			lCtrl.doChangePassword();
 			lCtrl.fConfirmPassword = 'aaaaaaaa';
 			lCtrl.doChangePassword();
 		}
	}
}