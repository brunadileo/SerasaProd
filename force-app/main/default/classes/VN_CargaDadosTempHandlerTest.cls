/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: PV                                                date: 23/07/2019
* 
* Name: VN_CargaDadosTempHandlerTest.cls
* 
* Classe de teste da VN_CargaDadosTempHandler.cls
*******************************************************************************/
@isTest
public with sharing class VN_CargaDadosTempHandlerTest {
    
    @isTest
    public static void executeTest(){
        // Criar participantes, gerenciador de meta, meta, sumarizador, preencher sumarizador
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

        List<VN_Sumarizador__c> lstSumarizador = new List<VN_Sumarizador__c>();
        lstSumarizador = [SELECT V_ProcessarCalculos__c
                    FROM VN_Sumarizador__c WHERE V_Mes__c = 1];

        for(VN_Sumarizador__c lSumarizador : lstSumarizador) {
            lSumarizador.V_ProcessarCalculos__c = true;          
        }
        update lstSumarizador;

        System.Test.startTest();
        FieloPLT__Member__c lMemberTest1 = lstMember[0];
        FieloPLT__Member__c lMemberTest2 = lstMember[1];

        VN_ResumoCargasDadosTemp__c lResumoCarga = SObjectForTest.getResumoCargaDadosTemp();
        insert lResumoCarga;

        List<VN_CargasDadosTemp__c> lCargaDadosLst = SObjectForTest.getCargaDadosTempList(
                lResumoCarga.Id, lMemberTest1.V_CodigoCarteira__c, lMemberTest2.V_CodigoCarteira__c);
        insert lCargaDadosLst;

        VN_CargasDadosTemp__c lCargaDadosUpdate = lCargaDadosLst[0];
        lCargaDadosUpdate.V_Meta__c = '2';
        update lCargaDadosUpdate;

        System.Test.stopTest();

        System.assertEquals(2, [SELECT Id FROM VN_Sumarizador__c WHERE V_Meta__c != 0].size());

        VN_Sumarizador__c lSumarizador1 = [SELECT V_Meta__c, V_Valor__c, V_ResultadoSE__c FROM VN_Sumarizador__c
                WHERE Participante__c = :lMemberTest1.Id AND V_Mes__c = 1 LIMIT 1];
        System.assertEquals(56, lSumarizador1.V_Meta__c);
        System.assertEquals(110, lSumarizador1.V_Valor__c);
        System.assertEquals(165, lSumarizador1.V_ResultadoSE__c);

        VN_Sumarizador__c lSumarizador2 = [SELECT V_Meta__c, V_Valor__c, V_ResultadoSE__c FROM VN_Sumarizador__c
                WHERE Participante__c = :lMemberTest2.Id AND V_Mes__c = 1 LIMIT 1];
        System.assertEquals(56, lSumarizador2.V_Meta__c);
        System.assertEquals(110, lSumarizador2.V_Valor__c);
        System.assertEquals(165, lSumarizador2.V_ResultadoSE__c);
    }
}