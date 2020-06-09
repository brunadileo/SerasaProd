/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV -- autalizado por LK                         date: 11/09/2018
* 
*
* Batch para atualizar os campos "Processar Cálculos" do Participante
*
*******************************************************************************/
global class SX_BatchProcessarCalculos implements Database.Batchable<sObject>, Database.Stateful {

	global String fAnoFiscal;
	global String fMes;
	global Integer fMonth;
	global String fMsgErro;
	global List<VN_Sumarizador__c> lLstSumarizadoresAlterados;
	
	global SX_BatchProcessarCalculos(String aAno, Integer aMes) {
		lLstSumarizadoresAlterados = new List<VN_Sumarizador__c>();
		if(SX_Utils.batchIsProcessing('SX_BatchProcessarCalculos')) return;
		fAnoFiscal = aAno;
		fMonth = aMes;
		fMsgErro = '';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {

		return Database.getQueryLocator([SELECT V_ProcessarCalculos__c, V_MetaDoParticipante__c, V_Mes__c, 
										Participante__c, V_Ponderou__c, V_PercentualAMYTDTrimestre__c
										FROM VN_Sumarizador__c
										WHERE V_MetaDoParticipante__r.Name =: fAnoFiscal 
										AND V_Mes__c =: fMonth 
										AND V_ProcessarCalculos__c = false]);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {

   		if ( scope == null || scope.isEmpty()) return; 

		//Nova estrutura
		List<VN_Sumarizador__c> lLstSumarizadores = (List<VN_Sumarizador__c>) scope;
		lLstSumarizadoresAlterados.addAll(lLstSumarizadores);
		Set<Id> lSetMetas = new Set<Id>();

		for(VN_Sumarizador__c lSumarizador : lLstSumarizadores)
			lSetMetas.add(lSumarizador.V_MetaDoParticipante__c);

		if(!lSetMetas.isEmpty()){
			Double lMesAnterior = lLstSumarizadores[0].V_Mes__c - 1;

            //Busca o Sumarizador do mês anterior
            List<VN_Sumarizador__c> lstSumarizadoresAntigos = new List<VN_Sumarizador__c>();
            lstSumarizadoresAntigos = [SELECT V_MetaDoParticipante__c, V_ValorYTD__c, V_MetaYTDPeriodo__c,
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
                                    WHERE V_MetaDoParticipante__c =: lSetMetas AND V_Mes__c =: lMesAnterior];

		 	Map<Id,VN_Sumarizador__c> lMapSumarizador = new Map<Id, VN_Sumarizador__c>();

            if(!lstSumarizadoresAntigos.isEmpty()){
                for(VN_Sumarizador__c lSumarizador : lstSumarizadoresAntigos){
                    lMapSumarizador.put(lSumarizador.V_MetaDoParticipante__c, lSumarizador);
                }
            }

			//Grava os valores do Sumarizador do mês anterior para o novo sumarizador
            // nos campos com denominação 'anterior'
            for(VN_Sumarizador__c lSumarizador : lLstSumarizadores){
                if(lMapSumarizador.containsKey(lSumarizador.V_MetaDoParticipante__c)){
                    VN_Sumarizador__c lSumarizadorAnterior =  lMapSumarizador.get(lSumarizador.V_MetaDoParticipante__c);
                    lSumarizador.V_ReferenciaMesAnterior__c = lSumarizadorAnterior.Id;
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
                }
            }							
		}
		Database.SaveResult[] lLstResult = database.update(lLstSumarizadores, false);
	  	 
	  	for(integer i=0; i < lLstResult.size(); i++) {
	 	
	 	    Database.SaveResult lResult = lLstResult[i];

			VN_Sumarizador__c lSumarizador = lLstSumarizadores[i];
			if(lSumarizador == null) continue;		 	
	 	    
	 	    if (!lResult.isSuccess()){
		  		for(Database.Error err : lResult.getErrors()) {
					fMsgErro += ' { ' + lSumarizador.Id +' }: '+err.getMessage()+' --FIM-- ';
			    }
		    }  
	  	}
	}
	
	global void finish(Database.BatchableContext BC) {
		
		// Marca processar cálculos para true, isto deve ocorrer após todos os sumarizadores 
		// terem os campos corretamente preenchidos
		if(!lLstSumarizadoresAlterados.isEmpty()){
			for(VN_Sumarizador__c lSumarizador : lLstSumarizadoresAlterados)
				lSumarizador.V_ProcessarCalculos__c = true;
			Database.SaveResult[] lLstResult = database.update(lLstSumarizadoresAlterados, false);
	  	 
	  		for(integer i=0; i < lLstResult.size(); i++) {
	 	    	Database.SaveResult lResult = lLstResult[i];
				VN_Sumarizador__c lSumarizador = lLstSumarizadoresAlterados[i];
				if(lSumarizador == null) continue;		 	
	 	    
		 	    if (!lResult.isSuccess()){
			  		for(Database.Error err : lResult.getErrors()) {
						fMsgErro += ' { ' + lSumarizador.Id +' }: '+err.getMessage()+' --FIM-- ';
			    	}
		    	}
			}
			// Após ter preenchido as informações corretamente no Sumarizador e ter 
			// setado Processar cálculos para true (o que da start para Process Builder que preenchem outros campos)
			// Trazer a informação da Meta do Líder vínculado ao participante
			Set<Id> lSetMember = new Set<Id>();
			Map<Id, VN_Sumarizador__c> lMapLiderSumarizador = new Map<Id, VN_Sumarizador__c>();
        	for(VN_Sumarizador__c lSumarizador: lLstSumarizadoresAlterados){
        	    lSetMember.add(lSumarizador.Participante__c);
				lMapLiderSumarizador.put(lSumarizador.Participante__c, lSumarizador);
        	}

        	if(!lSetMember.isEmpty()){
            	//Busca os participantes dos Sumarizadores
            	Map<Id, FieloPLT__Member__c> lMapMember = new Map <Id, FieloPLT__Member__c>();
            	List<FieloPLT__Member__c> lstMember = [SELECT V_Area__c, V_Setor__c, V_Lideranca__c, 
                                                V_Cargo__c, V_Ponderar__c, V_LiderImediato__c,
                                                V_LiderImediato__r.V_MetasAnoFiscalVigenteNovo__r.V_PercentualAM1Trimestre__c,
                                                V_LiderImediato__r.V_MetasAnoFiscalVigenteNovo__r.V_PercentualAM2Trimestre__c,
                                                V_LiderImediato__r.V_MetasAnoFiscalVigenteNovo__r.V_PercentualAM3Trimestre__c,
                                                V_LiderImediato__r.V_MetasAnoFiscalVigenteNovo__r.V_PercentualAM4Trimestre__c
                                                FROM FieloPLT__Member__c WHERE Id = : lSetMember];
            	if(!lstMember.isEmpty()){
        	        for(FieloPLT__Member__c lMember : lstMember)
    	                lMapMember.put(lMember.Id, lMember);
	            }

        	    //Percore a lista de sumarizadores, busca o Participante correto no mapa de Participantes
    	        // e insere os dados do participante no Sumarizador 
            	for(VN_Sumarizador__c lSumarizador : lLstSumarizadoresAlterados){
            	    if(lMapMember.containsKey(lSumarizador.Participante__c)){
                	    FieloPLT__Member__c lParticipante = lMapMember.get(lSumarizador.Participante__c);
            	        if(lParticipante.V_Area__c != null)
                    	    lSumarizador.V_Area__c = lParticipante.V_Area__c.left(255);
                    	if(lParticipante.V_Setor__c != null)    
                	        lSumarizador.V_Setor__c = lParticipante.V_Setor__c.left(255);
            	        if(lParticipante.V_Lideranca__c != null)    
                        	lSumarizador.V_Lideranca__c = lParticipante.V_Lideranca__c.left(255);
                    	if(lParticipante.V_Cargo__c != null)
                	        lSumarizador.V_Cargo__c = lParticipante.V_Cargo__c.left(255);
            	        if(lParticipante.V_LiderImediato__c != null)    
        	                lSumarizador.V_LiderImediato__c = lParticipante.V_LiderImediato__c;
    	                if(lParticipante.V_Ponderar__c == 'Sim')
	                        lSumarizador.V_Ponderou__c = true;

						if(lParticipante.V_LiderImediato__c != null && lMapLiderSumarizador.containsKey(lParticipante.V_LiderImediato__c)
								&& lMapLiderSumarizador.get(lParticipante.V_LiderImediato__c).V_PercentualAMYTDTrimestre__c != null)
							lSumarizador.V_PercAMLiderImediatoQuarter__c = lMapLiderSumarizador.get(lParticipante.V_LiderImediato__c).V_PercentualAMYTDTrimestre__c;
						
						//Integer quarter = Integer.valueOf(lSumarizador.V_Mes__c) - 1;
                	    //quarter = quarter / 3;
						
						// if(quarter == 0 && lParticipante.V_LiderImediato__r.V_MetasAnoFiscalVigenteNovo__r.V_PercentualAM1Trimestre__c != null)
        	            //     lSumarizador.V_PercAMLiderImediatoQuarter__c = lParticipante.V_LiderImediato__r.V_MetasAnoFiscalVigenteNovo__r.V_PercentualAM1Trimestre__c;
                   
    	                // else if(quarter == 1 && lParticipante.V_LiderImediato__r.V_MetasAnoFiscalVigenteNovo__r.V_PercentualAM2Trimestre__c != null)
	                    //     lSumarizador.V_PercAMLiderImediatoQuarter__c = lParticipante.V_LiderImediato__r.V_MetasAnoFiscalVigenteNovo__r.V_PercentualAM2Trimestre__c;

                    	// else if (quarter == 2 && lParticipante.V_LiderImediato__r.V_MetasAnoFiscalVigenteNovo__r.V_PercentualAM3Trimestre__c != null)
                    	//     lSumarizador.V_PercAMLiderImediatoQuarter__c = lParticipante.V_LiderImediato__r.V_MetasAnoFiscalVigenteNovo__r.V_PercentualAM3Trimestre__c;
                    
                    	// else if(lParticipante.V_LiderImediato__r.V_MetasAnoFiscalVigenteNovo__r.V_PercentualAM4Trimestre__c != null) 
                    	//     lSumarizador.V_PercAMLiderImediatoQuarter__c = lParticipante.V_LiderImediato__r.V_MetasAnoFiscalVigenteNovo__r.V_PercentualAM4Trimestre__c;
                	}
            	}

				Database.SaveResult[] lLstResult2 = database.update(lLstSumarizadoresAlterados, false);
	  			for(integer i=0; i < lLstResult2.size(); i++) {
	 	    		Database.SaveResult lResult = lLstResult2[i];

					VN_Sumarizador__c lSumarizador = lLstSumarizadoresAlterados[i];
					if(lSumarizador == null) continue;		 	
	 	    
	 		    	if (!lResult.isSuccess()){
			  			for(Database.Error err : lResult.getErrors()) {
							fMsgErro += ' { ' + lSumarizador.Id +' }: '+err.getMessage()+' --FIM-- ';
			    		}
		   	 		}
        		}
			}

			//Ao final tem que alterar Ponderar no Member para Não
			List<FieloPLT__Member__c> lstMember = new List<FieloPLT__Member__c>();
			for(VN_Sumarizador__c lSumarizador : lLstSumarizadoresAlterados){
				if(lSumarizador.V_Ponderou__c == true){
					lstMember.add( new FieloPLT__Member__c (
                    	Id = lSumarizador.Participante__c,
                	    V_Ponderar__c = 'Não'));
            	}
        	}
        	if(!lstMember.isEmpty()){
				Database.SaveResult[] lLstResult3 = database.update(lstMember, false);
	  	 
		  		for(integer i=0; i < lLstResult3.size(); i++) {
	 	    		Database.SaveResult lResult = lLstResult3[i];

					FieloPLT__Member__c lMember = lstMember[i];
					if(lMember == null) continue;		 	
	 	    
		 	    	if (!lResult.isSuccess()){
			  			for(Database.Error err : lResult.getErrors()) {
							fMsgErro += ' { ' + lMember.Id +' }: '+err.getMessage()+' --FIM-- ';
			    		}
		   	 		}
        		}
			}

			if(String.isNotEmpty(fMsgErro)){
				insert new VN_LogBatch__c(V_Processo__c = 'Processar Cálculos',
					V_IdBatch__c = BC.getJobId(), V_ErroResultado__c = fMsgErro.left(32768));
			}
		}
	}	
}