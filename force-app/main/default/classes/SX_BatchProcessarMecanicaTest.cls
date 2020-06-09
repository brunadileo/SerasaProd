/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 22/09/2018
*
* 
* Name: SX_BatchProcessarMecanicaTest.cls
* 
* Classe de testes para a classe SX_BatchProcessarMecanica.cls
*******************************************************************************/
@isTest
public with sharing class SX_BatchProcessarMecanicaTest {
	
	static testMethod void processarMecanica(){
		FieloPLT__Program__c lProgram = SObjectForTest.getProgram('testProgramName');
 		insert lProgram;

 		List<FieloPLT__Member__c> lstMember = SObjectForTest.getMemberList(lProgram.Id);
        insert lstMember;

        VN_GerenciadorMetaParticipanteAF__c lGerenciadorMetaParticipanteAF = SObjectForTest.getGerenciadorMetaParticipante();
        insert lGerenciadorMetaParticipanteAF;

		List<VN_MetaParticipante__c> lstMetas = SObjectForTest.getMetasNovaEstruturaLst(lstMember, lGerenciadorMetaParticipanteAF.Id, lGerenciadorMetaParticipanteAF.V_AnoFiscal__c);
		insert lstMetas;
		System.assertEquals(10, lstMetas.size());

		SX_BatchCriarMetas.gerarSumarizador(lstMetas, lGerenciadorMetaParticipanteAF.V_DataInicio__c);

        // List<VN_MetasParticipantes__c> lstMetasparticipantes = SObjectForTest.getMetasList(
        // 	new List<FieloPLT__Member__c>{lstMember[0]}, lGerenciadorMetaParticipanteAF.Id);
     	// insert lstMetasparticipantes;

		Test.startTest();

			SX_BatchProcessarCalculos batchProcessarCalculos = new SX_BatchProcessarCalculos(
            	lGerenciadorMetaParticipanteAF.V_AnoFiscal__c, 5);
            DataBase.executeBatch(batchProcessarCalculos);

            SX_BatchProcessarMecanica batchProcessarMecaninca = new SX_BatchProcessarMecanica(
            	lGerenciadorMetaParticipanteAF.V_AnoFiscal__c, 5);
            DataBase.executeBatch(batchProcessarMecaninca);   
        Test.stopTest();

		System.assertEquals(120, [SELECT Id FROM VN_Sumarizador__c].size());
		System.assertEquals(10, [SELECT Id FROM VN_Sumarizador__c WHERE V_ProcessarMecanicas__c = true].size());
	}
}