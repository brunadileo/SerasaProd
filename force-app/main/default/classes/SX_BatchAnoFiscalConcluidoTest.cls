/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 22/09/2018
*
* 
* Name: SX_BatchAnoFiscalConcluidoTest.cls
* 
* Classe de testes para a classe SX_BatchAnoFiscalConcluido.cls
*******************************************************************************/
@isTest
public with sharing class SX_BatchAnoFiscalConcluidoTest {
	static testMethod void anoFiscalConcluido(){
		FieloPLT__Program__c lProgram = SObjectForTest.getProgram('testProgramName');
 		insert lProgram;

 		List<FieloPLT__Member__c> lstMember = SObjectForTest.getMemberList(lProgram.Id);
        insert lstMember;

        VN_GerenciadorMetaParticipanteAF__c lGerenciadorMetaParticipanteAF = SObjectForTest.getGerenciadorMetaParticipante();
        insert lGerenciadorMetaParticipanteAF;

        List<VN_MetaParticipante__c> lstMetasparticipantes = SObjectForTest.getMetasNovaEstruturaLst(new List<FieloPLT__Member__c>{lstMember[0]}, 
            lGerenciadorMetaParticipanteAF.Id, Label.V_AnoFiscal);
     	insert lstMetasparticipantes;

		Test.startTest();
            SX_BatchAnoFiscalConcluido batchAnoFiscalConcluido = new SX_BatchAnoFiscalConcluido(lGerenciadorMetaParticipanteAF.V_AnoFiscal__c);
            DataBase.executeBatch(batchAnoFiscalConcluido);   
        Test.stopTest();
	}
}