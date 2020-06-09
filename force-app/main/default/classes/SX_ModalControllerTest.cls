/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 24/09/2018
*
* 
* Name: SX_ModalControllerTest.cls
* 
* Classe de testes para a classe SX_ModalController.cls
*******************************************************************************/
@isTest
public with sharing class SX_ModalControllerTest {
	static testMethod void SX_ModalControllerTest() {

		User lUser = SObjectForTest.loadUserLoggedMember();

		String lRegistro = 'test';

		FieloPLT__Member__c lMember = [select Id from FieloPLT__Member__c where FieloPLT__User__c =: lUser.Id limit 1];
		lMember.V_RegistroParticipante__c = lRegistro;
		update lMember;

 		Test.startTest();
 		System.runAs(lUser) {
 			String lNickname = SX_ModalController.setNickname1(lRegistro, 'test', 'test');
 			String lFgPass = SX_ModalController.doForgotPassword('test');
 		}	
 		Test.stopTest();
	}
}