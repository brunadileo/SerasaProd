/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 26/09/2018
* 
* Name: SX_Member_Before.cls
* 
* Trigger Before de FieloPLT__Member__c
*******************************************************************************/
trigger SX_Member_Before on FieloPLT__Member__c (before insert, before update) {

	if ( !VN_TriggerCheck.isActive( 'FieloPLT__Member__c' )) return;

	if(trigger.isInsert){
		SX_Member_Before.criarUsuario();
	} else {
		SX_Member_Before.atualizarUsuario();
	}
}