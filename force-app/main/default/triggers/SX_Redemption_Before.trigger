/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 01/02/2019
* 
* Name: SX_Redemption_Before.cls
* 
* Trigger Before de FieloPLT__Redemption__c
*******************************************************************************/
trigger SX_Redemption_Before on FieloPLT__Redemption__c (before insert) {

	if ( !VN_TriggerCheck.isActive( 'FieloPLT__Redemption__c' )) return;

	SX_Redemption_Before.execute();
}