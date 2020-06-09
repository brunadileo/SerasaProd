({
	myReward : function(component, event, helper) {

		var lMember = component.get("v.member");
		var lTipo = component.get("v.youbetType");
		if(!lMember) return;

		var action = component.get('c.getReward');
        action.setParams({aTipo:lTipo, aMemberId: lMember.Id});
       
        action.setCallback(this, function(response){   
            
            if(!response.getReturnValue()){
                component.set("v.reward",null); 
                component.set("v.carregouDados", true);
                component.set("v.expirado", true);
                return;
            }
            component.set("v.reward", response.getReturnValue());  

            var idReward = response.getReturnValue().Id; 

            var action2 = component.get('c.proximoLance');
			var param = new Object();
			param.aIdReward = idReward;
			param.aTipo = lTipo;
			action2.setParams(param);
	        action2.setCallback(this, function(a){ 

	        	if(!a.getReturnValue()){
	            	component.set("v.proximoLance", null);    
		        } else {
			        var dataProximo = $A.localizationService.formatDate(a.getReturnValue().V_DataHoraInicioYoubet__c, "dd/MM/yyyy");
			        component.set("v.proximoLance", dataProximo);  
		        }     
		        
	        });
       		$A.enqueueAction(action2);

       		var action3 = component.get('c.youbetFuturo');
			var param = new Object();
			param.aIdReward = idReward;
			param.aTipo = lTipo;
			action3.setParams(param);
	        action3.setCallback(this, function(a){ 

	            if(!a.getReturnValue()){
	            	component.set("v.youbetFuturo", null);    
		        } else {

		        	var dataProximo = $A.localizationService.formatDate(a.getReturnValue().V_DataHoraInicioYoubet__c, "dd/MM/yyyy");
		            component.set("v.youbetFuturo", dataProximo);
		        }
	        });
	        $A.enqueueAction(action3);

	        //add 28/01/19 - #14574
	        var action4 = component.get('c.podeDarLance');
        	action4.setParams({aIdReward:idReward});
        	action4.setCallback(this, function(a){ 

	            if(!a.getReturnValue()){
	            	component.set("v.podeParticiparLeilao", false);    
		        } else {
		            component.set("v.podeParticiparLeilao", a.getReturnValue());
		        }
	        });
	        $A.enqueueAction(action4);



            var countDownDate = new Date(response.getReturnValue().V_DataHoraFimYoubet__c).getTime();
			var x = setInterval(function() {

			    var now = new Date().getTime();
			    var distance = countDownDate - now;
			    if(distance < 0) {
			    	component.set("v.expirado", true);
			    }
			    component.set("v.carregouDados", true);
			    
			    var days = Math.floor(distance / (1000 * 60 * 60 * 24));
			    var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
			    //var hours = Math.floor((distance % (1000 * 60 * 60 * 8760)) / (1000 * 60 * 60)); 
			    var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
			    var seconds = Math.floor((distance % (1000 * 60)) / 1000);

			    hours = hours < 10 ? '0'+ hours : hours;
			    minutes = minutes < 10 ? '0'+ minutes : minutes;
			    seconds = seconds < 10 ? '0'+ seconds : seconds;
			    
			    var spanTempoFim = document.getElementById('tempo-fim-youbet');
			    if(!spanTempoFim) return;


				if (distance > 0) { 

					if(response.getReturnValue().V_IsActive__c){
						spanTempoFim.innerHTML =  +days + "d - " + hours + ":"
			   			 + minutes + ":" + seconds;

						let button = component.find('submit');
	    				button.set('v.disabled',false);
					} else {
						spanTempoFim.innerHTML = 'Não Iniciado';
					}
				}		    
			    
			    if (distance < 0) {
			        clearInterval(x);
			        var msgExpirado = $A.get('{!$Label.c.V_MsgLeilaoExpirado}');
			        spanTempoFim.innerHTML = msgExpirado;
			    }
			}, 1000);

			//add 21/02/19 - #14982
	    	var actionSumAccess = component.get('c.sumAccess');
	    	actionSumAccess.setParams({aIdMember:lMember.Id,aIdReward:idReward});
	    	actionSumAccess.setCallback(this, function(a){ 

	            if(!a.getReturnValue()){
	            	console.error('>>> sum access fail: SX_YoubetBetsContoller.sumAccess');  
		        } 
	        });
			$A.enqueueAction(actionSumAccess);
			
			//add 22/07/19 - #15974
			var action5 = component.get('c.proximosPremios');
			var param = new Object();
			param.aIdReward = idReward;
			param.aTipo = lTipo;
			action5.setParams(param);
	        action5.setCallback(this, function(response){ 
				if(response.getReturnValue()){
					component.set("v.lstPremios", response.getReturnValue()); 
					component.set("v.hasLstPremios", true);
				}	     	        
	        });
       		$A.enqueueAction(action5);
        });
        $A.enqueueAction(action);
	},
	onClick: function (component, event, helper) {
      
        var tipo = component.get('v.youbetType');
        var member = component.get('v.member');
        var reward = component.get('v.reward');
        var lance = component.find("lance").get("v.value");

        if(!member || !reward) return;

        var alertModal = $A.get("e.c:SX_Alert_Evt");

        if(!lance){
        	alertModal.setParams({"msg" : "Por favor informe o valor do lance", "tipo": "error"});
	        alertModal.fire();
	        return;
        }

        if (tipo == 'youbet' && member.FieloPLT__Points__c < lance
        	|| tipo == 'youbet-extra' && member.V_BetcoinsComp__c < lance) {
	        alertModal.setParams({"msg" : "Saldo Insuficiente", "tipo": "error"});
	        alertModal.fire();
	        return;
		}
        var dataHoraFim = new Date(reward.V_DataHoraFimYoubet__c).getTime();
        var dataHoraAtual = new Date().getTime();
        var tempoExpiracao = dataHoraFim - dataHoraAtual;

		var ultimoLance;
		if(reward.FieloPLT__RedemptionItems__r){
			ultimoLance = reward.FieloPLT__RedemptionItems__r[0].FieloPLT__Quantity__c;
		}

		if (tempoExpiracao < 0) {
			alertModal.setParams({"msg" : $A.get('{!$Label.c.V_MsgTempoEsgotado}'), "tipo": "error"}).fire();
	        return;
		}

		if(reward.V_LanceResgatarAgora__c){
			if(ultimoLance > 0){
				alertModal.setParams({"msg" : $A.get('{!$Label.c.V_MsgLanceArrematado}'), "tipo": "error"}).fire();
	        	return;
			} 
			 if(lance != reward.V_LanceResgatarAgora__c){
			 	alertModal.setParams({"msg" : $A.get('{!$Label.c.V_MsgLanceResgatarAgora}'), "tipo": "error"}).fire();
				return;
			} 
		} 
		else {
			if(reward.V_LanceMinimo__c && lance < reward.V_LanceMinimo__c){
				alertModal.setParams({"msg" : $A.get('{!$Label.c.V_MsgLanceMinimo}'), "tipo": "error"}).fire();
				return;
			}
			if(lance <= ultimoLance) {
				alertModal.setParams({"msg" : $A.get('{!$Label.c.V_MsgValorLance}'), "tipo": "error"}).fire();
				return;
			}
		}

		var alertConfirmation = $A.get("e.c:SX_Confirmation_Evt");
		alertConfirmation.setParams({"lance" : lance, "type": tipo, "member": member, "reward": reward}).fire();
    },
})