/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                date: 04/02/2019
*
* 
* Name: SX_Transaction_AfterTest.cls
* 
* Classe de testes para da SX_Transaction_After.cls
*******************************************************************************/

@isTest
public with sharing class SX_Transaction_AfterTest {

	static testMethod void testFuncional(){

		FieloPLT__Program__c lProg = SObjectForTest.getProgram('Test');
		insert lProg;

		FieloPLT__Member__c lMember = SObjectForTest.getMember(lProg.Id);
		insert lMember;

		VN_GerenciadorMetaParticipanteAF__c lGerenciador = SObjectForTest.getGerenciadorMetaParticipante();
		insert lGerenciador;

		VN_MetaParticipante__c lMeta = SObjectForTest.getMetasNovaEstrutura(lMember.Id, lGerenciador.Id, Label.V_AnoFiscal);
		insert lMeta;

		VN_MetaParticipante__c lMeta2 = SObjectForTest.getMetasNovaEstrutura(lMember.Id, lGerenciador.Id, 'FY20');
		insert lMeta2;

		lMember.V_MetasAnoFiscalVigenteNovo__c = lMeta.Id;
		update lMember;

		FieloPLT__Promotion__c lPromotion = SObjectForTest.getPromotion(lProg.Id);
		insert lPromotion;

		FieloPLT__RuleTrigger__c lRuleTrgg = SObjectForTest.getRuleTrigger();
		insert lRuleTrgg;

		FieloPLT__Action__c lAction = SObjectForTest.getAction(lRuleTrgg.Id);
		insert lAction;

		List<FieloPLT__Transaction__c> lLstTransaction = new List<FieloPLT__Transaction__c>();

		FieloPLT__Transaction__c lTrs = SObjectForTest.getTransaction(lMember.Id);
		lTrs.FieloPLT__Action__c = lAction.Id;
			lLstTransaction.add(lTrs);

		FieloPLT__Transaction__c lTrs2 = SObjectForTest.getTransaction(lMember.Id);
		lTrs2.FieloPLT__Action__c = lAction.Id;
		lTrs2.V_BetcoinsComp__c = 5;
		lTrs2.FieloPLT__Points__c = 0;
		lLstTransaction.add(lTrs2);

		FieloPLT__Transaction__c lTrs3 = SObjectForTest.getTransaction(lMember.Id);
		lTrs3.FieloPLT__Type__c = SX_Transaction_After.EXPIRATION;
		lTrs3.V_BetcoinsComp__c = 5;
		lLstTransaction.add(lTrs3);

		FieloPLT__Transaction__c lTrs4 = SObjectForTest.getTransaction(lMember.Id);
		lTrs4.FieloPLT__Type__c = 'Adjustment';
		lLstTransaction.add(lTrs4);

		Test.startTest();
			insert lLstTransaction;     
		Test.stopTest();

		//INSERT
		Map<Id,VN_MetaParticipante__c> lMapMetaResultInsert = new Map<Id,VN_MetaParticipante__c>([SELECT Id, 
			V_TotalBetcoins__c FROM VN_MetaParticipante__c]);

		System.assertEquals(lTrs.FieloPLT__Points__c + lTrs4.FieloPLT__Points__c, lMapMetaResultInsert.get(lMeta.Id).V_TotalBetcoins__c); //perene
		//System.assertEquals(lTrs2.V_BetcoinsComp__c, lMapMetaResultInsert.get(lMeta.Id).V_TotalBetcoinsCompAF__c); //extra
		System.assertEquals(0, lMapMetaResultInsert.get(lMeta2.Id).V_TotalBetcoins__c); //perene meta 2
		//System.assertEquals(0, lMapMetaResultInsert.get(lMeta2.Id).V_TotalBetcoinsCompAF__c); //extra meta 2

		// UPDATE
		lTrs2.V_MetaDoParticipante__c = lMeta2.Id;
		update lTrs2;

		Map<Id,VN_MetaParticipante__c> lMapMetaResultUpdate =  new Map<Id,VN_MetaParticipante__c>([SELECT Id, 
			V_TotalBetcoins__c FROM VN_MetaParticipante__c]);

		System.assertEquals(lTrs.FieloPLT__Points__c + lTrs4.FieloPLT__Points__c, lMapMetaResultUpdate.get(lMeta.Id).V_TotalBetcoins__c); //perene
		//System.assertEquals(0, lMapMetaResultUpdate.get(lMeta.Id).V_TotalBetcoinsCompAF__c); //extra
		System.assertEquals(0, lMapMetaResultUpdate.get(lMeta2.Id).V_TotalBetcoins__c); //perene meta 2
		//System.assertEquals(lTrs2.V_BetcoinsComp__c, lMapMetaResultUpdate.get(lMeta2.Id).V_TotalBetcoinsCompAF__c); //extra meta 2

		//DELETE
		delete lLstTransaction; 

		Map<Id,VN_MetaParticipante__c> lMapMetaResultDelete = new  Map<Id,VN_MetaParticipante__c>([SELECT Id, 
			V_TotalBetcoins__c FROM VN_MetaParticipante__c]);

		System.assertEquals(0, lMapMetaResultDelete.get(lMeta.Id).V_TotalBetcoins__c); //perene
		//System.assertEquals(0, lMapMetaResultDelete.get(lMeta.Id).V_TotalBetcoinsCompAF__c); //extra
		System.assertEquals(0, lMapMetaResultDelete.get(lMeta2.Id).V_TotalBetcoins__c); //perene meta 2
		//System.assertEquals(0, lMapMetaResultDelete.get(lMeta.Id).V_TotalBetcoinsCompAF__c); //extra meta 2
	}
}