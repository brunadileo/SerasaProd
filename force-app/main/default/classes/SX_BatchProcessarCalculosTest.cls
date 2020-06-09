/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 22/09/2018
*
* 
* Name: SX_BatchProcessarCalculosTest.cls
* 
* Classe de testes para a classe SX_BatchProcessarCalculos.cls
*******************************************************************************/
@isTest
public with sharing class SX_BatchProcessarCalculosTest {
	static testMethod void processarCalculos(){
		FieloPLT__Program__c lProgram = SObjectForTest.getProgram('testProgramName');
 		insert lProgram;

 		List<FieloPLT__Member__c> lstMember = SObjectForTest.getMemberList(lProgram.Id);
        insert lstMember;

		lstMember[1].V_Ponderar__c = 'Sim';
		lstMember[1].V_LiderImediato__c = lstMember[0].Id;
		update lstMember[1];

        VN_GerenciadorMetaParticipanteAF__c lGerenciadorMetaParticipanteAF = SObjectForTest.getGerenciadorMetaParticipante();
        insert lGerenciadorMetaParticipanteAF;

		List<VN_MetaParticipante__c> lstMetas = SObjectForTest.getMetasNovaEstruturaLst(lstMember, lGerenciadorMetaParticipanteAF.Id, lGerenciadorMetaParticipanteAF.V_AnoFiscal__c);
		insert lstMetas;
		System.assertEquals(10, lstMetas.size());

		SX_BatchCriarMetas.gerarSumarizador(lstMetas, lGerenciadorMetaParticipanteAF.V_DataInicio__c);

		Test.startTest();
            SX_BatchProcessarCalculos batchProcessarCalculos = new SX_BatchProcessarCalculos(
            	lGerenciadorMetaParticipanteAF.V_AnoFiscal__c, 5);
            DataBase.executeBatch(batchProcessarCalculos);
        Test.stopTest();

		System.assertEquals(120, [SELECT Id FROM VN_Sumarizador__c].size());
		System.assertEquals(10, [SELECT Id FROM VN_Sumarizador__c WHERE V_ProcessarCalculos__c = true].size());
		System.assertEquals(1, [SELECT Id FROM VN_Sumarizador__c WHERE V_LiderImediato__c != null].size());
		System.assertEquals(10, [SELECT Id FROM FieloPLT__Member__c WHERE V_Ponderar__c = 'Não'].size());
	}
}