/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 24/09/2018
*
* 
* Name: SX_AgreementControllerTest.cls
* 
* Classe de testes para a classe SX_YoubetBetsController.cls
*******************************************************************************/
@isTest
public with sharing class SX_AgreementControllerTest {
	static testMethod void SX_AgreementControllerTest() {

		User lUser = SObjectForTest.loadUserLoggedMember();

		FieloPLT__Member__c lMember = [select Id from FieloPLT__Member__c where FieloPLT__User__c =: lUser.Id limit 1];
		lMember.V_Setor__c = 'BANCOS E FINANCEIRAS SP';
 		lMember.V_Area__c = 'VERTICAIS';
 		lMember.V_Lideranca__c = 'SERVIÇOS FINANCEIROS';
 		lMember.V_Cargo__c = 'DIRETOR';
 		lMember.FieloPLT__Status__c = Label.V_StatusAtivoMember;
 		update lMember;	

 		FieloPLT__Program__c lProgram = [select Id, Name from FieloPLT__Program__c where Name =: 'programName' limit 1];

 		FieloPLT__Reward__c lReward = SObjectForTest.getReward(lProgram.Id, Label.V_RecTypeLeiloes, 'Elite');
 		lReward.V_YoubetCompleto__c = true;
 		lReward.V_AreaElegivelYoubet__c = 'VERTICAIS';
 		lReward.V_LiderancaElegivelYoubet__c = 'REGIÕES';
 		lReward.V_CargoElegivelYoubet__c = 'DIRETOR';
 		insert lReward;

 		FieloPLT__Agreement__c lAgg = SObjectForTest.getAgreement(lProgram.Id);
 		insert lAgg;

 		Test.startTest();
 		System.runAs(lUser) {
 			FieloPLT__Member__C lMember1 = SX_AgreementController.getMember();
 		}
 		FieloPLT__Reward__c lReward1 = SX_AgreementController.getRewardAgreement(lMember.Id,'youbet');
 		FieloPLT__Agreement__c lAgg1 = SX_AgreementController.getAgreement(lProgram.Id);
 		String lAceite = SX_AgreementController.acceptAgreement(true, lMember.Id);
 	
 		Test.stopTest();
	}
}