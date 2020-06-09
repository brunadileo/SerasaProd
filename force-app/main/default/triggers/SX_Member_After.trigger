/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 14/09/2018
* 
* Name: SX_Member_After.cls
* 
* Trigger After de FieloPLT__Member__c
*******************************************************************************/
trigger SX_Member_After on FieloPLT__Member__c (after insert) {

	if ( !VN_TriggerCheck.isActive( 'FieloPLT__Member__c' )) return;

	SX_Member_After.criarMetas();

}