/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 24/09/2018
*
* 
* Name: SX_YoubetBetsControllerTest.cls
* 
* Classe de testes para a classe SX_YoubetBetsController.cls
*******************************************************************************/
@isTest
public with sharing class SX_YoubetBetsControllerTest {
	static testMethod void SX_YoubetBetsControllerTest() {

		User lUser = SObjectForTest.loadUserLoggedMember();

		VN_GerenciadorMetaParticipanteAF__c lGerenciador = SObjectForTest.getGerenciadorMetaParticipante();
 		insert lGerenciador;

 		FieloPLT__Member__c lMember = [select Id from FieloPLT__Member__c where FieloPLT__User__c =: lUser.Id limit 1];

 		VN_MetaParticipante__c lMeta = SObjectForTest.getMetasNovaEstrutura(lMember.Id, lGerenciador.Id, Label.V_AnoFiscal);
 		insert lMeta;

		lMember.V_Setor__c = 'BANCOS E FINANCEIRAS SP';
 		lMember.V_Area__c = 'VERTICAIS';
 		lMember.V_Lideranca__c = 'SERVIÇOS FINANCEIROS';
 		lMember.V_Cargo__c = 'DIRETOR';
 		lMember.FieloPLT__Status__c = Label.V_StatusAtivoMember;
 		lMember.V_MetasAnoFiscalVigenteNovo__c = lMeta.Id;
		FieloPLT.SobjectService.enableAdminPermission(true);
		lMember.V_BetcoinsComp__c = 11;
		lMember.FieloPLT__Points__c = 11;
		update lMember;
		FieloPLT.SobjectService.enableAdminPermission(false);	

 		FieloPLT__Program__c lProgram = [select Id, Name from FieloPLT__Program__c where Name =: 'programName' limit 1];

 		FieloPLT__Reward__c lReward = SObjectForTest.getReward(lProgram.Id, Label.V_RecTypeLeiloes, 'Elite');
 		lReward.V_YoubetCompleto__c = true;
 		lReward.V_AreaElegivelYoubet__c = 'VERTICAIS';
 		lReward.V_LiderancaElegivelYoubet__c = 'REGIÕES';
 		lReward.V_CargoElegivelYoubet__c = 'DIRETOR';
 		insert lReward;

 		Test.startTest();
 		System.runAs(lUser) {
 			FieloPLT__Member__C lMember1 = SX_YoubetBetsContoller.getMember(); 
 			Boolean lPodedarLance = SX_YoubetBetsContoller.podeDarLance(lReward.Id);
 			System.assertNotEquals(lMember1, null);
 		}
 		FieloPLT__Reward__c lReward1 = SX_YoubetBetsContoller.getReward(lMember.Id,'youbet');
 		FieloPLT__Reward__c lReward2 = SX_YoubetBetsContoller.youbetFuturo('test', lReward.Id);
 		System.assertEquals(lReward1, null);

 		lReward.Iniciativa__c = Label.V_IniciativaComplementar;
 		lReward.V_DataHoraFimYoubet__c = System.today().addDays(1);
 		lReward.FieloPLT__ExpirationDate__c = System.today().addDays(1);
 		lReward.FieloPLT__Points__c = 0;
 		lReward.V_BetcoinsComp__c = 1;
 		update lReward;

		FieloPLT__Reward__c lProximoReward = lReward.clone(false, false, false, false);
		lProximoReward.V_DataHoraInicioYoubet__c = System.today().addDays(10);
		lProximoReward.V_DataHoraFimYoubet__c = System.today().addDays(20);
		lProximoReward.Iniciativa__c = Label.V_IniciativaPerene;
		lProximoReward.FieloPLT__Points__c = 1;
 		lProximoReward.V_BetcoinsComp__c = 0;
		insert lProximoReward;

		insert new VN_ParticipanteComPerfilCompativel__c(V_Member__c = lMember.Id,
														V_Reward__c = lReward.Id);

		insert new VN_ParticipanteComPerfilCompativel__c(V_Member__c = lMember.Id,
														V_Reward__c = lProximoReward.Id);												
		

 		
 		lReward1 = SX_YoubetBetsContoller.getReward(lMember.Id,'youbet-extra');

 		//System.assertNotEquals(lReward1, null);

 		lReward1 = null;
 		System.runAs(lUser) {
 			lReward1 = SX_YoubetBetsContoller.proximoLance('youbet-extra',lReward.Id);
 			//System.assertNotEquals(lReward1, null);
 		
 		String lReposta = SX_YoubetBetsContoller.efetuarLance(lMember.Id, lReward.Id, 10);
 		System.assertEquals(Label.V_MsgLanceSucesso, lReposta);

		SX_YoubetBetsContoller.sumAccess(String.valueOf(lReward.Id), String.valueOf(lMember.Id));
		SX_YoubetBetsContoller.proximosPremios('youbet', lReward.Id);
		}

 		Test.stopTest();
	}
}