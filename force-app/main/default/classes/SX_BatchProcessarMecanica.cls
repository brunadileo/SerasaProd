/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 11/09/2018
* 
* 
* Batch para atualizar os campos "Processar Mecânica" do Participante
*
*******************************************************************************/
global class SX_BatchProcessarMecanica implements Database.Batchable<sObject>, Database.Stateful {

	global String fAnoFiscal;
	global Integer fMonth;
	global String fMsgErro;
	global Set<Id> fSetSumarizadorAtualizado;
	
	global SX_BatchProcessarMecanica(String aAno, Integer aMes) {

		if(SX_Utils.batchIsProcessing('SX_BatchProcessarMecanica')) return;
		fAnoFiscal = aAno;
		fMonth = aMes;
		fMsgErro = '';
		fSetSumarizadorAtualizado = new Set<Id>();
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {

		return Database.getQueryLocator([SELECT V_ProcessarMecanicas__c 
										FROM VN_Sumarizador__c
										WHERE V_MetaDoParticipante__r.Name =: fAnoFiscal 
										AND V_Mes__c =: fMonth 
										AND V_ProcessarMecanicas__c = false]);								
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {

   		if ( scope == null || scope.isEmpty()) return;

		List<VN_Sumarizador__c> lstSumarizador = ( List<VN_Sumarizador__c> ) scope;  
		   for(VN_Sumarizador__c lSumarizador: lstSumarizador){
			   lSumarizador.V_ProcessarMecanicas__c = true;
		   }

		Database.SaveResult[] lLstResult = database.update(lstSumarizador, false);
	  	 
	  	for(integer i=0; i < lLstResult.size(); i++) {
	 	
	 	    Database.SaveResult lResult = lLstResult[i];

			VN_Sumarizador__c lSumarizador = lstSumarizador[i];	 	
	 	    if(lSumarizador == null) continue;
	 	    
	 	    if (!lResult.isSuccess()){
		  		for(Database.Error err : lResult.getErrors()) {
					  System.debug('***Erro::' + err);
					fMsgErro += ' { ' + lSumarizador.Id +' }: '+err.getMessage()+' --FIM-- ';
			    }
		    } else {
                fSetSumarizadorAtualizado.add(lSumarizador.Id);
            }
	  	}
	}
	
	global void finish(Database.BatchableContext BC) {

		if(String.isNotEmpty(fMsgErro)){
			insert new VN_LogBatch__c(V_Processo__c = 'Processar Mecânica',
				 V_IdBatch__c = BC.getJobId(), V_ErroResultado__c = fMsgErro.left(32768)); 
		}

		if(!fSetSumarizadorAtualizado.isEmpty()){
            List<VN_Sumarizador__c> lstSumarizadorAtualizado = new List<VN_Sumarizador__c>();
            lstSumarizadorAtualizado = [SELECT V_Mes__c, V_MesString__c, V_AMYTDAnterior__c, V_Persona__c, V_Meta__c, V_Valor__c,
						V_PercentualAMMes__c, V_ResultadoSE__c, V_PercentualSEMes__c, V_MetaDoParticipante__c,
						V_PercentualAMYTDSemestre__c, V_MetaYTDSemestre__c, V_ValorYTDSemestre__c,
						V_PercentualAMYTDTrimestre__c, V_MetaYTDTrimestre__c, V_ValorYTDTrimestre__c,
						V_ScoreSMQ1__c, V_ScoreAMYTD__c, V_ScoreSMYTD__c, V_PercentualAMYTD__c, V_ValorDisputaComercial__c 
                        FROM VN_Sumarizador__c WHERE Id =: fSetSumarizadorAtualizado];
			
			Map<Id, VN_Sumarizador__c> lMapMetaSumarizador = new Map<Id, VN_Sumarizador__c>();
            for(VN_Sumarizador__c lSumarizador : lstSumarizadorAtualizado){
                lMapMetaSumarizador.put(lSumarizador.V_MetaDoParticipante__c, lSumarizador);
            }

            if(!lMapMetaSumarizador.isEmpty()){
                List<VN_MetaParticipante__c> lstMeta = new List<VN_MetaParticipante__c>();
                lstMeta = [SELECT V_AMYTDAnterior__c, V_Persona__c, V_Meta__c, V_Valor__c, V_PercentualAMMes__c,
                            V_ResultadoSE__c, V_UltimoMesAtualizado__c, V_PercentualSEMes__c,
							V_PercentualAM1Semestre__c, V_TotalMetas1Semestre__c, V_TotaldeVendas1Semestre__c,
							V_PercentualAM2Semestre__c, V_TotalMetas2Semestre__c, V_TotaldeVendas2Semestre__c,
							V_PercentualAM1Trimestre__c, V_TotalMetas1Trimestre__c, V_TotaldeVendas1Trimestre__c,
							V_PercentualAM2Trimestre__c, V_TotalMetas2Trimestre__c, V_TotaldeVendas2Trimestre__c,
							V_PercentualAM3Trimestre__c, V_TotalMetas3Trimestre__c, V_TotaldeVendas3Trimestre__c,
							V_PercentualAM4Trimestre__c, V_TotalMetas4Trimestre__c, V_TotaldeVendas4Trimestre__c,
							V_ScoreSuperacaoQ1__c, V_ScoreAtingimentoFY__c, V_ScoreSuperacaoFY__c, V_TotalDisputaComercialAF__c
                            FROM VN_MetaParticipante__c WHERE Id =: lMapMetaSumarizador.keySet()];

                if(!lstMeta.isEmpty()){
                    for(VN_MetaParticipante__c lMeta : lstMeta){
						//Atualiza informações meta do Participante
                        VN_Sumarizador__c lSum = lMapMetaSumarizador.get(lMeta.Id);
                        lMeta.V_AMYTDAnterior__c = lSum.V_AMYTDAnterior__c;
                        lMeta.V_Persona__c = lSum.V_Persona__c;
                        lMeta.V_Meta__c = lSum.V_Meta__c;
                        lMeta.V_Valor__c = lSum.V_Valor__c;
                        lMeta.V_PercentualAMMes__c = lSum.V_PercentualAMMes__c;
                        lMeta.V_ResultadoSE__c = lSum.V_ResultadoSE__c;
                        lMeta.V_PercentualSEMes__c = lSum.V_PercentualSEMes__c;
                        lMeta.V_UltimoMesAtualizado__c = lSum.V_MesString__c;
						lMeta.V_AMYTD__c = lSum.V_PercentualAMYTD__c;
						
						//Novo - Atribui Score (Ating. e Sup)
						lMeta.V_ScoreAtingimentoFY__c = lSum.V_ScoreAMYTD__c;
						lMeta.V_ScoreSuperacaoFY__c = lSum.V_ScoreSMYTD__c;
						lMeta.V_TotalDisputaComercialAF__c = lSum.V_ValorDisputaComercial__c;

						//Atualiza 1º Trimestre Meta Participante
                        if(lSum.V_Mes__c == 3){
                            lMeta.V_PercentualAM1Trimestre__c = lSum.V_PercentualAMYTDTrimestre__c;
                            lMeta.V_TotalMetas1Trimestre__c = lSum.V_MetaYTDTrimestre__c;
                            lMeta.V_TotaldeVendas1Trimestre__c = lSum.V_ValorYTDTrimestre__c;
                        }

						//Atualiza 1º Semestre Meta Participante
						//Atualiza 2º Trimestre Meta Participante
						if(lSum.V_Mes__c == 6){
                            lMeta.V_PercentualAM1Semestre__c = lSum.V_PercentualAMYTDSemestre__c;
                            lMeta.V_TotalMetas1Semestre__c = lSum.V_MetaYTDSemestre__c;
                            lMeta.V_TotaldeVendas1Semestre__c = lSum.V_ValorYTDSemestre__c;
							lMeta.V_PercentualAM2Trimestre__c = lSum.V_PercentualAMYTDTrimestre__c;
                            lMeta.V_TotalMetas2Trimestre__c = lSum.V_MetaYTDTrimestre__c;
                            lMeta.V_TotaldeVendas2Trimestre__c = lSum.V_ValorYTDTrimestre__c;
                        }

						//Atualiza 3º Trimestre Meta Participante
                        if(lSum.V_Mes__c == 9){
                            lMeta.V_PercentualAM3Trimestre__c = lSum.V_PercentualAMYTDTrimestre__c;
                            lMeta.V_TotalMetas3Trimestre__c = lSum.V_MetaYTDTrimestre__c;
                            lMeta.V_TotaldeVendas3Trimestre__c = lSum.V_ValorYTDTrimestre__c;
                        }

						//Atualiza 2º Semestre Meta Participante
                        if(lSum.V_Mes__c == 12){
                            lMeta.V_PercentualAM2Semestre__c = lSum.V_PercentualAMYTDSemestre__c;
                            lMeta.V_TotalMetas2Semestre__c = lSum.V_MetaYTDSemestre__c;
                            lMeta.V_TotaldeVendas2Semestre__c = lSum.V_ValorYTDSemestre__c;
							lMeta.V_PercentualAM4Trimestre__c = lSum.V_PercentualAMYTDTrimestre__c;
                            lMeta.V_TotalMetas4Trimestre__c = lSum.V_MetaYTDTrimestre__c;
                            lMeta.V_TotaldeVendas4Trimestre__c = lSum.V_ValorYTDTrimestre__c;
                        }

						//Atualiza | Score de Superação Q1
						if(lSum.V_Mes__c == 3)
							lMeta.V_ScoreSuperacaoQ1__c = lSum.V_ScoreSMQ1__c;
                    }
                    update lstMeta;
                }
            }
		}
		Set<String> lSetAnoFiscal = new Set<String>{fAnoFiscal};
	  	if(!lSetAnoFiscal.isEmpty()){
			Decimal lRandomNumber = Integer.valueof((Math.random() * 1000000));
			System.scheduleBatch( new SX_BatchAtualizarRankingNaMeta(lSetAnoFiscal),'Atualizar posição ranking '+lRandomNumber, 1); 
		}
	}	
}