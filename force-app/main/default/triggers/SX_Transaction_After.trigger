/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 01/02/2019
* 
* Name: SX_Transaction_After.cls
* 
* Trigger after de FieloPLT__Transaction__c
*******************************************************************************/
trigger SX_Transaction_After on FieloPLT__Transaction__c (after insert, after update, after delete) {

	if ( !VN_TriggerCheck.isActive( 'FieloPLT__Transaction__c' )) return;

	SX_Transaction_After.execute();
}