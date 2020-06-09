public with sharing class SX_SpyHomeController {
	
	@AuraEnabled
	public static FieloPLT__Member__c getMember() {
		List<FieloPLT__Member__c> lMemberLst = [SELECT Id, V_Cargo__c, V_PapelSalesPersonYear__c
					FROM FieloPLT__Member__c
					WHERE FieloPLT__User__c =: UserInfo.getUserId()];

		return lMemberLst.isEmpty() ? null : lMemberLst[0];         
	}

	@AuraEnabled
	public static List<Badge> getBadges(String aIdMember, String aType, String aCargo) {

		Map<Id, Badge> lMapBadge = new Map<Id, Badge>();
		List<Badge> lLstBadge = new List<Badge>();

		for(FieloPLT__Badge__c badge: [SELECT Id, Name, FieloPLT__Image__c, V_Pontos__c FROM FieloPLT__Badge__c 
				WHERE V_Classificacao__c =: aType AND (V_PapelSalesPersonYear__c = NULL OR V_PapelSalesPersonYear__c =: aCargo )
				AND FieloPLT__Status__c = 'Active' ORDER BY V_Ordem__c ASC NULLS LAST]){

			Badge lBadge = new Badge(); 
			lBadge.wImgURL = Label.V_SiteURL + badge.FieloPLT__Image__c;
			lBadge.wShowColor = false;
			lBadge.wName = badge.Name;
			lMapBadge.put(badge.Id,  lBadge);
			lLstBadge.add(lBadge);
		}

		for(FieloPLT__BadgeMember__c badgeMember: [SELECT Id, FieloPLT__Badge__c FROM FieloPLT__BadgeMember__c WHERE FieloPLT__Badge__c =: lMapBadge.keySet() 
				AND FieloPLT__Member__c =: aIdMember AND FieloPLT__Status__c != 'Reverted' AND (FieloPLT__ExpirationDate__c = null OR FieloPLT__ExpirationDate__c >= TODAY)]){
			Badge lBadge = lMapBadge.get(badgeMember.FieloPLT__Badge__c);
			if(lBadge == null) continue;
			lBadge.wShowColor = true;
		}
		return lMapBadge.values(); 
	}

	@AuraEnabled
	public static String getMyBadges(String aIdMember, String aType) {

		List<AggregateResult> lLstAgg = [SELECT COUNT(Id) total FROM FieloPLT__BadgeMember__c WHERE FieloPLT__Member__c =: aIdMember
				AND FieloPLT__Status__c != 'Reverted' AND (FieloPLT__ExpirationDate__c = null OR FieloPLT__ExpirationDate__c >= TODAY)
				AND FieloPLT__Badge__r.FieloPLT__Status__c = 'Active' AND FieloPLT__Badge__r.V_Classificacao__c =: aType];
		Integer lTotalBadges = !lLstAgg.isEmpty() ? Integer.valueOf(lLstAgg[0].get('total')) : 0;

		return lTotalBadges < 10 ? '0'+String.valueOf(lTotalBadges) : String.valueOf(lTotalBadges);
	}

	 public class Badge{

		@AuraEnabled public String wImgURL {get; set;}
		@AuraEnabled public String wName {get; set;}
		@AuraEnabled public Boolean wShowColor {get; set;}
	}

}