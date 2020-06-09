/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                          date: 28/10/2019
* 
* Name: SX_BatchAtualizarSumarizador.cls
* 
* Batch para atualizar Sumarizador quando mês anterior é atualizado
*******************************************************************************/
global with sharing class SX_BatchAtualizarSumarizador implements Database.Batchable<sObject>, Database.Stateful{
    global Set<Id> fSetSumarizadorAtualizado;
    global Map<Id, VN_Sumarizador__c> fMapSumarizadorAnterior;
    global String fMsgErro;

    global SX_BatchAtualizarSumarizador(){
        fMapSumarizadorAnterior = new Map<Id, VN_Sumarizador__c>();
        fSetSumarizadorAtualizado = new Set<Id>();
        fMsgErro = '';
        List<VN_Sumarizador__c> lstSumarizador = new List<VN_Sumarizador__c>();
        
        lstSumarizador = [SELECT V_Mes__c, V_MetaDoParticipante__c, V_ValorYTD__c, V_MetaYTDPeriodo__c,
                        V_IDXAnoFiscal__c, V_ValorYTDPeriodo__c, V_MetaYTD__c, V_IDXAnoFiscalPeriodo__c,
                        V_PercentualAMYTDPeriodo__c, V_PercentualAMYTDFatorado__c, V_IDXSemestre__c,
                        V_MetaYTDSemestre__c, V_ValorYTDSemestre__c, V_IDXSemestrePeriodo__c,
                        V_MetaYTDSemestrePeriodo__c, V_ValorYTDSemestrePeriodo__c,
                        V_PercentualAMYTDSemestreFatorado__c, V_PercentualAMYTDSemestrePeriodo__c,
                        V_IDXTrimestre__c, V_MetaYTDTrimestre__c, V_ValorYTDTrimestre__c,
                        V_IDXTrimestrePeriodo__c, V_MetaYTDTrimestrePeriodo__c, V_ValorYTDTrimestrePeriodo__c,
                        V_PercentualAMYTDTrimestreFatorado__c, V_PercentualAMYTDTrimestrePeriodo__c,
                        V_PercentualAMYTD__c
                        FROM VN_Sumarizador__c
                        WHERE V_MetaDoParticipante__r.V_AnoFiscal__r.V_Vigente__c = true
                        AND V_ProcessarCalculos__c = true];

        if(!lstSumarizador.isEmpty()){
            Map<Id, VN_Sumarizador__c> lMapMetaSumMaisAntigo = new Map<Id, VN_Sumarizador__c>();
            for(VN_Sumarizador__c lSum : lstSumarizador){
                if(!lMapMetaSumMaisAntigo.containsKey(lSum.V_MetaDoParticipante__c))
                    lMapMetaSumMaisAntigo.put(lSum.V_MetaDoParticipante__c, lSum);
                else if(lMapMetaSumMaisAntigo.get(lSum.V_MetaDoParticipante__c).V_Mes__c > lSum.V_Mes__c)
                    lMapMetaSumMaisAntigo.put(lSum.V_MetaDoParticipante__c, lSum);
            }
            if(!lMapMetaSumMaisAntigo.isEmpty())
                for(VN_Sumarizador__c lSumarizador : lMapMetaSumMaisAntigo.values())
                    fMapSumarizadorAnterior.put(lSumarizador.Id, lSumarizador);
        }
    }
    
    global SX_BatchAtualizarSumarizador(List<VN_Sumarizador__c> aLstSumarizador) {
        fMapSumarizadorAnterior = new Map<Id, VN_Sumarizador__c>();
        fSetSumarizadorAtualizado = new Set<Id>();
        fMsgErro = '';

        for(VN_Sumarizador__c lSumarizador : aLstSumarizador){
            fMapSumarizadorAnterior.put(lSumarizador.Id, lSumarizador);
        }
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        if(fMapSumarizadorAnterior.isEmpty())
            return null;

		return Database.getQueryLocator([SELECT V_ReferenciaMesAnterior__c, V_ValorYTDAnterior__c, V_MetaYTDPeriodoAnterior__c,
            V_MesFYAnterior__c, V_ValorYTDPeriodoAnterior__c, V_MetaYTDAnterior__c, 
            V_IDXAnoFiscalPeriodoAnterior__c, V_PercentualAMYTDPeriodoAnterior__c, V_PercentualAMYTDFatoradoAnterior__c,
            V_IDXSemestreAnterior__c, V_MetaYTDSemestreAnterior__c, V_ValorYTDSemestreAnterior__c,
            V_IDXSemestrePeriodoAnterior__c, V_MetaYTDSemestrePeriodoAnterior__c, V_ValorYTDSemestrePeriodoAnterior__c, 
            V_PercentuaAMYTDSemestreFatoradoAnterior__c, V_PercentualAMYTDSemestrePeriodoAnterior__c,
            V_IDXTrimestreAnterior__c, V_MetaYTDTrimestreAnterior__c, V_ValorYTDTrimestreAnterior__c,
            V_IDXTrimestrePeriodoAnterior__c, V_MetaYTDTrimestrePeriodoAnterior__c, V_ValorYTDTrimestrePeriodoAnterior__c, 
            V_PercentuAMYTDTrimestreFatoradoAnterior__c, V_PercentuaAMYTDTrimestrePeriodoAnterior__c, V_AMYTDAnterior__c
										FROM VN_Sumarizador__c
										WHERE V_ReferenciaMesAnterior__c =: fMapSumarizadorAnterior.keySet()]);
	}

    global void execute(Database.BatchableContext BC, List<VN_Sumarizador__c> aLstSumarizadorScope) {

   		if (aLstSumarizadorScope == null || aLstSumarizadorScope.isEmpty()) return;
        
        List<VN_Sumarizador__c> lstSumarizadorToUpdate = new List<VN_Sumarizador__c>();
        for(VN_Sumarizador__c lSumarizador : aLstSumarizadorScope){

            VN_Sumarizador__c lSumarizadorAnterior = fMapSumarizadorAnterior.get(lSumarizador.V_ReferenciaMesAnterior__c);
            if(lSumarizadorAnterior.V_ValorYTD__c != null)
                lSumarizador.V_ValorYTDAnterior__c = lSumarizadorAnterior.V_ValorYTD__c;
            if(lSumarizadorAnterior.V_MetaYTDPeriodo__c != null)
                lSumarizador.V_MetaYTDPeriodoAnterior__c = lSumarizadorAnterior.V_MetaYTDPeriodo__c;
            if(lSumarizadorAnterior.V_IDXAnoFiscal__c != null)
                lSumarizador.V_MesFYAnterior__c = lSumarizadorAnterior.V_IDXAnoFiscal__c;
            if(lSumarizadorAnterior.V_ValorYTDPeriodo__c != null)
                lSumarizador.V_ValorYTDPeriodoAnterior__c = lSumarizadorAnterior.V_ValorYTDPeriodo__c;
            if(lSumarizadorAnterior.V_MetaYTD__c != null)
                lSumarizador.V_MetaYTDAnterior__c = lSumarizadorAnterior.V_MetaYTD__c;
            if(lSumarizadorAnterior.V_IDXAnoFiscalPeriodo__c != null)
                lSumarizador.V_IDXAnoFiscalPeriodoAnterior__c = lSumarizadorAnterior.V_IDXAnoFiscalPeriodo__c;
            if(lSumarizadorAnterior.V_PercentualAMYTDPeriodo__c != null)
                lSumarizador.V_PercentualAMYTDPeriodoAnterior__c = lSumarizadorAnterior.V_PercentualAMYTDPeriodo__c;
            if(lSumarizadorAnterior.V_PercentualAMYTDFatorado__c != null)
                lSumarizador.V_PercentualAMYTDFatoradoAnterior__c = lSumarizadorAnterior.V_PercentualAMYTDFatorado__c;
            if(lSumarizadorAnterior.V_IDXSemestre__c != null)
                lSumarizador.V_IDXSemestreAnterior__c = lSumarizadorAnterior.V_IDXSemestre__c;
            if(lSumarizadorAnterior.V_MetaYTDSemestre__c != null)
                lSumarizador.V_MetaYTDSemestreAnterior__c = lSumarizadorAnterior.V_MetaYTDSemestre__c;
            if(lSumarizadorAnterior.V_ValorYTDSemestre__c != null)
                lSumarizador.V_ValorYTDSemestreAnterior__c = lSumarizadorAnterior.V_ValorYTDSemestre__c;
            if(lSumarizadorAnterior.V_IDXSemestrePeriodo__c != null)
                lSumarizador.V_IDXSemestrePeriodoAnterior__c = lSumarizadorAnterior.V_IDXSemestrePeriodo__c;
            if(lSumarizadorAnterior.V_MetaYTDSemestrePeriodo__c != null)
                lSumarizador.V_MetaYTDSemestrePeriodoAnterior__c = lSumarizadorAnterior.V_MetaYTDSemestrePeriodo__c;
            if(lSumarizadorAnterior.V_ValorYTDSemestrePeriodo__c != null)
                lSumarizador.V_ValorYTDSemestrePeriodoAnterior__c = lSumarizadorAnterior.V_ValorYTDSemestrePeriodo__c;
            if(lSumarizadorAnterior.V_PercentualAMYTDSemestreFatorado__c != null)
                lSumarizador.V_PercentuaAMYTDSemestreFatoradoAnterior__c = lSumarizadorAnterior.V_PercentualAMYTDSemestreFatorado__c;
            if(lSumarizadorAnterior.V_PercentualAMYTDSemestrePeriodo__c != null)
                lSumarizador.V_PercentualAMYTDSemestrePeriodoAnterior__c = lSumarizadorAnterior.V_PercentualAMYTDSemestrePeriodo__c;
            if(lSumarizadorAnterior.V_IDXTrimestre__c != null)
                lSumarizador.V_IDXTrimestreAnterior__c = lSumarizadorAnterior.V_IDXTrimestre__c;
            if(lSumarizadorAnterior.V_MetaYTDTrimestre__c != null)
                lSumarizador.V_MetaYTDTrimestreAnterior__c = lSumarizadorAnterior.V_MetaYTDTrimestre__c;
            if(lSumarizadorAnterior.V_ValorYTDTrimestre__c != null)
                lSumarizador.V_ValorYTDTrimestreAnterior__c = lSumarizadorAnterior.V_ValorYTDTrimestre__c;
            if(lSumarizadorAnterior.V_IDXTrimestrePeriodo__c != null)
                lSumarizador.V_IDXTrimestrePeriodoAnterior__c = lSumarizadorAnterior.V_IDXTrimestrePeriodo__c;
            if(lSumarizadorAnterior.V_MetaYTDTrimestrePeriodo__c != null)
                lSumarizador.V_MetaYTDTrimestrePeriodoAnterior__c = lSumarizadorAnterior.V_MetaYTDTrimestrePeriodo__c;
            if(lSumarizadorAnterior.V_ValorYTDTrimestrePeriodo__c != null)
                lSumarizador.V_ValorYTDTrimestrePeriodoAnterior__c = lSumarizadorAnterior.V_ValorYTDTrimestrePeriodo__c;
            if(lSumarizadorAnterior.V_PercentualAMYTDTrimestreFatorado__c != null)
                lSumarizador.V_PercentuAMYTDTrimestreFatoradoAnterior__c = lSumarizadorAnterior.V_PercentualAMYTDTrimestreFatorado__c;
            if(lSumarizadorAnterior.V_PercentualAMYTDTrimestrePeriodo__c != null)
                lSumarizador.V_PercentuaAMYTDTrimestrePeriodoAnterior__c = lSumarizadorAnterior.V_PercentualAMYTDTrimestrePeriodo__c;
            if(lSumarizadorAnterior.V_PercentualAMYTD__c != null)
                lSumarizador.V_AMYTDAnterior__c = lSumarizadorAnterior.V_PercentualAMYTD__c;

            lstSumarizadorToUpdate.add(lSumarizador);
        }

        if(!lstSumarizadorToUpdate.isEmpty()){
            Database.SaveResult[] lLstResult = Database.update(lstSumarizadorToUpdate, false);
            for(integer i=0; i < lLstResult.size(); i++) {
            
                Database.SaveResult lResult = lLstResult[i];
                VN_Sumarizador__c lSumarizador = lstSumarizadorToUpdate[i];      
                if(lSumarizador == null) continue;
                
                if (!lResult.isSuccess()){
                    system.debug('### SX_BatchAtualizarSumarizador error atualizar Sumarizador '+' { ' + lSumarizador.Id +' }: ');
                    for(Database.Error err : lResult.getErrors()) {
                        fMsgErro += ' { ' + lSumarizador.Id +' }: '+err.getMessage()+' --FIM-- ';
                        system.debug(err.getMessage());
                    }
                } else {
                    fSetSumarizadorAtualizado.add(lSumarizador.Id);
                }
            }
            if(String.isNotEmpty(fMsgErro)){
				insert new VN_LogBatch__c(V_Processo__c = 'Atualizar Sumarizador',
					V_IdBatch__c = BC.getJobId(), V_ErroResultado__c = fMsgErro.left(32768));
			}
        }
    }

	global void finish(Database.BatchableContext BC) {
        if(!fSetSumarizadorAtualizado.isEmpty()){
            List<VN_Sumarizador__c> lstSumarizadorAtualizado = new List<VN_Sumarizador__c>();
            lstSumarizadorAtualizado = [SELECT V_MetaDoParticipante__c, V_ValorYTD__c, V_MetaYTDPeriodo__c,
                                    V_IDXAnoFiscal__c, V_ValorYTDPeriodo__c, V_MetaYTD__c, V_IDXAnoFiscalPeriodo__c,
                                    V_PercentualAMYTDPeriodo__c, V_PercentualAMYTDFatorado__c, V_IDXSemestre__c,
                                    V_MetaYTDSemestre__c, V_ValorYTDSemestre__c, V_IDXSemestrePeriodo__c,
                                    V_MetaYTDSemestrePeriodo__c, V_ValorYTDSemestrePeriodo__c, 
                                    V_PercentualAMYTDSemestreFatorado__c, V_PercentualAMYTDSemestrePeriodo__c,
                                    V_IDXTrimestre__c, V_MetaYTDTrimestre__c, V_ValorYTDTrimestre__c,
                                    V_IDXTrimestrePeriodo__c, V_MetaYTDTrimestrePeriodo__c, V_ValorYTDTrimestrePeriodo__c,
                                    V_PercentualAMYTDTrimestreFatorado__c, V_PercentualAMYTDTrimestrePeriodo__c,
									V_PercentualAMYTD__c, V_Mes__c, V_MesString__c, V_MetaDoParticipante__r.V_UltimoMesAtualizado__c,
                                    V_MetaDoParticipante__r.V_UltimoMesAtualizadoInteger__c, V_MetaDoParticipante__r.Name,
                                    V_LiderImediato__c, V_PercentualAMYTDTrimestre__c, Participante__c
                                    FROM VN_Sumarizador__c WHERE Id =: fSetSumarizadorAtualizado];

            if(!lstSumarizadorAtualizado.isEmpty()){

                //Se atualizei o Sumarizador, tenho que buscar Sumarizadores dos quais sou Líder, verificar se o valor é diferente,
                //se for atualiza
                Set<Integer> lSetMesAtualizado = new Set<Integer>();
                Set<Id> lSetLideres = new Set<Id>();
                Map<Id, VN_Sumarizador__c> lMapSumarizadorLider = new Map<Id, VN_Sumarizador__c>();
                List<VN_Sumarizador__c> lstSumarizadorToUpdate = new List<VN_Sumarizador__c>();
                
                for(VN_Sumarizador__c lSum : lstSumarizadorAtualizado){
                    lSetMesAtualizado.add(Integer.valueOf(lSum.V_Mes__c));
                    lMapSumarizadorLider.put(lSum.Participante__c, lSum);
                    if(lSum.V_LiderImediato__c != null)
                        lSetLideres.add(lSum.V_LiderImediato__c);
                }

                if(!lSetMesAtualizado.isEmpty() && 
                        (lSetMesAtualizado.contains(3) || lSetMesAtualizado.contains(6) 
                        || lSetMesAtualizado.contains(9) || lSetMesAtualizado.contains(12)) 
                        && !lSetLideres.isEmpty()){

                    List<VN_Sumarizador__c> lstSumarizadorFilhosDeLideres = [SELECT V_PercAMLiderImediatoQuarter__c, V_LiderImediato__c FROM VN_Sumarizador__c
                            WHERE V_Mes__c =: lSetMesAtualizado AND V_LiderImediato__c =: lSetLideres];
                    
                    if(!lstSumarizadorFilhosDeLideres.isEmpty()){
                        for(VN_Sumarizador__c lSumFilho : lstSumarizadorFilhosDeLideres){
                            if(lMapSumarizadorLider.containsKey(lSumFilho.V_LiderImediato__c)){
                                VN_Sumarizador__c lSumLider = lMapSumarizadorLider.get(lSumFilho.V_LiderImediato__c);
                                if(lSumLider.V_PercentualAMYTDTrimestre__c != null 
                                        && lSumLider.V_PercentualAMYTDTrimestre__c != lSumFilho.V_PercAMLiderImediatoQuarter__c){

                                    lSumFilho.V_PercAMLiderImediatoQuarter__c = lSumLider.V_PercentualAMYTDTrimestre__c;
                                    lstSumarizadorToUpdate.add(lSumFilho);
                                }
                            }
                        }
                        if(!lstSumarizadorToUpdate.isEmpty())
                            update lstSumarizadorToUpdate;
                    }
                }

                //if(lstSumarizadorAtualizado[0].V_MesString__c == lstSumarizadorAtualizado[0].V_MetaDoParticipante__r.V_UltimoMesAtualizado__c){
                if(lstSumarizadorAtualizado[0].V_Mes__c == (lstSumarizadorAtualizado[0].V_MetaDoParticipante__r.V_UltimoMesAtualizadoInteger__c + 1)){
                    Set<String> lSetAnoFiscal = new Set<String>{lstSumarizadorAtualizado[0].V_MetaDoParticipante__r.Name};
                    Decimal lRandomNumber = Integer.valueof((Math.random() * 1000000));
			        System.scheduleBatch( new SX_BatchAtualizarRankingNaMeta(lSetAnoFiscal),'Atualizar posição ranking '+lRandomNumber, 1); 
                } else { 
                    SX_BatchAtualizarSumarizador lBatch = new SX_BatchAtualizarSumarizador(lstSumarizadorAtualizado); 
                    Database.executeBatch(lBatch);
                }
            }
        }
    }	
}