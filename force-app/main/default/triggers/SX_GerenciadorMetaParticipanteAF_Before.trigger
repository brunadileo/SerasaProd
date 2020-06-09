/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 13/09/2018
* 
* Name: SX_GerenciadorMetaParticipanteAF_Before.cls
* 
* Trigger Before de VN_GerenciadorMetaParticipanteAF__c
*******************************************************************************/
trigger SX_GerenciadorMetaParticipanteAF_Before on VN_GerenciadorMetaParticipanteAF__c (before insert, before update) {

	if ( !VN_TriggerCheck.isActive( 'VN_GerenciadorMetaParticipanteAF__c' )) return;

	SX_GerenciadorMetaParticipanteAF_Before.verificarVigenciaUnica();

}