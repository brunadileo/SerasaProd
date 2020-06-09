/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                date: 04/02/2019
*
* 
* Name: SX_Redemption_AfterTest.cls
* 
* Classe de testes para da SX_Redemption_After.cls
*******************************************************************************/

@isTest
public with sharing class SX_Redemption_AfterTest {

	final private static String TEST_UPDATE = 'update';
	final private static String TEST_DELETE = 'delete';

	private static VN_MetaParticipante__c lMeta;
	private static VN_MetaParticipante__c lMeta2;

	static testMethod void testInsert(){

		loadDados(null);

		Map<Id, VN_MetaParticipante__c> lMapMetaResult = new Map<Id, VN_MetaParticipante__c>([SELECT Id, 
        	V_LancesLeiloes__c, V_LeiloesGanhos__c FROM VN_MetaParticipante__c]);

        System.assertEquals(2, lMapMetaResult.get(lMeta.Id).V_LancesLeiloes__c); 
        System.assertEquals(0, lMapMetaResult.get(lMeta2.Id).V_LancesLeiloes__c); 

        //lance ganhador
        System.assertEquals(0, lMapMetaResult.get(lMeta.Id).V_LeiloesGanhos__c); 
        System.assertEquals(0, lMapMetaResult.get(lMeta2.Id).V_LeiloesGanhos__c); 
	}

	static testMethod void testUpdate(){

		loadDados(TEST_UPDATE);

        Map<Id, VN_MetaParticipante__c> lMapMetaResult = new Map<Id, VN_MetaParticipante__c>([SELECT Id, 
        	V_LancesLeiloes__c, V_LeiloesGanhos__c FROM VN_MetaParticipante__c]);

        System.assertEquals(1, lMapMetaResult.get(lMeta.Id).V_LancesLeiloes__c); 
        System.assertEquals(1, lMapMetaResult.get(lMeta2.Id).V_LancesLeiloes__c); 

        //lance ganhador
        System.assertEquals(0, lMapMetaResult.get(lMeta.Id).V_LeiloesGanhos__c); 
        System.assertEquals(1, lMapMetaResult.get(lMeta2.Id).V_LeiloesGanhos__c); 
	}

	static testMethod void testDelete(){

		loadDados(TEST_DELETE);

        Map<Id, VN_MetaParticipante__c> lMapMetaResult = new Map<Id, VN_MetaParticipante__c>([SELECT Id, 
        	V_LancesLeiloes__c, V_LeiloesGanhos__c FROM VN_MetaParticipante__c]);

        System.assertEquals(0, lMapMetaResult.get(lMeta.Id).V_LancesLeiloes__c); 
        System.assertEquals(0, lMapMetaResult.get(lMeta2.Id).V_LancesLeiloes__c); 

        //lance ganhador
        System.assertEquals(0, lMapMetaResult.get(lMeta.Id).V_LeiloesGanhos__c); 
        System.assertEquals(0, lMapMetaResult.get(lMeta2.Id).V_LeiloesGanhos__c); 
	}

	private static void loadDados(String aType){

		FieloPLT__Program__c lProg = SObjectForTest.getProgram('Test');
		insert lProg;

		FieloPLT__Member__c lMember = SObjectForTest.getMember(lProg.Id);
		lMember.FieloPLT__Points__c = 1000000;
		FieloPLT.SobjectService.enableAdminPermission(true);
        insert lMember;
        FieloPLT.SObjectService.enableAdminPermission(false);

		VN_GerenciadorMetaParticipanteAF__c lGerenciador = SObjectForTest.getGerenciadorMetaParticipante();
 		insert lGerenciador;

 		lMeta = SObjectForTest.getMetasNovaEstrutura(lMember.Id, lGerenciador.Id, 'FY19');
 		insert lMeta;

 		lMeta2 = SObjectForTest.getMetasNovaEstrutura(lMember.Id, lGerenciador.Id, 'FY20');
 		insert lMeta2;

 		lMember.V_MetasAnoFiscalVigenteNovo__c = lMeta.Id;
 		update lMember;

		List<FieloPLT__Reward__c> lLstReward = new List<FieloPLT__Reward__c>();
		FieloPLT__Reward__c lRewPerene = SObjectForTest.getReward(lProg.Id, Label.V_RecTypeLeiloes, 'Youbet Perene'); 
		lRewPerene.FieloPLT__Points__c = 1;
		lRewPerene.V_BetcoinsComp__c = 0;
		lLstReward.add(lRewPerene);

		insert lLstReward;

		String lOpen = 'Open';

		List<FieloPLT__Redemption__c> lLstRedemption = new List<FieloPLT__Redemption__c>();
		FieloPLT__Redemption__c lRedmp =  SObjectForTest.getRedemption(lMember.Id);
		lRedmp.FieloPLT__Status__c = lOpen;
		lRedmp.V_MetaParticipante__c = lMeta.Id;
		lLstRedemption.add(lRedmp);
		FieloPLT__Redemption__c lRedemp2 = SObjectForTest.getRedemption(lMember.Id);
		lRedemp2.FieloPLT__Status__c = lOpen;
		lRedemp2.V_MetaParticipante__c = lMeta.Id;
		lLstRedemption.add(lRedemp2);
		insert lLstRedemption;

		List<FieloPLT__RedemptionItem__c> lLstRdi = new List<FieloPLT__RedemptionItem__c>();
		FieloPLT__RedemptionItem__c lRdiPerene =  SObjectForTest.getRedemptionItem(lRewPerene.Id, lRedmp.Id);
		lRdiPerene.FieloPLT__Points__c = 10;
		lLstRdi.add(lRdiPerene);
		FieloPLT__RedemptionItem__c lRdiPerene2 =  SObjectForTest.getRedemptionItem(lRewPerene.Id, lRedemp2.Id);
		lRdiPerene2.FieloPLT__Points__c = 10;
		lLstRdi.add(lRdiPerene2);

		insert lLstRdi;

		Test.startTest();

			lRedmp.FieloPLT__Status__c = SX_Redemption_After.CLOSED; 
			lRedemp2.FieloPLT__Status__c = SX_Redemption_After.CLOSED;

		    update lLstRedemption;

			if(aType == TEST_UPDATE){
				FieloPLT.SobjectService.enableAdminPermission(true);
		        lRedemp2.V_MetaParticipante__c = lMeta2.Id;
		        lRedemp2.V_LanceGanhador__c = true;
		        update lRedemp2;
			}

			if(aType == TEST_DELETE){
				delete lLstRedemption; 
			}
                
        Test.stopTest();
	}
}