public without sharing class SX_AgreementController {

	@AuraEnabled
    public static FieloPLT__Member__c getMember() {
        List<FieloPLT__Member__c> lMemberLst = [SELECT Id, FieloPLT__Program__c, FieloPLT__Program__r.V_RegulamentoElite__c,
                        FieloPLT__Program__r.V_RegulamentoSPY__c,  FieloPLT__Agreement__c
	                FROM FieloPLT__Member__c
	                WHERE FieloPLT__User__c =: UserInfo.getUserId()];

	    return lMemberLst.isEmpty() ? null : lMemberLst[0];         
    }
    
    @AuraEnabled
    public static FieloPLT__Reward__c getRewardAgreement(String aMemberId, String aType){
        String lIniciativa;
        if (aType == 'youbet') {
            lIniciativa = Label.V_IniciativaPerene;
        } else if (aType == 'youbet-extra') {
            lIniciativa = Label.V_IniciativaComplementar;
        }
        return SX_RewardServices.getReward(aMemberId, lIniciativa);
	}

	@AuraEnabled
    public static FieloPLT__Agreement__c getAgreement(String aIdProgram){

    	FieloPLT__Agreement__c lAgreement;
        try{
            lAgreement = FieloPLT.AgreementService.getCurrentAgreement(aIdProgram, new Set<String>{'Id', 'FieloPLT__Status__c', 'FieloPLT__Agreement__c'});

    	} catch (Exception e) {
    		system.debug('### error getAgreement: '+e);
        }
        return lAgreement;
	}

	@AuraEnabled
    public static String acceptAgreement(Boolean aAgree, String aIdMember){

        if (!aAgree) return '';
        try {
            FieloPLT.MemberService.acceptCurrentAgreement(aIdMember);
            return 'Sucesso';
        } catch (Exception e) {
            if(e.getTypeName() == 'System.DmlException'){
    			return ((System.DmlException) e).getDmlMessage(0);
    		}
        }
        return Label.V_ErroGenerico;
	}
}