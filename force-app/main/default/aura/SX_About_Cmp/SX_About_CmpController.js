({
    myMember : function(component, event, helper) {
		var action =component.get("c.getMember");
        action.setCallback(this, function(a){ 
         	
            component.set("v.member", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    openEliteAgreement : function(component, event, helper) {
        var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
       modalEvent.setParams({"name" : "Agreement", "type" : 'elite'});
       modalEvent.fire();
    },

    openYoubetAgreement : function(component, event, helper) {
        var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
       modalEvent.setParams({"name" : "Agreement", "type" : 'youbet'});
       modalEvent.fire();
    },

    openSpyAgreement : function(component, event, helper) {
        var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
       modalEvent.setParams({"name" : "Agreement", "type" : 'spy'});
       modalEvent.fire();
    }
})