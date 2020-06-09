public with sharing class SX_ChangePassword {

	@AuraEnabled
    public static FieloPLT__Member__c getMember() {
        List<FieloPLT__Member__c> lMemberLst = [SELECT Id, FieloPLT__User__c
	                FROM FieloPLT__Member__c
	                WHERE FieloPLT__User__c =: UserInfo.getUserId()];

	    return lMemberLst.isEmpty() ? null : lMemberLst[0];         
    }

	@AuraEnabled
    public static String getChangePassword(String aIdUser, String aPassword){

    	String status = '';
        try {
            System.setPassword(aIdUser, aPassword);
            return 'Ok';
        } catch (Exception ex) {

        	String lError = ex.getMessage();
            if(lError.contains('Your password must have a mix of letters and numbers')){
                status = 'A senha deve conter letras e números'; 
            } else if(lError.contains('Your Password cannot equal or contain your user name')){
                status = 'A senha não pode ser igual ou conter seu e-mail cadastrado'; 
            } else {
            	status = 'Ocorreu um erro ao atualizar a senha';
            } 
        }
    	return status;
	}
}