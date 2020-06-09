/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 22/09/2018
*
* 
* Name: SX_BatchLanceGanhadorTest.cls
* 
* Classe de testes para a classe SX_BatchLanceGanhador.cls
*******************************************************************************/

@isTest
public with sharing class SX_BatchLanceGanhadorTest {
	static testMethod void lanceGanhador(){
		FieloPLT__Program__c lProgram = SObjectForTest.getProgram('testProgramName');
 		insert lProgram;

 		VN_GerenciadorMetaParticipanteAF__c lGerenciador = SObjectForTest.getGerenciadorMetaParticipante();
 		insert lGerenciador;


 		FieloPLT__Reward__c lReward = SObjectForTest.getReward(lProgram.Id, Label.V_RecTypeLeiloes, 'Elite');
 		lReward.V_DataHoraFimYoubet__c = System.now();
 		insert lReward;

 		List<FieloPLT__Member__c> lstMember = SObjectForTest.getMemberList(lProgram.Id);
 		insert lstMember;

 		VN_MetaParticipante__c lMeta = SObjectForTest.getMetasNovaEstrutura(lstMember[0].Id, lGerenciador.Id, Label.V_AnoFiscal);
 		insert lMeta;

 		//List<VN_MetaParticipante__c> lLstMetas = new List<VN_MetaParticipante__c>();
 		//for(FieloPLT__Member__c lMb: lstMember){
 		//	lLstMetas.add(SObjectForTest.getMetas(lMb.Id, lGerenciador.Id));
 		//}
 		//insert lLstMetas;
 		

 		List<FieloPLT__Redemption__c> lstRedemption = SObjectForTest.getRedemptionList(lstMember);
 		insert lstRedemption;

 		List<FieloPLT__RedemptionItem__c> lstRedemptionItem = SObjectForTest.getRedemptionItemList(lReward.Id, lstRedemption);
 		for(FieloPLT__RedemptionItem__c rdi: lstRedemptionItem){
 			rdi.V_MetaParticipante__c = lMeta.Id;
 		}
 		insert lstRedemptionItem;

 		Test.startTest();
            SX_BatchLanceGanhador batchLanceGanhador = new SX_BatchLanceGanhador();
            DataBase.executeBatch(batchLanceGanhador);   
        Test.stopTest();
	}
}