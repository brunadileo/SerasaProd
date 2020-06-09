/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                date: 16/09/2019
*
* 
* Name: SX_BatchAtualizarRankingNaMetaTest.cls
* 
* Classe de testes SX_BatchAtualizarRankingNaMeta.cls
*******************************************************************************/
@isTest
public with sharing class SX_BatchAtualizarRankingNaMetaTest {

	static testMethod void testFuncional() {

		FieloPLT__Program__c lProgram = SObjectForTest.getProgram('testProgramName');
 		insert lProgram;

 		FieloPLT__Member__c lMember = SObjectForTest.getMember(lProgram.Id);
        lMember.V_PapelElite__c = 'LÍDERES (COORDENADORES) E GERENTE REGIONAIS';
		lMember.FieloPLT__Status__c =  'Active';
        lMember.V_NovoContratado__c = 'Não';
        insert lMember;

        VN_GerenciadorMetaParticipanteAF__c lGerenciadorMetaParticipanteAF = SObjectForTest.getGerenciadorMetaParticipante();
        insert lGerenciadorMetaParticipanteAF;

        VN_MetaParticipante__c lMeta = SObjectForTest.getMetasNovaEstrutura(lMember.Id, lGerenciadorMetaParticipanteAF.Id, lGerenciadorMetaParticipanteAF.V_AnoFiscal__c);
     	insert lMeta;

		Set<String> lSetAnoFiscal = new Set<String>();
		lSetAnoFiscal.add(lMeta.Name);

        Test.startTest();
			Database.executeBatch(new SX_BatchAtualizarRankingNaMeta(lSetAnoFiscal));
        Test.stopTest();
	}
}