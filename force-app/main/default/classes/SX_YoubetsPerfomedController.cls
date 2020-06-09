public with sharing class SX_YoubetsPerfomedController {

	@AuraEnabled
    public static FieloPLT__Member__c getMember() {
        List<FieloPLT__Member__c> lMemberLst = [SELECT Id
								                FROM FieloPLT__Member__c
								                WHERE FieloPLT__User__c =: UserInfo.getUserId()];
	    return lMemberLst.isEmpty() ? null : lMemberLst[0];         
    }

   	@AuraEnabled
    public static FieloPLT__Reward__c getAgreement(String aIdReward) {
        List<FieloPLT__Reward__c> lRewardLst = [SELECT Name, V_RegulamentoYoubet__c
								                FROM FieloPLT__Reward__c
								                WHERE Id =: aIdReward];
	    return !lRewardLst.isEmpty() ? lRewardLst[0] : null;         
    }

	@AuraEnabled
    public static List<FieloPLT__Reward__c> getYoubets(String aDe, String aAte, String aPalavraChave, String aTipo, String aIdMember){

    	String lIniciativa = aTipo == 'youbet' ? Label.V_IniciativaPerene 
        						: aTipo == 'youbet-extra' ? Label.V_IniciativaComplementar
        						: Label.V_IniciativaElite;

        Set<Id> lSetReward = idsRewardsCompativeis();

    	String lQuery = 'SELECT Id, Name, V_RegulamentoYoubet__c, V_DataInicioTexto__c, V_DataFimTexto__c, V_NomeVencedor__c, V_ValorLanceGanhador__c' +
					 	' FROM FieloPLT__Reward__c' +
					 	' WHERE Id IN :lSetReward' +
					 	' AND RecordTypeId = \'' + VN_RecType.getID('FieloPLT__Reward__c', Label.V_RecTypeLeiloes) + '\''+
					 	' AND V_YoubetCompleto__c = true '+
					 	' AND V_YoubetProcessado__c != null'+
					 	' AND V_DataHoraFimYoubet__c <= TODAY'+ 
					 	' AND V_IsActive__c = false'+ 
					 	' AND Iniciativa__c = \''+ lIniciativa + '\'';

		if(String.isNotEmpty(aPalavraChave)){
			lQuery += ' AND (Name like \'%' + aPalavraChave + '%\'';
			lQuery += ' OR V_NomeVencedor__c like \'%' + aPalavraChave + '%\')';
		}

		if(aDe != null){
			Date lDe = date.valueOf(aDe);
			lQuery += ' AND V_DataInicioYoubet__c >= :lDe';
		}
		if(aAte != null){
			Date lAte = date.valueOf(aAte);
			lQuery += ' AND V_DatafinalYoubet__c <= :lAte';
		}

		lQuery +=' ORDER BY V_DataHoraFimYoubet__c';

		system.debug('### '+lQuery);

		List<FieloPLT__Reward__c> lLstRewards = database.query(lQuery);
		return lLstRewards;
	}

	private static Set<Id> idsRewardsCompativeis(){

        Set<Id> lSetReward = new Set<Id>();
        for(VN_ParticipanteComPerfilCompativel__c perfilCompativel: [SELECT V_Reward__c 
                                                                     FROM VN_ParticipanteComPerfilCompativel__c
                                                                    WHERE V_Member__r.FieloPLT__User__c =: UserInfo.getUserId()]){
            if(perfilCompativel.V_Reward__c != null)
                lSetReward.add(perfilCompativel.V_Reward__c);
        }
        return lSetReward;
    }
}