({
	loadAgreement : function(component, event, helper) {

		var member = component.get('v.member');
        console.log(member);
        if(!member) return;

        var action =  component.get("c.getAgreement");
        action.setParams({
            aIdProgram : member.FieloPLT__Program__c
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.agreement",response.getReturnValue());
                var showAccept = response.getReturnValue().Id != member.FieloPLT__Agreement__c;
                component.set("v.showAccept", showAccept);
            } else {
                console.log('Erro ao carregar o regulamento');
            }
        });
        $A.enqueueAction(action);
	},
	onCheck: function(component, event) {

		var member = component.get('v.member');
        if(!member) return;

		var aceite = component.find("aceite").get("v.value");
		if(!aceite) return;
		var action = component.get("c.acceptAgreement");
		action.setParams({
            aAgree : aceite,
            aIdMember : member.Id
        });
        action.setCallback(this, function(a){ 
            var rtnValue = response.getReturnValue();    
        });
        $A.enqueueAction(action);

	 }
})