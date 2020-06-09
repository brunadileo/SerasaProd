public without sharing class SX_TeamPerformanceController {
	
	@AuraEnabled
    public static FieloPLT__Member__c getMember() {
        List<FieloPLT__Member__c> lMemberLst = [SELECT Id
								                FROM FieloPLT__Member__c
								                WHERE FieloPLT__User__c =: UserInfo.getUserId()];

	    return lMemberLst.isEmpty() ? null : lMemberLst[0];         
    }

    @AuraEnabled
	public static List<Map<String, String>> getArea(String aIdMember) {

	    Map<String, Map<String, String>> lMapArea = new Map<String, Map<String, String>>();
	    for (FieloPLT__Member__c member : loadMembers(aIdMember)) {
	        lMapArea.put(member.V_Area__c, new Map<String, String>{'value' => member.V_Area__c, 'label' => member.V_Area__c});
	    }
	    return lMapArea.values();
	}
	@AuraEnabled
	public static List<Map<String, String>> getSubArea(String aIdMember) {

	    Map<String, Map<String, String>> lMapSubArea = new Map<String, Map<String, String>>();
	    for (FieloPLT__Member__c member : loadMembers(aIdMember)) {
	        lMapSubArea.put(member.V_Lideranca__c, new Map<String, String>{'value' => member.V_Lideranca__c, 'label' => member.V_Lideranca__c});
	    }
	    return lMapSubArea.values();
	}

	@AuraEnabled
	public static List<Map<String, String>> getCargo(String aIdMember) {

	    Map<String, Map<String, String>> lMapCargo = new Map<String, Map<String, String>>();
	    for (FieloPLT__Member__c member : loadMembers(aIdMember)) {
	    	if(member.Id == aIdMember) continue;
	        lMapCargo.put(member.V_Cargo__c, new Map<String, String>{'value' => member.V_Cargo__c, 'label' => member.V_Cargo__c});
	    }
	    return lMapCargo.values();
	}

    @AuraEnabled
    public static List<FieloPLT__RedemptionItem__c> getLances(String aArea, String aLideranca, String aCargo, String aPalavraChave, String aTipo, String aIdMember){

    	String lIniciativa = aTipo == 'youbet' ? Label.V_IniciativaPerene 
        						: aTipo == 'youbet-extra' ? Label.V_IniciativaComplementar
        						: Label.V_IniciativaElite;

        Set<Id> lSetMember = new Set<Id>();
        for (FieloPLT__Member__c member : loadMembers(aIdMember)) {
        	lSetMember.add(member.Id);
        }

    	String lQuery = 'SELECT Id, Name, V_DataTexto__c, FieloPLT__Points__c, V_NomePremio__c, V_BetcoinsInvestidos__c,' +
						' V_Participante__c, FieloPLT__Redemption__r.FieloPLT__Member__r.V_Area__c,' +
						' FieloPLT__Redemption__r.FieloPLT__Member__r.V_Lideranca__c, FieloPLT__Redemption__r.FieloPLT__Member__r.V_Cargo__c' +
					 	' FROM FieloPLT__RedemptionItem__c' +
					 	' WHERE FieloPLT__Redemption__r.FieloPLT__Member__c = :lSetMember'+
					 	' AND FieloPLT__Reward__r.Iniciativa__c = \''+ lIniciativa + '\'';

		if(String.isNotEmpty(aPalavraChave)){
			lQuery += ' AND (FieloPLT__Redemption__r.FieloPLT__Member__r.Name like \'%' + aPalavraChave + '%\'';
			lQuery += ' OR FieloPLT__Reward__r.Name like \'%' + aPalavraChave + '%\')';
		}

		if(String.isNotEmpty(aArea)){
			lQuery += ' AND FieloPLT__Redemption__r.FieloPLT__Member__r.V_Area__c = \'' + aArea + '\'';
		}

		if(String.isNotEmpty(aLideranca)){
			lQuery += ' AND FieloPLT__Redemption__r.FieloPLT__Member__r.V_Lideranca__c = \'' + aLideranca + '\'';
		}

		if(String.isNotEmpty(aCargo)){
			lQuery += ' AND FieloPLT__Redemption__r.FieloPLT__Member__r.V_Cargo__c = \'' + aCargo + '\'';
		}

		lQuery +=' ORDER BY CreatedDate';

		List<FieloPLT__RedemptionItem__c> lLstRdi = database.query(lQuery);
		return lLstRdi;
	}

	private static List<FieloPLT__Member__c> loadMembers(String aIdMember){
		return [SELECT Id, V_Cargo__c, V_Area__c, V_Lideranca__c
	            FROM FieloPLT__Member__c
	            WHERE (V_LiderImediato__c  =: aIdMember
	             OR V_LiderImediato__r.V_LiderImediato__c =: aIdMember
	             OR V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__c =: aIdMember
	             OR V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__c =: aIdMember
	             OR V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__c =: aIdMember)];
	}
}