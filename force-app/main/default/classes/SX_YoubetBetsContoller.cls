/*******************************************************************************
*                          Copyright (C) 2018 ValueNET
* ------------------------------------------------------------------------------
* Author: FFV                          date: 15/09/2018
* 
* Name: SX_YoubetBetsContoller.cls
* 
* Controller responsável pelos lances de leilão
*******************************************************************************/
public with sharing class SX_YoubetBetsContoller {
	
	private static String UNLIMITED = 'Unlimited';
	private static String ERRO = 'Ocorreu um erro, por favor tente novamente mais tarde!.';

	@AuraEnabled
    public static FieloPLT__Member__c getMember() {
        List<FieloPLT__Member__c> lMemberLst = [SELECT Id, V_Cargo__c, V_BetcoinsComp__c,
        		 FieloPLT__Points__c, V_PapelYoubet__c
	                FROM FieloPLT__Member__c
	                WHERE FieloPLT__User__c =: UserInfo.getUserId()];

	    return lMemberLst.isEmpty() ? null : lMemberLst[0];         
    }

    @AuraEnabled //add 21/02/19 - #14982
    public static Boolean sumAccess(String aIdReward, String aIdMember) {

    	try{

    		system.debug('##>> '+aIdMember+' --- '+aIdReward);

    	 	VN_ParticipanteComPerfilCompativel__c lPerfilComp = [SELECT V_NumeroAcessos__c 	FROM VN_ParticipanteComPerfilCompativel__c 
    	 		WHERE V_Member__c =: aIdMember AND V_Reward__c =: aIdReward ORDER BY CreatedDate LIMIT 1];

    	 	lPerfilComp.V_NumeroAcessos__c ++;
    	 	update lPerfilComp;

	 	}catch(Exception e){
	 		system.debug('## '+e);
	 		return false;
	 	}  
	 	return true; 
    }

	@AuraEnabled
	public static FieloPLT__Reward__c getReward(String aMemberId, String aTipo) {
		String lIniciativa;
        if (aTipo == 'youbet') {
            lIniciativa = Label.V_IniciativaPerene;
        } else if (aTipo == 'youbet-extra') {
            lIniciativa = Label.V_IniciativaComplementar;
        }
        return SX_RewardServices.getReward(aMemberId, lIniciativa);
	}

    @AuraEnabled
    public static FieloPLT__Reward__c proximoLance(String aTipo, String aIdReward){

        String lIniciativa = aTipo == 'youbet' ? Label.V_IniciativaPerene 
        						: aTipo == 'youbet-extra' ? Label.V_IniciativaComplementar
        						: Label.V_IniciativaElite;

		List<VN_ParticipanteComPerfilCompativel__c> lstRewardCompativel = [SELECT V_Reward__c
				FROM VN_ParticipanteComPerfilCompativel__c WHERE V_Member__r.FieloPLT__User__c =: UserInfo.getUserId()
				AND V_Reward__r.V_IsActive__c = false
				AND V_Reward__r.Iniciativa__c =: lIniciativa AND V_Reward__r.V_DataHoraInicioYoubet__c >: System.now() 
				ORDER BY V_Reward__r.V_DataHoraFimYoubet__c LIMIT 1];
		if (lstRewardCompativel.isEmpty()) return null;

		List<FieloPLT__Reward__c> lLstReward = [SELECT id, Name, V_DataHoraInicioYoubet__c
												FROM FieloPLT__Reward__c
												WHERE Id =: lstRewardCompativel[0].V_Reward__c];

		return lLstReward.isEmpty() ? null : lLstReward[0];
	}

	@AuraEnabled
	public static String efetuarLance(String aIdMember, String aIdReward, Decimal aLance){

		List<FieloPLT__Reward__c> lLstReward = [SELECT Id, FieloPLT__Points__c, V_BetcoinsComp__c, V_LanceResgatarAgora__c,
												 V_LanceMinimo__c, V_DataHoraFimYoubet__c, V_Redemption__c, Iniciativa__c,
													 (SELECT FieloPLT__Quantity__c, FieloPLT__Redemption__r.FieloPLT__Member__r.Name, 
                                                        FieloPLT__Redemption__r.FieloPLT__Member__r.FieloPLT__Points__c
                                                        FROM FieloPLT__RedemptionItems__r 
														WHERE FieloPLT__Status__c =: Label.V_StatusOpen
														ORDER BY FieloPLT__Quantity__c DESC LIMIT 1)
											 	FROM FieloPLT__Reward__c   
												WHERE Id =: aIdReward
												FOR UPDATE]; 

		List<FieloPLT__Member__c> lLstMember = [SELECT FieloPLT__Points__c, V_BetcoinsComp__c 
			FROM FieloPLT__Member__c WHERE Id =: aIdmember];

		if(lLstReward.isEmpty() || lLstMember.isEmpty()) return ERRO;

		//double check
		FieloPLT__Reward__c lReward = lLstReward[0];

        FieloPLT__Member__c lMemberOld;

        //member antigo (para verificar o saldo posteriormente)
        if(lReward.FieloPLT__RedemptionItems__r != null && !lReward.FieloPLT__RedemptionItems__r.isEmpty()){
                FieloPLT__Redemption__c lRedemption = lReward.FieloPLT__RedemptionItems__r[0].FieloPLT__Redemption__r;
            if(lRedemption != null && lRedemption.FieloPLT__Member__r != null){
                lMemberOld = lRedemption.FieloPLT__Member__r;
            }  
        }

		FieloPLT__Member__c lMember = lLstMember[0];
		String lMsgValidacao = validarLance(lReward, lMember, Integer.valueOf(aLance));

		if(String.isNotEmpty(lMsgValidacao)){
			return lMsgValidacao;
		}

		Savepoint sp = Database.setSavepoint();

        try{

        	List<FieloPLT__Redemption__c> lLstRedemption = [SELECT Id FROM FieloPLT__Redemption__c
        	 WHERE FieloPLT__Member__c =: aIdMember AND FieloPLT__Status__c =: Label.V_StatusOpen
        	 AND Id IN (SELECT FieloPLT__Redemption__c FROM FieloPLT__RedemptionItem__c 
   			 	WHERE FieloPLT__Reward__c =: lReward.Id)];

        	FieloPLT__Redemption__c lRedemption;

        	FieloPLT.SObjectService.enableAdminPermission(true);

        	if(lLstRedemption.isEmpty()){

	        	lRedemption = new FieloPLT__Redemption__c( 
	                FieloPLT__Member__c = aIdMember, 
	                FieloPLT__Status__c = Label.V_StatusOpen, 
	                FieloPLT__Origin__c = 'FrontEnd'
	            );
	            insert lRedemption;

        	} else {
        		lRedemption = lLstRedemption[0];
        		delete [SELECT Id FROM FieloPLT__RedemptionItem__c WHERE FieloPLT__Redemption__c =: lRedemption.Id];
        	}

            FieloPLT__RedemptionItem__c lRedemptionItem = new FieloPLT__RedemptionItem__c( 
                FieloPLT__Redemption__c = lRedemption.Id, 
                FieloPLT__Reward__c = lReward.Id, 
                FieloPLT__Quantity__c = Integer.valueOf(aLance)
            );
            
            insert lRedemptionItem;

			FieloPLT__Redemption__c lRedemptionValidoAntigo = new FieloPLT__Redemption__c();
			if(lReward.V_Redemption__c != null){
				lRedemptionValidoAntigo.Id = lReward.V_Redemption__c;
                if(lMemberOld != null && lMemberOld.FieloPLT__Points__c > lRedemptionItem.FieloPLT__Quantity__c){
                    lRedemptionValidoAntigo.V_LanceValido__c = false;

					// add 09/12/19 - #17770 (para acionar o alerta de email sempre que o lance for coberto)
					update new FieloPLT__Redemption__c(Id = lRedemptionValidoAntigo.Id, V_LanceValido__c = true);
                }
			}

            FieloPLT.SObjectService.enableAdminPermission(false);
        	
    		lReward.V_Redemption__c = lRedemption.Id;
    		update lLstReward;

			if(lRedemptionValidoAntigo.Id != null)
				update lRedemptionValidoAntigo;

        	return Label.V_MsgLanceSucesso;
    	} catch(Exception e){

    		system.debug('#### erro ao efetuar lance '+ e);

    		if(e.getTypeName() == 'System.DmlException'){
    			return ERRO; //((System.DmlException) e).getDmlMessage(0);
    		} 
            Database.rollBack(sp);
    	}
		return ERRO;
	}

    private static String validarLance(FieloPLT__Reward__c aReward, FieloPLT__Member__c aMember, Integer aLance){

		if(aLance == null) return 'Insira o valor do lance';

		if( (aReward.Iniciativa__c == Label.V_IniciativaComplementar && aMember.V_BetcoinsComp__c < aLance)
			|| (aReward.Iniciativa__c == Label.V_IniciativaPerene && aMember.FieloPLT__Points__c < aLance) ){
			return 'Saldo Insuficiente.';
		}

		Decimal lUltimoLance = 0;
		if( !aReward.FieloPLT__RedemptionItems__r.isEmpty()) {
			lUltimoLance = aReward.FieloPLT__RedemptionItems__r[0].FieloPLT__Quantity__c;
		} 

		if(aReward.V_DataHoraFimYoubet__c < system.now()) return Label.V_MsgTempoEsgotado;

		if(aReward.V_LanceResgatarAgora__c != null){
			if(lUltimoLance > 0) return Label.V_MsgLanceArrematado;
			if(aLance != aReward.V_LanceResgatarAgora__c) return Label.V_MsgLanceResgatarAgora;
		} else {
			if(aReward.V_LanceMinimo__c != null && aLance < aReward.V_LanceMinimo__c) return Label.V_MsgLanceMinimo;
			if(aLance <= lUltimoLance) return Label.V_MsgValorLance;
		}
		return '';
	}

	@AuraEnabled
    public static Boolean podeDarLance(String aIdReward){

    	Boolean lPodeDarLance = true;
	    List<VN_ParticipanteComPerfilCompativel__c> lLstPerfilCompativel = [SELECT V_PodeParticiparLeilao__c  
	                                                                     FROM VN_ParticipanteComPerfilCompativel__c
	                                                                     WHERE V_Member__r.FieloPLT__User__c =: UserInfo.getUserId()
	                                                                     AND V_Reward__c =: aIdReward];

	    if(!lLstPerfilCompativel.isEmpty()) lPodeDarLance = lLstPerfilCompativel[0].V_PodeParticiparLeilao__c;
	    return lPodeDarLance;
    }

	//add 28/11 (alteração solicitada pelo atendimento). Método duplicado para não
	// alterar a estrutura já existente (*sem pipe)
	@AuraEnabled
    public static FieloPLT__Reward__c youbetFuturo(String aTipo, String aIdReward){

        String lIniciativa = aTipo == 'youbet' ? Label.V_IniciativaPerene 
        						: aTipo == 'youbet-extra' ? Label.V_IniciativaComplementar
        						: Label.V_IniciativaElite;

		List<VN_ParticipanteComPerfilCompativel__c> lstRewardCompativel = [SELECT V_Reward__c
				FROM VN_ParticipanteComPerfilCompativel__c WHERE V_Member__r.FieloPLT__User__c =: UserInfo.getUserId()
				AND V_Reward__r.V_IsActive__c = false
				AND V_Reward__r.Iniciativa__c =: lIniciativa AND V_Reward__r.V_DataHoraInicioYoubet__c >: System.now() 
				ORDER BY V_Reward__r.V_DataHoraFimYoubet__c LIMIT 2];
		if (lstRewardCompativel.isEmpty() || lstRewardCompativel.size() < 2) return null;

		List<FieloPLT__Reward__c> lLstReward = [SELECT id, Name, V_DataHoraInicioYoubet__c
												FROM FieloPLT__Reward__c
												WHERE Id =: lstRewardCompativel[1].V_Reward__c];

		return lLstReward.isEmpty() ? null : lLstReward[0];
	}

	@AuraEnabled
    public static List<PremiosCarrossel> proximosPremios(String aTipo, String aIdReward){

        String lIniciativa = aTipo == 'youbet' ? Label.V_IniciativaPerene 
        						: aTipo == 'youbet-extra' ? Label.V_IniciativaComplementar
        						: Label.V_IniciativaElite;

        Set<Id> lSetReward = new Set<Id>();
        for(VN_ParticipanteComPerfilCompativel__c perfilCompativel: [SELECT V_Reward__c 
        																FROM VN_ParticipanteComPerfilCompativel__c
        																WHERE V_Member__r.FieloPLT__User__c =: UserInfo.getUserId()
																		AND V_Reward__r.V_IsActive__c = false
																		AND V_Reward__r.Iniciativa__c =: lIniciativa 
																		AND V_Reward__r.V_DataHoraInicioYoubet__c >: System.now()]){
            if(perfilCompativel.V_Reward__c != null)
                lSetReward.add(perfilCompativel.V_Reward__c);
		}

		List<PremiosCarrossel> lLstReward = new List<PremiosCarrossel>();

		for(FieloPLT__Reward__c rew: [SELECT id, Name, V_DataHoraInicioYoubet__c, FieloPLT__Image__c
												FROM FieloPLT__Reward__c
												WHERE Id =: lSetReward
												AND Id !=: aIdReward
												AND V_DataHoraInicioYoubet__c >: System.now() 
												ORDER BY V_DataHoraInicioYoubet__c
												LIMIT 3]){

			PremiosCarrossel lPremio = new PremiosCarrossel();
			lPremio.wName = rew.Name;
			lPremio.wDataInicio = rew.V_DataHoraInicioYoubet__c.format('dd/MM/yyyy');
			lPremio.wImgURL = rew.FieloPLT__Image__c;
			lLstReward.add(lPremio);
		}
			
		return lLstReward.isEmpty() ? null : lLstReward;
	}

	public class PremiosCarrossel{

		@AuraEnabled public String wImgURL {get; set;}
		@AuraEnabled public String wName {get; set;}
		@AuraEnabled public String wDataInicio {get; set;}
	}

}