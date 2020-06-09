({
    loadRanking: function(component, event, helper) {
        var lMember = component.get("v.member");
        if(!lMember) return;
        var action = component.get('c.getRanking');
        var param = new Object();
        param.aPapelElite = lMember.V_PapelElite__c;
        action.setParams(param);
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.rankingMap", response.getReturnValue());
                component.set("v.rankingVagas", component.get("v.rankingMap")[0]);
                component.set("v.rankingQuaseLa", component.get("v.rankingMap")[1]);
            }
        });
        $A.enqueueAction(action);
    },

    loadUltimoMesProcessado: function(component, event, helper){

        var lMember = component.get("v.member");
        if(!lMember) return;

        component.set("v.ultimoMesProcessado", lMember.V_MetasAnoFiscalVigenteNovo__r.V_UltimoMesAtualizado__c);
		var anos = lMember.V_MetasAnoFiscalVigenteNovo__r.V_AnoFiscal__r.V_PeriodoAF__c.split("-");
		component.set("v.ano", anos[0]);

		if (lMember.V_MetasAnoFiscalVigenteNovo__r.V_UltimoMesAtualizado__c == 'Janeiro' 
                || lMember.V_MetasAnoFiscalVigenteNovo__r.V_UltimoMesAtualizado__c == 'Fevereiro'
                || lMember.V_MetasAnoFiscalVigenteNovo__r.V_UltimoMesAtualizado__c == 'Março')
			component.set("v.anofim", anos[1]);
		else
			component.set("v.anofim", anos[0]);
    }
});