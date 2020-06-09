({
	loadAgreement : function(component, event, helper) {
		var member = component.get('v.Member');
        if(!member) return;

        component.set("v.agreed", false);
        var action =  component.get("c.getAgreement");
        action.setParams({
            aIdProgram : member.FieloPLT__Program__c
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.agreement",response.getReturnValue());
                var isAgreed = response.getReturnValue().Id == member.FieloPLT__Agreement__c;
                component.set("v.agreed", isAgreed); 
            }  else {
            	component.set("v.agreement", null);
            }
            component.set("v.loaded", true);
        });
        $A.enqueueAction(action);
	},
	acceptAgreement : function(component, event, helper) {

        var accept = component.find("accept").get("v.value");
        var member = component.get('v.Member');

        if(!accept || !member) return;

        var action2 = component.get("c.aceitarRegulamento");
        action2.setParams({aIdMember:member.Id});
        action2.setCallback(this, function(response){
            if(response.getReturnValue()){
                component.set("v.agreed", true); 
            }
        });
        $A.enqueueAction(action2);
    },
})