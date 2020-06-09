({
	loadDadosMeta : function(component, event, helper) {

		var lMember = component.get("v.member");
		if(!lMember) return;
		var action = component.get('c.getMetaParticipante');
		var param = new Object();
		param.aIdMember = lMember.Id;
		action.setParams(param);
        action.setCallback(this, function(response){ 
			component.set("v.meta", response.getReturnValue());
			this.loadUltimoMesProcessado(component, event);
        });
		$A.enqueueAction(action);
	},

	// redirecionarHome : function(component, event, helper) {
	// 	var evt = $A.get("e.force:navigateToComponent");
	// 	evt.setParams({
	// 		componentDef : "c:SX_SpyHome_Cmp",
	// 		componentAttributes: {
	// 		// 	contactName : component.get("v.contact.Name")
	// 		 }
	// 	});
	// 	evt.fire();
	// },

	loadVagas : function(component, event, helper) {
		var lMember = component.get("v.member");
		if(!lMember) return;

		//var action = component.get('c.getVagas');
		var action = component.get('c.getVagasNovaEstrutura');
		var param = new Object();
		param.aIdMember = lMember.Id;
		param.aCargo = lMember.V_PapelElite__c;
		action.setParams(param);
        action.setCallback(this, function(response){ 
            component.set("v.vagas", response.getReturnValue());       
        });
        $A.enqueueAction(action);
	},

	loadPosicaoRanking : function(component, event, helper){
		var lMember = component.get("v.member");
		if(!lMember) return;

		var action = component.get('c.getPosicaoRanking');
		var param = new Object();
		param.aIdMember = lMember.Id;
		param.aCargo = lMember.V_PapelElite__c;
		action.setParams(param);
		action.setCallback(this, function(response){
			var state = response.getState();
            if (state === "SUCCESS") {
				component.set("v.posicaoRanking", response.getReturnValue());
			} else {
				component.set("v.posicaoRanking",0)
			}
		});
		$A.enqueueAction(action);
	},

	loadRanking : function(component, event, helper) {

		var lMember = component.get("v.member");
		if(!lMember) return;

		//var action = component.get('c.getRanking');
		var action = component.get('c.getRankingNovaEstrutura');
		var param = new Object();
		param.aIdMember = lMember.Id;
		param.aCargo = lMember.V_PapelElite__c;
		action.setParams(param);
		action.setCallback(this, function(response){ 

            var state = response.getState();
            if (state === "SUCCESS") {                
                var ranking = [];
                component.set("v.ranking", response.getReturnValue());
                component.set("v.mostrarRanking", true);
               // component.set("v.pontuacaoElegivel", $A.get('{!$Label.c.V_PontuacaoElegivel}'));  
            }        
        });
        $A.enqueueAction(action);
	},

	loadUltimoMesProcessado: function(component, event, helper){
		var lMeta = component.get("v.meta");
		if (!lMeta) return;

		component.set("v.ultimoMesProcessado", lMeta.V_UltimoMesAtualizado__c);
		var anos = lMeta.V_AnoFiscal__r.V_PeriodoAF__c.split("-");
		component.set("v.ano", anos[0]);

		if (lMeta.V_UltimoMesAtualizado__c == 'Janeiro' 
                || lMeta.V_UltimoMesAtualizado__c == 'Fevereiro'
                || lMeta.V_UltimoMesAtualizado__c == 'Março')
			component.set("v.anofim", anos[1]);
		else
			component.set("v.anofim", anos[0]);
    }
})