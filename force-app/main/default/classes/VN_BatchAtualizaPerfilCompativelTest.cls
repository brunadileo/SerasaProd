/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                          date: 02/12/2019
* 
* Name: VN_BatchAtualizaPerfilCompativelTest.cls
* 
* Classe de teste para VN_BatchAtualizaPerfilCompativel.cls
*******************************************************************************/
@isTest
public without sharing class VN_BatchAtualizaPerfilCompativelTest {

	static testMethod void atualizarPerfilCompativel(){
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
 		lReward.V_DataHoraFimYoubet__c = System.now().addDays(10);
 		lReward.V_YoubetCompleto__c = true;
 		lReward.V_AreaElegivelYoubet__c = 'REGIÕES';
 		lReward.V_LiderancaElegivelYoubet__c = 'REGIÕES';
 		lReward.V_CargoElegivelYoubet__c = 'DIRETOR';
        lReward.V_DataHoraInicioYoubet__c = System.now().addDays(1);
        insert lReward;

        List<VN_ParticipanteComPerfilCompativel__c> lstParticipanteComPerfilCompativel = new List<VN_ParticipanteComPerfilCompativel__c>();
 		lstParticipanteComPerfilCompativel = [SELECT Id FROM VN_ParticipanteComPerfilCompativel__c];
 		System.assertEquals(10, lstParticipanteComPerfilCompativel.size());

        //Dois Participantes não atendem mais o critério para participar do leilão
        lstMember2[0].V_PapelYoubet__c = 'LÍDERES';
        lstMember2[1].FieloPLT__Status__c = 'Inactive';
        update lstMember2;
        Date fData = System.today().addDays(1);
        System.assertEquals(1, [SELECT Id, 
                                        (SELECT V_Reward__r.V_PapelYoubet__c, V_Member__r.FieloPLT__Status__c,
                                        V_Member__r.V_PapelYoubet__c FROM ParticipantesPerfiCompativeis__r)   
                                        FROM FieloPLT__Reward__c 
                                        WHERE V_YoubetCompleto__c = true
                                        AND V_DataInicioYoubet__c =: fData
                                        ].size());

 		Test.startTest();
            Database.executeBatch(new VN_BatchAtualizaPerfilCompativel());

 		Test.stopTest();

        System.assertEquals(8, [SELECT Id FROM VN_ParticipanteComPerfilCompativel__c].size());
	}
}