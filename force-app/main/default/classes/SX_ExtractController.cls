public with sharing class SX_ExtractController {


	@AuraEnabled
    public static FieloPLT__Member__c getMember() {
        List<FieloPLT__Member__c> lMemberLst = [SELECT Id
	                FROM FieloPLT__Member__c
	                WHERE FieloPLT__User__c =: UserInfo.getUserId()];

	    return lMemberLst.isEmpty() ? null : lMemberLst[0];         
    }

	@AuraEnabled
    public static List<FieloPLT__Point__c> getPoints(String aDe, String aAte, String aPalavraChave, String aTipo, String aIdMember){
    	String lTipo = aTipo == 'youbet-extra' ? 'Betcoins-Extra' : 'Betcoins';

    	String lQuery = 'SELECT Id, FieloPLT__TotalPoints__c, V_DataTexto__c, V_DataCriacao__c, V_Origem__c' +
					 	' FROM FieloPLT__Point__c' +
					 	' WHERE FieloPLT__Member__c = \'' + aIdMember + '\''+
					 	' AND FieloPLT__PointType__r.Name = \'' + lTipo + '\'';

		if(String.isNotEmpty(aPalavraChave)){
			lQuery += ' AND V_Origem__c like \'%' + aPalavraChave + '%\'';
		}
		if(aDe != null){
			Date lDe = date.valueOf(aDe);
			lQuery += ' AND V_DataCriacao__c >= :lDe';
		}
		if(aAte != null){
			Date lAte = date.valueOf(aAte);
			lQuery += ' AND V_DataCriacao__c <= :lAte';
		}

		lQuery += ' ORDER BY CreatedDate';
		
		List<FieloPLT__Point__c> lLstPoints = database.query(lQuery);
		return lLstPoints;
	}
}