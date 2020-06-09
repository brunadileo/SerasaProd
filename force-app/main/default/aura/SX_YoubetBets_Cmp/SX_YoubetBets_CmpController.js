({
	myMember : function(component, event, helper) {
		var action = component.get("c.getMember");
         action.setCallback(this, function(a){ 
         	
            component.set("v.member", a.getReturnValue());  
            helper.myReward(component, event);
        });
        $A.enqueueAction(action);
	},

    darLance: function (component, event, helper) {
         helper.onClick(component, event, helper);
    },
    waiting: function(component, event, helper) {
        document.getElementById("spinner").style.display = "block";
    },
    doneWaiting: function(component, event, helper) {
        document.getElementById("spinner").style.display = "none";
    },
    openExtract : function(component, event, helper) {
        var tipo = component.get('v.youbetType');
        var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
        modalEvent.setParams({"type" : tipo, "name" : "Extract"});
        modalEvent.fire();
    },
    openYoubetsPerformed : function(component, event, helper) {
        var tipo = component.get('v.youbetType');
        var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
        modalEvent.setParams({"type" : tipo, "name" : "YoubetsPerformed"});
        modalEvent.fire();
    },
    openTeamPerformance : function(component, event, helper) {
        var tipo = component.get('v.youbetType');
        var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
        modalEvent.setParams({"type" : tipo, name:"TeamPerformance"});
        modalEvent.fire();
    },

})