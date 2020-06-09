public with sharing class SX_ModalController {

    @Future
    private static void updateNickname(Id aMemberId, String aNickname) {
    	FieloPLT__Member__c member = [SELECT V_NomeTratamento__c FROM FieloPLT__Member__c WHERE Id =: aMemberId];
    	member.V_NomeTratamento__c = aNickname;
    	update member;
    }

	@AuraEnabled
    public static String setNickname1(String numeroRegistro, String password, String nickname) {
    	List<FieloPLT__Member__c> lstMember = [SELECT FieloPLT__User__c, FieloPLT__User__r.Username
    			FROM FieloPLT__Member__c WHERE V_RegistroParticipante__c =: numeroRegistro];
    	if (lstMember.isEmpty()) return null;

    	FieloPLT__Member__c member = lstMember[0];
    	try {
    		System.setPassword(member.FieloPLT__User__c, password);
    		updateNickname(member.Id, nickname);
        	ApexPages.PageReference login = Site.login(member.FieloPLT__User__r.Username, password, '');
            aura.redirect(login);
            return null;
        }
        catch (Exception ex) {
            return ex.getMessage();            
        }
        return null;
    }

    @AuraEnabled
    public static String doForgotPassword(String numeroRegistro) {
    	List<FieloPLT__Member__c> lstMember = [SELECT FieloPLT__User__r.Username FROM FieloPLT__Member__c
    			WHERE V_RegistroParticipante__c =: numeroRegistro];
    	if (lstMember.isEmpty()) {
    		return 'Member not found';
    	}
    	Site.forgotPassword(lstMember[0].FieloPLT__User__r.Username);
    	return null;
    }

}