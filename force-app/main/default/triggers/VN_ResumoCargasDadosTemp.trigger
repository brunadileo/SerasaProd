/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: PV                                           date: 01/11/2019
* 
* Name: VN_ResumoCargasDadosTemp.trigger
* 
* Trigger de VN_ResumoCargasDadosTemp__c
*******************************************************************************/
trigger VN_ResumoCargasDadosTemp on VN_ResumoCargasDadosTemp__c (before insert, before update) {
    if(!VN_TriggerCheck.isActive('VN_ResumoCargasDadosTemp__c')) return;

    if (Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            VN_ResumoCargasDadosTempHandler.processarSumarizadores();
        }
    }
}