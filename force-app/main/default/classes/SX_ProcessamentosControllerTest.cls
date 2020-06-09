/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 22/09/2018
*
* 
* Name: SX_ProcessamentosControllerTest.cls
* 
* Classe de testes para a classe SX_ProcessamentosController.cls
*******************************************************************************/
@isTest
public with sharing class SX_ProcessamentosControllerTest {
	
    static testMethod void processarCalculo() {
		FieloPLT__Program__c lProgram = SObjectForTest.getProgram('testProgramName');
 		insert lProgram;

 		List<FieloPLT__Member__c> lstMember = SObjectForTest.getMemberList(lProgram.Id);
        for(FieloPLT__Member__c member: lstMember){
            member.V_Lideranca__c = 'MULTI CANAL';
            member.V_Area__c = 'MULTI CANAL';
            member.V_Setor__c  = 'CONVÊNIO SPC SERASA EXPERIAN';
            member.V_Cargo__c = 'COORDENADOR | GERENTE REGIONAL VIP';
        }
        insert lstMember;

        VN_GerenciadorMetaParticipanteAF__c lGerenciadorMetaParticipanteAF = SObjectForTest.getGerenciadorMetaParticipante();
        insert lGerenciadorMetaParticipanteAF;

        List<VN_MetaParticipante__c> lstMetas = SObjectForTest.getMetasNovaEstruturaLst(lstMember, lGerenciadorMetaParticipanteAF.Id, lGerenciadorMetaParticipanteAF.V_AnoFiscal__c);
		insert lstMetas;
		System.assertEquals(10, lstMetas.size());

		SX_BatchCriarMetas.gerarSumarizador(lstMetas, lGerenciadorMetaParticipanteAF.V_DataInicio__c);

		Test.startTest();
		    ApexPages.PageReference pagina = new PageReference('SX_Processamentos');
            Test.setCurrentPage(pagina); 	

            SX_ProcessamentosController lProcessamentosController = new SX_ProcessamentosController();
            lProcessamentosController.getMesDesejado();

            //lProcessamentosController.processarAnoFiscalConcluido();
            lProcessamentosController.fAnoFiscal = lGerenciadorMetaParticipanteAF.V_AnoFiscal__c;
            lProcessamentosController.fMesCalculos = '5';
            lProcessamentosController.processarCalculos();
  
            //lProcessamentosController.processarLanceGanhador();
        Test.stopTest();

        System.assertEquals(10, [SELECT Id FROM VN_Sumarizador__c WHERE V_ProcessarCalculos__c = true AND V_Mes__c = 5].size());
	}


    static testMethod void processarMecanica() {
		FieloPLT__Program__c lProgram = SObjectForTest.getProgram('testProgramName');
 		insert lProgram;

 		List<FieloPLT__Member__c> lstMember = SObjectForTest.getMemberList(lProgram.Id);
        for(FieloPLT__Member__c member: lstMember){
            member.V_Lideranca__c = 'MULTI CANAL';
            member.V_Area__c = 'MULTI CANAL';
            member.V_Setor__c  = 'CONVÊNIO SPC SERASA EXPERIAN';
            member.V_Cargo__c = 'COORDENADOR | GERENTE REGIONAL VIP';
            member.V_PapelElite__c = 'GERENTES DE CONTAS';
        }
        insert lstMember;

        VN_GerenciadorMetaParticipanteAF__c lGerenciadorMetaParticipanteAF = SObjectForTest.getGerenciadorMetaParticipante();
        insert lGerenciadorMetaParticipanteAF;

        List<VN_MetaParticipante__c> lstMetas = SObjectForTest.getMetasNovaEstruturaLst(lstMember, lGerenciadorMetaParticipanteAF.Id, lGerenciadorMetaParticipanteAF.V_AnoFiscal__c);
		insert lstMetas;
		System.assertEquals(10, lstMetas.size());

        List<VN_Sumarizador__c> lLstSumarizador  = new List<VN_Sumarizador__c>();
        for(VN_MetaParticipante__c meta: lstMetas){
            VN_Sumarizador__c lSumarizador  = new VN_Sumarizador__c();
            lSumarizador.V_MetaDoParticipante__c = meta.Id;
            lSumarizador.Participante__c = meta.V_Participante__c;
            lSumarizador.V_Mes__c = lGerenciadorMetaParticipanteAF.V_DataInicio__c.month();
            lSumarizador.V_ProcessarCalculos__c = true; 
            lLstSumarizador.add(lSumarizador);
        }
        insert lLstSumarizador;     

		Test.startTest();
		    ApexPages.PageReference pagina = new PageReference('SX_Processamentos');
            Test.setCurrentPage(pagina); 	

            SX_ProcessamentosController lProcessamentosController = new SX_ProcessamentosController();
            lProcessamentosController.getMesDesejado();

            lProcessamentosController.fAnoFiscal = lGerenciadorMetaParticipanteAF.V_AnoFiscal__c;

            lProcessamentosController.fMesMecanica = '5';
            lProcessamentosController.processarMecanica();


            lProcessamentosController.processarAnoFiscalConcluido();
            lProcessamentosController.processarLanceGanhador();

        Test.stopTest();
        //System.assertEquals(10, [SELECT Id FROM VN_Sumarizador__c WHERE V_ProcessarMecanicas__c = true].size());
	}

    static testMethod void recalcularRanking() {
		FieloPLT__Program__c lProgram = SObjectForTest.getProgram('testProgramName');
 		insert lProgram;

 		FieloPLT__Member__c lMember = SObjectForTest.getMember(lProgram.Id);
        lMember.V_PapelElite__c = 'LÍDERES (COORDENADORES) E GERENTE REGIONAIS';
        lMember.FieloPLT__Status__c =  'Active';
        lMember.V_NovoContratado__c = 'Não';
        insert lMember;

        VN_GerenciadorMetaParticipanteAF__c lGerenciadorMetaParticipanteAF = SObjectForTest.getGerenciadorMetaParticipante();
        insert lGerenciadorMetaParticipanteAF;

        VN_MetasParticipantes__c lMeta = SObjectForTest.getMetas(lMember.Id, lGerenciadorMetaParticipanteAF.Id);
        insert lMeta;
         
		Test.startTest();
		    ApexPages.PageReference pagina = new PageReference('SX_Processamentos');
            Test.setCurrentPage(pagina); 	
            SX_ProcessamentosController lProcessamentosController = new SX_ProcessamentosController();

            lProcessamentosController.recalcularRanking();

        Test.stopTest();
	}

}