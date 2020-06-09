/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 26/09/2018
* 
* Name: VN_ContactRelationshipDefault.trigger
* 
* Classe reflection da Fielo para criar relacionamentos dos members
*
*******************************************************************************/
global without sharing class VN_ContactRelationshipDefault implements FieloPLT.ContactRelationship{
   
    global static List<Contact> getRelatedContacts(List<FieloPLT__Member__c> aLstMembers){

        Map<Id, FieloPLT__Member__c> lMapMember = new Map<Id,FieloPLT__Member__c>();
        List<Contact> lListContact = new List<Contact>();

        List<Account> lLstAccount = [SELECT Id FROM Account WHERE Name =: Label.V_NomeContaSerasa];
        if(lLstAccount.isEmpty()) return lListContact;

        Map<String, Contact> lMapContact = new Map<String, Contact>();
        for(FieloPLT__Member__c member : aLstMembers){

            if (member.FieloPLT__Account__c != null && member.FieloPLT__Contact__c != null) continue;

            if(member.FieloPLT__Account__c == null){ 

            	member.FieloPLT__Account__c = lLstAccount[0].Id;

                //campo de registro é único e obrigatório
                String lNumRegistro = member.V_RegistroParticipante__c; 

                if(member.FieloPLT__Email__c == null) member.FieloPLT__Email__c = lNumRegistro + Label.V_DominioEmailVazio;

                Contact lCtt = new Contact(
                		LastName = member.Name, 
                		Email = member.FieloPLT__Email__c,
                		V_Member__c = member.Id, 
                		AccountId = member.FieloPLT__Account__c);
                lMapContact.put(lNumRegistro, lCtt);
            }
        }

        try{

            if(!lMapContact.isEmpty()) insert lMapContact.values();

            for (FieloPLT__Member__c member : aLstMembers) {                
                String lNumRegistro = member.V_RegistroParticipante__c;
                if (lMapContact.containsKey(lNumRegistro)) {
                    member.FieloPLT__Contact__c = lMapContact.get(lNumRegistro).Id;
                    lListContact.add(new Contact(id = member.FieloPLT__Contact__c));
                }
                else lListContact.add(null);
            }

        } catch(Exception e){
            system.debug('### erro criação conta/contato :' + e.getMessage());
        }
        return lListContact;
    }
}