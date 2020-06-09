/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 22/07/2019
* 
* Name: SX_FooterController.cls
* 
* Controller do Footer
*******************************************************************************/
public without sharing class SX_FooterController {

  @AuraEnabled
    public static  FieloPLT__Member__c getMember() {
        return [SELECT V_Cargo__c, V_PapelElite__c,
                  V_PapelYoubet__c,V_PapelSalesPersonYear__c FROM FieloPLT__Member__c
                  WHERE FieloPLT__User__c =: UserInfo.getUserId() LIMIT 1];
    }
}