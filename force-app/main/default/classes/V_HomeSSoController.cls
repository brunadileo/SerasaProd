/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                                 date: 14/06/2018
* 
* Name: V_HomeSSoController.cls
* 
* Controller da página Home da Comunidade 
*******************************************************************************/
public class V_HomeSSoController {
    
    public String fMsg {get; set;}
    public FieloPLT__Member__c fMember {get; set;}
    
    public V_HomeSSoController() {

        fMsg = '';

        List<FieloPLT__Member__c> lstMember = [SELECT id, Name, FieloPLT__Program__c, FieloPLT__User__c
                                                FROM FieloPLT__Member__c 
                                                WHERE FieloPLT__User__c =: UserInfo.getUserId()];

        if(!lstMember.isEmpty()){
            fMember = lstMember[0];
        } else fMsg = 'Não encontramos member associado à Usuário com esse Id de Federação';
    }
}