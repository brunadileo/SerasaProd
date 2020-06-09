/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                          date: 28/10/2019
* 
* Name: SX_BatchAtualizarSumarizadorTest.cls
* 
* Classe de teste para SX_BatchAtualizarSumarizador.cls
*******************************************************************************/
@isTest
public with sharing class SX_BatchAtualizarSumarizadorTest {
    @IsTest
    static void atualizarSumarizadores(){
        Map<String, VN_Sumarizador__c> lMapSumarizador = new Map<String, VN_Sumarizador__c>();
        FieloPLT__Program__c lProgram = SObjectForTest.getProgram('testProgramName');
 		insert lProgram;

 		List<FieloPLT__Member__c> lstMember = SObjectForTest.getMemberList(lProgram.Id);
        insert lstMember;
        for(FieloPLT__Member__c lMember : lstMember){
            if(lMember.Id != lstMember[0].Id)
                lMember.V_LiderImediato__c = lstMember[0].Id;
        }
        update lstMember;

        VN_GerenciadorMetaParticipanteAF__c lGerenciadorMetaParticipanteAF = SObjectForTest.getGerenciadorMetaParticipante();
        insert lGerenciadorMetaParticipanteAF;

		List<VN_MetaParticipante__c> lstMetas = SObjectForTest.getMetasNovaEstruturaLst(lstMember, lGerenciadorMetaParticipanteAF.Id, lGerenciadorMetaParticipanteAF.V_AnoFiscal__c);
		insert lstMetas;
		System.assertEquals(10, lstMetas.size());

		SX_BatchCriarMetas.gerarSumarizador(lstMetas, lGerenciadorMetaParticipanteAF.V_DataInicio__c);
        List<VN_Sumarizador__c> lstSumarizador = new List<VN_Sumarizador__c>();
        for(VN_Sumarizador__c lSumarizador : [SELECT V_LiderImediato__c, Participante__r.V_LiderImediato__c , V_Valor__c, V_Meta__c, V_Mes__c, V_IDXAnoFiscal__c, V_MetaYTDPeriodo__c, V_ResultadoSE__c
                    FROM VN_Sumarizador__c]){
            criarSumarizador(lSumarizador);
            lMapSumarizador.put(String.valueOf(lSumarizador.V_Meta__c) + String.valueOf(lSumarizador.V_Mes__c), lSumarizador);
            lstSumarizador.add(lSumarizador); 
        }
         for(VN_Sumarizador__c lSumarizador :lstSumarizador){
            if(lMapSumarizador.containsKey(String.valueOf(lSumarizador.V_Meta__c) + String.valueOf(lSumarizador.V_Mes__c - 1))){
                lSumarizador.V_ReferenciaMesAnterior__c = lMapSumarizador.get(String.valueOf(lSumarizador.V_Meta__c) + String.valueOf(lSumarizador.V_Mes__c - 1)).Id;
                if(lSumarizador.V_Mes__c == 1 || lSumarizador.V_Mes__c == 2 || lSumarizador.V_Mes__c == 3){
                    lSumarizador.V_ProcessarCalculos__c = true;
                    lSumarizador.V_LiderImediato__c = lSumarizador.Participante__r.V_LiderImediato__c;
                }
            }
         }
        Test.startTest();
        if(!lstSumarizador.isEmpty())
            update lstSumarizador;
            Database.executeBatch(new SX_BatchAtualizarSumarizador());
        Test.stopTest();
        System.assertEquals(110, [SELECT Id FROM VN_Sumarizador__c WHERE V_ReferenciaMesAnterior__c != null].size());
    }

    public static void criarSumarizador(VN_Sumarizador__c aSumarizador){
        aSumarizador.V_Valor__c = 4478412.08;
        aSumarizador.V_Meta__c = 4037061.84;
        aSumarizador.V_IDXAnoFiscal__c = 1;
        aSumarizador.V_MetaYTDPeriodo__c = 4037061.84;
        aSumarizador.V_ResultadoSE__c = 970697.95;
    }
}