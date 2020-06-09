/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 14/09/2018
* 
* Name: SX_BatchCriarMetas.cls
* 
* Batch para criar e metas nos Members
*******************************************************************************/
global class SX_BatchCriarMetas implements Database.Batchable<sObject>, Database.Stateful {
    
    global Map<Id, VN_GerenciadorMetaParticipanteAF__c>  fMapGerenciador; 
    
    global SX_BatchCriarMetas(Map<Id, VN_GerenciadorMetaParticipanteAF__c>  aMapGerenciador) {

        if(SX_Utils.batchIsProcessing('SX_BatchCriarMetas')) return;
        fMapGerenciador = aMapGerenciador;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {

        return Database.getQueryLocator([SELECT Id, V_MetasAnoFiscalVigenteNovo__c FROM FieloPLT__Member__c]);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('>>> SX_BatchCriarMetas.execute()');
        System.debug(scope);
        if ( scope == null || scope.isEmpty()) return; 

        List<FieloPLT__Member__c> lListMember = ( List<FieloPLT__Member__c> ) scope;

        Set<Id> lSetMeta = new Set<Id>();
        for(VN_MetaParticipante__c meta: [SELECT V_Participante__c 
	                                        FROM VN_MetaParticipante__c 
	                                        WHERE V_AnoFiscal__c =: fMapGerenciador.keySet()
	                                        AND V_Participante__c =: lListMember]){
            lSetMeta.add(meta.V_Participante__c);
        }

        List<VN_MetaParticipante__c> lLstMeta = new List<VN_MetaParticipante__c>();
        for(FieloPLT__Member__c member: lListMember){

        	if(lSetMeta.contains(member.Id)) continue;

        	for(VN_GerenciadorMetaParticipanteAF__c lGerenciador: fMapGerenciador.values()){

        		 lLstMeta.add(new VN_MetaParticipante__c(
						Name = lGerenciador.V_AnoFiscal__c,
						V_AnoFiscal__c  = lGerenciador.Id,
						V_Participante__c = member.Id
					)
				);
        	}
        }

        if(!lLstMeta.isEmpty()) {

            Database.SaveResult[] lLstResult = Database.insert(lLstMeta, false);
            for(integer i=0; i < lLstResult.size(); i++) {
            
                Database.SaveResult lResult = lLstResult[i];
                VN_MetaParticipante__c lMeta = lLstMeta[i];      
                if(lMeta == null) continue;
                
                if (!lResult.isSuccess()){
                     system.debug('### SX_BatchCriarMetas error insert metas '+' { ' + lMeta.V_Participante__c +' }: ');

                    for(Database.Error err : lResult.getErrors()) {
                        system.debug(err.getMessage());
                    }
                }
            }
            associarMetaNoMember(lLstMeta); 
            gerarSumarizador(lLstMeta, null);
        }          
    }
    
    global void finish(Database.BatchableContext BC) {
    }

    public static void associarMetaNoMember(List<VN_MetaParticipante__c> aLstMeta){

        Map<Id,VN_MetaParticipante__c> lMapMemberMetas = new Map<Id,VN_MetaParticipante__c>();
        for(VN_MetaParticipante__c meta: [SELECT Id, V_Participante__c FROM VN_MetaParticipante__c 
        									 WHERE Id =: aLstMeta
        									 AND V_Vigente__c = true]){
            lMapMemberMetas.put(Meta.V_Participante__c, meta);
        }

        List<FieloPLT__Member__c> lLstMember = [SELECT Id, V_MetasAnoFiscalVigenteNovo__c FROM FieloPLT__Member__c WHERE Id =: lMapMemberMetas.keySet()];
        for(FieloPLT__Member__c member: lLstMember){

            VN_MetaParticipante__c lMeta = lMapMemberMetas.get(member.Id);
            if(lMeta == null) continue;

            member.V_MetasAnoFiscalVigenteNovo__c = lMeta.Id;
        }

        if(!lLstMember.isEmpty()) {

            Database.SaveResult[] lLstResult = Database.update(lLstMember, false);
            for(integer i=0; i < lLstResult.size(); i++) {
            
                Database.SaveResult lResult = lLstResult[i];
                FieloPLT__Member__c lMember = lLstMember[i];      
                if(lMember == null) continue;
                
                if (!lResult.isSuccess()){
                     system.debug('### SX_BatchCriarMetas erro update member'+' { ' + lMember.Id +' }: ');

                    for(Database.Error err : lResult.getErrors()) {
                        system.debug(err.getMessage());
                    }
                }
            }
        } 
    }

    public static void gerarSumarizador(List<VN_MetaParticipante__c> aLstMeta, Date data){
        List<VN_Sumarizador__c> lLstSumarizador  = new List<VN_Sumarizador__c>();

        Set<Id> lSetSumarizador = new Set<Id>();
        for(VN_Sumarizador__c sumarizador: [SELECT Participante__c  
	                                   FROM VN_Sumarizador__c 
	                                  WHERE V_MetaDoParticipante__c =: aLstMeta]){
            lSetSumarizador.add(sumarizador.Participante__c);
        }
            
        for(VN_MetaParticipante__c meta: [SELECT Id, V_Participante__c, V_AnoFiscal__r.V_DataInicio__c, V_AnoFiscal__r.V_DataFim__c,
                                                V_Participante__r.V_DataSumarizador__c 
                                                FROM VN_MetaParticipante__c 
                                                WHERE Id =: aLstMeta
                                                AND V_Vigente__c = true]){
            
            // task #17414
            // Date dataIni = data == null ? meta.V_AnoFiscal__r.V_DataInicio__c : data;
            Date dataIni = data == null ? System.now().date() : data;
            if(meta.V_Participante__c != null && meta.V_Participante__r.V_DataSumarizador__c != null){
                dataIni = meta.V_Participante__r.V_DataSumarizador__c;
            }
            Integer month = dataIni.monthsBetween(meta.V_AnoFiscal__r.V_DataFim__c) + 1;

            if(lSetSumarizador.contains(meta.V_Participante__c)) continue;

            for(Integer i = 1; i <= month; i++){
                VN_Sumarizador__c lSumarizador  = new VN_Sumarizador__c();
                lSumarizador.V_MetaDoParticipante__c = meta.Id;
                lSumarizador.Participante__c = meta.V_Participante__c;
                //lSumarizador.V_Mes__c = dataIni.month();
                lSumarizador.V_Mes__c = VN_CargaDadosTempHandler.getMesMeta(meta.V_AnoFiscal__r, dataIni);

                lLstSumarizador.add(lSumarizador);
                dataIni = dataIni.addMonths(1);
            }
        }
        
        if (!lLstSumarizador.isEmpty()){
            system.debug('Sumarizador: ' + lLstSumarizador);
            Database.SaveResult[] lLstResult = Database.insert(lLstSumarizador, false);
            for(integer i=0; i < lLstResult.size(); i++) {
                    
                Database.SaveResult lResult = lLstResult[i];
                VN_Sumarizador__c lSumarizador = lLstSumarizador[i];      
                if(lSumarizador == null) continue;
                        
                if (!lResult.isSuccess()){
                    system.debug('### SX_BatchCriarMetas error insert sumarizador '+' { ' + lSumarizador.Participante__c +' }: ');

                    for(Database.Error err : lResult.getErrors()) {
                        system.debug(err.getMessage());
                    }
                }
            }
        }
    }
}