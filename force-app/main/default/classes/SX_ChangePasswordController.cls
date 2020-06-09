public without sharing class SX_ChangePasswordController {

    public boolean fFirstAccess {get;set;}
    public FieloPLT__Member__c fMember {get; set;}

    public String fErrorMsg {get; set;}

    public String fPassword {get; set;}
    public String fConfirmPassword {get; set;}

    public SX_ChangePasswordController() {
        fFirstAccess = true;
        List<FieloPLT__Member__c> lstMember = [SELECT FieloPLT__User__c, FieloPLT__User__r.Username,
                V_FirstAccess__c, V_NomeTratamento__c FROM FieloPLT__Member__c
                WHERE FieloPLT__User__c =: UserInfo.getUserId()];
        if (lstMember.isEmpty()) return;
        fMember = lstMember[0];
        fFirstAccess = fMember.V_FirstAccess__c;
    }

    public PageReference doChangePassword() {

        if (fFirstAccess && String.isEmpty(fMember.V_NomeTratamento__c)) {
            fErrorMsg = 'Informe como deseja ser tratado';
            return null;
        }

        if(String.isEmpty(fPassword) || String.isEmpty(fConfirmPassword) ){
            fErrorMsg = 'O preenchimento dos campos é obrigatório';
            return null;
        }

        Integer lTamanhoMinimo = Integer.valueOf(Label.V_ComprimentoMinimoSenha); // configurado na política de senha
        if(fPassword.length() < lTamanhoMinimo){
            fErrorMsg = 'A senha deve conter no mínimo '+Label.V_ComprimentoMinimoSenha+ ' caracteres';
            return null;
        }

        if (fPassword != fConfirmPassword) {
            fErrorMsg = 'Senhas não conferem';
            return null;
        }

        try {

            System.setPassword(fMember.FieloPLT__User__c, fPassword);
            ApexPages.PageReference login = Site.login(fMember.FieloPLT__User__r.Username, fPassword, '');

            if(login != null && fMember.V_FirstAccess__c) {
                updateNickname(fMember.Id, fMember.V_NomeTratamento__c);
            }
            return login;
        }
        catch (Exception ex) {

            String lError = ex.getMessage();
            if(lError.contains('Your password must have a mix of letters and numbers')){
                fErrorMsg = 'A senha deve conter letras e números'; 
            } else if(lError.contains('Your Password cannot equal or contain your user name')){
                fErrorMsg = 'A senha não pode ser igual ou conter seu e-mail cadastrado'; 
            } 
            else {
                fErrorMsg = ex.getMessage(); 
            }    
        }
        return null;
    }

    @Future
    private static void updateNickname(Id aMemberId, String aNickname) {
        FieloPLT__Member__c member = new FieloPLT__Member__c(Id = aMemberId, V_NomeTratamento__c = aNickname,
                V_FirstAccess__c = false);
        update member;
    }
}