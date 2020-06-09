/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: LK                date: 02/11/2018
*
* 
* Name: VN_ResultadoTest.cls
* 
* Classe de testes para a trigger VN_Resultado
*******************************************************************************/
@isTest(SeeAllData=true) 
public with sharing class VN_ResultadoTest {
	static testMethod void processarCalculos(){
	
        
        VN_Resultado__c lRes = [SELECT Id, V_AnoFiscal__c FROM VN_Resultado__c limit 1];
        lRes.V_AnoFiscal__c = 'FY00';
            
		Test.startTest();  
        update lRes;
        Test.stopTest();	
	}
}