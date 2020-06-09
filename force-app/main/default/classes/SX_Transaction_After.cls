/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 01/02/2019
* 
* Name: SX_Transaction_After.cls
* 
* Classe para disparar ações after em FieloPLT__Transaction__c
*
* Ações:
* 1 - sumarizar total de pontos nas metas
*******************************************************************************/
public with sharing class SX_Transaction_After {

	@TestVisible final public static String EXPIRATION = 'Expiration';

	public static void execute() {

		VN_TriggerCheck.assert();

		List<FieloPLT__Transaction__c> lLstTrigger = (List<FieloPLT__Transaction__c>) (trigger.isDelete ? trigger.old : trigger.new);

		Set<Id> lSetMetas = new Set<Id>();
		List<FieloPLT__Transaction__c> lLstTrans = new List<FieloPLT__Transaction__c>();
		for(FieloPLT__Transaction__c trans: lLstTrigger){

			if( (trans.FieloPLT__Action__c != null || trans.FieloPLT__Type__c != EXPIRATION )
				&& (VN_TriggerCheck.isChanged(trans, FieloPLT__Transaction__c.V_MetaDoParticipante__c) || trigger.isDelete) ){

				if(trans.V_MetaDoParticipante__c != null) lSetMetas.add(trans.V_MetaDoParticipante__c);

				// se deixou de ter meta, guarda meta antiga para recálculo
				if(trigger.isUpdate && VN_TriggerCheck.isChanged(trans, FieloPLT__Transaction__c.V_MetaDoParticipante__c) 
					&& ((FieloPLT__Transaction__c)trigger.oldMap.get( trans.id )).V_MetaDoParticipante__c != null){
					lSetMetas.add(((FieloPLT__Transaction__c)trigger.oldMap.get( trans.id )).V_MetaDoParticipante__c);
				}
				
				lLstTrans.add(trans);
			}
		}

		// atualiza campos "totais" das metas
		if(!lSetMetas.isEmpty()){

			Map<Id, VN_MetaParticipante__c> lMapMeta = new Map<Id, VN_MetaParticipante__c>([SELECT Id, 
				V_TotalBetcoins__c FROM VN_MetaParticipante__c WHERE Id =: lSetMetas]);


			for(FieloPLT__Transaction__c trans: lLstTrans){

				if(lMapMeta.containsKey(trans.V_MetaDoParticipante__c)){
					VN_MetaParticipante__c lMeta = lMapMeta.get(trans.V_MetaDoParticipante__c);

					if(lMeta.V_TotalBetcoins__c == null) lMeta.V_TotalBetcoins__c = 0;

					Decimal lPoint = trans.FieloPLT__Points__c != null ? trans.FieloPLT__Points__c : 0;

					if(trigger.isInsert || trigger.isUpdate){

						lMeta.V_TotalBetcoins__c += lPoint;

						//desconta da meta antiga
						if(trigger.isUpdate && VN_TriggerCheck.isChanged(trans, FieloPLT__Transaction__c.V_MetaDoParticipante__c) 
							&& ((FieloPLT__Transaction__c)trigger.oldMap.get( trans.id )).V_MetaDoParticipante__c != null){

							if(lMapMeta.containsKey(((FieloPLT__Transaction__c)trigger.oldMap.get( trans.id )).V_MetaDoParticipante__c)){
								VN_MetaParticipante__c lMetaOld = lMapMeta.get(((FieloPLT__Transaction__c)trigger.oldMap.get( trans.id )).V_MetaDoParticipante__c);

								if(lMetaOld.V_TotalBetcoins__c == null) lMetaOld.V_TotalBetcoins__c = 0;
								lMetaOld.V_TotalBetcoins__c -= lPoint;
							}
						}

					} else if(trigger.isDelete){
						lMeta.V_TotalBetcoins__c -= lPoint;
					}
				}
			}

			if(!lMapMeta.isEmpty()) update lMapMeta.values();
		}
	}
}