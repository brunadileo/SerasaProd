/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 25/10/2018
* 
* Name: SX_MetasParticipantes_Before.cls
* 
* Trigger After de VN_MetasParticipantes__c
*******************************************************************************/
trigger SX_MetasParticipantes_Before on VN_MetasParticipantes__c (before insert, before update) {

	if ( !VN_TriggerCheck.isActive( 'VN_MetasParticipantes__c' )) return;

	SX_MetasParticipantes_Before.atualizarPersona();

	if(trigger.isUpdate){
		//SX_MetasParticipantes_Before.calcularMediaPonderada();
	}
}