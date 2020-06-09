//ObjectPluralName is the Action Object name. ObjectAPIName is the API Name of the object to process.
trigger AT_Sumarizador on VN_Sumarizador__c(after insert, after update, before insert, before update){
  
    if(Trigger.isBefore){

        //ATUALIZAÇÃO DE VALORES DO PRÓPRIO REGISTRO
        for(VN_Sumarizador__c lSumarizador : Trigger.new){
            //1 - VN_SUMIDX Ano Fiscal
            //OR( ISCHANGED(V_Meta__c ), ISCHANGED(V_MesFYAnterior__c ) )
            if(VN_TriggerCheck.isChanged(lSumarizador, VN_Sumarizador__c.V_Meta__c) 
                    || VN_TriggerCheck.isChanged(lSumarizador, VN_Sumarizador__c.V_MesFYAnterior__c)){
                if(lSumarizador.V_Meta__c == 0)
                    lSumarizador.V_IDXAnoFiscal__c = lSumarizador.V_MesFYAnterior__c;
                else if(lSumarizador.V_Meta__c > 0)
                    lSumarizador.V_IDXAnoFiscal__c = lSumarizador.V_MesFYAnterior__c  + 1;
                else 
                    lSumarizador.V_IDXAnoFiscal__c = lSumarizador.V_MesFYAnterior__c;
            }

            //4 - VN_SUMIDX Semestre
            //OR (ISCHANGED(V_Meta__c), ISCHANGED(V_IDXSemestreAnterior__c))
            if(VN_TriggerCheck.isChanged(lSumarizador, VN_Sumarizador__c.V_Meta__c)
                    || VN_TriggerCheck.isChanged(lSumarizador, VN_Sumarizador__c.V_IDXSemestreAnterior__c)){

                if (lSumarizador.V_Mes__c == 1 && lSumarizador.V_Meta__c == 0)
                    lSumarizador.V_IDXSemestre__c = 0;
                else if(lSumarizador.V_Mes__c == 7 && lSumarizador.V_Meta__c == 0)
                    lSumarizador.V_IDXSemestre__c = 0;
                else if(lSumarizador.V_Mes__c == 1 && lSumarizador.V_Meta__c > 0)
                    lSumarizador.V_IDXSemestre__c = 1;
                else if(lSumarizador.V_Mes__c == 7 && lSumarizador.V_Meta__c > 0)
                    lSumarizador.V_IDXSemestre__c = 1;
                else if(lSumarizador.V_Meta__c == 0) 
                    lSumarizador.V_IDXSemestre__c = lSumarizador.V_IDXSemestreAnterior__c;
                else
                    lSumarizador.V_IDXSemestre__c = 1 + lSumarizador.V_IDXSemestreAnterior__c;
            }
            
            //7 - VN_SUMIDX Trimestre
            //OR(ISCHANGED(V_Meta__c), ISCHANGED(V_IDXTrimestreAnterior__c))
            if(VN_TriggerCheck.isChanged(lSumarizador, VN_Sumarizador__c.V_Meta__c)
                    || VN_TriggerCheck.isChanged(lSumarizador, VN_Sumarizador__c.V_IDXTrimestreAnterior__c)){

                if(lSumarizador.V_Mes__c == 1 && lSumarizador.V_Meta__c == 0)
                    lSumarizador.V_IDXTrimestre__c = 0;
                else if(lSumarizador.V_Mes__c == 4 && lSumarizador.V_Meta__c == 0)
                    lSumarizador.V_IDXTrimestre__c = 0;
                else if(lSumarizador.V_Mes__c == 7 && lSumarizador.V_Meta__c == 0)
                    lSumarizador.V_IDXTrimestre__c = 0;
                else if (lSumarizador.V_Mes__c == 10 && lSumarizador.V_Meta__c == 0)
                    lSumarizador.V_IDXTrimestre__c = 0;
                else if(lSumarizador.V_Mes__c == 1 && lSumarizador.V_Meta__c > 0)
                    lSumarizador.V_IDXTrimestre__c = 1;
                else if(lSumarizador.V_Mes__c == 4 && lSumarizador.V_Meta__c > 0)
                    lSumarizador.V_IDXTrimestre__c = 1;
                else if(lSumarizador.V_Mes__c == 7 && lSumarizador.V_Meta__c > 0) 
                    lSumarizador.V_IDXTrimestre__c = 1;
                else if(lSumarizador.V_Mes__c == 10 && lSumarizador.V_Meta__c > 0)
                    lSumarizador.V_IDXTrimestre__c = 1;
                else if(lSumarizador.V_Meta__c == 0)
                    lSumarizador.V_IDXTrimestre__c = lSumarizador.V_IDXTrimestreAnterior__c;
                else
                    lSumarizador.V_IDXTrimestre__c = 1 + lSumarizador.V_IDXTrimestreAnterior__c;
            }
        }
    } else if(Trigger.isAfter){

        if(Trigger.isInsert || Trigger.isUpdate){

            Map<Id, VN_Sumarizador__c> lMapMetaSumarizador = new Map<Id, VN_Sumarizador__c>();

            for(VN_Sumarizador__c lSumarizador : Trigger.new){
                
                //Se Processar Mecânicas já estava true, reprocessar
                //Se foi mudado pra true já foi processado no Batch SX_BatchProcessarMecanica (não deve entrar aqui)
                if (VN_TriggerCheck.isChangedFromTo(lSumarizador, VN_Sumarizador__c.V_ProcessarMecanicas__c, true, true)){
                    lMapMetaSumarizador.put(lSumarizador.V_MetaDoParticipante__c, lSumarizador);
                }
            }

            List<VN_MetaParticipante__c> lstMetaToUpdate = new List<VN_MetaParticipante__c>();
            if(!lMapMetaSumarizador.isEmpty()){
                List<VN_MetaParticipante__c> lstMeta = new List<VN_MetaParticipante__c>();
                
                lstMeta = [SELECT V_AMYTD__c, V_PercentualAM1Semestre__c, V_TotalMetas1Semestre__c, V_TotaldeVendas1Semestre__c,
                        V_PercentualAM2Semestre__c, V_TotalMetas2Semestre__c, V_TotaldeVendas2Semestre__c,
                        V_PercentualAM1Trimestre__c, V_TotalMetas1Trimestre__c, V_TotaldeVendas1Trimestre__c,
                        V_PercentualAM2Trimestre__c, V_TotalMetas2Trimestre__c, V_TotaldeVendas2Trimestre__c,
                        V_PercentualAM3Trimestre__c, V_TotalMetas3Trimestre__c, V_TotaldeVendas3Trimestre__c,
                        V_PercentualAM4Trimestre__c, V_TotalMetas4Trimestre__c, V_TotaldeVendas4Trimestre__c,
                        V_ScoreSuperacaoQ1__c, V_ScoreSuperacaoFY__c, V_UltimoMesAtualizado__c
                        FROM VN_MetaParticipante__c WHERE Id =: lMapMetaSumarizador.keySet()];

                if(!lstMeta.isEmpty()){

                    for(VN_MetaParticipante__c lMeta : lstMeta){
                        VN_Sumarizador__c lSum = lMapMetaSumarizador.get(lMeta.Id);
                        Boolean lUpdate = false;

                        // Só atualiza Percentual se Mês do Sumarizador for igual ao Último Mês Processado na Meta
                        if(lSum.V_MesString__c == lMeta.V_UltimoMesAtualizado__c){
                            lMeta.V_AMYTD__c = lSum.V_PercentualAMYTD__c;

                            //Novo - Atribui Score (Ating. e Sup)
                            lMeta.V_ScoreAtingimentoFY__c = lSum.V_ScoreAMYTD__c;
                            lMeta.V_ScoreSuperacaoFY__c = lSum.V_ScoreSMYTD__c;
                            lUpdate = true;
                        }

                        //Atualiza 1º Trimestre Meta Participante
                        if(lSum.V_Mes__c == 3){
                            lMeta.V_PercentualAM1Trimestre__c = lSum.V_PercentualAMYTDTrimestre__c;
                            lMeta.V_TotalMetas1Trimestre__c = lSum.V_MetaYTDTrimestre__c;
                            lMeta.V_TotaldeVendas1Trimestre__c = lSum.V_ValorYTDTrimestre__c;
                            lUpdate = true;
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
                            lUpdate = true;
                        }

                        //Atualiza 3º Trimestre Meta Participante
                        if(lSum.V_Mes__c == 9){
                            lMeta.V_PercentualAM3Trimestre__c = lSUm.V_PercentualAMYTDTrimestre__c;
                            lMeta.V_TotalMetas3Trimestre__c = lSum.V_MetaYTDTrimestre__c;
                            lMeta.V_TotaldeVendas3Trimestre__c = lSum.V_ValorYTDTrimestre__c;
                            lUpdate = true;
                        }

                        //Atualiza 2º Semestre Meta Participante
                        //Atualiza 4º Trimestre Meta Participante
                        if(lSum.V_Mes__c == 12){
                            lMeta.V_PercentualAM2Semestre__c = lSum.V_PercentualAMYTDSemestre__c;
                            lMeta.V_TotalMetas2Semestre__c = lSum.V_MetaYTDSemestre__c;
                            lMeta.V_TotaldeVendas2Semestre__c = lSum.V_ValorYTDSemestre__c;
                            lMeta.V_PercentualAM4Trimestre__c = lSum.V_PercentualAMYTDTrimestre__c;
                            lMeta.V_TotalMetas4Trimestre__c = lSum.V_MetaYTDTrimestre__c;
                            lMeta.V_TotaldeVendas4Trimestre__c = lSum.V_ValorYTDTrimestre__c;
                            lUpdate = true;
                        }

                        //Atualiza | Score de Superação Q1
                        if(lSum.V_Mes__c == 1 || lSum.V_Mes__c == 2 || lSum.V_Mes__c == 3){
                            lMeta.V_ScoreSuperacaoQ1__c = lSum.V_ScoreSMQ1__c;
                            lUpdate = true;
                        }

                        if(lUpdate)
                            lstMetaToUpdate.add(lMeta);
                    } 
                }   
            }
            if(!lstMetaToUpdate.isEmpty())
                update lstMetaToUpdate;
        }
        
        if(Trigger.isInsert){
            FieloPLT.SObjectService.processRecords(Trigger.new, null);  
        }else if(Trigger.isUpdate){
            FieloPLT.SObjectService.processRecords(Trigger.new, Trigger.oldMap);
        }
    }
}