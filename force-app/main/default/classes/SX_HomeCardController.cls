public with sharing class SX_HomeCardController {

    private static String UNLIMITED = 'Unlimited';

	@AuraEnabled
    public static FieloPLT__Member__c getMember() {
        List<FieloPLT__Member__c> lMemberLst = [SELECT Id, Name, V_Cargo__c, FieloPLT__Program__c, V_PosicaoRankingCongelado__c,
                        V_PapelElite__c, V_PapelSalesPersonYear__c, V_PapelYoubet__c,
                        V_MetaScoreEliteAFCongelado__c, V_MetaScoreEliteAFProjetadoCongelado__c,V_BadgeEliteCongelado__c,
                        V_BadgeYouBetCongelado__c, V_BadgeEngajamentoCongelado__c,
                     FieloPLT__User__c, FieloPLT__Points__c, V_BetcoinsComp__c, FieloPLT__Agreement__c
	                FROM FieloPLT__Member__c
	                WHERE FieloPLT__User__c =: UserInfo.getUserId()];
        if(lMemberLst.isEmpty())
            return null;
        else    
            return lMemberLst[0];           
    }

    @AuraEnabled
    public static Boolean getAgreed(){

        Boolean lAgreed = false;

        FieloPLT__Member__c lMember = SX_HomeCardController.getMember();
        
        try{
            FieloPLT__Agreement__c lAgreement = FieloPLT.AgreementService.getCurrentAgreement(lMember.FieloPLT__Program__c, new Set<String>{'Id', 'FieloPLT__Status__c', 'FieloPLT__Agreement__c'});
            lAgreed = lAgreement.id == lMember.FieloPLT__Agreement__c;
        } catch (Exception e) { }  

        return lAgreed;
    }

    @AuraEnabled
    public static List<FieloPLT__Reward__c> getRewards(){
    	List<FieloPLT__Reward__c> lRewardLst = [SELECT Id, Name, FieloPLT__Description__c, FieloPLT__Image__c,
    			V_LanceMinimo__c, FieloPLT__Points__c, FieloPLT__Program__c, FieloPLT__Segment__c 
    			FROM FieloPLT__Reward__c];
    	if(lRewardLst.isEmpty())
    		return null;
    	else 
    		return lRewardLst;		
    }

    @AuraEnabled
    public static FieloPLT__Reward__c getReward(String aMemberId){

        //perene
        return SX_RewardServices.getReward(aMemberId, Label.V_IniciativaPerene);
    }

    // Score Atual, Score Projetado, Posição no Ranking
	// Vagas remanescentes
	// @AuraEnabled
    // public static VN_MetasParticipantes__c getMeta(){
    // 	FieloPLT__Member__c lMember = SX_HomeCardController.getMember();
    // 	if(lMember != null){
    // 		//List<VN_MetasParticipantes__c> lMetasAnoFiscalLst = [SELECT Id FROM VN_MetasParticipantes__c WHERE V_Participante__c =: lMember.Id ];
    // 		if (lMetasAnoFiscalLst.isEmpty())
    // 			return null;
    // 		else
    // 			return 	lMetasAnoFiscalLst[0];
    // 	}
    // 	else 
    // 		return null;
    // }

    @AuraEnabled
    public static VN_MetaParticipante__c getMeta(){
    	FieloPLT__Member__c lMember = SX_HomeCardController.getMember();
    	if(lMember != null){
            List<VN_MetaParticipante__c> lMetasAnoFiscalLst = [SELECT Id FROM VN_MetaParticipante__c WHERE V_Participante__c =: lMember.Id ];
    		if (lMetasAnoFiscalLst.isEmpty())
    			return null;
    		else
    			return 	lMetasAnoFiscalLst[0];
    	}
    	else 
    		return null;
    }

    // @AuraEnabled
    // public static VN_MetasParticipantes__c getMetaScore(String aIdMember) {

    //     String lAnoFiscal = loadAnoFiscalVigente();
    //     if(String.isEmpty(lAnoFiscal)) return null;

    //     List<VN_MetasParticipantes__c> lLstMeta = [SELECT Id, V_ScoreEliteAF__c, V_ScoreEliteAFProjetado__c, V_ScorePotencialCarteira__c,
    //                                                 V_ScoreAMH1EliteSemestre1AF__c, V_ScoreAMEliteAF__c, V_ScoreSMEliteAF__c
    //                                                 FROM VN_MetasParticipantes__c
    //                                                 WHERE V_Participante__c =: aIdMember
    //                                                 AND Name =: lAnoFiscal];

    //     return lLstMeta.isEmpty() ? null : lLstMeta[0];          
    // }

    @AuraEnabled
    public static VN_MetaParticipante__c getMetaScore(String aIdMember) {

        String lAnoFiscal = loadAnoFiscalVigente();
        if(String.isEmpty(lAnoFiscal)) return null;

        List<VN_MetaParticipante__c> lLstMeta = [SELECT Id, V_ScoreElite__c, V_ScoreEliteAFProjetado__c, V_ScorePotencialCarteira__c,
                                                V_ScoreSuperacaoQ1__c, V_ScoreAtingimentoFY__c, V_ScoreSuperacaoFY__c
                                                FROM VN_MetaParticipante__c
                                                WHERE V_Participante__c =: aIdMember
                                                AND Name =: lAnoFiscal];

        return lLstMeta.isEmpty() ? null : lLstMeta[0];          
    }

    // @AuraEnabled
    // public static String getRanking(String aIdMember, String aCargo) {

    //     String lAnoFiscal = loadAnoFiscalVigente();
    //     if(String.isEmpty(lAnoFiscal)) return null;

    //     List<VN_MetasParticipantes__c> lLstMeta = [SELECT V_Participante__c, V_ParticRankingElite__c, V_Participante__r.Name, V_ScoreEliteAF__c, V_PercentualAMAF__c
    //                                                 FROM VN_MetasParticipantes__c
    //                                                 WHERE V_Participante__r.V_Cargo__c =: aCargo
    //                                                 AND Name =: lAnoFiscal
    //                                                 AND (V_ParticRankingElite__c = true OR V_Participante__c =: aIdMember) // add 19/11 
    //                                                 ORDER BY V_ScoreEliteAF__c DESC, V_PercentualAMAF__c DESC];

    //     Integer lPosition = 0;
    //     Decimal lLastScore = 0;
    //     Decimal lLastPercent = 0;
    //     for(Integer i = 0; i < lLstMeta.size(); i++){

    //         VN_MetasParticipantes__c lMeta = lLstMeta[i];

    //         if(i > 0 && (lMeta.V_ScoreEliteAF__c == lLastScore && lMeta.V_PercentualAMAF__c == lLastPercent)){
    //             lPosition = lPosition;
    //         } else {
    //             lPosition = i+1; // i++ no func
    //         }
    //         lLastScore = lMeta.V_ScoreEliteAF__c;
    //         lLastPercent = lMeta.V_PercentualAMAF__c;

    //         if(lMeta.V_Participante__c == aIdMember) {
    //             if(!lMeta.V_ParticRankingElite__c) lPosition = 0;
    //             break;
    //         }
    //     }

    @AuraEnabled
    public static String getRanking(String aIdMember, String aCargo) {

       String lAnoFiscal = loadAnoFiscalVigente();
        if(String.isEmpty(lAnoFiscal)) return null;

        // critério de desempate alterado 06/08/19 - #task 16632
        List<VN_MetaParticipante__c> lLstMeta = [SELECT V_Participante__c, V_ParticRankingElite__c, V_Participante__r.Name, V_ScoreElite__c, V_PercentualAMMes__c
                                                    FROM VN_MetaParticipante__c
                                                    WHERE V_PapelElite__c =: aCargo
                                                    AND Name =: lAnoFiscal
                                                    AND (NOT V_Participante__r.Name like '%VAGO_%') // add 10/10 task #17343
										            AND (NOT V_Participante__r.Name like '%CARTEIRA_AFASTADO_%') // add 30/10 task #17394
                                                    AND (V_ParticRankingElite__c = true OR V_Participante__c =: aIdMember) // add 19/11 
                                                    ORDER BY V_ScoreElite__c DESC, V_PercentualMetaYTD__c DESC, V_TotalVendasYTD__c DESC, V_Participante__r.Name ASC];
        Integer lPosition = 0;
        Decimal lLastScore = 0;
        Decimal lLastPercent = 0;
        for(Integer i = 0; i < lLstMeta.size(); i++){

            VN_MetaParticipante__c lMeta = lLstMeta[i];

            // if(i > 0 && (lMeta.V_ScoreElite__c == lLastScore && lMeta.V_PercentualAMMes__c == lLastPercent)){
            //     lPosition = lPosition;
            // } else {
            lPosition = i+1;
            // }
            lLastScore = lMeta.V_ScoreElite__c;
            lLastPercent = lMeta.V_PercentualAMMes__c;

            if(lMeta.V_Participante__c == aIdMember) {
                if(!lMeta.V_ParticRankingElite__c) lPosition = 0;
                break;
            }
        }

        return lPosition < 10 ? '0' + String.valueOf(lPosition) : String.valueOf(lPosition);       
    }  

    private static String loadAnoFiscalVigente(){

        List<VN_GerenciadorMetaParticipanteAF__c> lLstGeren = [SELECT V_AnoFiscal__c 
                                                                FROM VN_GerenciadorMetaParticipanteAF__c
                                                                WHERE V_Vigente__c = true];
        return lLstGeren.isEmpty() ? '' : lLstGeren[0].V_AnoFiscal__c;
    }  

    @AuraEnabled
    public static String getVagas(String aIdMember, String aCargo) {

        String lAnoFiscal = loadAnoFiscalVigente();
        if(String.isEmpty(lAnoFiscal)) return null;

        Integer lTotalVagas = aCargo == 'NÃO ELEGÍVEL' ? 0
                                : aCargo == 'DIRETORES' ? Integer.valueOf(Label.V_VagasDiretor)
                                : aCargo == 'LÍDERES' ? Integer.valueOf(Label.V_VagasLider)
                                : aCargo == 'GERENTES DE CONTAS' ? Integer.valueOf(Label.V_VagasGerenteDeContas)
                                : Integer.valueOf(Label.V_VagasCordenador_GerenteRegional); 

        // List<AggregateResult> lLstAgg = [SELECT COUNT(Id)total FROM VN_MetasParticipantes__c
        //         WHERE V_Participante__r.V_Cargo__c =: aCargo AND Name =: lAnoFiscal AND V_ElegivelAoElite__c = true];
        List<AggregateResult> lLstAgg = [SELECT COUNT(Id)total FROM VN_MetaParticipante__c
                WHERE V_Participante__r.V_PapelElite__c =: aCargo AND Name =: lAnoFiscal AND V_ElegivelAoElite__c = true];
        Integer lTotalMembers = !lLstAgg.isEmpty() ? Integer.valueOf(lLstAgg[0].get('total')) : 0;

        Integer lVagas = lTotalMembers >= lTotalVagas ? 0 : (lTotalVagas - lTotalMembers); 
        
        //return lVagas < 10 ? '0'+String.valueOf(lVagas) : String.valueOf(lVagas);
        return lTotalVagas < 10 ? '0'+String.valueOf(lTotalVagas) : String.valueOf(lTotalVagas);
    }

    @AuraEnabled
    public static Badge getNumBadges(String aIdMember) {

        Badge lBadge = new Badge();
        lBadge.wBadgeEliteD = 0;
        lBadge.wBadgeYoubetD = 0;
        lBadge.wBadgeEngajamentoD = 0;

        for(AggregateResult lAgg: [SELECT FieloPLT__Badge__r.V_Classificacao__c tipo, COUNT(id) total FROM FieloPLT__BadgeMember__c WHERE FieloPLT__Member__c =: aIdMember
                AND FieloPLT__Status__c != 'Reverted' AND (FieloPLT__ExpirationDate__c = null OR FieloPLT__ExpirationDate__c >= TODAY)
                AND FieloPLT__Badge__r.FieloPLT__Status__c = 'Active'  GROUP BY FieloPLT__Badge__r.V_Classificacao__c]){
            if(lAgg.get('tipo') == null || lAgg.get('total') == null ) continue;

            String lTipo = String.valueOf(lAgg.get('tipo'));
            Integer lTotal = Integer.valueOf(lAgg.get('total'));
            if(lTipo == label.V_BadgeElite){
                lBadge.wBadgeEliteD = lTotal;
            } else if(lTipo == label.V_BadgeYouBet){
                lBadge.wBadgeYoubetD = lTotal;
            } if(lTipo == label.V_BadgeEngajamento){
                lBadge.wBadgeEngajamentoD = lTotal;
            }
        }

        lBadge.wBadgeElite = lBadge.wBadgeEliteD < 10 ? '0'+String.valueOf(lBadge.wBadgeEliteD) : String.valueOf(lBadge.wBadgeEliteD);
        lBadge.wBadgeYoubet = lBadge.wBadgeYoubetD < 10 ? '0'+String.valueOf(lBadge.wBadgeYoubetD) : String.valueOf(lBadge.wBadgeYoubetD);
        lBadge.wBadgeEngajamento = lBadge.wBadgeEngajamentoD < 10 ? '0'+String.valueOf(lBadge.wBadgeEngajamentoD) : String.valueOf(lBadge.wBadgeEngajamentoD);

        return lBadge;
    }

    public class Badge{

        @AuraEnabled public String wBadgeElite {get; set;}
        @AuraEnabled public String wBadgeYoubet {get; set;}
        @AuraEnabled public String wBadgeEngajamento {get; set;}
        @AuraEnabled public Integer wBadgeEliteD {get; set;}
        @AuraEnabled public Integer wBadgeYoubetD {get; set;}
        @AuraEnabled public Integer wBadgeEngajamentoD {get; set;}
    }

}