/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 27/08/2018
* 
* Name: VN_MemberService.cls
* 
* Classe que implementa métodos de manipulação do Member
*******************************************************************************/
public class VN_MemberService {
    public static String PAPEL_DIRETORES = 'DIRETORES';
    public static String PAPEL_GERENTECONTAS = 'GERENTES DE CONTAS';
    public static String PAPEL_LIDERES = 'LÍDERES';
    public static String PAPEL_COORDENADOR_GERENTE = 'LÍDERES (COORDENADORES) E GERENTE REGIONAIS';

    public static FieloPLT__Member__c loggedMember {
      get {
        if (loggedMember == null) {
          loggedMember = getAllFieldsLoggedMember();
        }
        return loggedMember;
      }
      private set;
    }

    private static Id memId;

    public VN_MemberService() { }

    public static FieloPLT__Member__c getAllFieldsLoggedMember() {
        Id lMemberId = getCurrentMemberId();
        if ( lMemberId == null ) return null;
        
        Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get('FieloPLT__Member__c').getDescribe().fields.getMap();

        List<String> lCampos = new List<String>();//'Id';
        for (Schema.SObjectField f : fields.values()) {
            Schema.DescribeFieldResult dField = f.getDescribe();
            lCampos.add(dField.getName());
        }
            
        List<FieloPLT__Member__c> lMembers = Database.query(
                'SELECT '+String.join(lCampos, ',')+
                ' FROM FieloPLT__Member__c'+
                ' WHERE Id =: lMemberId'
        );
        
        if (lMembers.size() == 1) return lMembers.get(0);
        return null;
    }

    public static Id getCurrentMemberId(){        
        if(UserInfo.getUserType() == 'Guest')
            return null;

        if(memId == null){

        	try{
        	 	List<FieloPLT__Member__c> members = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c WHERE FieloPLT__User__c =: UserInfo.getUserId()];
        	 	memId = members[0].Id;
    	 	} catch(Exception e){
                system.debug('### Exception: ' + e.getMessage());
                return null;
            }
        }
        return memId;
    }

    public Boolean personAccountsEnabled() {
        // Describe the Account object to get a map of all fields
        // then check to see if the map contains the field 'isPersonAccount'
        return Schema.sObjectType.Account.fields.getMap().containsKey('isPersonAccount');
    }

    public static Integer getQuantidadeVagas(String aPapel){
        if(aPapel == PAPEL_DIRETORES) return Integer.valueOf(Label.V_VagasDiretor);
        if(aPapel == PAPEL_GERENTECONTAS) return Integer.valueOf(Label.V_VagasGerenteDeContas);
        if(aPapel == PAPEL_LIDERES) return Integer.valueOf(Label.V_VagasLider);
        if(aPapel == PAPEL_COORDENADOR_GERENTE) return Integer.valueOf(Label.V_VagasCordenador_GerenteRegional);
        
        return null;
    }
}