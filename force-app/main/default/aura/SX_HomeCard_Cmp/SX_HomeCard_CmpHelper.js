({

	myReward : function(component, event, helper) { 

		component.set("v.showMsgSemPremio", false);  

		var lMember = component.get("v.member");      
		if(!lMember) return;

		var action = component.get('c.getReward'); 
        action.setParams({aMemberId: lMember.Id});   
       
        action.setCallback(this, function(response){

        	if(!response.getReturnValue()){
        		component.set("v.reward", null); 
        		component.set("v.expirado", true);
        		component.set("v.showMsgSemPremio", true); 
        		return;

        	}
            component.set("v.reward", response.getReturnValue());  
             

            var countDownDate = new Date(response.getReturnValue().V_DataHoraFimYoubet__c).getTime();
			var x = setInterval(function() {

			    var now = new Date().getTime();
			    var distance = countDownDate - now;
			     if(distance < 0) {
			    	component.set("v.expirado", true);
			    }
			    component.set("v.showMsgSemPremio", true);
			    
			    var days = Math.floor(distance / (1000 * 60 * 60 * 24));
			    var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
			    //var hours = Math.floor((distance % (1000 * 60 * 60 * 8760)) / (1000 * 60 * 60)); 
			    var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
			    var seconds = Math.floor((distance % (1000 * 60)) / 1000);

			    hours = hours < 10 ? '0'+ hours : hours;
			    minutes = minutes < 10 ? '0'+ minutes : minutes;
			    seconds = seconds < 10 ? '0'+ seconds : seconds;
			    
			    var spanTempoFim = document.getElementById('tempo-fim');
			    if(!spanTempoFim) {
			    	return;
			    }

			    if(response.getReturnValue().V_IsActive__c){
					spanTempoFim.innerHTML =  +days + "d - " + hours + ":"
		   			 + minutes + ":" + seconds;
				} else {
					spanTempoFim.innerHTML = 'Não Iniciado';
				}
			    
			    if (distance < 0) {
			    
			        clearInterval(x);

			        var msgExpirado = $A.get('{!$Label.c.V_MsgLeilaoExpirado}');
			        spanTempoFim.innerHTML = msgExpirado;
			    }
			     
			}, 1000);   
        });
        $A.enqueueAction(action);
	},
	tempoRestante : function(component, event, helper) {

		var lReward = component.get("v.reward");
		if(!lReward) return;

		var countDownDate = new Date(lReward.V_DataHoraFimYoubet__c).getTime();
		var x = setInterval(function() {

		    var now = new Date().getTime();
		    var distance = countDownDate - now;
		    
		    var days = Math.floor(distance / (1000 * 60 * 60 * 24));
		    var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
		    //var hours = Math.floor((distance % (1000 * 60 * 60 * 8760)) / (1000 * 60 * 60)); 
		    var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
		    var seconds = Math.floor((distance % (1000 * 60)) / 1000);
		    
		    var spanTempoFim = document.getElementById('tempo-fim');
		    if(!spanTempoFim) return;

		    spanTempoFim.innerHTML =  +days + "d - " + hours + ":"
		    + minutes + ":" + seconds;
		    
		    if (distance < 0) {
		        clearInterval(x);

		        var msgExpirado = $A.get('{!$Label.c.V_MsgLeilaoExpirado}');
		        spanTempoFim.innerHTML = msgExpirado;
		    }
		}, 1000);
	},
	loadDadosMeta : function(component, event, helper) {

		var lMember = component.get("v.member");
		if(!lMember) return;

		var action2 = component.get('c.getMetaScore');
		var param = new Object();
		param.aIdMember = lMember.Id;
		action2.setParams(param);
        action2.setCallback(this, function(response){ 
        	if(!response.getReturnValue()){
        		component.set("v.meta", '0');     
        		return;
        	}
            component.set("v.meta", response.getReturnValue());       
        });
        $A.enqueueAction(action2);
	},
	loadRanking : function(component, event, helper) {

		var lMember = component.get("v.member");
		if(!lMember) return;

		var action3 = component.get('c.getRanking');
		var param = new Object();
		param.aIdMember = lMember.Id;
		param.aCargo = lMember.V_PapelElite__c;
		action3.setParams(param);
		action3.setCallback(this, function(response){ 

			if(!response.getReturnValue()){
				component.set("v.positionRanking", '0'); 
				console.log('erro');    
        		return;
        	}
			component.set("v.positionRanking", response.getReturnValue());
			console.log('posicaoRanking: ' + component.get("v.positionRanking"));
        });
        $A.enqueueAction(action3);
	},
	loadVagas : function(component, event, helper) {

		var lMember = component.get("v.member");
		if(!lMember) return;

		var action4 = component.get('c.getVagas');
		var param = new Object();
		param.aIdMember = lMember.Id;
		param.aCargo = lMember.V_PapelElite__c;
		action4.setParams(param);
        action4.setCallback(this, function(response){ 

        	if(!response.getReturnValue()){
        		component.set("v.vagas", '0');     
        		return;
        	}
            component.set("v.vagas", response.getReturnValue());       
        });
        $A.enqueueAction(action4);
	},
	loadNumBadges : function(component, event, helper) {

		var lMember = component.get("v.member");
		if(!lMember) return;

		var action = component.get('c.getNumBadges');
		var param = new Object();
		param.aIdMember = lMember.Id;
		action.setParams(param);
        action.setCallback(this, function(response){
            component.set("v.numBadges", response.getReturnValue());       
        });
        $A.enqueueAction(action);
	},

})