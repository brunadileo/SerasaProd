/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 08/08/2019
* 
* Name: VN_MetaParticipanteTrigger.cls
* 
* Classe manipuladora da trigger after de MetaParticipante
*******************************************************************************/
public with sharing class VN_MetaParticipanteTrigger {

	public static void atualizarRanking() {
		
		VN_TriggerCheck.assert();

		Set<String> lSetAnoFiscal = new Set<String>();
	  	for (VN_MetaParticipante__c meta : (List<VN_MetaParticipante__c>) trigger.new) {

			  if(VN_TriggerCheck.isChanged(meta, VN_MetaParticipante__c.V_ScoreElite__c)
			  			|| VN_TriggerCheck.isChanged(meta, VN_MetaParticipante__c.V_PercentualMetaYTD__c)
						|| VN_TriggerCheck.isChanged(meta, VN_MetaParticipante__c.V_TotalVendasYTD__c)){
	  			lSetAnoFiscal.add(meta.Name);
	  		}
	  	}
	  	if(!lSetAnoFiscal.isEmpty()){
			List<ApexClass> lstClasses = [SELECT Id FROM ApexClass WHERE Name = 'SX_BatchAtualizarRankingNaMeta'];
			Integer lSuperacaoScheduler = [SELECT COUNT() FROM AsyncApexJob 
				                        WHERE Status IN ('Processing','Preparing','Queued') 
				                        AND ApexClassID =: lstClasses[0].Id] ;
				
			if(lSuperacaoScheduler <= 0){
				Datetime lScheduledTime = datetime.now().addMinutes(3);
				String sch = '00 ' + lScheduledTime.minute() + ' '+ lScheduledTime.hour() + ' '
					+ ' ' + lScheduledTime.day() + ' ' + lScheduledTime.month() + ' ? ' + lScheduledTime.year();
				String jobId = system.schedule('Atualizar_Posição_Ranking' + lScheduledTime, sch,  new SX_BatchAtualizarRankingNaMeta(lSetAnoFiscal));
			}
		}
	}
}