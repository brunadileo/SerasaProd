/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 13/09/2018
* 
* Name: SX_GerenciadorMetaParticipanteAF_Before.cls
* 
* Classe para disparar ações before em VN_GerenciadorMetaParticipanteAF__c
*******************************************************************************/
public with sharing class SX_GerenciadorMetaParticipanteAF_Before {

	public static void verificarVigenciaUnica() {

		VN_TriggerCheck.assert();

		List<VN_GerenciadorMetaParticipanteAF__c> lLstGerenciador = new List< VN_GerenciadorMetaParticipanteAF__c>();
	  	for (VN_GerenciadorMetaParticipanteAF__c gerenciador : (List<VN_GerenciadorMetaParticipanteAF__c>) trigger.new) {

	  		if(gerenciador.V_Vigente__c){
		  		lLstGerenciador.add(gerenciador);
		  	}
	  	}
	  	if(lLstGerenciador.isEmpty()) return;

	  	List<AggregateResult> lLstAgg = [SELECT COUNT(Id) total 
	  									  FROM VN_GerenciadorMetaParticipanteAF__c
	  									  WHERE V_Vigente__c = true
	  									  AND Id !=: lLstGerenciador];


	  	for(VN_GerenciadorMetaParticipanteAF__c gerenciador: lLstGerenciador){

	  		if(lLstAgg != null && Integer.valueOf(lLstAgg[0].get('total')) > 0)
	  			gerenciador.addError('Não é possível atualizar o Gerenciador de Metas por já haver outro vigente. Por favor, verificar.');
	  	}
	}
}