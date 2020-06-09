/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 11/09/2018
* 
* Name: SX_Utils.cls
* 
* Classe utilitária 
*
*******************************************************************************/
public with sharing class SX_Utils {

	public SX_Utils() {}

	public static void addError( String aMsg ) { 
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, aMsg));
	}

	public static List< String > getSObjectFieldsList ( Schema.SObjectType obj ) {
		return new List< String >( obj.getDescribe().fields.getMap().keySet() );
	}

	public static Boolean batchIsProcessing(String aNameClass) { 
		return ![SELECT Id FROM AsyncApexJob WHERE ApexClass.Name =: aNameClass
                AND Status = 'Processing'].isEmpty();
	}
}