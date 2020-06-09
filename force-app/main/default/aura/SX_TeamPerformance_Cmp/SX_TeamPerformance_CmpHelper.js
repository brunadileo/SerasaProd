({
    loadResultados: function(component, event, helper) {

        component.set("v.Spinner", true);

		var cols = [
            {label: 'NOME', fieldName: 'V_Participante__c', type: 'text'},
            {label: 'DATA', fieldName: 'V_DataTexto__c', type: 'text'},
            {label: 'PRÊMIO', fieldName: 'V_NomePremio__c', type: 'text'},
            {label: 'BETCOINS INVESTIDOS', fieldName: 'V_BetcoinsInvestidos__c', type: 'number'}
        ];
        component.set("v.tableCols", cols);

        var member = component.get('v.member');
        if(!member) return;

        var area = component.find("area").get("v.value") == 'Diretoria' ? null : component.find("area").get("v.value");
        var subArea = component.find("subArea").get("v.value") == 'Setor' ? null : component.find("subArea").get("v.value");
        var cargo = component.find("cargo").get("v.value") == 'Cargo' ? null : component.find("cargo").get("v.value");
        var palavraChave = !component.find("palavraChave").get("v.value") ? null : component.find("palavraChave").get("v.value");
        var tipo = component.get('v.youbetType');

		var action =  component.get("c.getLances");
        action.setParams({
            aArea : area,
            aLideranca : subArea,
            aCargo : cargo,
            aPalavraChave : palavraChave,
            aTipo: tipo,
            aIdMember :member.Id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.lstRdi",response.getReturnValue());
            } else {
                console.error('Erro');
            }
            component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);
	},
    doCloseModal : function(component, event) {

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
    loadCargo : function(component){

        var member = component.get('v.member');
        if(!member) return;

        var action = component.get('c.getCargo');
        action.setParams({aIdMember :member.Id});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var recordTypes = response.getReturnValue();
                component.set('v.lstCargo', response.getReturnValue());
            } else {
                var errors = response.getError();
                console.log(errors);
            }
        }));
        $A.enqueueAction(action);
    },
});