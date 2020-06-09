/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: PV                                            date: 22/09/2019
*
* 
* Name: SX_BatchEmailInicioLeilaoTest.cls
* 
* Classe de testes para a classe SX_BatchEmailInicioLeilao.cls
*******************************************************************************/
@isTest
public with sharing class SX_BatchEmailInicioLeilaoTest {
    
    @isTest
    public static void testBatchEmailInicioLeilao(){
		FieloPLT__Program__c lProgram = SObjectForTest.getProgram('testProgramName');
 		insert lProgram;

 		VN_GerenciadorMetaParticipanteAF__c lGerenciador = SObjectForTest.getGerenciadorMetaParticipante();
 		insert lGerenciador;

        List<FieloPLT__Member__c> lstMember = SObjectForTest.getMemberList(lProgram.Id);
 		insert lstMember;

 	    FieloPLT__Reward__c lReward = SObjectForTest.getReward(lProgram.Id, Label.V_RecTypeLeiloes, 'Elite');
 		lReward.V_DataHoraInicioYoubet__c = System.now().addDays(-1);
        lReward.V_DataHoraFimYoubet__c = System.now().addDays(1);
        lReward.V_PapelYoubet__c = 'GERENTES DE CONTAS';
 		insert lReward;

        lReward.V_YoubetCompleto__c = true;
        update lReward;

 		Test.startTest();
            DataBase.executeBatch(new SX_BatchEmailInicioLeilao());   
        Test.stopTest();   
	}
}