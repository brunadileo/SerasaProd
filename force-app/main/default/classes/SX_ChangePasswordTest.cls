/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                date: 31/10/2018
*
* 
* Name: SX_ChangePasswordTest.cls
* 
* Classe de testes para a classe SX_ChangePassword.cls
*******************************************************************************/
@isTest
public with sharing class SX_ChangePasswordTest {
	static testMethod void SX_ChangePasswordTest() {

		User lUser = SObjectForTest.loadUserLoggedMember();
 		Test.startTest();
 		System.runAs(lUser) {

 			FieloPLT__Member__C lMember1 = SX_ChangePassword.getMember();
 			String lSetPass = SX_ChangePassword.getChangePassword(lUser.Id, 'teste123');

 			try {
            	String lSetPassError = SX_ChangePassword.getChangePassword(lUser.Id, 'sssssssss');
	        } catch (Exception ex) {}
 			
 		}	
 		Test.stopTest();
	}
}