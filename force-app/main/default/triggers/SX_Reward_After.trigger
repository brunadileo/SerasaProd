/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 13/09/2018
* 
* Name: SX_Reward_After.cls
* 
* Trigger After de FieloPLT__Reward__c
*******************************************************************************/
trigger SX_Reward_After on FieloPLT__Reward__c (after insert, after update) {

	if ( !VN_TriggerCheck.isActive( 'FieloPLT__Reward__c' )) return;

	SX_Reward_After.criarPerfilCompativel();

	if(trigger.isUpdate){
		SX_Reward_After.excluirPerfilCompativel(); 
		//SX_Reward_After.enviarEmailEncerramento();
		SX_Reward_After.atualizarSaldoPerfilCompativel();
        SX_Reward_After.atualizaFinalizadoPerfilCompativel();
	}
}