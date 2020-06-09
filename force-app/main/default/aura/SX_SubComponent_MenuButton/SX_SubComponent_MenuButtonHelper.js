({
	changeClass : function (idsInativar, idAtivar) {
		for(var i = 0; i< idsInativar.length ; i++) {
			$("#" + idsInativar[i]).removeClass("active");
		}

		$("#" + idAtivar).addClass("active");
	},
	h_toggleMenu : function (component, event, helper) {
 		if(window.location.href.indexOf("elite-home") > -1) {
			helper.changeClass(['home', 'youbet', 'elite', 'spy'], 'elite');
 		} else if(window.location.href.indexOf("youbet-home") > -1) {
			helper.changeClass(['home', 'youbet', 'elite', 'spy'], 'youbet');
 		} else if(window.location.href.indexOf("spy-home") > -1) {
			helper.changeClass(['home', 'youbet', 'elite', 'spy'], 'spy');
 		} else {
			helper.changeClass(['home', 'youbet', 'elite', 'spy'], 'home');
 		}
 		//checar se o menu está aberto ou fechado
 		// se aberto, fechar
 		// se fechado, abrir
 		if($('#menuBox').css('display') == 'none') {
 			$('#menuBox').fadeIn(100);
            $('.main-menu-mod').fadeOut(100);
            $('.greetings').fadeOut(100);
		} else {
			$('#menuBox').fadeOut(100);
            $('.main-menu-mod').fadeIn(100);
            $('.greetings').fadeIn(100);
 		}
 	},
 	loadDadosMeta : function(component, event, helper) {

		var lMember = component.get("v.lMember");
		if(!lMember) return;

		var action = component.get('c.getScore');
		var param = new Object();
		param.aIdMember = lMember.Id;
		action.setParams(param);
        action.setCallback(this, function(response){ 
            component.set("v.score", response.getReturnValue());       
        });
        $A.enqueueAction(action);
	},
	loadRanking : function(component, event, helper) {

		var lMember = component.get("v.lMember");
		if(!lMember) return;

		var action = component.get('c.getRanking');
		var param = new Object();
		param.aIdMember = lMember.Id;
		param.aCargo = lMember.V_PapelElite__c;
		action.setParams(param);
		action.setCallback(this, function(response){ 

            var state = response.getState();
            if (state === "SUCCESS") {                
                var ranking = [];
                component.set("v.positionRanking", response.getReturnValue());
            }        
        });
        $A.enqueueAction(action);
	},
})