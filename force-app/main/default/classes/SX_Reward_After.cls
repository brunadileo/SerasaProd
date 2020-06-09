/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 13/09/2018
* 
* Name: SX_Reward_After.cls
* 
* Classe para disparar ações after em FieloPLT__Reward__c
*******************************************************************************/
public with sharing class SX_Reward_After { 

	public static void criarPerfilCompativel() {

		VN_TriggerCheck.assert();

		Map<Id, FieloPLT__Reward__c> lMapReward = new Map<Id, FieloPLT__Reward__c>();

		Map<Id, String> lMapPapel = new Map<Id, String>(); //add 17/07/19 #16429

		for(FieloPLT__Reward__c rew: (List<FieloPLT__Reward__c>) trigger.new ){ 

			if(VN_TriggerCheck.isChangedTo(rew,  FieloPLT__Reward__c.V_YoubetCompleto__c, true)){

				//add 17/07/19 #16429
				if(rew.V_PapelYoubet__c != null) 
					lMapPapel.put(rew.Id, rew.V_PapelYoubet__c);

				lMapReward.put(rew.Id, rew);
			}
		}
		if(lMapReward.isEmpty()) return;


		List<VN_ParticipanteComPerfilCompativel__c> lLstPerfilCompativel = new List<VN_ParticipanteComPerfilCompativel__c>();
		for(FieloPLT__Member__c member: [SELECT Id, Name, V_PapelYoubet__c, FieloPLT__Points__c, V_BetcoinsComp__c, V_Setor__c, V_Area__c, V_Lideranca__c, V_Cargo__c,
											(SELECT Id, V_Reward__r.Name, V_Reward__r.Iniciativa__c, V_Reward__r.V_DataHoraFimYoubet__c
												FROM V_RewardsCompativeis__r WHERE V_Reward__r.V_IsActive__c = true)
											FROM FieloPLT__Member__c
											WHERE V_PapelYoubet__c =: lMapPapel.values()
											AND FieloPLT__Status__c =: Label.V_StatusAtivoMember]){

			for(FieloPLT__Reward__c rew: lMapReward.values()){

				Boolean lJaTemAtivo = false;
				for( VN_ParticipanteComPerfilCompativel__c lRewComp: member.V_RewardsCompativeis__r){
					if((rew.Iniciativa__c == Label.V_IniciativaPerene && lRewComp.V_Reward__r.Iniciativa__c == Label.V_IniciativaPerene)
						|| (rew.Iniciativa__c == Label.V_IniciativaComplementar && lRewComp.V_Reward__r.Iniciativa__c == Label.V_IniciativaComplementar)){

						if(lRewComp.V_Reward__r.V_DataHoraFimYoubet__c > rew.V_DataHoraInicioYoubet__c)
							lJaTemAtivo = true;
					}
				}
				if(lJaTemAtivo) continue;


				//verifica se valores são compatíveis com do reward
				if(lMapPapel.containsKey(rew.Id) && lMapPapel.get(rew.Id) == member.V_PapelYoubet__c){

					Decimal lSaldoMember = rew.Iniciativa__c == Label.V_IniciativaComplementar ? member.V_BetcoinsComp__c : member.FieloPLT__Points__c;

					lLstPerfilCompativel.add(new VN_ParticipanteComPerfilCompativel__c(
							V_Member__c = member.Id,
							V_Reward__c = rew.Id,
							V_Saldo__c = lSaldoMember,
							V_Area__c = member.V_Area__c,
							V_Lideranca__c = member.V_Lideranca__c,
							V_Cargo__c = member.V_Cargo__c,
							V_Setor__c = member.V_Setor__c.left(255)
						)
					);
				}
			}
		}
		if(!lLstPerfilCompativel.isEmpty()) insert lLstPerfilCompativel;
	}

	public static void atualizarSaldoPerfilCompativel() {

		VN_TriggerCheck.assert();


		Map<Id, FieloPLT__Reward__c> lMapReward = new Map<Id, FieloPLT__Reward__c>();
		for(FieloPLT__Reward__c rew: ((List<FieloPLT__Reward__c>) trigger.new) ){ 

			if(VN_TriggerCheck.isChanged(rew, FieloPLT__Reward__c.V_LanceMinimo__c) && rew.V_YoubetCompleto__c
				&& rew.V_YoubetProcessado__c == null){
				lMapReward.put(rew.id, rew);
			}
		}
		if(lMapReward.isEmpty()) return;

		List<VN_ParticipanteComPerfilCompativel__c> lLstPerfilCompativel = new List<VN_ParticipanteComPerfilCompativel__c>();
		for(VN_ParticipanteComPerfilCompativel__c perfilCompativel: [SELECT Id, V_Reward__c, V_Saldo__c, V_SaldoInsuficiente__c, 
						V_Member__r.FieloPLT__Points__c, V_Member__r.V_BetcoinsComp__c
						FROM VN_ParticipanteComPerfilCompativel__c
						WHERE V_Reward__c =: lMapReward.keySet()]){

			if(!lMapReward.containsKey(perfilCompativel.V_Reward__c)) continue;

			FieloPLT__Reward__c lReward = lMapReward.get(perfilCompativel.V_Reward__c); 
			Decimal lSaldoMember = lReward.Iniciativa__c == Label.V_IniciativaComplementar 
									? perfilCompativel.V_Member__r.V_BetcoinsComp__c 
									: perfilCompativel.V_Member__r.FieloPLT__Points__c;

			perfilCompativel.V_Saldo__c = lSaldoMember;
			perfilCompativel.V_SaldoInsuficiente__c = lReward.V_LanceMinimo__c != null && lReward.V_LanceMinimo__c > lSaldoMember ? true : false;
			
			lLstPerfilCompativel.add(perfilCompativel);
		}
		if(!lLstPerfilCompativel.isEmpty()) update lLstPerfilCompativel;
	}

	public static void excluirPerfilCompativel() {

		VN_TriggerCheck.assert();

		List<VN_ParticipanteComPerfilCompativel__c> lLstPerfilCompativel = new List<VN_ParticipanteComPerfilCompativel__c>();
		for(FieloPLT__Reward__c rew: [SELECT Id, V_YoubetCompleto__c, (SELECT Id FROM ParticipantesPerfiCompativeis__r)
										FROM FieloPLT__Reward__c
										WHERE Id =: (List<FieloPLT__Reward__c>) trigger.new]){ 

			if(VN_TriggerCheck.isChangedTo(rew, FieloPLT__Reward__c.V_YoubetCompleto__c, false)){

				for(VN_ParticipanteComPerfilCompativel__c perfilCompativel: rew.ParticipantesPerfiCompativeis__r){
					lLstPerfilCompativel.add(perfilCompativel);
				}
			}
		}
		if(!lLstPerfilCompativel.isEmpty()) delete lLstPerfilCompativel;
	}

    public static void atualizaFinalizadoPerfilCompativel(){
        VN_TriggerCheck.assert();

		Set<Id> lRewardIdSet = new Set<Id>();
		for(FieloPLT__Reward__c rew : (List<FieloPLT__Reward__c>)Trigger.new ){ 
			if(VN_TriggerCheck.isChanged(rew, FieloPLT__Reward__c.V_NomeVencedor__c)){
				lRewardIdSet.add(rew.id);
			}
		}
		if(lRewardIdSet.isEmpty()) return;

        List<VN_ParticipanteComPerfilCompativel__c> lLstPerfilCompativelToUpdate = new List<VN_ParticipanteComPerfilCompativel__c>();
		for(VN_ParticipanteComPerfilCompativel__c perfilCompativel: [SELECT V_Finalizado__c, V_Reward__r.V_ParticipanteUltimoLance__c, V_Member__c
                FROM VN_ParticipanteComPerfilCompativel__c
                WHERE V_Reward__c =: lRewardIdSet
                AND V_Finalizado__c = false
                ]){
            if(perfilCompativel.V_Reward__r != null && perfilCompativel.V_Member__c != null
                    && perfilCompativel.V_Reward__r.V_ParticipanteUltimoLance__c != null
                    && perfilCompativel.V_Member__c == perfilCompativel.V_Reward__r.V_ParticipanteUltimoLance__c) continue;
            perfilCompativel.V_Finalizado__c = true;
            lLstPerfilCompativelToUpdate.add(perfilCompativel);
        }

        if(!lLstPerfilCompativelToUpdate.isEmpty()) update lLstPerfilCompativelToUpdate;
    }
}