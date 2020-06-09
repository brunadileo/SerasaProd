/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                          date: 15/07/2019
* 
* Name: SX_UnfinishedNotesController.cls
* 
* Controller do componente UnfinishedNotes (Notas em Aberto)
*******************************************************************************/
public with sharing class SX_UnfinishedNotesController {
    public SX_UnfinishedNotesController() {

    }

    @AuraEnabled
	public static FieloPLT__Member__c getMember() {
		List<FieloPLT__Member__c> lMemberLst = [SELECT Id, V_Cargo__c, FieloPLT__Program__r.V_RegulamentoElite__c
					FROM FieloPLT__Member__c
					WHERE FieloPLT__User__c =: UserInfo.getUserId()];

		return lMemberLst.isEmpty() ? null : lMemberLst[0];         
	}

    @AuraEnabled
    public static string getNotasEmAberto(String aIdMember){

        return 'Teste';
        
    }
}