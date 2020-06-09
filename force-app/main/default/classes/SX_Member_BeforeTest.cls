/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 24/09/2018
*
* 
* Name: SX_Member_BeforeTest.cls
* 
* Classe de testes para a classe SX_Member_Before.cls
*******************************************************************************/
@isTest
public with sharing class SX_Member_BeforeTest {
	static testMethod void SX_Member_BeforeTest() {

		FieloPLT__Program__c lProgram = SObjectForTest.getProgram('programName'); 
		insert lProgram;

		//SObjectForTest.setPublicSettings();

		FieloPLT__Member__c lMember = SObjectForTest.getMember(lProgram.Id);
		lMember.FieloPLT__User__c = null;
		

 		Test.startTest();
 		insert lMember;

		Profile lPerfil = SObjectForTest.getProfile('Fielo Partner Community');
                                
        Account lAccount = SObjectForTest.getAccount();
        insert lAccount;
        
        Contact lContact = SObjectForTest.getContact();
        lContact.AccountId = lAccount.Id;
        insert lContact;
        
        User lUser = SObjectForTest.getUser(lPerfil.Id);
        lUser.ContactId = lContact.Id;
        insert lUser;

		lMember.FieloPLT__Email__c = 'teste@teste.com';
		lMember.FieloPLT__User__c = lUser.Id;
 		update lMember;
 		Test.stopTest();
	}
}