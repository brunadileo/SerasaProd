/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: VN                          date: 13/09/2018
* 
* Name: VN_RecType.cls
* 
* Classe que faz o acesso aos tipos de registros
*
*******************************************************************************/
public with sharing class VN_RecType {
	
  private static map< String, Schema.DescribeSObjectResult > fMapObjects = new map< String, Schema.DescribeSObjectResult >();
  
  public static ID getID( String aObjectName, String aRecName ){
	Schema.DescribeSObjectResult lObject = fMapObjects.get( aObjectName );
	if ( lObject == null ) {
	  list< Schema.DescribeSObjectResult > lListObjs = Schema.describeSObjects( new String[]{ aObjectName } );
	  if ( lListObjs.size() == 0 ) return null;
	  lObject = lListObjs[ 0 ];
	  fMapObjects.put( aObjectName, lObject );
	}
	Schema.RecordTypeInfo lRecInfo = lObject.getRecordTypeInfosByName().get( aRecName );
	if ( lRecInfo == null ) return null;
	else return lRecInfo.getRecordTypeId();
  }
}