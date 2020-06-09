/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: FM                date: 18/10/2019
*
* 
* Name: SX_BatchAtualizarPercentMetaEquipeTest.cls
* 
* Classe de testes SX_BatchAtualizarPercentualMetaEquipe.cls
*******************************************************************************/
@isTest
public with sharing class SX_BatchAtualizarPercentMetaEquipeTest {

	static testMethod void testFuncional() {

		FieloPLT__Program__c lProgram = SObjectForTest.getProgram('testProgramName');
 		insert lProgram;

        List<FieloPLT__Member__c> lstMember = SObjectForTest.getMemberList(lProgram.Id);
        insert lstMember;

        VN_GerenciadorMetaParticipanteAF__c lGerenciadorMetaParticipanteAF = SObjectForTest.getGerenciadorMetaParticipante();
        insert lGerenciadorMetaParticipanteAF;

        List<VN_MetaParticipante__c> lstMetas = SObjectForTest.getMetasNovaEstruturaLst(lstMember, lGerenciadorMetaParticipanteAF.Id, lGerenciadorMetaParticipanteAF.V_AnoFiscal__c);
        insert lstMetas;

		Set<String> lSetAnoFiscal = new Set<String>();
		lSetAnoFiscal.add(lstMetas[0].Name);

        FieloPLT__Member__c lMember = lstMember[0];
        lMember.V_LiderImediato__c = lstMember[1].Id;
        lMember.V_MetasAnoFiscalVigenteNovo__c = lstMetas[0].Id;
        update lMember;

        Test.startTest();
			Database.executeBatch(new SX_BatchAtualizarPercentualMetaEquipe());
        Test.stopTest();
	}
}