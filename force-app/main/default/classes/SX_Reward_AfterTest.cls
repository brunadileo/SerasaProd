/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 22/09/2018
*
* 
* Name: SX_Reward_AfterTest.cls
* 
* Classe de testes para a classe SX_Reward_After.cls
*******************************************************************************/
@isTest
public with sharing class SX_Reward_AfterTest {

	static testMethod void SX_Reward_After(){
		FieloPLT__Program__c lProgram = SObjectForTest.getProgram('programName');
 		insert lProgram;

		List<FieloPLT__Member__c> lstMember = SObjectForTest.getMemberList(lProgram.Id);
		insert lstMember;
		List<FieloPLT__Member__c> lstMember2 = new List<FieloPLT__Member__c>();
 		for(FieloPLT__Member__c lMember: lstMember){
 			lMember.V_Setor__c = 'BANCOS E FINANCEIRAS BR';
 			lMember.V_Area__c = 'REGIÕES';
 			lMember.V_Lideranca__c = 'REGIÕES';
 			lMember.V_Cargo__c = 'DIRETOR';
 			lMember.FieloPLT__Status__c = Label.V_StatusAtivoMember;
 			lstMember2.add(lMember);
 		}
 		update lstMember2;

		FieloPLT__Reward__c lReward = SObjectForTest.getReward(lProgram.Id, Label.V_RecTypeLeiloes, 'Elite');
 		lReward.V_DataHoraFimYoubet__c = System.now();
 		insert lReward;

 		Test.startTest();
 		lReward.V_YoubetCompleto__c = true;
 		lReward.V_AreaElegivelYoubet__c = 'REGIÕES';
 		lReward.V_LiderancaElegivelYoubet__c = 'REGIÕES';
 		lReward.V_CargoElegivelYoubet__c = 'DIRETOR';
 		lReward.V_YoubetProcessado__c = System.now();
 		update lReward;

 		List<VN_ParticipanteComPerfilCompativel__c> lstParticipanteComPerfilCompativel = new List<VN_ParticipanteComPerfilCompativel__c>();
 		lstParticipanteComPerfilCompativel = [select Id from VN_ParticipanteComPerfilCompativel__c];
 		System.assertEquals(lstParticipanteComPerfilCompativel.size(),10);

 		lReward.V_YoubetCompleto__c = false;
 		update lReward;

 		lstParticipanteComPerfilCompativel = [select Id from VN_ParticipanteComPerfilCompativel__c];
 		System.assertEquals(lstParticipanteComPerfilCompativel.size(),0);

 		Test.stopTest();
	}

	static testMethod void atualizarSaldoPerfilCompativel(){

		FieloPLT__Program__c lProgram = SObjectForTest.getProgram('programName');
 		insert lProgram;

		List<FieloPLT__Member__c> lstMember = SObjectForTest.getMemberList(lProgram.Id);
		insert lstMember;
		List<FieloPLT__Member__c> lstMember2 = new List<FieloPLT__Member__c>();

		FieloPLT.SobjectService.enableAdminPermission(true);
 		for(FieloPLT__Member__c lMember: lstMember){
 			lMember.V_Setor__c = 'BANCOS E FINANCEIRAS BR';
 			lMember.V_Area__c = 'REGIÕES';
 			lMember.V_Lideranca__c = 'REGIÕES';
 			lMember.V_Cargo__c = 'DIRETOR';
 			lMember.FieloPLT__Status__c = Label.V_StatusAtivoMember;
 			lMember.V_BetcoinsComp__c = 10;
 			lstMember2.add(lMember);
 		}
 		update lstMember2;
 		FieloPLT.SobjectService.enableAdminPermission(false);

		FieloPLT__Reward__c lReward = SObjectForTest.getReward(lProgram.Id, Label.V_RecTypeLeiloes, Label.V_IniciativaComplementar);
 		lReward.V_DataHoraFimYoubet__c = System.now().addDays(5);
 		lReward.V_AreaElegivelYoubet__c = 'REGIÕES';
 		lReward.V_LiderancaElegivelYoubet__c = 'REGIÕES';
 		lReward.V_CargoElegivelYoubet__c = 'DIRETOR';
 		lReward.V_YoubetCompleto__c = true;
 		lReward.V_LanceMinimo__c = 20;
 		lReward.V_YoubetProcessado__c = null;
		lReward.FieloPLT__Points__c = 0;
		lReward.V_BetcoinsComp__c = 1;
		
 		insert lReward;


	 	lReward.V_LanceMinimo__c = 10;
	 	update lReward;

	}

    static testMethod void atualizaFinalizadoPerfilCompativel(){

		FieloPLT__Program__c lProgram = SObjectForTest.getProgram('programName');
 		insert lProgram;

		List<FieloPLT__Member__c> lstMember = SObjectForTest.getMemberList(lProgram.Id);
		insert lstMember;
		List<FieloPLT__Member__c> lstMember2 = new List<FieloPLT__Member__c>();

		FieloPLT.SobjectService.enableAdminPermission(true);
 		for(FieloPLT__Member__c lMember: lstMember){
 			lMember.V_Setor__c = 'BANCOS E FINANCEIRAS BR';
 			lMember.V_Area__c = 'REGIÕES';
 			lMember.V_Lideranca__c = 'REGIÕES';
 			lMember.V_Cargo__c = 'DIRETOR';
 			lMember.FieloPLT__Status__c = Label.V_StatusAtivoMember;
 			lMember.V_BetcoinsComp__c = 10;
 			lstMember2.add(lMember);
 		}
 		update lstMember2;
 		FieloPLT.SobjectService.enableAdminPermission(false);

		FieloPLT__Reward__c lReward = SObjectForTest.getReward(lProgram.Id, Label.V_RecTypeLeiloes, Label.V_IniciativaComplementar);
 		lReward.V_DataHoraFimYoubet__c = System.now().addDays(5);
 		lReward.V_AreaElegivelYoubet__c = 'REGIÕES';
 		lReward.V_LiderancaElegivelYoubet__c = 'REGIÕES';
 		lReward.V_CargoElegivelYoubet__c = 'DIRETOR';
 		lReward.V_YoubetCompleto__c = true;
 		lReward.V_LanceMinimo__c = 20;
 		lReward.V_YoubetProcessado__c = null;
		lReward.FieloPLT__Points__c = 0;
		lReward.V_BetcoinsComp__c = 1;
		
 		insert lReward;


	 	lReward.V_NomeVencedor__c = 'NOME VENCEDOR';
	 	update lReward;

	}
}