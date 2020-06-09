({
	loadResultados: function(component, event, helper) {

		var cols = [
            {label: 'NOME', fieldName: 'V_Nome__c', type: 'text'},
            {label: 'SCORE', fieldName: 'V_ScoreElite__c', type: 'number'}
        ];
        component.set("v.tableCols", cols);

        var member = component.get('v.member');
        if(!member) return;
        console.log('### >1 ');

        var area = component.find("area").get("v.value") == 'Área' ? null : component.find("area").get("v.value");
        var subArea = component.find("subArea").get("v.value") == 'Liderança' ? null : component.find("subArea").get("v.value");
        console.log('### >.2 ');
        var cargo = null; //component.find("cargo").get("v.value") == 'Categoria' ? null : component.find("cargo").get("v.value");

        var papel = component.find("papel").get("v.value") == 'Cargo' ? null : component.find("papel").get("v.value");

        console.log('### >. '+papel);
        if(!papel){
        	var alertModal = $A.get("e.c:SX_Alert_Evt");
        	alertModal.setParams({"msg" : "É necessário selecionar o Cargo para essa consulta", "tipo": "error"});
	        alertModal.fire();
	        return;
        }

        component.set("v.Spinner", true);

		var action =  component.get("c.getMetas");
        action.setParams({
            aArea : area,
            aLideranca : subArea,
            aCargo : cargo,
            aIdMember :member.Id,
            aPapel : papel
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.lstMetas",response.getReturnValue());
            } 
        });
        $A.enqueueAction(action);

        var action2 = component.get('c.getRanking');
		action2.setParams({
			aIdMember :member.Id,
            aArea : area,
            aLideranca : subArea,
            aCargo : cargo,
            aPapel : papel
        });
		action2.setCallback(this, function(response){ 
			
            var state = response.getState();

            if (state === "SUCCESS") {                
                var ranking = [];
                component.set("v.ranking", response.getReturnValue());
                component.set("v.mostrarRanking", true);
                component.set("v.pontuacaoElegivel", $A.get('{!$Label.c.V_PontuacaoElegivel}'));  
            }        
        });
        $A.enqueueAction(action2);

        component.set("v.Spinner", false);
    },
    loadPapel : function(component){

        var member = component.get('v.member');
        if(!member) return;

        var action = component.get('c.getPapel');
        action.setParams({aIdMember :member.Id});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();

            if(state === "SUCCESS"){
                var recordTypes = response.getReturnValue();

                component.set('v.lstPapel', response.getReturnValue());
            } else {
                var errors = response.getError();
                console.log(errors);
            }
        }));
        $A.enqueueAction(action);
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
})