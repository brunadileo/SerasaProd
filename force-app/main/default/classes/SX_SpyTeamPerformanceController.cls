public with sharing class SX_SpyTeamPerformanceController {
	
	@AuraEnabled
    public static FieloPLT__Member__c getMember() {
        List<FieloPLT__Member__c> lMemberLst = [SELECT Id
								                FROM FieloPLT__Member__c
								                WHERE FieloPLT__User__c =: UserInfo.getUserId()];

	    return lMemberLst.isEmpty() ? null : lMemberLst[0];         
    }

	// @AuraEnabled
	// public static List<Map<String, String>> getPapel(String aIdMember) {

	//     Map<String, Map<String, String>> lMapPapel = new Map<String, Map<String, String>>();
	//     for (FieloPLT__Member__c member : loadMembers(aIdMember)) {
	// 		if(member.V_PapelSalesPersonYear__c == 'NÃO ELEGÍVEL') continue;
	//         lMapPapel.put(member.V_PapelSalesPersonYear__c, new Map<String, String>{'value' => member.V_PapelSalesPersonYear__c, 'label' => member.V_PapelSalesPersonYear__c});
	//     }
	//     return lMapPapel.values();
	// }

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
	public static List<Map<String, String>> getBadges() {

	    Map<String, Map<String, String>> lMapBadges = new Map<String, Map<String, String>>();
	    for(FieloPLT__Badge__c badge: [SELECT Id, Name, FieloPLT__Image__c, V_Pontos__c FROM FieloPLT__Badge__c 
				WHERE FieloPLT__Status__c = 'Active' ORDER BY Name]){
	    	lMapBadges.put(badge.Name, new Map<String, String>{'value' => badge.Name, 'label' => badge.Name});
	    }
	    return lMapBadges.values();
	}

	@AuraEnabled
    public static List<Badge> getBadgesPerformance(String aArea, String aLideranca, String aBadge, String aPalavraChave, String aIdMember){

        Set<Id> lSetMember = new Set<Id>();
        for (FieloPLT__Member__c member : loadMembers(aIdMember)) {
        	lSetMember.add(member.Id);
        }

    	String lQuery = 'SELECT Id, FieloPLT__Member__c, FieloPLT__Member__r.Name, FieloPLT__Badge__r.Name, FieloPLT__Badge__r.V_Pontos__c' +
					 	' FROM FieloPLT__BadgeMember__c' +
					 	' WHERE FieloPLT__Member__c = :lSetMember'+
					 	' AND FieloPLT__Status__c != \'Reverted\''+
					 	' AND FieloPLT__Badge__r.FieloPLT__Status__c = \'Active\''+
					 	' AND (FieloPLT__ExpirationDate__c = null OR FieloPLT__ExpirationDate__c >= TODAY)';

		if(String.isNotEmpty(aPalavraChave)){
			lQuery += ' AND FieloPLT__Member__r.Name like \'%' + aPalavraChave + '%\'';
		}

		if(String.isNotEmpty(aArea)){
			lQuery += ' AND FieloPLT__Member__r.V_Area__c = \'' + aArea + '\'';
		}

		if(String.isNotEmpty(aLideranca)){
			lQuery += ' AND FieloPLT__Member__r.V_Lideranca__c = \'' + aLideranca + '\'';
		}

		if(String.isNotEmpty(aBadge)){
			lQuery += ' AND FieloPLT__Badge__r.Name = \'' + aBadge + '\'';
		}

		lQuery +=' ORDER BY FieloPLT__Member__r.Name';

		Map<String, Badge> lMapBadge = new Map<String, Badge>();
		for(FieloPLT__BadgeMember__c badgeMember: (List<FieloPLT__BadgeMember__c>)database.query(lQuery)){

			Badge lBadge = lMapBadge.get(badgeMember.FieloPLT__Member__c);
			if(lBadge == null){
				lBadge = new Badge();
				lBadge.wMember =  badgeMember.FieloPLT__Member__r.Name;
				lBadge.wNumBages = 1;
				lBadge.wPontuacao = badgeMember.FieloPLT__Badge__r.V_Pontos__c != null ? badgeMember.FieloPLT__Badge__r.V_Pontos__c : 0;
			} else {
				lBadge.wNumBages ++;
				lBadge.wPontuacao += badgeMember.FieloPLT__Badge__r.V_Pontos__c != null ? badgeMember.FieloPLT__Badge__r.V_Pontos__c : 0;
			}
			lMapBadge.put(badgeMember.FieloPLT__Member__c, lBadge);
		}
		return lMapBadge.values();
	}

	public class Badge{

		@AuraEnabled public String wMember {get; set;}
		@AuraEnabled public Integer wNumBages {get; set;}
		@AuraEnabled public Decimal wPontuacao {get; set;}
	}

	private static List<FieloPLT__Member__c> loadMembers(String aIdMember){
		return [SELECT Id, V_Cargo__c, V_Area__c, V_Lideranca__c, V_PapelSalesPersonYear__c
	            FROM FieloPLT__Member__c
	            WHERE (V_LiderImediato__c  =: aIdMember
	             OR V_LiderImediato__r.V_LiderImediato__c =: aIdMember
	             OR V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__c =: aIdMember
	             OR V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__c =: aIdMember
	             OR V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__c =: aIdMember)
				 AND V_PapelSalesPersonYear__c != 'NÃO ELEGÍVEL'];
	}
}