({
    loadResultados: function(component, event, helper) {

        component.set("v.Spinner", true);

		var cols = [
            {label: 'DATA', fieldName: 'V_DataTexto__c', type: 'text'},
            {label: 'ATIVIDADES', fieldName: 'V_Origem__c', type: 'text'},
            {label: 'BETCOINS', fieldName: 'FieloPLT__TotalPoints__c', type: 'number'}
            // ADICIONAR PARAMETRO PARA SORTING
            // sortable: true
        ];
        component.set("v.tableCols", cols);

        var member = component.get('v.member');
        if(!member) return;

        var dataDe = component.find("dataDe").get("v.value");
        var dataAte = component.find("dataAte").get("v.value");
        var palavraChave = !component.find("palavraChave").get("v.value") ? null : component.find("palavraChave").get("v.value");
        var tipo = component.get('v.youbetType');

		var action =  component.get("c.getPoints");
        action.setParams({
            aDe : dataDe,
            aAte : dataAte,
            aPalavraChave : palavraChave,
            aTipo: tipo,
            aIdMember :member.Id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.lstPoints",response.getReturnValue());
            } else {
                console.log('Erro');
            }
            component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);
	},

    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';

        data = Object.assign([],
            data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
        );
        cmp.set("v.data", data);
    },

    sortBy: function (field, reverse, primer) {
        var key = primer
            ? function(x) { return primer(x[field]) }
            : function(x) { return x[field] };

        return function (a, b) {
            var A = key(a);
            var B = key(b);
            return reverse * ((A > B) - (B > A));
        };
    }
});