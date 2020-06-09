/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: PT                         							date: 21/09/2018
* 
* Name: SX_RewardServices.cls
* 
* Classe que implementa funcões do reward
*******************************************************************************/
public with sharing class SX_RewardServices {
	
	public static FieloPLT__Reward__c getReward(String aMemberId, String aIniciativa) {
		List<VN_ParticipanteComPerfilCompativel__c> lstRewardCompativel = [SELECT V_Reward__c
				FROM VN_ParticipanteComPerfilCompativel__c WHERE V_Member__c =: aMemberId
				AND V_Reward__r.Iniciativa__c =: aIniciativa
				AND (V_Reward__r.V_IsActive__c = true OR V_Reward__r.V_DataHoraInicioYoubet__c >: System.now() )
				 ORDER BY V_Reward__r.V_IsActive__c DESC, 
				V_Reward__r.V_DataHoraFimYoubet__c LIMIT 1];
		if (lstRewardCompativel.isEmpty()) return null;

		List<FieloPLT__Reward__c> lstReward = [SELECT Id, Name, FieloPLT__Points__c, V_BetcoinsComp__c, Iniciativa__c,
				FieloPLT__Image__c, V_LanceResgatarAgora__c, V_LanceMinimo__c, V_DataHoraFimYoubet__c, V_IsActive__c,
			    V_RegulamentoYoubet__c, (SELECT FieloPLT__Quantity__c, FieloPLT__Redemption__r.FieloPLT__Member__r.Name FROM FieloPLT__RedemptionItems__r 
										WHERE FieloPLT__Status__c =: Label.V_StatusOpen
										ORDER BY FieloPLT__Quantity__c DESC LIMIT 1)
				FROM FieloPLT__Reward__c
				WHERE Id =: lstRewardCompativel[0].V_Reward__c];
		if (!lstReward.isEmpty()) {
			return lstReward[0];
		} else {
			return null;
		}
	}
}