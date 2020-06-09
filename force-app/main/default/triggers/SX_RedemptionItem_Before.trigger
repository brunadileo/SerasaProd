/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 13/09/2018
* 
* Name: SX_RedemptionItem_Before.cls
* 
* Trigger Before de FieloPLT__RedemptionItem__c
*******************************************************************************/
trigger SX_RedemptionItem_Before on FieloPLT__RedemptionItem__c (before insert, before update) {

	if ( !VN_TriggerCheck.isActive( 'FieloPLT__RedemptionItem__c' )) return;

	SX_RedemptionItem_Before.verificarUnicoLanceGanhador();
}