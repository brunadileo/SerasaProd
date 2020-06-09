/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: VN                         date: 13/09/2018
* 
* Name: VN_TriggerCheck.cls
* 
* Classe que faz validações no contexto de trigger
*
*******************************************************************************/
public with sharing class VN_TriggerCheck {
  
	public static boolean isActive( String aObjName ) {
	    VN_TriggerConfiguration__c lConf = VN_TriggerConfiguration__c.getValues( aObjName );
	    return lConf == null || lConf.V_Active__c;
	}
	  
	public static void assert() {
	    system.assert( trigger.isExecuting, 'This método must be called only in trigger context' );
	}
	  
	public static boolean isChanged( SObject aObj, Schema.sObjectField aField ) {
	    assert();
	    return trigger.isInsert || aObj.get( aField ) != trigger.oldMap.get( aObj.id ).get( aField );
	}
	  
	public static boolean isChangedTo( SObject aObj, Schema.sObjectField aField, Object aExpectedValue ) {
	    assert();
	    Object lActualValue = aObj.get( aField );
	    return aExpectedValue == lActualValue 
	       && ( trigger.isInsert || lActualValue != trigger.oldMap.get( aObj.id ).get( aField ) );
	}
	  
	public static boolean isChangedFromTo( SObject aObj, Schema.sObjectField aField, Object aOldValue, Object aExpectedValue ) {
	    assert();
	    return trigger.isUpdate 
	        && aOldValue == trigger.oldMap.get( aObj.id ).get( aField )
	        && aExpectedValue == aObj.get( aField );
	}

	public static boolean isChangedFrom( SObject aObj, Schema.sObjectField aField, Object aOldValue) {
		assert(); 
		return aObj.get( aField ) != null 
			&&  (trigger.isUpdate && trigger.oldMap.get( aObj.id ).get( aField ) == aOldValue);
	}
}