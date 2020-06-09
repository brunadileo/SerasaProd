/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 11/09/2018
* 
* Batch para atualozar os campos "Ano Fiscal Concluído" do Participante
*******************************************************************************/
global class SX_BatchAnoFiscalConcluido implements Database.Batchable<sObject>, Database.Stateful {

	global String fAnoFiscal;
	global String fMsgErro;
	
	global SX_BatchAnoFiscalConcluido(String aAno) {

		if(SX_Utils.batchIsProcessing('SX_BatchAnoFiscalConcluido')) return;
		fAnoFiscal = aAno;
		fMsgErro = '';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {

		return Database.getQueryLocator([SELECT Id, V_AnoFiscalConcluido__c
										FROM VN_MetaParticipante__c
										WHERE Name =: fAnoFiscal]);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {

   		if ( scope == null || scope.isEmpty()) return; 
   		List<VN_MetaParticipante__c> lLstMetas = ( List<VN_MetaParticipante__c> ) scope; 

   		for(VN_MetaParticipante__c metas: lLstMetas){
   			metas.V_AnoFiscalConcluido__c = true;
   		}

   		Database.SaveResult[] lLstResult = database.update(lLstMetas, false);
	  	 
	  	for(integer i=0; i < lLstResult.size(); i++) {
	 	
	 	    Database.SaveResult lResult = lLstResult[i];
	 	    VN_MetaParticipante__c lMetas = lLstMetas[i];	 	
	 	    if(lMetas == null) continue;
	 	    
	 	    if (!lResult.isSuccess()){
		  		for(Database.Error err : lResult.getErrors()) {
		  		 	fMsgErro += ' { ' + lMetas.Id +' }: '+err.getMessage()+' --FIM-- ';
			    }
		    }  
	  	}   	
	}
	
	global void finish(Database.BatchableContext BC) {

		if(String.isNotEmpty(fMsgErro)){
			insert new VN_LogBatch__c(V_Processo__c = 'Ano Fiscal Concluído',
				 V_IdBatch__c = BC.getJobId(), V_ErroResultado__c = fMsgErro.left(32768));
		}
	}	
}