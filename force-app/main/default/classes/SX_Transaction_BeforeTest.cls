/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                date: 04/02/2019
*
* 
* Name: SX_Transaction_BeforeTest.cls
* 
* Classe de testes para da SX_Transaction_Before.cls
*******************************************************************************/

@isTest
public with sharing class SX_Transaction_BeforeTest {

	static testMethod void testFuncional(){

		FieloPLT__Program__c lProg = SObjectForTest.getProgram('Test');
		insert lProg;

		FieloPLT__Member__c lMember = SObjectForTest.getMember(lProg.Id);
		insert lMember;

		VN_GerenciadorMetaParticipanteAF__c lGerenciador = SObjectForTest.getGerenciadorMetaParticipante();
 		insert lGerenciador;

 		VN_MetaParticipante__c lMeta = SObjectForTest.getMetasNovaEstrutura(lMember.Id, lGerenciador.Id, Label.V_AnoFiscal);
 		insert lMeta;

 		VN_MetaParticipante__c lMeta2 = SObjectForTest.getMetasNovaEstrutura(lMember.Id, lGerenciador.Id, Label.V_AnoFiscal);
 		lMeta2.Name = 'FY20';
 		insert lMeta2;

 		lMember.V_MetasAnoFiscalVigenteNovo__c = lMeta.Id;
 		update lMember;

		FieloPLT__Transaction__c lTrs = SObjectForTest.getTransaction(lMember.Id);
   		
		Test.startTest();
            insert lTrs;    
        Test.stopTest();

        FieloPLT__Transaction__c lTransResult = [SELECT Id, V_MetaDoParticipante__c FROM FieloPLT__Transaction__c];

        System.assertEquals(lMeta.Id, lTransResult.V_MetaDoParticipante__c); 
	}
}