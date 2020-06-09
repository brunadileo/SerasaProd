/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 15/07/2019
*
* 
* Name: SX_RankingControllerTest.cls
* 
* Classe de testes para a classe SX_RankingController.cls
*******************************************************************************/
@isTest
public with sharing class SX_RankingControllerTest {

    static testMethod void SX_RankingControllerTest() {

		User lUser = SObjectForTest.loadUserLoggedMember();

		FieloPLT__Member__c lMember = [select Id from FieloPLT__Member__c where FieloPLT__User__c =: lUser.Id limit 1];
		lMember.V_Setor__c = 'BANCOS E FINANCEIRAS SP';
 		lMember.V_Area__c = 'VERTICAIS';
 		lMember.V_Lideranca__c = 'SERVIÇOS FINANCEIROS';
 		lMember.V_Cargo__c = 'DIRETOR';
 		lMember.FieloPLT__Status__c = Label.V_StatusAtivoMember;
		lMember.V_PapelElite__c = VN_MemberService.PAPEL_DIRETORES;
		lMember.V_NovoContratado__c = 'Não';
 		update lMember;

		VN_GerenciadorMetaParticipanteAF__c lGerenciador = SObjectForTest.getGerenciadorMetaParticipante();
 		lGerenciador.V_CriarAnoFiscalParticipantes__c = true;
		insert lGerenciador;

		List<VN_MetaParticipante__c> lLstMeta = new List<VN_MetaParticipante__c>{new VN_MetaParticipante__c(
						Name = lGerenciador.V_AnoFiscal__c,
						V_AnoFiscal__c  = lGerenciador.Id,
						V_Participante__c = lMember.Id)};				
		insert lLstMeta;

		SX_BatchCriarMetas.associarMetaNoMember(lLstMeta);

		VN_MetaParticipante__c lMetaParticipante = [SELECT V_UltimoMesAtualizado__c FROM VN_MetaParticipante__c WHERE V_Participante__c =: lMember.Id];
		lMetaParticipante.V_UltimoMesAtualizado__c = 'Julho';
		update lMetaParticipante;
		
 		Test.startTest();
 			System.runAs(lUser) {
 				System.assertEquals(lMember.Id, SX_RankingController.getMember().Id);
 				System.assertNotEquals(null, SX_RankingController.getRanking(lMember.V_PapelElite__c));
 			}
 		Test.stopTest();
	}

}