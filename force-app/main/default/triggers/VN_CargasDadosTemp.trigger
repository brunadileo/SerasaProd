/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: PV                                           date: 11/06/2019
* 
* Name: VN_CargasDadosTemp.trigger
* 
* Trigger de VN_CargasDadosTemp__c
*******************************************************************************/
trigger VN_CargasDadosTemp on VN_CargasDadosTemp__c (before insert, before update) {
    if(!VN_TriggerCheck.isActive('VN_CargasDadosTemp__c')) return;

    if (Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            VN_CargaDadosTempHandler.updateSumarizador();
        }
    }
}