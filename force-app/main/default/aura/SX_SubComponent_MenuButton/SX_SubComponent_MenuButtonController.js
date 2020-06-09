({
	initComponent : function(component, event, helper) {
		var action = component.get("c.getMember");
         action.setCallback(this, function(a){ 

         	console.log(a.getReturnValue());
         	
            component.set("v.lMember", a.getReturnValue()); 
            helper.loadDadosMeta(component, event); 
            helper.loadRanking(component, event);       
        });
        $A.enqueueAction(action);
	},
	onChildAttributeChange : function (component, event, helper) {
        console.log("MENU - Old value: " + event.getParam("oldValue"));
        console.log("MENU - Current value: " + event.getParam("value"));
    },
	
	toggleMenu : function (component, event, helper) {
        helper.h_toggleMenu(component, event, helper);
 	},

 	// openReward : function(component, event, helper) {
 	// 	window.open('./youbet-home', '_self');
 	// },
 	// openRewardComp : function(component, event, helper) {
 	// 	window.open('./youbet-extra-home', '_self');
 	// },
 	openExtract : function(component, event, helper) {
 		var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
        modalEvent.setParams({"name" : "Extract", "type" : 'youbet'});
        modalEvent.fire();
        helper.h_toggleMenu(component, event, helper);
 	},
 	openExtractComp : function(component, event, helper) {
 		var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
        modalEvent.setParams({"name" : "Extract", "type" : 'youbet-extra'});
        modalEvent.fire();
        helper.h_toggleMenu(component, event, helper);
 	},
 	openYoubetsPerformed : function(component, event, helper) {
 		var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
        modalEvent.setParams({"name" : "YoubetsPerformed", "type" : 'youbet'});
        modalEvent.fire();
        helper.h_toggleMenu(component, event, helper);
 	},
 	openYoubetsPerformedComp : function(component, event, helper) {
 		var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
        modalEvent.setParams({"name" : "YoubetsPerformed", "type" : 'youbet-extra'});
        modalEvent.fire();
        helper.h_toggleMenu(component, event, helper);
 	},
 	openAgreement : function(component, event, helper) {
 		var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
        modalEvent.setParams({"name" : "Agreement", "type" : 'youbet'});
        modalEvent.fire();
        helper.h_toggleMenu(component, event, helper);
 	},
 	openAgreementComp : function(component, event, helper) {
 		var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
        modalEvent.setParams({"name" : "Agreement", "type" : 'youbet-extra'});
        modalEvent.fire();
        helper.h_toggleMenu(component, event, helper);
 	},
    openAgreementElite : function(component, event, helper) {
        var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
        modalEvent.setParams({"name" : "Agreement", "type" : 'elite'});
        modalEvent.fire();
        helper.h_toggleMenu(component, event, helper);
    },
    openAgreementSpy : function(component, event, helper) {
        var modalEvent = $A.get("e.c:SX_YouBetModal_Evt");
        modalEvent.setParams({"name" : "Agreement", "type" : 'spy'});
        modalEvent.fire();
        helper.h_toggleMenu(component, event, helper);
    },
    changePassword : function(component, event, helper) {
        var modalEvent = $A.get("e.c:SX_ChangePassword_Evt");
        modalEvent.fire();
        helper.h_toggleMenu(component, event, helper);
    },

})