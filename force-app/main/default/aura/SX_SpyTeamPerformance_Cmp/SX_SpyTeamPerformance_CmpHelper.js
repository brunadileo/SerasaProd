({
	loadResultados: function(component, event, helper) {

		var cols = [
            {label: 'NOME', fieldName: 'wMember', type: 'text'},
            {label: 'Nº DE BADGES', fieldName: 'wNumBages', type: 'number'},
            {label: 'PONTUAÇÃO', fieldName: 'wPontuacao', type: 'number'}
        ];
        component.set("v.tableCols", cols);

        var member = component.get('v.member');
        if(!member) return;

        var area = component.find("area").get("v.value") == 'Diretoria' ? null : component.find("area").get("v.value");
        var subArea = component.find("subArea").get("v.value") == 'Setor' ? null : component.find("subArea").get("v.value");
        var badge = component.find("badge").get("v.value") == 'Badge' ? null : component.find("badge").get("v.value");
        var palavraChave = !component.find("palavraChave").get("v.value") ? null : component.find("palavraChave").get("v.value");
       
        component.set("v.Spinner", true);
		var action =  component.get("c.getBadgesPerformance");
        action.setParams({
            aArea : area,
            aLideranca : subArea,
            aBadge : badge,
            aPalavraChave : palavraChave,
            aIdMember :member.Id
        });
        action.setCallback(this, function(response) {

            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.tabelaBadges",response.getReturnValue());
            } 
        });
        $A.enqueueAction(action);

        component.set("v.Spinner", false);
	},
	loadArea : function(component){

        var member = component.get('v.member');
        if(!member) return;

        var action = component.get('c.getArea');
        action.setParams({aIdMember :member.Id});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var recordTypes = response.getReturnValue();
                component.set('v.lstArea', response.getReturnValue());
            } else {
                var errors = response.getError();
                console.log(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    loadSubArea : function(component){

        var member = component.get('v.member');
        if(!member) return;

        var action = component.get('c.getSubArea');
        action.setParams({aIdMember :member.Id});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var recordTypes = response.getReturnValue();
                component.set('v.lstSubArea', response.getReturnValue());
            } else {
                var errors = response.getError();
                console.log(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    loadBadges : function(component){

        var action = component.get('c.getBadges');
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var recordTypes = response.getReturnValue();
                component.set('v.lstBadges', response.getReturnValue());
            } else {
                var errors = response.getError();
                console.log(errors);
            }
        }));
        $A.enqueueAction(action);
    },
})