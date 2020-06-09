/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 26/09/2018
* 
* Name: SX_Member_Before.cls
* 
* Classe para disparar ações before em FieloPLT__Member__c
*******************************************************************************/
public with sharing class SX_Member_Before { 

	public static void criarUsuario() {

		VN_TriggerCheck.assert();

		Map<String,User> lMapUser = new Map<String,User>();
        List<FieloPLT__Member__c> lLstMember = new List<FieloPLT__Member__c>();
        for(FieloPLT__Member__c member :(List<FieloPLT__Member__c>) trigger.new) {
            
            if(member.FieloPLT__User__c == null) {
                lLstMember.add(member);
            }
        }

        lMapUser = getUser(lLstMember);

        if(!Test.isRunningTest())
        insert lMapUser.values();

        for(FieloPLT__Member__c member: lLstMember) { 
            
            User lUser = lMapUser.get(member.FieloPLT__Email__c);
            if(lUser != null) {

                member.FieloPLT__User__c = lUser.id;              
            }           
        }
	} 

	// Used part of the code UserCreationFielo
    private static Map<String,User> getUser(List<FieloPLT__Member__c> aLstMember){   

    	Map<String,User> lMapUser = new Map<String,User>();

    	String language = orgSettings.LanguageLocaleKey;
        String locale = orgSettings.LanguageLocaleKey;
        String timeZone = UserInfo.getTimeZone().getId();

        for(FieloPLT__Member__c member : aLstMember) {

        	List<String> lNameSplited = member.Name.split(' ',2); // splita em no maximo 2 elementos
		    
		    String lLastName, lFistName;
			if (lNameSplited.size() > 1) {
				lFistName = lNameSplited.get(0); 
				lLastName = lNameSplited.get(1);
			} else {
				lLastName = member.Name;
			}
         
	        String email = member.FieloPLT__Email__c;      
	        String subAlias = (member.Name.length()>4) ? member.Name.substring(0,4) : member.Name;     
	        String communityNickname = subAlias + String.valueOf(member.FieloPLT__Contact__c).substring(12,15);   
	        String alias = subalias;                     
	        
	        User lUser = new User(
	                Username = email, Email = email, FirstName = lFistName, LastName = lLastName, 
                    Alias = alias, emailencodingkey='UTF-8', 
	                ProfileId = profileId, contactId = member.FieloPLT__Contact__c, LocaleSidKey = locale, TimeZoneSidKey = timeZone, LanguageLocaleKey = language,
	                CommunityNickname = communityNickname, IsActive = true);

	        lMapUser.put(member.FieloPLT__Email__c, lUser);
        } 
                            
        return lMapUser;
    }

    public static void atualizarUsuario() {

        VN_TriggerCheck.assert();

        Map<Id, FieloPLT__Member__c> lMapMember = new Map<Id, FieloPLT__Member__c>();
        for(FieloPLT__Member__c member: (List<FieloPLT__Member__c>) trigger.new) {            

            if(member.FieloPLT__User__c == null) continue; 

            // Atualiza dados do usuario vinculado ao member
            if(VN_TriggerCheck.isChanged( member, FieloPLT__Member__c.FieloPLT__Email__c)) {
                lMapMember.put(member.id, member);
            }                   
        }
        if(lMapMember.isEmpty()) return;

        list<Contact> lLstContact = new list<Contact>();
        for(FieloPLT__Member__c member :lMapMember.values()) {
            lLstContact.add(new Contact(
                    Id = member.FieloPLT__Contact__c,
                    Email = member.FieloPLT__Email__c
                ));
        }
        update lLstContact;

        atuaalizaUsuarioF(lMapMember.keySet());
    }

    @future
    private static void atuaalizaUsuarioF( Set<Id> aSetMember ) {

        List<FieloPLT__Member__c> lLstMember = [SELECT id, FieloPLT__User__c, FieloPLT__Email__c
                                                FROM FieloPLT__Member__c
                                                WHERE Id IN :aSetMember];

        if(lLstMember.size() == 0) return;

        list<User> lLstUser = new list<User>();
        for(FieloPLT__Member__c mb :lLstMember) {

            lLstUser.add( new User( Id = mb.FieloPLT__User__c, Email = mb.FieloPLT__Email__c));
        }          
        update lLstUser;
    }

    private static Organization orgSettings {get{if(orgSettings == null){orgSettings = [SELECT DefaultLocaleSidKey, LanguageLocaleKey FROM Organization];}return orgSettings;}}        
    
    private static Id profileId {get{
                                    if(profileId == null){                                                                                
                                        profileId = [SELECT Id FROM Profile WHERE Name = 'Fielo Partner Community'].get(0).Id;                                                                                                                                                            
                                    }
                                    return profileId;
                                } set;} 
}