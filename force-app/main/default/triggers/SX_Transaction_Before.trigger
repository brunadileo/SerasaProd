/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 01/02/2019
* 
* Name: SX_Transaction_Before.cls
* 
* Trigger Before de FieloPLT__Transaction__c
*******************************************************************************/
trigger SX_Transaction_Before on FieloPLT__Transaction__c (before insert) {

	if ( !VN_TriggerCheck.isActive( 'FieloPLT__Transaction__c' )) return;

	SX_Transaction_Before.execute();
}