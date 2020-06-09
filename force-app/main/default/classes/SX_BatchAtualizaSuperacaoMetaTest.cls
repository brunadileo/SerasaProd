/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                          date: 02/12/2019
* 
* Name: SX_BatchAtualizaSuperacaoMetaTest.cls
* 
* Classe de teste para SX_BatchAtualizaSuperacaoMetaTest
*******************************************************************************/
@isTest
public with sharing class SX_BatchAtualizaSuperacaoMetaTest {
   @IsTest
    static void atualizarSuperacaoMes12(){

        VN_GerenciadorMetaParticipanteAF__c lGerenciadorMetaParticipanteAF = criarDados();

		Test.startTest();

            for(Integer mesProcessado = 1; mesProcessado < 13; mesProcessado++){
                SX_BatchProcessarCalculos batchProcessarCalculos = new SX_BatchProcessarCalculos(
            	lGerenciadorMetaParticipanteAF.V_AnoFiscal__c, mesProcessado);
                DataBase.executeBatch(batchProcessarCalculos);

                SX_BatchProcessarMecanica batchProcessarMecaninca = new SX_BatchProcessarMecanica(
            	lGerenciadorMetaParticipanteAF.V_AnoFiscal__c, mesProcessado);
                DataBase.executeBatch(batchProcessarMecaninca);
            }
        Test.stopTest();

        System.assertEquals(120, [SELECT Id FROM VN_Sumarizador__c WHERE V_ProcessarCalculos__c = true].size());
        System.assertEquals(10, [SELECT Id FROM VN_MetaParticipante__c WHERE V_UltimoMesAtualizado__c = 'Março'].size());
        System.assertEquals(1, [SELECT V_IDXTrimestrePeriodo__c FROM VN_Sumarizador__c WHERE V_Mes__c = 1 LIMIT 1].V_IDXTrimestrePeriodo__c);
        System.assertEquals(4037061.84, [SELECT V_MetaYTDTrimestre__c FROM VN_Sumarizador__c WHERE V_Mes__c = 1 LIMIT 1].V_MetaYTDTrimestre__c);
        System.assertEquals(4037061.84, [SELECT V_MetaYTDTrimestrePeriodo__c FROM VN_Sumarizador__c WHERE V_Mes__c = 1 LIMIT 1].V_MetaYTDTrimestrePeriodo__c);
        System.assertEquals(4478412.08, [SELECT V_ValorYTDTrimestrePeriodo__c FROM VN_Sumarizador__c WHERE V_Mes__c = 1 LIMIT 1].V_ValorYTDTrimestrePeriodo__c);
        System.assertEquals(110, [SELECT Id FROM VN_Sumarizador__c WHERE V_ReferenciaMesAnterior__c != null].size());
        System.assertEquals(6, [SELECT V_QtdMesesComMetaRes2Semestre__c FROM VN_MetaParticipante__c LIMIT 1].V_QtdMesesComMetaRes2Semestre__c);
        
        SX_BatchAtualizaSuperacaoMeta batchSuperacaoMeta = new SX_BatchAtualizaSuperacaoMeta();
        DataBase.executeBatch(batchSuperacaoMeta);
        
        //Este assert falha pois roda antes do Batch ter finalizado
        //System.assertEquals(10, [SELECT Id FROM VN_MetaParticipante__c WHERE V_SuperacaoQ4__c = true].size());
        //System.assertEquals(10, [SELECT Id FROM VN_MetaParticipante__c WHERE V_SuperacaoH2__c = true].size());
    }

    @IsTest
    static void atualizarSuperacao(){
        criarDados();
        List<VN_MetaParticipante__c> lstMetas = [SELECT V_PercentualAM2Trimestre__c, V_PercentualAM3Trimestre__c,
                V_PercentualAM4Trimestre__c, V_PercentualAM1Semestre__c, V_PercentualAM2Semestre__c FROM VN_MetaParticipante__c];
        for(VN_MetaParticipante__c lMeta : lstMetas){
            lMeta.V_PercentualAM2Trimestre__c = 110; 
            lMeta.V_PercentualAM3Trimestre__c = 110; 
            lMeta.V_PercentualAM4Trimestre__c = 110;
		    lMeta.V_PercentualAM1Semestre__c = 110; 
            lMeta.V_PercentualAM2Semestre__c = 110;
        }
        update lstMetas;

        Test.startTest();
            SX_BatchAtualizaSuperacaoMeta batchSuperacaoMeta = new SX_BatchAtualizaSuperacaoMeta();
            DataBase.executeBatch(batchSuperacaoMeta);
        Test.stopTest();

        System.assertEquals(10, [SELECT Id FROM VN_MetaParticipante__c WHERE V_SuperacaoQ4__c = true].size());
        System.assertEquals(10, [SELECT Id FROM VN_MetaParticipante__c WHERE V_SuperacaoH2__c = true].size());     
    }

    public static void criarSumarizador(VN_Sumarizador__c aSumarizador){
        aSumarizador.V_Valor__c = 4478412.08;
        aSumarizador.V_Meta__c = 4037061.84;
        aSumarizador.V_IDXAnoFiscal__c = 1;
        aSumarizador.V_MetaYTDPeriodo__c = 4037061.84;
        aSumarizador.V_ResultadoSE__c = 970697.95;
    }

    public static void criarSumarizadorZerado(VN_Sumarizador__c aSumarizador){
        aSumarizador.V_Valor__c = 0;
        aSumarizador.V_Meta__c = 0;
        aSumarizador.V_IDXAnoFiscal__c = 0;
        aSumarizador.V_MetaYTDPeriodo__c = 0;
        aSumarizador.V_ResultadoSE__c = 0;
    }
  
    public static VN_GerenciadorMetaParticipanteAF__c criarDados(){
        FieloPLT__Program__c lProgram = SObjectForTest.getProgram('testProgramName');
 		insert lProgram;

 		List<FieloPLT__Member__c> lstMember = SObjectForTest.getMemberList(lProgram.Id);
        lstMember[0].V_RegistroParticipante__c = 'SSK3473';
        insert lstMember;
        
        VN_GerenciadorMetaParticipanteAF__c lGerenciadorMetaParticipanteAF = SObjectForTest.getGerenciadorMetaParticipante();
        insert lGerenciadorMetaParticipanteAF;

		List<VN_MetaParticipante__c> lstMetas = SObjectForTest.getMetasNovaEstruturaLst(lstMember, lGerenciadorMetaParticipanteAF.Id, lGerenciadorMetaParticipanteAF.V_AnoFiscal__c);
        insert lstMetas;
		System.assertEquals(10, lstMetas.size());

		SX_BatchCriarMetas.gerarSumarizador(lstMetas, lGerenciadorMetaParticipanteAF.V_DataInicio__c);
        System.assertEquals(120, [SELECT Id FROM VN_Sumarizador__c].size());

        List<VN_Sumarizador__c> lstSumarizador = new List<VN_Sumarizador__c>();
        for(VN_Sumarizador__c lSumarizador : [SELECT V_Valor__c, V_Meta__c, V_IDXAnoFiscal__c, V_MetaYTDPeriodo__c, V_ResultadoSE__c
                    FROM VN_Sumarizador__c]){
            criarSumarizador(lSumarizador);
            lstSumarizador.add(lSumarizador); 
        }
        if(!lstSumarizador.isEmpty())
            update lstSumarizador;

        System.assertEquals(120, [SELECT Id FROM VN_Sumarizador__c].size());

        return lGerenciadorMetaParticipanteAF;
    }
}