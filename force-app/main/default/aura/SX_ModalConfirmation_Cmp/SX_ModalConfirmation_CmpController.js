({
		youbetModal : function(component, event, helper) {
				component.set("v.youbetType", event.getParam("type"));
				component.set("v.lance", event.getParam("lance"));
				component.set("v.member", event.getParam("member"));
				component.set("v.reward", event.getParam("reward"));
				$('#modalConfirmation').fadeIn(200);
		},

		closeModal : function (component, event, helper) {
				$('#modalConfirmation').fadeOut(200);
		},
		darLanceAcao : function (component, event, helper) {

			var member = component.get('v.member');
			var reward = component.get('v.reward');
			var lance = component.get('v.lance');
		
			component.set("v.Spinner", true); 
			var action = component.get("c.efetuarLance");
			action.setParams({aIdMember:member.Id, aIdReward:reward.Id, aLance:lance});
			action.setCallback(this, function(response){
					var rtnValue = response.getReturnValue();

					 $('#modalConfirmation').fadeOut(0);
					var sucesso = $A.get('{!$Label.c.V_MsgLanceSucesso}');
					if(rtnValue == sucesso){
						var alertSuccess = $A.get("e.c:SX_Success_Evt");
						alertSuccess.setParams({"lance" : lance}).fire();
					} else {
						var alertError = $A.get("e.c:SX_Alert_Evt");
						alertError.setParams({"msg" : rtnValue, "tipo": "error"}).fire();
					}
			});
			$A.enqueueAction(action);

		}
})