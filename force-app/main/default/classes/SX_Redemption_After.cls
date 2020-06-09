/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 01/02/2019
* 
* Name: SX_Redemption_After.cls
* 
* Classe para disparar ações after em FieloPLT__Redemption__c
*
* Ações:
* 1 - sumarizar total de lances e lance ganhador nas metas
*******************************************************************************/
public with sharing class SX_Redemption_After {

	@TestVisible final static String CLOSED = 'Closed';
	@TestVisible final static String REVERTED = 'Reverted';

	public static void execute() {

		VN_TriggerCheck.assert();

		List<FieloPLT__Redemption__c> lLstTrigger = (List<FieloPLT__Redemption__c>) (trigger.isDelete ? trigger.old : trigger.new);

		Set<Id> lSetMetas = new Set<Id>();
		for(FieloPLT__Redemption__c redemp: lLstTrigger){

			if( VN_TriggerCheck.isChangedTo(redemp, FieloPLT__Redemption__c.FieloPLT__Status__c, CLOSED) 
				|| VN_TriggerCheck.isChangedTo(redemp, FieloPLT__Redemption__c.FieloPLT__Status__c, REVERTED) 
				|| VN_TriggerCheck.isChanged(redemp, FieloPLT__Redemption__c.V_MetaParticipante__c)
				|| VN_TriggerCheck.isChanged(redemp, FieloPLT__Redemption__c.V_LanceGanhador__c)
				|| trigger.isDelete){

				if(redemp.V_MetaParticipante__c != null) lSetMetas.add(redemp.V_MetaParticipante__c);

				// se deixou de ter meta, guarda meta antiga para recálculo
				if(trigger.isUpdate && VN_TriggerCheck.isChanged(redemp, FieloPLT__Redemption__c.V_MetaParticipante__c) 
					&& ((FieloPLT__Redemption__c)trigger.oldMap.get( redemp.id )).V_MetaParticipante__c != null){
					lSetMetas.add(((FieloPLT__Redemption__c)trigger.oldMap.get( redemp.id )).V_MetaParticipante__c);
				}
			}
		}

		// atualiza campos "totais" das metas
		if(!lSetMetas.isEmpty()){

			List<VN_MetaParticipante__c> lLstMeta = [SELECT Id, Name, V_LancesLeiloes__c, V_LeiloesGanhos__c,
				(SELECT Id, V_BetcoinsComp__c, FieloPLT__Points__c, V_LanceGanhador__c 
				FROM Resgates_Lances__r WHERE FieloPLT__Status__c =: CLOSED) FROM VN_MetaParticipante__c WHERE Id =: lSetMetas];

			for(VN_MetaParticipante__c meta: lLstMeta){

				meta.V_LancesLeiloes__c = 0;
				meta.V_LeiloesGanhos__c = 0; 

				for(FieloPLT__Redemption__c redemp: meta.Resgates_Lances__r){

					if(redemp.FieloPLT__Points__c > 0){
						meta.V_LancesLeiloes__c ++;

						if(redemp.V_LanceGanhador__c) meta.V_LeiloesGanhos__c ++;
					} 					
				}
			}
			if(!lLstMeta.isEmpty()) update lLstMeta;
		}
	}
}