public with sharing class SX_EliteTeamPerfomanceController {
	
	@AuraEnabled
    public static FieloPLT__Member__c getMember() {
        List<FieloPLT__Member__c> lMemberLst = [SELECT Id, V_PapelElite__c
								                FROM FieloPLT__Member__c
								                WHERE FieloPLT__User__c =: UserInfo.getUserId()];

	    return lMemberLst.isEmpty() ? null : lMemberLst[0];         
    }

	@AuraEnabled
	public static List<Map<String, String>> getPapel(String aIdMember) {

	    Map<String, Map<String, String>> lMapPapel = new Map<String, Map<String, String>>();

        Schema.DescribeFieldResult fieldResult = FieloPLT__Member__c.V_PapelElite__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
			if(pickListVal.getValue() == 'NÃO ELEGÍVEL') continue;
	        lMapPapel.put(pickListVal.getValue() , new Map<String, String>{'value' => pickListVal.getValue() , 'label' => pickListVal.getLabel() });
        } 

	    // for (FieloPLT__Member__c member : loadMembers(aIdMember)) {
		// 	if(member.V_PapelElite__c == 'NÃO ELEGÍVEL') continue;
	    //     lMapPapel.put(member.V_PapelElite__c, new Map<String, String>{'value' => member.V_PapelElite__c, 'label' => member.V_PapelElite__c});
	    // }
	    return lMapPapel.values();
	}

    @AuraEnabled
	public static List<Map<String, String>> getArea(String aIdMember) {

	    Map<String, Map<String, String>> lMapArea = new Map<String, Map<String, String>>();
	    for (FieloPLT__Member__c member : loadMembers(aIdMember)) {
	        lMapArea.put(member.V_Area__c, new Map<String, String>{'value' => member.V_Area__c, 'label' => member.V_Area__c});
	    }

	    system.debug('##lMapArea '+lMapArea);
	    return lMapArea.values();
	}
	@AuraEnabled
	public static List<Map<String, String>> getSubArea(String aIdMember) {

	    Map<String, Map<String, String>> lMapSubArea = new Map<String, Map<String, String>>();
	    for (FieloPLT__Member__c member : loadMembers(aIdMember)) {
	        lMapSubArea.put(member.V_Lideranca__c, new Map<String, String>{'value' => member.V_Lideranca__c, 'label' => member.V_Lideranca__c});
	    }
	    system.debug('##lMapSubArea '+lMapSubArea);
	    return lMapSubArea.values();
	}

	@AuraEnabled
	public static List<Map<String, String>> getCargo(String aIdMember) {

	    Map<String, Map<String, String>> lMapCargo = new Map<String, Map<String, String>>();
	    for (FieloPLT__Member__c member : loadMembers(aIdMember)) {
	    	if(member.Id == aIdMember) continue;
	        lMapCargo.put(member.V_Cargo__c, new Map<String, String>{'value' => member.V_Cargo__c, 'label' => member.V_Cargo__c});
	    }
	    system.debug('##lMapCargo '+lMapCargo);
	    return lMapCargo.values();
	}

	@AuraEnabled
    public static List<VN_MetaParticipante__c> getMetas(String aArea, String aLideranca, String aCargo, String aIdMember, String aPapel){

    	system.debug('##### ');

    	String lAnoFiscal = loadAnoFiscalVigente();
    	if(String.isEmpty(lAnoFiscal)) return null;

    	Set<Id> lSetMember = new Set<Id>();
        for (FieloPLT__Member__c member : loadMembers(aIdMember)) {
        	lSetMember.add(member.Id);
        }

		List<VN_MetaParticipante__c> lLstMeta = loadMetas(aIdMember, lAnoFiscal, aArea, aLideranca, aCargo, lSetMember, aPapel);
		return lLstMeta;
	}

	@AuraEnabled
    public static List<Posicao> getRanking(String aIdMember, String aArea, String aLideranca, String aCargo, String aPapel) {

    	String lAnoFiscal = loadAnoFiscalVigente();
    	if(String.isEmpty(lAnoFiscal)) return null;

    	Set<Id> lSetMember = new Set<Id>();
        for (FieloPLT__Member__c member : loadMembers(aIdMember)) {
        	lSetMember.add(member.Id);
        }

		Integer lTotalRanking = aPapel == 'DIRETORES' ? Integer.valueOf(Label.V_RankingDiretor)
								: aPapel == 'LÍDERES' ? Integer.valueOf(Label.V_RankingLider)
								: aPapel == 'GERENTES DE CONTAS' ? Integer.valueOf(Label.V_RankingGerenteDeContas)
								: Integer.valueOf(Label.V_RankingCoordenador_GerenteRegional); 

		Map<Integer, Integer> lMapRanking = new Map<Integer, Integer>();
		Map<Integer, Integer> lMapEquipe = new Map<Integer, Integer>();
		for(Integer i = lTotalRanking; i > 0; i--){
			lMapRanking.put(i, 0);
			lMapEquipe.put(i, 0);
		}

		List<VN_MetaParticipante__c> lLstMeta = loadMetas(aIdMember, lAnoFiscal, aArea, aLideranca, aCargo, null, aPapel);

        for(VN_MetaParticipante__c metas: lLstMeta){
        	Integer lScore = Integer.valueOf(metas.V_ScoreElite__c);

        	Integer lTotalMembers = lMapRanking.get(lScore);
        	if(lTotalMembers == null) continue;

        	lTotalMembers ++;
        	lMapRanking.put(lScore, lTotalMembers);

        	if(lSetMember.contains(metas.V_Participante__c)){
        		Integer lTotalEquipe = lMapEquipe.get(lScore);
        		if(lTotalEquipe == null) continue;
        		lTotalEquipe ++;
        		lMapEquipe.put(lScore, lTotalEquipe);
        	}
        }

        List<Posicao> lLstPos = new List<Posicao>();
        for(Integer lKey: lMapRanking.keySet()){

        	Integer lTotal = lMapRanking.get(lKey);
        	Integer lTotalEquipe = lMapEquipe.get(lKey);
        	if(lTotal == null || lTotalEquipe == null) continue;

        	Posicao lPos = new Posicao();
        	lPos.wScore = lKey;
        	lPos.wTotalMembers = lTotal;
        	lPos.wTotalEquipe = lTotalEquipe;

        	String lKeyStr = lKey < 10 ? '0'+String.valueOf(lKey) : String.valueOf(lKey);
        	lPos.wScoreStr = lKeyStr; 

        	lLstPos.add(lPos);
        }
	    return lLstPos;         
    } 

    private static List<VN_MetaParticipante__c> loadMetas(String aIdMember, String aAnoFiscal, String aArea, String aLideranca, String aCargo, Set<Id> aSetMember, String aPapel){

    	String lQuery = 'SELECT V_Participante__c, V_Nome__c, V_ScoreElite__c, V_PapelElite__c' +
					 	' FROM VN_MetaParticipante__c' +
					 	' WHERE Name = \''+ aAnoFiscal + '\''+
					 	' AND V_ParticRankingElite__c = true'+
					 	' AND V_PapelElite__c != \'NÃO ELEGÍVEL\'';

		if(aSetMember != null){
			lQuery += ' AND V_Participante__c = :aSetMember';
		}

		if(String.isNotEmpty(aPapel)){
			lQuery += ' AND V_Participante__r.V_PapelElite__c = \'' + aPapel + '\'';
		}

		if(String.isNotEmpty(aArea)){
			lQuery += ' AND V_Participante__r.V_Area__c = \'' + aArea + '\'';
		}

		if(String.isNotEmpty(aLideranca)){
			lQuery += ' AND V_Participante__r.V_Lideranca__c = \'' + aLideranca + '\'';
		}

		if(String.isNotEmpty(aCargo)){
			lQuery += ' AND V_Participante__r.V_Cargo__c = \'' + aCargo + '\'';
		}

		lQuery +=' ORDER BY V_ScoreElite__c DESC';

		List<VN_MetaParticipante__c> lLstMeta = database.query(lQuery);

		return lLstMeta;
    }

    private static String loadAnoFiscalVigente(){

    	List<VN_GerenciadorMetaParticipanteAF__c> lLstGeren = [SELECT V_AnoFiscal__c 
																FROM VN_GerenciadorMetaParticipanteAF__c
																WHERE V_Vigente__c = true];
		return lLstGeren.isEmpty() ? '' : lLstGeren[0].V_AnoFiscal__c;
    }  	

    public class Posicao{

    	@AuraEnabled public Integer wScore {get; set;}
    	@AuraEnabled public String wScoreStr {get; set;}
		@AuraEnabled public Integer wTotalMembers {get; set;}
		@AuraEnabled public Integer wTotalEquipe {get; set;}
    }

	private static List<FieloPLT__Member__c> loadMembers(String aIdMember){
		return [SELECT Id, V_Cargo__c, V_Area__c, V_Lideranca__c
	            FROM FieloPLT__Member__c
	            WHERE (V_LiderImediato__c  =: aIdMember
	             OR V_LiderImediato__r.V_LiderImediato__c =: aIdMember
	             OR V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__c =: aIdMember
	             OR V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__c =: aIdMember
	             OR V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__r.V_LiderImediato__c =: aIdMember)
				AND V_PapelElite__c != 'NÃO ELEGÍVEL'];
	}
}