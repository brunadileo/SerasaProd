/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 14/09/2018
* 
* Name: SX_GerenciadorMetaParticipanteAF_After.cls
* 
* Trigger After de VN_GerenciadorMetaParticipanteAF__c
*******************************************************************************/
trigger SX_GerenciadorMetaParticipanteAF_After on VN_GerenciadorMetaParticipanteAF__c (after insert, after update) {

	if ( !VN_TriggerCheck.isActive( 'VN_GerenciadorMetaParticipanteAF__c' )) return;

	SX_GerenciadorMetaParticipanteAF_After.criarMetas();
}