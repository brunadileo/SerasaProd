/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: PV                                           date: 01/11/2019
* 
* Name: VN_ResumoCargasDadosTempHandler.cls
* 
* Handler trigger de VN_ResumoCargasDadosTemp__c
*******************************************************************************/
public with sharing class VN_ResumoCargasDadosTempHandler {
    
    public static void processarSumarizadores(){
        VN_TriggerCheck.assert();
        
        for(VN_ResumoCargasDadosTemp__c rcd : (List<VN_ResumoCargasDadosTemp__c>)Trigger.new){
            if(VN_TriggerCheck.isChangedTo(rcd, VN_ResumoCargasDadosTemp__c.V_StatusPDI__c, 'Carregado')){
                Database.executeBatch(new SX_BatchAtualizarSumarizador());
            }
        }
    }
}