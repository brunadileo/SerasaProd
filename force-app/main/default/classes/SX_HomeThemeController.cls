/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                                                   date: 15/09/2018
* 
* Name: SX_HomeThemeController.cls
* 
* Classe controladora para SX_Theme_Home
*******************************************************************************/

public without sharing class SX_HomeThemeController {

    @AuraEnabled
    public static Boolean isAdmin() {
        List<Profile> lProfile = [SELECT Id, Name FROM Profile WHERE Id=: userinfo.getProfileId() LIMIT 1];
        return !lProfile.isEmpty() && lProfile[0].Name.contains('Administrador do sistema') ? true : false;         
    }

	// Campos faltando:
	// Score Atual, Score Projetado, Posição no Ranking
	// Vagas remanescentes, Badges
	@AuraEnabled
    public static  List<FieloPLT__Member__c> getMembers() {
        List<FieloPLT__Member__c> lMemberLst = [SELECT Id, Name, FieloPLT__Program__c, FieloPLT__User__c
	                FROM FieloPLT__Member__c
	                WHERE FieloPLT__User__c =: UserInfo.getUserId()];
        if(lMemberLst.isEmpty())
            return null;
        else    
            return lMemberLst;               
    }

    @AuraEnabled
    public static FieloPLT__Member__c getMember() {
        List<FieloPLT__Member__c> lMemberLst = [SELECT Id, Name, FieloPLT__Program__c, FieloPLT__User__c, FieloPLT__Points__c,
         V_BetcoinsComp__c, FieloPLT__Agreement__c
	                FROM FieloPLT__Member__c
	                WHERE FieloPLT__User__c =: UserInfo.getUserId()];
        if(lMemberLst.isEmpty())
            return null;
        else    
            return lMemberLst[0];           
    }

    @AuraEnabled
    public static Boolean aceitarRegulamento(String aIdMember){

        try {
            FieloPLT.MemberService.acceptCurrentAgreement(aIdMember);
            return true;
        } catch (Exception e) {}
        return false;
    }

    @AuraEnabled
    public static FieloPLT__Agreement__c getAgreement(String aIdProgram){

        FieloPLT__Agreement__c lAgreement;
        try{
            lAgreement = FieloPLT.AgreementService.getCurrentAgreement(aIdProgram, new Set<String>{'Id', 'FieloPLT__Status__c', 'FieloPLT__Agreement__c'});

        } catch (Exception e) {
            system.debug('### error getAgreement: '+e);
        }
        return lAgreement;
    }
}