/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                date: 26/10/2018
*
* 
* Name: SX_MetasParticipantes_BeforeTest.cls
* 
* Classe de testes para a classe SX_MetasParticipantes_Before.cls
*******************************************************************************/
@isTest
public with sharing class SX_MetasParticipantes_BeforeTest {

	static testMethod void atualizarPersona() {

		FieloPLT__Program__c lProgram = SObjectForTest.getProgram('testProgramName');
 		insert lProgram;

 		FieloPLT__Member__c lMember = SObjectForTest.getMember(lProgram.Id);
        insert lMember;

        VN_GerenciadorMetaParticipanteAF__c lGerenciadorMetaParticipanteAF = SObjectForTest.getGerenciadorMetaParticipante();
        insert lGerenciadorMetaParticipanteAF;

        VN_MetasParticipantes__c lMeta = SObjectForTest.getMetas(lMember.Id, lGerenciadorMetaParticipanteAF.Id);
    	lMeta.V_ProcessarMecanicasPrimeiroMesAF__c = false;
		lMeta.V_ProcessarMecanicasSegundoMesAF__c = false;
		lMeta.V_ProcessarMecanicasTerceiroMesAF__c = false;
		lMeta.V_ProcessarMecanicasQuartoMesAF__c = false;
		lMeta.V_ProcessarMecanicasQuintoMesAF__c = false;
		lMeta.V_ProcessarMecanicasSextoMesAF__c = false;
		lMeta.V_ProcessarMecanicasSetimoMesAF__c = false;
		lMeta.V_ProcessarMecanicasOitavoMesAF__c = false;
		lMeta.V_ProcessarMecanicasNonoMesAF__c = false;
		lMeta.V_ProcessarMecanicasDecimoMesAF__c = false;
		lMeta.V_ProcessarMecanicasDecimoPrimeiroAF__c = false;
		lMeta.V_ProcessarMecanicasDecimoSegundoAF__c = false;
     	insert lMeta;

        //VN_Resultado__c lRes = SObjectForTest.getResultado(lMeta.Id, lGerenciadorMetaParticipanteAF.Name, lMember.Id);
        //insert lRes;

		Test.startTest();

			lMeta.V_ProcessarMecanicasPrimeiroMesAF__c = true;
			update lMeta;
			lMeta.V_ProcessarMecanicasSegundoMesAF__c = true;
			update lMeta;
			lMeta.V_ProcessarMecanicasTerceiroMesAF__c = true;
			update lMeta;
			lMeta.V_ProcessarMecanicasQuartoMesAF__c = true;
			update lMeta;
			lMeta.V_ProcessarMecanicasQuintoMesAF__c = true;
			update lMeta;
			lMeta.V_ProcessarMecanicasSextoMesAF__c = true;
			update lMeta;
			lMeta.V_ProcessarMecanicasSetimoMesAF__c = true;
			update lMeta;
			lMeta.V_ProcessarMecanicasOitavoMesAF__c = true;
			update lMeta;
			lMeta.V_ProcessarMecanicasNonoMesAF__c = true;
			update lMeta;
			lMeta.V_ProcessarMecanicasDecimoMesAF__c = true;
			update lMeta;
			lMeta.V_ProcessarMecanicasDecimoPrimeiroAF__c = true;
			update lMeta;
			lMeta.V_ProcessarMecanicasDecimoSegundoAF__c = true;
			update lMeta;
            
        Test.stopTest();
	}
}