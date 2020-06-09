/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: PV                                           date: 28/06/2019
* 
* Name: VN_CargaDadosTempHandler.cls
* 
* Handler trigger de VN_CargasDadosTemp__c
*******************************************************************************/
public with sharing class VN_CargaDadosTempHandler {

    private static Map<String, Id> fMapCodCarteiraMemberId;
    private static Map<Id, Map<Integer, VN_Sumarizador__c>> fMapMemberIdMapMesSum;
    private static Map<Id, VN_GerenciadorMetaParticipanteAF__c> fMapMemberIdGerenciadorMeta;

    private static Map<Id, VN_Sumarizador__c> fMapSumarizadorToUpdate;

    public static void updateSumarizador() {
        VN_TriggerCheck.assert();
		
        List<VN_CargasDadosTemp__c> lCargasDadosTempLst = (List<VN_CargasDadosTemp__c>)Trigger.new;
        
        //popula map codcarteira -> member
        fMapCodCarteiraMemberId = new Map<String, Id>();
        for(VN_CargasDadosTemp__c lCargasDadosTemp : lCargasDadosTempLst){
            initMapCarteira(lCargasDadosTemp, fMapCodCarteiraMemberId);
        }
        for(FieloPLT__Member__c lMember : [SELECT Id, V_CodigoCarteira__c FROM FieloPLT__Member__c 
                WHERE V_CodigoCarteira__c =:fMapCodCarteiraMemberId.keySet()]){
            fMapCodCarteiraMemberId.put(lMember.V_CodigoCarteira__c, lMember.Id);
        }
        System.debug(fMapCodCarteiraMemberId);

        //popula map member -> gerenciador meta
        fMapMemberIdGerenciadorMeta = new Map<Id, VN_GerenciadorMetaParticipanteAF__c>();
        for(VN_MetaParticipante__c lMetaParticipante : [SELECT V_Participante__c,
                V_AnoFiscal__r.V_DataInicio__c, V_AnoFiscal__r.V_DataFim__c 
                FROM VN_MetaParticipante__c WHERE V_Participante__c = :fMapCodCarteiraMemberId.values()
                AND V_AnoFiscal__r.V_Vigente__c = true]){
            if(!fMapMemberIdGerenciadorMeta.containsKey(lMetaParticipante.V_Participante__c)){
                fMapMemberIdGerenciadorMeta.put(lMetaParticipante.V_Participante__c, lMetaParticipante.V_AnoFiscal__r);
            }
        }
        System.debug(fMapMemberIdGerenciadorMeta);

        //popula map member/mes -> sumarizador
        fMapMemberIdMapMesSum = new Map<Id, Map<Integer, VN_Sumarizador__c>>();
        for(VN_Sumarizador__c lSumarizador : [SELECT Participante__c, V_Mes__c, V_Meta__c, V_Valor__c, V_ResultadoSE__c
                FROM VN_Sumarizador__c WHERE Participante__c = :fMapCodCarteiraMemberId.values()
                AND V_MetaDoParticipante__r.V_AnoFiscal__r.V_Vigente__c = true
                //AND V_ProcessarCalculos__c = false
                ]){
            
            if(!fMapMemberIdMapMesSum.containsKey(lSumarizador.Participante__c)){
                fMapMemberIdMapMesSum.put(lSumarizador.Participante__c, new Map<Integer, VN_Sumarizador__c>());
            }
            if(!fMapMemberIdMapMesSum.get(lSumarizador.Participante__c).containsKey(lSumarizador.V_Mes__c.intValue()) ){
                fMapMemberIdMapMesSum.get(lSumarizador.Participante__c).put(lSumarizador.V_Mes__c.intValue(), lSumarizador);
            }
        }
        System.debug(fMapMemberIdMapMesSum);

        //
        // Processa os registros
        //

        fMapSumarizadorToUpdate = new Map<Id, VN_Sumarizador__c>();
        for(VN_CargasDadosTemp__c lCargasDadosTemp : lCargasDadosTempLst){
            processaItemCargaDados(lCargasDadosTemp);
        }

        if(!fMapSumarizadorToUpdate.isEmpty()){
            update fMapSumarizadorToUpdate.values();
        }
    }

    private static void processaItemCargaDados(VN_CargasDadosTemp__c aCargasDadosTemp){
        System.debug(aCargasDadosTemp);
        if(aCargasDadosTemp == null) return;

        Date lDate = Date.parse(aCargasDadosTemp.V_Mes__c);
        if(lDate != null){
            processaCampo(aCargasDadosTemp, 'V_CodigoLideranca__c', 'V_SumarizadorDirLideranca__c', lDate);
            processaCampo(aCargasDadosTemp, 'V_CodigoLeaderSetor__c', 'V_SumarizadorLeaderSetor__c', lDate);
            processaCampo(aCargasDadosTemp, 'V_CodigoGerentedeVendas__c', 'V_SumarizadorGerenteVendas__c', lDate);
            processaCampo(aCargasDadosTemp, 'V_CodigoCoordenadorVenda1__c', 'V_SumarizadorCoordVendas1__c', lDate);
            processaCampo(aCargasDadosTemp, 'V_CodigoCoordenadorVendas2__c', 'V_SumarizadorCoordVendas2__c', lDate);
            processaCampo(aCargasDadosTemp, 'V_CodigodoResponsavel3__c', 'V_SumarizadorResponsavel3__c', lDate);
            processaCampo(aCargasDadosTemp, 'V_CodigodoResponsavel2__c', 'V_SumarizadorResponsavel2__c', lDate);
            processaCampo(aCargasDadosTemp, 'V_CodigodoResponsavel1__c', 'V_SumarizadorResponsavel1__c', lDate);
            //processaCampo(aCargasDadosTemp, 'V_CodigoResponsavelCarteira__c', 'V_SumarizadorResponsavelCarteira__c', lDate);
        }
    }

    private static void processaCampo(SObject aCargasDadosTemp, String aFieldName, String aLookupSumarizadorFieldName, Date aDate){
        String lCod = (String)aCargasDadosTemp.get(aFieldName);
        if(String.isNotEmpty(lCod)) {
            Id lMemberId = fMapCodCarteiraMemberId.get(lCod);
            if(lMemberId != null){
                VN_GerenciadorMetaParticipanteAF__c lGm = fMapMemberIdGerenciadorMeta.get(lMemberId);
                if(lGm != null){
                    Integer lMesMeta = getMesMeta(lGm, aDate);
                    Map<Integer, VN_Sumarizador__c> lMapMesSum = fMapMemberIdMapMesSum.get(lMemberId);
                    if(lMapMesSum != null && !lMapMesSum.isEmpty() && lMapMesSum.containsKey(lMesMeta)){
                        VN_Sumarizador__c lSumarizador = lMapMesSum.get(lMesMeta);
                        if(lSumarizador != null){
                            updateValuesSumarizador((VN_CargasDadosTemp__c)aCargasDadosTemp, lSumarizador, aLookupSumarizadorFieldName);
                        }
                    }
                }
            }
        }
    }
    
    private static void updateValuesSumarizador(VN_CargasDadosTemp__c aCargasDadosTemp, VN_Sumarizador__c aSumarizador, String aLookupSumarizadorFieldName){
        if(aCargasDadosTemp == null || aSumarizador == null) return;

        //insert (soma)
        if(Trigger.isInsert){
            if(aSumarizador.V_Meta__c == null) aSumarizador.V_Meta__c = 0.0;
            aSumarizador.V_Meta__c += String.isEmpty(aCargasDadosTemp.V_Meta__c) ? 0.0 : Double.valueOf(aCargasDadosTemp.V_Meta__c);
            
            if(aSumarizador.V_Valor__c == null) aSumarizador.V_Valor__c = 0.0;
            aSumarizador.V_Valor__c += String.isEmpty(aCargasDadosTemp.V_ResultadoTotal__c) ? 0.0 : Double.valueOf(aCargasDadosTemp.V_ResultadoTotal__c);
            
            if(aSumarizador.V_ResultadoSE__c == null) aSumarizador.V_ResultadoSE__c = 0.0;
            aSumarizador.V_ResultadoSE__c += String.isEmpty(aCargasDadosTemp.V_ProdutosEstrategicos__c) ? 0.0 : Double.valueOf(aCargasDadosTemp.V_ProdutosEstrategicos__c);

            fMapSumarizadorToUpdate.put(aSumarizador.Id, aSumarizador);
        } 
        //update (subtrai o valor antigo e soma o novo)
        else if(Trigger.isUpdate) { 
            VN_CargasDadosTemp__c lCargasDadosTempOld = (VN_CargasDadosTemp__c)Trigger.oldMap.get(aCargasDadosTemp.Id);
            if(aSumarizador.V_Meta__c == null) aSumarizador.V_Meta__c = 0.0;
            aSumarizador.V_Meta__c -= String.isEmpty(lCargasDadosTempOld.V_Meta__c) ? 0.0 : Double.valueOf(lCargasDadosTempOld.V_Meta__c);
            
            if(aSumarizador.V_Valor__c == null) aSumarizador.V_Valor__c = 0.0;
            aSumarizador.V_Valor__c -= String.isEmpty(lCargasDadosTempOld.V_ResultadoTotal__c) ? 0.0 : Double.valueOf(lCargasDadosTempOld.V_ResultadoTotal__c);
            
            if(aSumarizador.V_ResultadoSE__c == null) aSumarizador.V_ResultadoSE__c = 0.0;
            aSumarizador.V_ResultadoSE__c -= String.isEmpty(lCargasDadosTempOld.V_ProdutosEstrategicos__c) ? 0.0 : Double.valueOf(lCargasDadosTempOld.V_ProdutosEstrategicos__c);

            aSumarizador.V_Meta__c += String.isEmpty(aCargasDadosTemp.V_Meta__c) ? 0.0 : Double.valueOf(aCargasDadosTemp.V_Meta__c);
            aSumarizador.V_Valor__c += String.isEmpty(aCargasDadosTemp.V_ResultadoTotal__c) ? 0.0 : Double.valueOf(aCargasDadosTemp.V_ResultadoTotal__c);
            aSumarizador.V_ResultadoSE__c += String.isEmpty(aCargasDadosTemp.V_ProdutosEstrategicos__c) ? 0.0 : Double.valueOf(aCargasDadosTemp.V_ProdutosEstrategicos__c);

            fMapSumarizadorToUpdate.put(aSumarizador.Id, aSumarizador);
        }

        //ajuste task #17172 - 27/09/2019
        //aCargasDadosTemp.V_Sumarizador__c = aSumarizador.Id;
        if(!String.isEmpty(aLookupSumarizadorFieldName)){
            aCargasDadosTemp.put(aLookupSumarizadorFieldName, aSumarizador.Id);
        }
        
    }

    private static void initMapCarteira(VN_CargasDadosTemp__c aCargasDadosTemp, Map<String, Id> aMapCodCarteiraMemberId){
        if(String.isNotEmpty(aCargasDadosTemp.V_CodigoLideranca__c)) aMapCodCarteiraMemberId.put(aCargasDadosTemp.V_CodigoLideranca__c, null);
        if(String.isNotEmpty(aCargasDadosTemp.V_CodigoLeaderSetor__c)) aMapCodCarteiraMemberId.put(aCargasDadosTemp.V_CodigoLeaderSetor__c, null);
        if(String.isNotEmpty(aCargasDadosTemp.V_CodigoGerentedeVendas__c)) aMapCodCarteiraMemberId.put(aCargasDadosTemp.V_CodigoGerentedeVendas__c, null);
        if(String.isNotEmpty(aCargasDadosTemp.V_CodigoCoordenadorVenda1__c)) aMapCodCarteiraMemberId.put(aCargasDadosTemp.V_CodigoCoordenadorVenda1__c, null);
        if(String.isNotEmpty(aCargasDadosTemp.V_CodigoCoordenadorVendas2__c)) aMapCodCarteiraMemberId.put(aCargasDadosTemp.V_CodigoCoordenadorVendas2__c, null);
        if(String.isNotEmpty(aCargasDadosTemp.V_CodigodoResponsavel3__c)) aMapCodCarteiraMemberId.put(aCargasDadosTemp.V_CodigodoResponsavel3__c, null);
        if(String.isNotEmpty(aCargasDadosTemp.V_CodigodoResponsavel2__c)) aMapCodCarteiraMemberId.put(aCargasDadosTemp.V_CodigodoResponsavel2__c, null);
        if(String.isNotEmpty(aCargasDadosTemp.V_CodigodoResponsavel1__c)) aMapCodCarteiraMemberId.put(aCargasDadosTemp.V_CodigodoResponsavel1__c, null);
        if(String.isNotEmpty(aCargasDadosTemp.V_CodigoResponsavelCarteira__c)) aMapCodCarteiraMemberId.put(aCargasDadosTemp.V_CodigoResponsavelCarteira__c, null);
    }

    public static Integer getMesMeta(VN_GerenciadorMetaParticipanteAF__c aGerenciadorMetaParticipanteAF, Date aDate){
        Date lDataIniGm = aGerenciadorMetaParticipanteAF.V_DataInicio__c;
        Integer lMonthRange = aGerenciadorMetaParticipanteAF.V_DataInicio__c.monthsBetween(aGerenciadorMetaParticipanteAF.V_DataFim__c)+1;
        for(Integer i = 1; i <= lMonthRange; i++){
            if(aDate.month() == lDataIniGm.month()){
                return i;
            } else {
                lDataIniGm = lDataIniGm.addMonths(1);
            }
        }
        return 0;
    }
}