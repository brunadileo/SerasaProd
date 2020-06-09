/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 26/09/2018
* 
* Name: SX_MetasParticipantes_Before.cls
* 
* Classe para disparar ações before em VN_MetasParticipantes__c
*******************************************************************************/
public with sharing class SX_MetasParticipantes_Before { 

	public static void atualizarPersona() {

		VN_TriggerCheck.assert();

		//Integer[] lLstGap = new Integer[]{2,3,4,5,6,7,8,9,10,11,12,1};
		//Integer[] lLstMesDe = new Integer[]{5,6,7,8,9,10,11,12,1,2,3,4};
		//Integer[] lLstlMesAte = new Integer[]{4,5,6,7,8,9,10,11,12,1,2,3};
		
		Integer[] lLstGap = new Integer[]{1,2,3,4,5,6,7,8,9,10,11,12};        
		Integer[] lLstMesDe = new Integer[]{4,5,6,7,8,9,10,11,12,1,2,3};
		Integer[] lLstlMesAte = new Integer[]{3,4,5,6,7,8,9,10,11,12,1,2};

		for(VN_MetasParticipantes__c meta :(List<VN_MetasParticipantes__c>) trigger.new) {

			if(VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasPrimeiroMesAF__c, true)
				|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasSegundoMesAF__c, true)
				|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasTerceiroMesAF__c, true)
				|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasQuartoMesAF__c, true)
				|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasQuintoMesAF__c, true)
				|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasSextoMesAF__c, true)
				|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasSetimoMesAF__c, true)
				|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasOitavoMesAF__c, true)
				|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasNonoMesAF__c, true)
				|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasDecimoMesAF__c, true)
				|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasDecimoPrimeiroAF__c, true)
				|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasDecimoSegundoAF__c, true)){

				Integer lMes = VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasPrimeiroMesAF__c, true) ? 1
							   : VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasSegundoMesAF__c, true) ? 2
							   : VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasTerceiroMesAF__c, true) ? 3
							   : VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasQuartoMesAF__c, true) ? 4
							   : VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasQuintoMesAF__c, true) ? 5
							   : VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasSextoMesAF__c, true) ? 6
							   : VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasSetimoMesAF__c, true) ? 7
							   : VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasOitavoMesAF__c, true) ? 8
							   : VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasNonoMesAF__c, true) ? 9
							   : VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasDecimoMesAF__c, true) ? 10
							   : VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarMecanicasDecimoPrimeiroAF__c, true) ? 11
							   : 12; //meta.V_ProcessarMecanicasDecimoSegundoAF__c 

				Integer lMesGap = lLstGap[lMes - 1]; 
				Integer lMesDe = lLstMesDe[lMes - 1];
				Integer lMesAte = lLstlMesAte[lMes - 1];

				if(lMesGap == 1){
					meta.put('V_ClassificacaoPersonaMes'+lMes+'__c', meta.V_CargoPersona__c +'-');
					continue;
				} 

				Decimal lGapMeta = (Decimal) meta.get('V_GAPMetaAte'+lMesGap+'oMesAF__c'); 
				Decimal lDifPercentual = (Decimal) meta.get('V_DiferencaPercentualAMAteMes'+lMesDe+'AteMes'+lMesAte+'__c');
				if(lGapMeta == null || lDifPercentual == null) continue; 

				String lClassificacao = lGapMeta > 0 && lDifPercentual < 0 ? 'Warn'
										: lGapMeta > 0 && lDifPercentual >= 0 ? 'Cold'
										: lGapMeta == 0 && lDifPercentual < 0 ? 'Warm'
										: lGapMeta == 0 && lDifPercentual == 0 ? 'Hot'
										: lGapMeta == 0 && lDifPercentual > 0 ? 'Gold': '';

				meta.put('V_ClassificacaoPersonaMes'+lMes+'__c', meta.V_CargoPersona__c +''+ lClassificacao);
			}                                            
		}
	} 

	public static void calcularMediaPonderada() {

		VN_TriggerCheck.assert();

		//Map<Id, Map<Id,Decimal>> lMapMesDe = new Map<Id, Map<Id,Decimal>>();
		//Map<Id, Map<Id,Decimal>> lMapMesAte = new Map<Id, Map<Id,Decimal>>();
		//Map<Id, List<VN_MetasParticipantes__c>> lMapMemberMeta = new Map<Id, List<VN_MetasParticipantes__c>>();
		//for(VN_MetasParticipantes__c meta :(List<VN_MetasParticipantes__c>) trigger.new) {

		//	if(meta.V_Ponderacao__c &&
		//		(VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosTerceiroMesAF__c, true)
		//		|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosQuartoMesAF__c, true)
		//		|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosQuintoMesAF__c, true)
		//		|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosSextoMesAF__c, true)
		//		|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosSetimoMesAF__c, true)
		//		|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosOitavoMesAF__c, true)
		//		|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosNonoMesAF__c, true)
		//		|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosDecimoMesAF__c, true)
		//		|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosDecimoPrimeiroMesAF__c, true)
		//		|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosDecimoSegundoMesAF__c, true))){

		//		// TERCEIRO (>=4 && <=6) 
		//		// QUARTO (>=4 && <=7) 
		//		// QUINTO (>=4 && <=8) 
		//		// SEXTO (>=4 && <=9) 
		//		// SÉTIMO (>=4 && <=10)
		//		// OITAVO (>=4 && <=11) 
		//		// NONO (>=4 && <=12) 
		//		// DÉCIMO (>=4 && <=12) 
		//		// DÉCIMO PRIMEIRO (>=4 && <=12) 
		//		// DECIMO SEGUNDO (>=1 && <=12)
			
		//		Integer lMesDe = VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosTerceiroMesAF__c, true) 
		//						|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosQuartoMesAF__c, true) 
		//						|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosQuintoMesAF__c, true) 
		//						|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosSextoMesAF__c, true) 
		//						|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosSetimoMesAF__c, true) 
		//						|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosOitavoMesAF__c, true) 
		//						|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosNonoMesAF__c, true) 
		//						|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosDecimoMesAF__c, true) 
		//						|| VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosDecimoPrimeiroMesAF__c, true) 
		//						? 4 : 1;

		//		Integer lMesAte = VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosTerceiroMesAF__c, true) ? 6
		//					   : VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosQuartoMesAF__c, true) ? 7
		//					   : VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosQuintoMesAF__c, true) ? 8
		//					   : VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosSextoMesAF__c, true) ? 9
		//					   : VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosSetimoMesAF__c, true) ? 10
		//					   : VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosOitavoMesAF__c, true) ? 11 : 12;

		//		//Monta mapa com mês "inicio"
		//		Map<Id,Decimal> lMapMesDeAux = lMapMesDe.get(meta.V_Participante__c);
		//		if(lMapMesDeAux == null){
		//			lMapMesDeAux = new Map<Id,Decimal>();
		//			lMapMesDe.put(meta.V_Participante__c, lMapMesDeAux);
		//		}
		//		lMapMesDeAux.put(meta.Id, lMesDe);

		//		//monta mapa com "mes fim"
		//		Map<Id,Decimal> lMapMesAteAux = lMapMesAte.get(meta.V_Participante__c);
		//		if(lMapMesAteAux == null){
		//			lMapMesAteAux = new Map<Id,Decimal>();
		//			lMapMesAte.put(meta.V_Participante__c, lMapMesAteAux);
		//		}
		//		lMapMesAteAux.put(meta.Id, lMesAte);

		//		List<VN_MetasParticipantes__c> lLstMetaAux = lMapMemberMeta.get(meta.V_Participante__c);
		//		if(lLstMetaAux == null){
		//			lLstMetaAux = new List<VN_MetasParticipantes__c>();
		//			lMapMemberMeta.put(meta.V_Participante__c, lLstMetaAux);
		//		}
		//		lLstMetaAux.add(meta);
		//	}
		//}
		//if(lMapMemberMeta.isEmpty()) return;

		//Map<Id, Decimal> lMapSomaResultadoAgrup = new Map<Id, Decimal>();
		//Map<Id, Integer> lMapQtdRegistros = new Map<Id, Integer>();

		////agrupa Resultados de acordo com os participantes
		//for(AggregateResult aggResultado: [SELECT V_Participante__c member, CALENDAR_MONTH(V_PeriodoVenda__c) mes, V_ChaveComposta__c chave, COUNT(Id) totalDeRegistros, SUM(V_Valor__c) soma, MAX(Meta__c) meta
		//	   FROM VN_Resultado__c WHERE V_Participante__c =: lMapMemberMeta.keySet() GROUP BY V_Participante__c, CALENDAR_MONTH(V_PeriodoVenda__c), V_ChaveComposta__c]){

		//  	if(aggResultado.get('member') == null ||aggResultado.get('mes') == null || aggResultado.get('chave') == null
		//	  || aggResultado.get('totalDeRegistros') == null || aggResultado.get('soma') == null || aggResultado.get('meta') == null) continue;

		//	Id lIdMember = (Id) aggResultado.get('member');
		//	String lChave = (String) aggResultado.get('chave');
		//	Decimal lMes = (Decimal) aggResultado.get('mes');
		//	Decimal lSoma = (Decimal) aggResultado.get('soma');
		//	Decimal lMeta = (Decimal) aggResultado.get('meta');
		//	Integer lTotalDeRegistros = (Integer) aggResultado.get('totalDeRegistros');

		//	List<VN_MetasParticipantes__c> lLstMeta = lMapMemberMeta.get(lIdMember);
		//	Map<Id, Decimal> lMapMesDeAux =  lMapMesDe.get(lIdMember);
		//	Map<Id, Decimal> lMapMesAteAux = lMapMesAte.get(lIdMember);
		//	if(lLstMeta == null || lMapMesDeAux == null || lMapMesAteAux == null) continue;

			
		//	for(VN_MetasParticipantes__c meta: lLstMeta){

		//		Decimal lMesDe = lMapMesDeAux.get(meta.Id);
		//		Decimal lMesAte = lMapMesAteAux.get(meta.Id);

		//		if(lMesDe == null || lMesAte == null) continue;

		//		//verifica se resultado está dentro do intervalo de mês correspondente
		//		if(lMes >= lMesDe && lMes <= lMesAte){

		//			//guarda quantidade de registro agrupado por Mês/Chave
		//			lMapQtdRegistros.put(meta.Id, lTotalDeRegistros);

		//			Decimal lResultadoDivisao = lSoma == 0 || lMeta == 0 ? 0 : ((lSoma / lMeta) * lTotalDeRegistros);

		//			Decimal lSumarizacaoCalculo = lMapSomaResultadoAgrup.get(meta.Id);
		//			if(lSumarizacaoCalculo == null){
		//				lSumarizacaoCalculo = lResultadoDivisao;
		//			} else lSumarizacaoCalculo += lResultadoDivisao;

		//			lMapSomaResultadoAgrup.put(meta.Id, lResultadoDivisao); 
		//		} 
		//	}
		//}

		//for(Id lId: lMapMemberMeta.keySet()){

		//	List<VN_MetasParticipantes__c> lLstMeta = lMapMemberMeta.get(lId);
		//	if(lLstMeta == null) continue;

		//	for(VN_MetasParticipantes__c meta: lLstMeta){

		//		Decimal lSomaResultado = lMapSomaResultadoAgrup.get(meta.Id);
		//		Integer lQtdRegistros = lMapQtdRegistros.get(meta.Id);

		//		if(lSomaResultado == null || lQtdRegistros == null) continue;

		//		Decimal lResultadoFinal = lSomaResultado == 0 || lQtdRegistros == 0 ? 0 : (lSomaResultado / lQtdRegistros);

		//		if(VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosTerceiroMesAF__c, true)){
		//			meta.V_AMAteTerceiroMesAFPonderado__c = lResultadoFinal;
		//		}else if(VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosQuartoMesAF__c, true)){
		//			meta.V_AMAteQuartoMesAFPonderado__c = lResultadoFinal;
		//		} else if(VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosQuintoMesAF__c, true)){
		//			meta.V_AMAteQuintoMesAFPonderado__c = lResultadoFinal;
		//		} else if(VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosSextoMesAF__c, true)){
		//			meta.V_AMAteSextoMesAFPonderado__c = lResultadoFinal;
		//		} else if(VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosSetimoMesAF__c, true)){
		//			meta.V_AMAteSetimoMesAFPonderado__c = lResultadoFinal;
		//		} else if(VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosOitavoMesAF__c, true)){
		//			meta.V_AMAteOitavoMesAFPonderado__c = lResultadoFinal;
		//		} else if(VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosNonoMesAF__c, true)){
		//			meta.V_AMAteNonoMesAFPonderado__c = lResultadoFinal;
		//		} else if(VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosDecimoMesAF__c, true)){
		//			meta.V_AMAteDecimoMesAFPonderado__c = lResultadoFinal;
		//		} else if(VN_TriggerCheck.isChangedTo(meta, VN_MetasParticipantes__c.V_ProcessarCalculosDecimoPrimeiroMesAF__c, true)){
		//			meta.V_AMAteDecimoPrimeiroMesAFPonderado__c = lResultadoFinal;
		//		} else {
		//			meta.V_AMAteDecimoSegundoMesAFPonderado__c = lResultadoFinal;
		//		}
		//	}		
		//}
	}
}