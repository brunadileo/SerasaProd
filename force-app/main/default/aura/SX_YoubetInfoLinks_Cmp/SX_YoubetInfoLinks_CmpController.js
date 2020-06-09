({
	myAction : function(component, event, helper) {
	},

	openAgreement : function(component, event, helper) {
		var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
		var youbetType = component.get('v.youbetType');
        modalEvent.setParams({"name" : "Agreement", type: youbetType});
        modalEvent.fire();
	}
})