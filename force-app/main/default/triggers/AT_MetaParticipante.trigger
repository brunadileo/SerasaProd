//ObjectPluralName is the Action Object name. ObjectAPIName is the API Name of the object to process.
trigger AT_MetaParticipante on VN_MetaParticipante__c(after insert, after update, before insert, before update){
  
	if(Trigger.isBefore){
		for(VN_MetaParticipante__c lMeta : Trigger.new){
			
			//Atualiza | Total de Beticoins >=1000
			if(lMeta.V_TotalBetcoins__c >= 1000)
				lMeta.V_SaldoTotalBetcoinsmaior__c = true;

			//Atualiza | 1 Quarter Atingido
			//Atualiza | 2 Quarters Atingidos
			//Atualiza | 3 Quarters Atingidos
			lMeta.V_1QuarterAtingido__c = false;
			lMeta.V_2QuartersAtingidos__c = false;
			lMeta.V_3QuartersAtingidos__c = false;

			Integer lTotalQuartersAAtingidos = 0;
			if(lMeta.V_PercentualAM1Trimestre__c >= 100)
				lTotalQuartersAAtingidos++;
			if(lMeta.V_PercentualAM2Trimestre__c >= 100)
				lTotalQuartersAAtingidos++;
			if(lMeta.V_PercentualAM3Trimestre__c >= 100)
				lTotalQuartersAAtingidos++;
			if(lMeta.V_PercentualAM4Trimestre__c >= 100)
				lTotalQuartersAAtingidos++;
			
			if(lTotalQuartersAAtingidos == 1)
				lMeta.V_1QuarterAtingido__c = true;
			if(lTotalQuartersAAtingidos == 2){
				lMeta.V_1QuarterAtingido__c = true;
				lMeta.V_2QuartersAtingidos__c = true;
			}
			if(lTotalQuartersAAtingidos == 3){
				lMeta.V_1QuarterAtingido__c = true;
				lMeta.V_2QuartersAtingidos__c = true;
				lMeta.V_3QuartersAtingidos__c = true;
			}
		}

	}
	if(Trigger.isAfter){

		if(Trigger.isInsert){
			FieloPLT.SObjectService.processRecords(Trigger.new, null);

		}else if(Trigger.isUpdate){
			Boolean lProcessarSuperacaoMetas = false;
			for(VN_MetaParticipante__c lMeta : Trigger.new){
				if((lMeta.V_PercentualAM2Trimestre__c != null && lMeta.V_PercentualAM2Trimestre__c != 0)
					|| (lMeta.V_PercentualAM3Trimestre__c != null && lMeta.V_PercentualAM3Trimestre__c != 0)
					|| (lMeta.V_PercentualAM4Trimestre__c != null && lMeta.V_PercentualAM4Trimestre__c != 0)
					|| (lMeta.V_PercentualAM1Semestre__c != null && lMeta.V_PercentualAM1Semestre__c != 0)
					|| (lMeta.V_PercentualAM2Semestre__c != null && lMeta.V_PercentualAM2Semestre__c != 0)){
					lProcessarSuperacaoMetas = true;
					break;
				}
			}
			if(lProcessarSuperacaoMetas){
				List<ApexClass> lstClasses = [SELECT Id FROM ApexClass WHERE Name = 'SX_BatchAtualizaSuperacaoMeta'];
				Integer lSuperacaoScheduler = [SELECT COUNT() FROM AsyncApexJob 
				                        WHERE Status IN ('Processing','Preparing','Queued') 
				                        AND ApexClassID =: lstClasses[0].Id] ;
				
				if(lSuperacaoScheduler <= 0){
					Datetime lScheduledTime = datetime.now().addMinutes(5);

					String sch = '00 ' + lScheduledTime.minute() + ' '+ lScheduledTime.hour() + ' '
						+ ' ' + lScheduledTime.day() + ' ' + lScheduledTime.month() + ' ? ' + lScheduledTime.year();
					String jobId = system.schedule('Atualizar_Superação_Metas' + lScheduledTime, sch,  new SX_BatchAtualizaSuperacaoMeta());
				}
			}

			FieloPLT.SObjectService.processRecords(Trigger.new, Trigger.oldMap);
		}

		//add 09/08/19 - task #16685
		if(trigger.isInsert || trigger.isUpdate){

			if(!system.isBatch()){
				VN_MetaParticipanteTrigger.atualizarRanking();
			}
		}
	}
}