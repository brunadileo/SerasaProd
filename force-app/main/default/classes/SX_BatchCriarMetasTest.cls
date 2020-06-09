/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 22/09/2018
*
* 
* Name: SX_BatchCriarMetasTest.cls
* 
* Classe de testes para a classe SX_BatchCriarMetas.cls
*******************************************************************************/
@isTest 
public with sharing class SX_BatchCriarMetasTest {
	 	
	static testMethod void criarMetas(){
		FieloPLT__Program__c lProgram = SObjectForTest.getProgram('testProgramName');
 		insert lProgram;

 		List<FieloPLT__Member__c> lstMember = SObjectForTest.getMemberList(lProgram.Id);
        insert lstMember;
		System.debug('Participantes: ' + lstMember);

        VN_GerenciadorMetaParticipanteAF__c lGerenciadorMetaParticipanteAF = SObjectForTest.getGerenciadorMetaParticipante();
        lGerenciadorMetaParticipanteAF.V_CriarAnoFiscalParticipantes__c = true;
		insert lGerenciadorMetaParticipanteAF;
		System.debug('Gerenciador: ' + lGerenciadorMetaParticipanteAF);

        /*List<VN_MetaParticipante__c> lstMetaparticipante = SObjectForTest.getMetasNovaEstruturaLst(lstMember, lGerenciadorMetaParticipanteAF.Id, lGerenciadorMetaParticipanteAF.V_AnoFiscal__c);
		insert lstMetaparticipante;
		System.assertEquals(10, lstMetaparticipante.size());
		System.debug('Metas: ' + lstMetaparticipante);*/

     	Map<Id, VN_GerenciadorMetaParticipanteAF__c> fMapGerenciador = new Map<Id, VN_GerenciadorMetaParticipanteAF__c>{
     		lGerenciadorMetaParticipanteAF.Id =>
     		lGerenciadorMetaParticipanteAF};
		System.debug('Map Gerenciador: ' + fMapGerenciador);

        Test.startTest();
			Database.executeBatch(new SX_BatchCriarMetas(fMapGerenciador), 200);
        Test.stopTest();
	}
}