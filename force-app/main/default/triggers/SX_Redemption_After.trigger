/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 01/02/2019
* 
* Name: SX_Redemption_After.cls
* 
* Trigger after de FieloPLT__Redemption__c
*******************************************************************************/
trigger SX_Redemption_After on FieloPLT__Redemption__c (after insert, after update, after delete) {

	if ( !VN_TriggerCheck.isActive( 'FieloPLT__Redemption__c' )) return;

	SX_Redemption_After.execute();
}