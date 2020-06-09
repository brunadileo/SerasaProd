({
     loadResultados: function(component, event, helper) {

        component.set("v.Spinner", true);

        var cols = [
            {label: 'YOUBET', fieldName: 'Name', type: 'text'},
            {label: 'DATA DE INÍCIO', fieldName: 'V_DataInicioTexto__c', type: 'text'},
            {label: 'DATA FINAL', fieldName: 'V_DataFimTexto__c', type: 'TEXT'},
            {label: 'VENCEDOR', fieldName: 'V_NomeVencedor__c', type: 'text'},
            {label: 'BETCOINS', fieldName: 'V_ValorLanceGanhador__c', type: 'number'},
            // {label: 'REGULAMENTO', type: 'button', initialWidth: 135, typeAttributes: { iconName: 'utility:preview', name: 'show_agreement'}},
        ];
        component.set("v.tableCols", cols);

        var member = component.get('v.member');
        if(!member) return;

        var dataDe = component.find("dataDe").get("v.value");
        var dataAte = component.find("dataAte").get("v.value");
        var palavraChave = !component.find("palavraChave").get("v.value") ? null : component.find("palavraChave").get("v.value");
        var tipo = component.get('v.youbetType');

        var action =  component.get("c.getYoubets");
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
                component.set("v.lstRewards",response.getReturnValue());
            } else {
                console.log('Erro');
            }
            component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);
    },
})