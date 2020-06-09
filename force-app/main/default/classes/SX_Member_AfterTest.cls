/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                          date: 23/07/2019
* 
* Name: SX_Member_AfterTest.cls
* 
* Classe de teste para SX_Member_After
*******************************************************************************/
@isTest
public with sharing class SX_Member_AfterTest {
    
    @isTest
    static void memberAfter(){

        FieloPLT__Program__c lProgram = SObjectForTest.getProgram('programName'); 
		insert lProgram;

		FieloPLT__Member__c lMember = SObjectForTest.getMember(lProgram.Id);

        VN_GerenciadorMetaParticipanteAF__c lGerenciadorMeta = SObjectForTest.getGerenciadorMetaParticipante();
        lGerenciadorMeta.V_CriarAnoFiscalParticipantes__c = true;
        insert lGerenciadorMeta;
        
        Test.startTest();
            insert lMember;
        Test.stopTest();
        System.assertEquals(1, [SELECT Id FROM VN_MetaParticipante__c WHERE V_Participante__c =: lMember.Id].size());
    }
}