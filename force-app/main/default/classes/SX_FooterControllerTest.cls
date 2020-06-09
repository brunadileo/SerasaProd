/*******************************************************************************
*                          Copyright (C) 2019 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                          date: 23/07/2019
* 
* Name: SX_FooterControllerTest.cls
* 
* Classe de teste para o Controller SX_FooterController
*******************************************************************************/
@isTest
public with sharing class SX_FooterControllerTest {
    
    @isTest
    static void footerController(){

        User lUser = SObjectForTest.loadUserLoggedMember();

		FieloPLT__Member__c lMember = [select Id from FieloPLT__Member__c where FieloPLT__User__c =: lUser.Id limit 1];
		lMember.FieloPLT__Status__c = 'Active';
		lMember.V_PapelElite__c = 'LÍDERES';
		update lMember;

        Test.startTest();
        FieloPLT__Member__c lMemberLogado = new FieloPLT__Member__c();
        System.runAs(lUser){
            lMemberLogado = SX_FooterController.getMember();
        }
        Test.stopTest();
        System.assertEquals(lMember.Id, lMemberLogado.Id);
    }
}