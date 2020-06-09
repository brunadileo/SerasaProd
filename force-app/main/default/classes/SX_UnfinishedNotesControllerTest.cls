/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                          date: 15/07/2019
* 
* Name: SX_UnfinishedNotesControllerTest.cls
* 
* Classe de Testes para a classe SX_UnfinishedNotesController.cls
*******************************************************************************/
@isTest public with sharing class SX_UnfinishedNotesControllerTest {

     static testMethod void SX_UnfinishedNotesControllerTest() {

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
 			FieloPLT__Member__c lMember1 = SX_UnfinishedNotesController.getMember();
 			SX_UnfinishedNotesController.getNotasEmAberto(lMember.Id);
 		}
 	
 		Test.stopTest();
	}
}