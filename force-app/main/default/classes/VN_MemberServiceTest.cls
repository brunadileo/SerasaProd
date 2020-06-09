/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 22/09/2018
*
* 
* Name: VN_MemberServiceTest.cls
* 
* Classe de testes para a classe VN_MemberService.cls
*******************************************************************************/
@isTest
public with sharing class VN_MemberServiceTest {
	static testMethod void memberServices(){

		User lUser = SObjectForTest.loadUserLoggedMember();

		String lCargo = 'LÍDER';
		FieloPLT__Member__c lMember = [select Id from FieloPLT__Member__c where FieloPLT__User__c =: lUser.Id limit 1];
		lMember.V_PapelElite__c = VN_MemberService.PAPEL_COORDENADOR_GERENTE;
		update lMember;

		Test.startTest();
			System.runAs(lUser) {

				FieloPLT__Member__c lMember1 = VN_MemberService.getAllFieldsLoggedMember();
				VN_MemberService.getQuantidadeVagas(lMember.V_PapelElite__c);
				FieloPLT__Member__c lMember2 = VN_MemberService.loggedMember;
			}	
		Test.stopTest();
 	}
}